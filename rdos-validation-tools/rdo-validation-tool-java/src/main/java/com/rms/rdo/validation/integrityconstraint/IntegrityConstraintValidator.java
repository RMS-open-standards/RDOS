package com.rms.rdo.validation.integrityconstraint;

import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.model.integrityconstraint.ForeignKeyErrorDetail;
import com.rms.rdo.validation.model.integrityconstraint.IntegrityConstraint;
import com.rms.rdo.validation.model.integrityconstraint.IntegrityConstraintValidationError;
import com.rms.rdo.validation.model.integrityconstraint.PrimaryKeyErrorDetail;
import com.rms.rdo.validation.utility.Utility;

import java.io.File;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class IntegrityConstraintValidator {

    private final PrimaryKeyValidator primaryKeyValidator;
    private final ForeignKeyValidator foreignKeyValidator;
    private final Utility utility;

    public CompletableFuture<IntegrityConstraintValidationError> processIntegrityConstraintValidation(File file,
                                                                                                      String directoryPath) {
        String fileName = file.getName().split("\\.")[0];
        String constraintValidationFileName = fileName + "/integrity_constraints.json";

        Optional<IntegrityConstraint> integrityConstraintOpt =
                utility.getIntegrityConstraintValidationJson(constraintValidationFileName,
                        Constants.INTEGRITY_CONSTRAINT_VALIDATION_TYPE);

        return integrityConstraintOpt.map(integrityConstraint ->
                primaryKeyValidator.processPrimaryKeysValidation(file.getPath(), integrityConstraint)
                        .thenCompose(primaryKeyErrors ->
                                foreignKeyValidator
                                        .processForeignKeysValidation(file.getPath(), integrityConstraint, directoryPath)
                                        .thenApply(foreignKeyErrors ->
                                                prepareIntegrityConstraintValidationError(
                                                        primaryKeyErrors.orElse(null),
                                                        foreignKeyErrors.orElse(null)))
                        )).orElseGet(() -> CompletableFuture.completedFuture(
                IntegrityConstraintValidationError
                        .builder()
                        .message(Constants.INTEGRITY_CONSTRAIN_CONFIG_PARSING_ERROR_MESSAGE).build()));
    }

    private IntegrityConstraintValidationError prepareIntegrityConstraintValidationError(
            PrimaryKeyErrorDetail primaryKeyErrorDetail, ForeignKeyErrorDetail foreignKeyErrorDetail) {
        if (primaryKeyErrorDetail != null && foreignKeyErrorDetail != null) {
            return IntegrityConstraintValidationError
                    .builder()
                    .foreignKey(foreignKeyErrorDetail)
                    .primaryKey(primaryKeyErrorDetail)
                    .build();
        } else if (primaryKeyErrorDetail != null) {
            return IntegrityConstraintValidationError
                    .builder()
                    .primaryKey(primaryKeyErrorDetail).build();
        } else if (foreignKeyErrorDetail != null) {
            return IntegrityConstraintValidationError
                    .builder()
                    .foreignKey(foreignKeyErrorDetail)
                    .build();
        } else {
            return IntegrityConstraintValidationError
                    .builder()
                    .message(Constants.NO_INTEGRITY_CONSTRAINT_ERROR_MESSAGE)
                    .build();
        }
    }
}
