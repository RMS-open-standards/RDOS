package com.rms.rdo.validation.integrityconstraint

import java.io.File

import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.csv.CsvReader
import com.rms.rdo.validation.model.{ForeignKeyDetail, ForeignKeyError, ForeignKeyErrorDetail, IntegrityConstraint}
import com.rms.rdo.validation.model

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

class ForeignKeyValidator(csvReader: CsvReader) {

    def processForeignKeysValidation(foreignKeyFilePath: String,
                                     integrityConstraint: IntegrityConstraint,
                                     directoryPath: String): Future[Option[ForeignKeyErrorDetail]] = {
        val foreignKeyDetails = integrityConstraint.foreignKeys
        Future.sequence(foreignKeyDetails.map(detail => {
            val primaryKeyFilePath = s"$directoryPath/${detail.table}.csv"
            val primaryKeyFile = new File(primaryKeyFilePath)
            if (primaryKeyFile.exists()) {
                val primaryKeys = detail.columnMapping.keySet.toList
                val foreignKeys = detail.columnMapping.values.toList
                val primaryKeyDataResult = csvReader.getDataByColumns(primaryKeyFilePath, primaryKeys)
                val foreignKeyDataResult = csvReader.getDataByColumns(foreignKeyFilePath, foreignKeys)

                primaryKeyDataResult.flatMap(primaryKeyData =>
                                                 foreignKeyDataResult.map(foreignKeyData =>
                                                                              validateForeignKeys(detail,
                                                                                                  primaryKeyData,
                                                                                                  foreignKeyData)
                                                                          ))
            } else Future.successful(Some(ForeignKeyError(detail.table, None, Some("File does not exist"))))
        }))
              .map(errors => if (errors.flatten.isEmpty) None
                             else Some(model.ForeignKeyErrorDetail(Constants.ForeignKeyErrorMessage, errors.flatten)))
    }

    private def validateForeignKeys(detail: ForeignKeyDetail,
                                    primaryKeyData: List[Map[String, String]],
                                    foreignKeyData: List[Map[String, String]]): Option[ForeignKeyError] = {
        val mapping = detail.columnMapping
        val foreignKeys = detail.columnMapping.values.toList
        val updatedPrimaryKeyData = primaryKeyData.map(values => {
            values.map { case (key, value) =>
                mapping.getOrElse(key, key) -> value
            }
        })

        val errors = foreignKeyData.distinct diff updatedPrimaryKeyData
        if (errors.isEmpty) None else Some(ForeignKeyError(detail.table, Some(errors)))
    }
}