package com.rms.rdo.validation.csv

import java.io.File

import akka.actor.ActorSystem
import com.rms.rdo.validation.model.DataTypeValidationErrors
import org.mockito.MockitoSugar
import org.scalatest.funsuite.AsyncFunSuite

class CsvReaderTest extends AsyncFunSuite with MockitoSugar {

    implicit val actorSystem: ActorSystem = ActorSystem("test")

    val csvReader = new CsvReader
    test("get data by columns successfully") {
        val filePath = "src/test/resources/csv/employee.csv"
        val result = csvReader.getDataByColumns(filePath, List("id", "age"))

        result.map(x => {
            assert(x.length == 5)
            assert(x.head.size == 2)
        })
    }

    test("should get error while getting data by columns") {
        val filePath = "src/test/resources/csv/employee.csv"
        val result = csvReader.getDataByColumns(filePath, List("id", "address"))

        result.map(x => assert(x.isEmpty))
    }

    test("should get data type validation config parsing error ") {
        val file = new File("src/test/resources/csv/department.csv")
        val result = csvReader.processDataTypeValidation(file)

        result.map(x => assert(x == DataTypeValidationErrors(Nil,
                                                             Some(
                                                                 "Error in parsing the data type validation config file"))))
    }

    test("should get process data type validation successfully ") {
        val file = new File("src/test/resources/csv/employee.csv")
        val result = csvReader.processDataTypeValidation(file)

        result.map(x => assert(x == DataTypeValidationErrors(Nil, None)))
    }
}
