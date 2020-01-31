package com.rms.rdo.validation.integrityconstraint

import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.csv.CsvReader
import com.rms.rdo.validation.model.{ForeignKeyDetail, ForeignKeyError, ForeignKeyErrorDetail, IntegrityConstraint}
import org.mockito.MockitoSugar
import org.scalatest.funsuite.AsyncFunSuite

import scala.concurrent.Future

class ForeignKeyValidatorTest extends AsyncFunSuite with MockitoSugar {

    private val csvReader = mock[CsvReader]
    private val foreignKeyValidator = new ForeignKeyValidator(csvReader)

    test("process foreign key validation for invalid csv") {
        val foreignKeyDetail = ForeignKeyDetail("department", Map("id" -> "empId"))
        val integrityConstraint = IntegrityConstraint(List("id"), List(foreignKeyDetail))
        val result = foreignKeyValidator.processForeignKeysValidation("", integrityConstraint, "employee")
        result.map(x => assert(x.get.errors == List(ForeignKeyError("department", None, Some("File does not exist")))))
    }

    test("process foreign key validation with no error") {
        val primaryKeyData = Future.successful(List(Map("id" -> "1"), Map("id" -> "2"), Map("id" -> "3")))
        val foreignKeyData = Future.successful(List(Map("empId" -> "1"), Map("empId" -> "1"), Map("empId" -> "3")))
        val foreignKeyDetail = ForeignKeyDetail("emp", Map("id" -> "empId"))

        val integrityConstraint = IntegrityConstraint(List("id"), List(foreignKeyDetail))

        when(csvReader.getDataByColumns("src/test/resources/employee/dept.csv", List("empId"))).thenReturn(
            foreignKeyData)
        when(csvReader.getDataByColumns("src/test/resources/employee/emp.csv", List("id"))).thenReturn(primaryKeyData)
        val result = foreignKeyValidator.processForeignKeysValidation("src/test/resources/employee/dept.csv",
                                                                      integrityConstraint,
                                                                      "src/test/resources/employee")
        result.map(x => assert(x.isEmpty))
    }

    test("process foreign key validation with error") {
        val primaryKeyData = Future.successful(List(Map("id" -> "1"), Map("id" -> "2"), Map("id" -> "3")))
        val foreignKeyData = Future.successful(List(Map("empId" -> "1"), Map("empId" -> "1"), Map("empId" -> "4")))
        val foreignKeyDetail = ForeignKeyDetail("emp", Map("id" -> "empId"))

        val integrityConstraint = IntegrityConstraint(List("id"), List(foreignKeyDetail))

        when(csvReader.getDataByColumns("src/test/resources/employee/people.csv", List("empId"))).thenReturn(
            foreignKeyData)
        when(csvReader.getDataByColumns("src/test/resources/employee/emp.csv", List("id"))).thenReturn(primaryKeyData)
        val result = foreignKeyValidator.processForeignKeysValidation("src/test/resources/employee/people.csv",
                                                                      integrityConstraint,
                                                                      "src/test/resources/employee")
        result.map(x => assert(x.contains(ForeignKeyErrorDetail(Constants.ForeignKeyErrorMessage, List(ForeignKeyError(
            "emp",
            Some(List(Map("empId" -> "4")))))))))
    }
}
