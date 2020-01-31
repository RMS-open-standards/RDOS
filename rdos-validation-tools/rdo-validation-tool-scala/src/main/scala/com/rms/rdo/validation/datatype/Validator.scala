package com.rms.rdo.validation.datatype

import java.text.SimpleDateFormat

object Validator {

  def validateNumericType[T](value: Option[T], dataType: String): Option[String] = {
    value match {
      case Some(_) => None
      case None => Some(s"The value is not a $dataType")
    }
  }

  def validateDateAndTimeDataType(value: String, formats: List[String], dataType: String): Option[String] = {
    val result = formats.flatMap(dateFormat => isDateValid(value, dateFormat, dataType))
    if (result.length == formats.length) result.headOption else None
  }

  def validateBitType(value: String, dataType: String): Option[String] = {
    if (value == "0" || value == "1") None else Some(s"The value is not a $dataType")
  }

  private def isDateValid(value: String, formats: String, dataType: String): Option[String] = {
    try {
      val formatter = new SimpleDateFormat(formats)
      formatter.parse(value)
      None
    } catch {
      case _: Exception => Some(s"The value is not a $dataType")
    }
  }

}
