package com.rms.rdo.validation

import java.io.File

import akka.actor.ActorSystem
import com.rms.rdo.validation.cdl.CDLValidator
import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.csv.CsvReader
import com.rms.rdo.validation.integrityconstraint.{ForeignKeyValidator, IntegrityConstraintValidator, PrimaryKeyValidator}
import com.rms.rdo.validation.utility.Utility
import org.slf4j.{Logger, LoggerFactory}

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import scala.util.Try

object Application {

    private val logger: Logger = LoggerFactory.getLogger(this.getClass)

    def main(args: Array[String]): Unit = {

        implicit val actorSystem: ActorSystem = ActorSystem("rdo-validation")

        if (args.length > 1) {
            val validationType = args(0)
            if (Constants.ValidationType.contains(validationType)) {
                val directoryPath = args(1)
                val outputDirectory = Try(args(2)).toOption.getOrElse(directoryPath)
                val fileType = if (validationType == Constants.RdoValidationType) ".csv" else ".txt"

                val files: List[File] = Option(new File(directoryPath).listFiles())
                        .map(files => files.filter(_.getName.endsWith(fileType)).toList).fold(List
                                                                                                      .empty[File])(
                    identity)
                if (files.nonEmpty) {
                    val result = if (validationType == Constants.RdoValidationType) {
                        validateRDOFile(files, directoryPath, outputDirectory)
                    } else {
                        validateCDLFile(files, outputDirectory)
                    }
                    result.onComplete { _ =>
                        logger.info("Validation has been completed")
                        actorSystem.terminate()
                    }
                } else {
                    logger.error(s"Either the directory path is wrong or there are no $validationType files in the directory")
                    actorSystem.terminate()
                }
            } else {
                logger.error("Please provide the correct validation type")
                actorSystem.terminate()
            }
        } else {
            logger.error("Please provide the correct no of arguments")
            actorSystem.terminate()
        }
    }

    private def validateCDLFile(files: List[File], outputDirectory: String): Future[Boolean] = {
        Future(files.flatMap(file =>
                                 CDLValidator.validateCDLFile(file)
                             )).map(errors => Utility.writeErrorsIntoFile(errors, outputDirectory + "/" + "CDL",
                                                                          Constants.CdlValidationType))
    }

    private def validateRDOFile(files: List[File], directoryPath: String,
                                outputDirectory: String)(implicit actorSystem: ActorSystem): Future[List[Boolean]] = {

        val csvReader = new CsvReader()
        val foreignKeyValidator = new ForeignKeyValidator(csvReader)
        val primaryKeyValidator = new PrimaryKeyValidator(csvReader)
        val integrityConstraintValidator = new IntegrityConstraintValidator(foreignKeyValidator, primaryKeyValidator)

        Future.sequence(files.map(file =>
                                      csvReader.processDataTypeValidation(file)
                                               .map(errors =>
                                                        Utility.writeErrorsIntoFile(errors,
                                                                                    outputDirectory + "/" + file.getName
                                                                                                                .split(
                                                                                                                    '.')(
                                                                                                                    0),
                                                                                    Constants.DataTypeValidationType)
                                                    )))
              .flatMap(_ =>
                           Future.sequence(files.map(file =>
                                                         integrityConstraintValidator.processIntegrityConstraintValidation(
                                                             file,
                                                             directoryPath)
                                                                                     .map(error => Utility.writeErrorsIntoFile(
                                                                                         error,
                                                                                         outputDirectory + "/" + file.getName
                                                                                                                     .split(
                                                                                                                         '.')(
                                                                                                                         0),
                                                                                         Constants
                                                                                                 .IntegrityConstraintValidationType))
                                                     )))
    }
}
