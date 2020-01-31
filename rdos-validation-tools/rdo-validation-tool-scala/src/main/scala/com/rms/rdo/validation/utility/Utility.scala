package com.rms.rdo.validation.utility

import java.io.{File, FileWriter}

import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.scala.DefaultScalaModule
import com.fasterxml.jackson.module.scala.experimental.ScalaObjectMapper
import org.slf4j.{Logger, LoggerFactory}

import scala.io.Source

object Utility {

    private val logger: Logger = LoggerFactory.getLogger(this.getClass)

    private val mapper = new ObjectMapper() with ScalaObjectMapper
    mapper.setSerializationInclusion(Include.NON_ABSENT)
    mapper.registerModule(DefaultScalaModule)

    def getValidationJson[T](fileName: String, validationType: String)(implicit m: Manifest[T]): Option[T] = {
        try {
            val validationJson = Source.fromResource(fileName)
            Some(mapper.readValue[T](validationJson.reader()))
        } catch {
            case _: Exception => logger.error(s"Error in parsing the $validationType json for file: $fileName")
                None
        }
    }

    def writeErrorsIntoFile[T](errors: T, filePath: String, validationTye: String): Boolean = {
        try {
            val writer = new FileWriter(new File(filePath + "_errors"), true)
            writer.append(s"============= $validationTye errors =================\n")
            writer.append(mapper.writerWithDefaultPrettyPrinter.writeValueAsString(errors) + "\n\n")
            writer.close()
            true
        } catch {
            case _: Exception => logger.error(s"Failure for writing errors in the file: $filePath")
                false
        }
    }
}
