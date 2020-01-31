package com.rms.rdo.validation.cdl

import java.io.File

import com.rms.cdl.parser.validator.ContractValidator
import com.rms.rdo.validation.model.CDLValidationError

import scala.io.Source
import scala.util.Try

object CDLValidator {

    def validateCDLFile(file: File): Option[CDLValidationError] = {
        val fileContent = Try(Source.fromFile(file.getPath)).toOption.map(_.getLines.mkString)

        fileContent.flatMap(content =>
                                try {
                                    ContractValidator.validate(content)
                                    None
                                }
                                catch {
                                    case e: Exception => Some(CDLValidationError(file.getName, e.getMessage))
                                })
    }
}
