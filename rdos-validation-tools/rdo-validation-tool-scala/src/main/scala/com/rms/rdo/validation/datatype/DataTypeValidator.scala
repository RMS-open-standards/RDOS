package com.rms.rdo.validation.datatype

import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.model.DataTypeValidationError

import scala.util.Try

object DataTypeValidator {

  def validateDataType(row: Map[String, String],
                       validationMap: Map[String, String]): List[DataTypeValidationError] = {
    val columnNames = row.keySet.toList
    columnNames.flatMap { columnName =>
      checkDataTypes(row(columnName), validationMap(columnName))
        .map(error => DataTypeValidationError(columnName, row(columnName), error))
    }
  }

  private def checkDataTypes(columnValue: String, dataType: String): Option[String] = {
    dataType match {
      case "Date" => Validator.validateDateAndTimeDataType(columnValue, Constants.DateFormats, dataType)
      case "Time" => Validator.validateDateAndTimeDataType(columnValue, Constants.TimeFormats, dataType)
      case "DateTime" => Validator.validateDateAndTimeDataType(columnValue,
        Constants.DateTimeFormats, dataType)
      case "Bit" => Validator.validateBitType(columnValue, dataType)
      case _ => validateNumericDataTypes(columnValue, dataType)
    }
  }

  private def validateNumericDataTypes(columnValue: String, dataType: String): Option[String] = {
    dataType match {
      case "Double" => Validator.validateNumericType(Try(columnValue.toDouble).toOption, dataType)
      case "Long" => Validator.validateNumericType(Try(columnValue.toLong).toOption, dataType)
      case "Byte" => Validator.validateNumericType(Try(columnValue.toByte).toOption, dataType)
      case "Short" => Validator.validateNumericType(Try(columnValue.toShort).toOption, dataType)
      case "Integer" => Validator.validateNumericType(Try(columnValue.toInt).toOption, dataType)
      case _ => None
    }
  }
}
