package com.rms.rdo.validation.constant

object Constants {

    val EmptyString = ""
    val ForeignKeyErrorMessage = "The below columnValues should not be present in this file as it is not present" +
                                 " in primary keys of the below given file"
    val PrimaryKeyNullValueErrorMessage = "Primary Key contains null values"
    val PrimaryKeyDuplicateValueErrorMessage = "Primary Key contains duplicate Values"
    val DataTypeValidationType = "data type validation"
    val IntegrityConstraintValidationType = "integrity constraint validation"
    val DateFormats = List("MM/dd/yyyy", "dd/MM/yyyy", "MMM dd, yyyy", "dd-MM-yyyy")
    val TimeFormats = List("hh:mm:ss", "hh:mm:ss[.nnnnnnn]", "hh-mm-ss")
    val DateTimeFormats = List("MM/dd/yyyy hh:mm:ss", "dd/MM/yyyy hh:mm:ss",
                               "MMM dd, yyyy hh:mm:ss", "dd-MM-yyyy hh:mm:ss")

    val IntegrityConstrainConfigParsingErrorMessage = "Error in parsing the integrity constraint config file"
    val NoIntegrityConstraintErrorMessage = "There are no integrity constraint errors"
    val RdoValidationType = "RDO"
    val CdlValidationType = "CDL"
    val ValidationType = List(RdoValidationType, CdlValidationType)
}
