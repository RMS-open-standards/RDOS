package com.rms.rdo.validation.integrityconstraint

import java.io.File

import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.model.{IntegrityConstraint, IntegrityConstraintValidationError}
import com.rms.rdo.validation.utility.Utility

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

class IntegrityConstraintValidator(foreignKeyValidator: ForeignKeyValidator,
                                   primaryKeyValidator: PrimaryKeyValidator) {

    def processIntegrityConstraintValidation(file: File,
                                             directoryPath: String): Future[IntegrityConstraintValidationError] = {
        val fileName = file.getName.split('.')(0)
        val constraintValidationFileName = s"$fileName/integrity_constraints.json"

        val integrityConstraintOpt = Utility.getValidationJson[IntegrityConstraint](constraintValidationFileName,
                                                                                    Constants
                                                                                            .IntegrityConstraintValidationType)

        integrityConstraintOpt.fold(Future.successful(IntegrityConstraintValidationError(
            Some(Constants.IntegrityConstrainConfigParsingErrorMessage), None, None))) {
            integrityConstraint =>
                primaryKeyValidator.processPrimaryKeysValidation(file.getPath, integrityConstraint)
                                   .flatMap(primaryKeyErrors =>
                                                foreignKeyValidator.processForeignKeysValidation(file.getPath,
                                                                                                 integrityConstraint,
                                                                                                 directoryPath)
                                                                   .map(errorDetail =>
                                                                            if (primaryKeyErrors
                                                                                        .isDefined || errorDetail
                                                                                        .isDefined)
                                                                                IntegrityConstraintValidationError(None,
                                                                                                                   primaryKeyErrors,
                                                                                                                   errorDetail)
                                                                            else IntegrityConstraintValidationError(Some(
                                                                                Constants
                                                                                        .NoIntegrityConstraintErrorMessage),
                                                                                                                    None,
                                                                                                                    None))
                                            )
        }
    }
}
