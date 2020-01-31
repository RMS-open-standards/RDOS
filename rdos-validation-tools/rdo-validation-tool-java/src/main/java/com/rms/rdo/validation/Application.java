package com.rms.rdo.validation;

import akka.actor.ActorSystem;
import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.csv.CsvReader;
import com.rms.rdo.validation.handler.CDLValidationHandler;
import com.rms.rdo.validation.handler.RDOValidationHandler;
import com.rms.rdo.validation.integrityconstraint.ForeignKeyValidator;
import com.rms.rdo.validation.integrityconstraint.IntegrityConstraintValidator;
import com.rms.rdo.validation.integrityconstraint.PrimaryKeyValidator;
import com.rms.rdo.validation.utility.Utility;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Application {

    private static Logger logger = LoggerFactory.getLogger("Application");

    public static void main(String[] args) {
        ActorSystem actorSystem = ActorSystem.create("rdo-validation");

        if (args.length > 1) {
            String validationType = args[0];
            if (Constants.VALIDATION_TYPE.contains(validationType)) {
                String directoryPath = args[1];
                String outputDirectory = getOutputDirectoryPath(args).orElse(directoryPath);

                Utility utility = new Utility();
                CsvReader csvReader = new CsvReader(actorSystem, utility);
                ForeignKeyValidator foreignKeyValidator = new ForeignKeyValidator(csvReader);
                PrimaryKeyValidator primaryKeyValidator = new PrimaryKeyValidator(csvReader);
                IntegrityConstraintValidator integrityConstraintValidator =
                        new IntegrityConstraintValidator(primaryKeyValidator, foreignKeyValidator, utility);
                RDOValidationHandler rdoValidationHandler = new RDOValidationHandler(utility, csvReader,
                        integrityConstraintValidator);
                CDLValidationHandler cdlValidationHandler = new CDLValidationHandler(utility);

                List<File> files = getFiles(directoryPath, getFileType(validationType));
                if (!files.isEmpty()) {
                    (validationType.equals(Constants.RDO_VALIDATION_TYPE) ?
                            rdoValidationHandler.validateRDOFile(files, directoryPath, outputDirectory)
                            : cdlValidationHandler.validateCDLFile(files,
                            outputDirectory)).whenComplete((data, error) -> {
                        logger.info("Validation has been completed");
                        actorSystem.terminate();
                    });
                } else {
                    logger.error("Either the directory path is wrong or there are no {} files " +
                            "in the directory", validationType);
                    actorSystem.terminate();
                }
            } else {
                logger.error("Please provide the correct validation type");
                actorSystem.terminate();
            }
        } else {
            logger.error("Please provide the correct no of arguments");
            actorSystem.terminate();
        }
    }

    private static Optional<String> getOutputDirectoryPath(String[] args) {
        try {
            return Optional.ofNullable(args[2]);
        } catch (Exception ex) {
            return Optional.empty();
        }
    }

    private static String getFileType(String validationType) {
        if (validationType.equals(Constants.RDO_VALIDATION_TYPE)) {
            return ".csv";
        } else {
            return ".txt";
        }
    }

    private static List<File> getFiles(String directoryPath, String fileType) {
        return Optional.ofNullable(new File(directoryPath).listFiles())
                .map(fileList -> Stream.of(fileList)
                        .filter(file -> file.getName().endsWith(fileType))
                        .collect(Collectors.toList()))
                .orElse(Collections.emptyList());
    }
}
