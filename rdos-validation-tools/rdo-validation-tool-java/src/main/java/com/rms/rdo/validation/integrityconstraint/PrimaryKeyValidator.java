package com.rms.rdo.validation.integrityconstraint;

import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.csv.CsvReader;
import com.rms.rdo.validation.model.integrityconstraint.IntegrityConstraint;
import com.rms.rdo.validation.model.integrityconstraint.PrimaryKeyErrorDetail;
import com.rms.rdo.validation.model.integrityconstraint.PrimaryKeyError;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class PrimaryKeyValidator {

    private final CsvReader csvReader;

    public CompletableFuture<Optional<PrimaryKeyErrorDetail>>
    processPrimaryKeysValidation(String filePath,
                                 IntegrityConstraint integrityConstraint) {
        List<String> primaryKeys = integrityConstraint.getPrimaryKeys();
        CompletableFuture<List<Map<String, String>>> primaryKeyData = csvReader.getDataByColumns(filePath, primaryKeys);
        return primaryKeyData.thenApply(values -> {
            Optional<PrimaryKeyError> nulErrors = validateNull(values);
            Optional<PrimaryKeyError> duplicateErrors = validateDuplicateValues(values);
            List<PrimaryKeyError> primaryKeyErrors = Stream.of(nulErrors, duplicateErrors)
                    .filter(Optional::isPresent)
                    .map(Optional::get)
                    .collect(Collectors.toList());
            if (primaryKeyErrors.isEmpty()) {
                return Optional.empty();
            } else {
                return Optional.of(PrimaryKeyErrorDetail.builder().errors(primaryKeyErrors).build());
            }
        });
    }

    private Optional<PrimaryKeyError> validateNull(List<Map<String, String>> rows) {
        boolean isNull = rows.stream().anyMatch(row -> row.values().contains(null));
        if (isNull) {
            String columns = String.join("-", rows.get(0).keySet());
            return Optional.of(PrimaryKeyError.builder().columnName(columns)
                    .errorMessage(Constants.PRIMARY_KEY_NULL_VALUE_ERROR_MESSAGE).build());
        } else {
            return Optional.empty();
        }
    }

    private Optional<PrimaryKeyError> validateDuplicateValues(List<Map<String, String>> rows) {
        List<String> duplicates = rows.stream()
                .filter(e -> Collections.frequency(rows, e) > 1)
                .distinct()
                .map(res -> String.join("-", res.values()))
                .collect(Collectors.toList());

        if (duplicates.isEmpty()) {
            return Optional.empty();
        } else {
            String columns = String.join("-", rows.get(0).keySet());
            return Optional.of(PrimaryKeyError.builder()
                    .columnName(columns).columnValue(duplicates)
                    .errorMessage(Constants.PRIMARY_KEY_DUPLICATE_VALUE_ERROR_MESSAGE).build());
        }
    }
}
