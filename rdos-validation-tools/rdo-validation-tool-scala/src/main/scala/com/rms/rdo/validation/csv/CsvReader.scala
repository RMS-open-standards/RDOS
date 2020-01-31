package com.rms.rdo.validation.csv

import java.io.File
import java.nio.file.{Path, Paths}

import akka.actor.ActorSystem
import akka.stream.alpakka.csv.scaladsl.{CsvParsing, CsvToMap}
import akka.stream.scaladsl._
import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.datatype.DataTypeValidator
import com.rms.rdo.validation.model.DataTypeValidationErrors
import com.rms.rdo.validation.utility.Utility
import org.slf4j.{Logger, LoggerFactory}

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

class CsvReader(implicit system: ActorSystem) {

    private val logger: Logger = LoggerFactory.getLogger(this.getClass)

    def processDataTypeValidation(file: File): Future[DataTypeValidationErrors] = {

        val csvFile: Path = Paths.get(file.getPath)
        val source = FileIO.fromPath(csvFile)
        val fileName = file.getName.split('.')(0)
        val validationFileName = s"$fileName/data_type_validation.json"

        val validationMapOpt = Utility.getValidationJson[Map[String, String]](validationFileName,
                                                                              Constants.DataTypeValidationType)

        validationMapOpt.fold(Future.successful(DataTypeValidationErrors(Nil,
                                                                         Some(
                                                                             "Error in parsing the data type validation config file"))))
        {
            validationMap =>
                source
                        .via(CsvParsing.lineScanner())
                        .via(CsvToMap.toMapAsStrings())
                        .map(rows => DataTypeValidator.validateDataType(rows, validationMap))
                        .filter(errors => errors.nonEmpty)
                        .runWith(Sink.seq).map(data => data.flatten.toList)
                        .map(errors => DataTypeValidationErrors(errors))
                        .recover {
                            case ex: Exception => ex.printStackTrace()
                                val errorMessage = s"Error in processing data type validation for file $fileName"
                                logger.error(errorMessage)
                                DataTypeValidationErrors(Nil, Some(errorMessage))
                        }
        }
    }

    def getDataByColumns(filePath: String, columns: List[String]): Future[List[Map[String, String]]] = {
        val csvFile: Path = Paths.get(filePath)
        val source = FileIO.fromPath(csvFile)

        source
                .via(CsvParsing.lineScanner())
                .via(CsvToMap.toMapAsStrings())
                .map(row => {
                    columns.flatMap(column => Map(column -> row(column))).toMap
                })
                .runWith(Sink.seq).map(_.toList)
                .recover {
                    case e: Exception => logger.error(s"Error in reading the file $filePath for integrity constraint validation")
                        Nil
                }
    }
}

