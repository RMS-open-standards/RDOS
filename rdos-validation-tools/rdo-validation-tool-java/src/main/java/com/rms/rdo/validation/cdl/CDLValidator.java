package com.rms.rdo.validation.cdl;

import com.rms.cdl.parser.validator.ContractValidator;
import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.model.cdl.CDLValidationError;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class CDLValidator {

    public static Optional<CDLValidationError> validateCDLFile(File file) {
        Optional<String> fileContent = readFile(file);

        return fileContent.flatMap(content -> {
            try {
                ContractValidator.validate(content);
                return Optional.empty();
            } catch (Exception ex) {
                return Optional.of(CDLValidationError.builder()
                        .file(file.getName()).errorMessage(ex.getMessage()).build());
            }
        });
    }

    private static Optional<String> readFile(File file) {
        try (Stream<String> stream = Files.lines(Paths.get(file.getPath()))) {
            return Optional.ofNullable(stream.collect(Collectors.joining(Constants.EMPTY_STRING)));
        } catch (IOException e) {
            return Optional.empty();
        }
    }
}