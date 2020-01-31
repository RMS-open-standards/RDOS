package com.rms.rdo.validation.model

case class IntegrityConstraintValidationError(message: Option[String],
                                              primaryKey: Option[PrimaryKeyErrorDetail],
                                              foreignKey: Option[ForeignKeyErrorDetail])

case class PrimaryKeyError(columnName: String, columnValue: List[String], errorMessage: String)

case class PrimaryKeyErrorDetail(errors: List[PrimaryKeyError])

case class ColumnDetails()

case class ForeignKeyError(file: String, columnValues: Option[List[Map[String, String]]],
                           message: Option[String] = None)

case class ForeignKeyErrorDetail(errorMessage: String, errors: List[ForeignKeyError])