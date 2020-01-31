package com.rms.rdo.validation.model

case class DataTypeValidationError(columnName: String, columnValue: String, errorMessage: String)

case class DataTypeValidationErrors(errors: List[DataTypeValidationError],
                                    message: Option[String] = None)