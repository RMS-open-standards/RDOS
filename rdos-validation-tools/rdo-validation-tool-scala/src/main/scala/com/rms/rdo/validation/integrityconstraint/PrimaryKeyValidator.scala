package com.rms.rdo.validation.integrityconstraint

import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.csv.CsvReader
import com.rms.rdo.validation.model.{IntegrityConstraint, PrimaryKeyError, PrimaryKeyErrorDetail}

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

class PrimaryKeyValidator(csvReader: CsvReader) {

    def processPrimaryKeysValidation(filePath: String, integrityConstraint: IntegrityConstraint):
    Future[Option[PrimaryKeyErrorDetail]] = {
        val primaryKeys = integrityConstraint.primaryKeys
        val primaryKeyData = csvReader.getDataByColumns(filePath, primaryKeys)
        primaryKeyData.map(values => {
            val nulErrors = validateNull(values)
            val duplicateErrors = validateDuplicateValues(values)
            if (nulErrors.isDefined || duplicateErrors.isDefined)
                Some(PrimaryKeyErrorDetail(List(nulErrors, duplicateErrors).flatten))
            else None
        })
    }

    private def validateNull(rows: List[Map[String, String]]): Option[PrimaryKeyError] = {
        val isNull = rows.exists(row => row.values.toList.contains(null))
        if (isNull) {
            val columns = rows.head.keySet.mkString("-")
            Some(PrimaryKeyError(columns, Nil, Constants.PrimaryKeyNullValueErrorMessage))
        } else None
    }

    private def validateDuplicateValues(rows: List[Map[String, String]]): Option[PrimaryKeyError] = {
        val duplicates = rows.groupBy(identity).collect {
            case (x, y) if y.lengthCompare(1) > 0 => x
        }.toList.map(res => res.values.mkString("-"))

        if (duplicates.nonEmpty) {
            val columns = rows.head.keySet.mkString("-")
            Some(PrimaryKeyError(columns, duplicates, Constants.PrimaryKeyDuplicateValueErrorMessage))
        } else None
    }
}
