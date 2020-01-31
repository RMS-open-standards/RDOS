package com.rms.rdo.validation.handler;

import com.rms.rdo.validation.cdl.CDLValidator;
import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.utility.Utility;
import lombok.AllArgsConstructor;

import java.io.File;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@AllArgsConstructor
public class CDLValidationHandler {

    private Utility utility;

    public CompletableFuture<Boolean> validateCDLFile(List<File> files, String outputDirectory) {
        return CompletableFuture.supplyAsync(() -> files.stream()
                .map(CDLValidator::validateCDLFile)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .collect(Collectors.toList()))
                .thenApply(errors -> utility.writeErrorsIntoFile(errors, outputDirectory + "/" + "CDL",
                        Constants.CDL_VALIDATION_TYPE));
    }
}
