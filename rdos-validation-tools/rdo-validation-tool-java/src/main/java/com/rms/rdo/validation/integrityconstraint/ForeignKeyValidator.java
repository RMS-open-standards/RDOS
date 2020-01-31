package com.rms.rdo.validation.integrityconstraint;

import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.csv.CsvReader;
import com.rms.rdo.validation.model.integrityconstraint.ForeignKeyDetail;
import com.rms.rdo.validation.model.integrityconstraint.ForeignKeyErrorDetail;
import com.rms.rdo.validation.model.integrityconstraint.ForeignKeyError;
import com.rms.rdo.validation.model.integrityconstraint.IntegrityConstraint;

import java.io.File;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class ForeignKeyValidator {

    private final CsvReader csvReader;

    public CompletableFuture<Optional<ForeignKeyErrorDetail>> processForeignKeysValidation(String foreignKeyFilePath,
                                                                                           IntegrityConstraint integrityConstraint,
                                                                                           String directoryPath) {
        List<ForeignKeyDetail> foreignKeyDetails = integrityConstraint.getForeignKeys();
        List<CompletableFuture<Optional<ForeignKeyError>>> result = foreignKeyDetails
                .stream().map(detail ->
                        procesForeignKeyDetail(directoryPath, foreignKeyFilePath, detail))
                .collect(Collectors.toList());

        CompletableFuture<List<Optional<ForeignKeyError>>> future = CompletableFuture
                .allOf(result.toArray(new CompletableFuture[result.size()]))
                .thenApply(v -> result.stream()
                        .map(CompletableFuture::join)
                        .collect(Collectors.toList()));

        return future.thenApply(res -> {
            List<ForeignKeyError> errors =
                    res.stream().filter(Optional::isPresent).map(Optional::get).collect(Collectors.toList());
            if (errors.isEmpty()) {
                return Optional.empty();
            } else {
                return Optional.of(
                        ForeignKeyErrorDetail.builder().errorMessage(Constants.FOREIGN_KEY_ERROR_MESSAGE)
                                .errors(errors).build());
            }
        });
    }

    private Optional<ForeignKeyError> validateForeignKeys(ForeignKeyDetail detail,
                                                          List<Map<String, String>> primaryKeyData,
                                                          List<Map<String, String>> foreignKeyData) {
        Map<String, String> mapping = detail.getColumnMapping();
        List<Map<String, String>> updatedPrimaryKeyData = primaryKeyData.stream().map(values -> {
            Map<String, String> data = new HashMap<>();
            for (Map.Entry<String, String> entry : values.entrySet()) {
                data.put(mapping.getOrDefault(entry.getKey(), entry.getKey()), entry.getValue());
            }
            return data;
        }).collect(Collectors.toList());
        List<Map<String, String>> errors = foreignKeyData.stream().distinct()
                .filter(x -> !updatedPrimaryKeyData.contains(x))
                .collect(Collectors.toList());
        if (errors.isEmpty()) {
            return Optional.empty();
        } else {
            return Optional.of(ForeignKeyError.builder().file(detail.getTable()).columnValues(errors).build());
        }
    }

    private CompletableFuture<Optional<ForeignKeyError>> procesForeignKeyDetail(String directoryPath,
                                                                                String foreignKeyFilePath,
                                                                                ForeignKeyDetail detail) {
        String primaryKeyFilePath = directoryPath + "/" + detail.getTable() + ".csv";
        File primaryKeyFile = new File(primaryKeyFilePath);
        if (primaryKeyFile.exists()) {
            List<String> primaryKeys = new ArrayList<>(detail.getColumnMapping().keySet());
            List<String> foreignKeys = new ArrayList<>(detail.getColumnMapping().values());
            CompletableFuture<List<Map<String, String>>> primaryKeyDataResult =
                    csvReader.getDataByColumns(primaryKeyFilePath, primaryKeys);
            CompletableFuture<List<Map<String, String>>> foreignKeyDataResult =
                    csvReader.getDataByColumns(foreignKeyFilePath, foreignKeys);

            return primaryKeyDataResult.thenCompose(primaryKeyData ->
                    foreignKeyDataResult.thenApply(foreignKeyData ->
                            validateForeignKeys(detail, primaryKeyData, foreignKeyData)));
        } else {
            return CompletableFuture.completedFuture(Optional.of(
                    ForeignKeyError.builder().file(detail.getTable())
                            .message("File does not exist").build()));
        }
    }
}
