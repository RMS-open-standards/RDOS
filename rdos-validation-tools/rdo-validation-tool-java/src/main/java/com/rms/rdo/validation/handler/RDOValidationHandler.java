package com.rms.rdo.validation.handler;

import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.csv.CsvReader;
import com.rms.rdo.validation.integrityconstraint.IntegrityConstraintValidator;
import com.rms.rdo.validation.utility.Utility;
import lombok.AllArgsConstructor;

import java.io.File;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@AllArgsConstructor
public class RDOValidationHandler {

    private Utility utility;
    private CsvReader csvReader;
    private IntegrityConstraintValidator integrityConstraintValidator;

    public CompletableFuture<List<Boolean>> validateRDOFile(List<File> files, String directoryPath,
                                                            String outputDirectory) {

        List<CompletableFuture<Boolean>> result = files.stream().map(file -> csvReader.processDataTypeValidation(file)
                .thenApply(errors -> utility.writeErrorsIntoFile(
                        errors, outputDirectory + "/" + file.getName().split("\\.")[0],
                        Constants.DATA_TYPE_VALIDATION_TYPE))
                .thenCompose(res ->
                        integrityConstraintValidator.processIntegrityConstraintValidation(
                                file, directoryPath).thenApply(error -> utility.writeErrorsIntoFile(
                                error, outputDirectory + "/" + file.getName().split("\\.")[0],
                                Constants.INTEGRITY_CONSTRAINT_VALIDATION_TYPE))
                ))
                .map(x -> x.toCompletableFuture())
                .collect(Collectors.toList());

        return CompletableFuture
                .allOf(result.toArray(new CompletableFuture[result.size()]))
                .thenApply(v -> result.stream()
                        .map(CompletableFuture::join)
                        .collect(Collectors.toList()));
    }

}
