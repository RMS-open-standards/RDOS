package com.rms.rdo.validation.integrityconstraint

import com.rms.rdo.validation.csv.CsvReader
import com.rms.rdo.validation.model.IntegrityConstraint
import org.mockito.MockitoSugar
import org.scalatest.funsuite.AsyncFunSuite

import scala.concurrent.Future

class PrimaryKeyValidatorTest extends AsyncFunSuite with MockitoSugar {

    private val csvReader = mock[CsvReader]
    private val primaryKeyValidator = new PrimaryKeyValidator(csvReader)

    test("validate primary key for duplicate values") {
        val integrityConstraint = IntegrityConstraint(List("id"), Nil)
        val data = List(Map("id" -> "1"), Map("id" -> "2"), Map("id" -> "1"), Map("id" -> "2"))

        when(csvReader.getDataByColumns("test.csv", List("id"))).thenReturn(Future.successful(data))

        val result = primaryKeyValidator.processPrimaryKeysValidation("test.csv", integrityConstraint)
        result map (errors => assert(errors.get.errors.length == 1))
    }

    test("validate primary key for null values") {
        val integrityConstraint = IntegrityConstraint(List("id"), Nil)
        val data = List(Map("id" -> "1"), Map("id" -> null), Map("id" -> "3"), Map("id" -> "2"))

        when(csvReader.getDataByColumns("test.csv", List("id"))).thenReturn(Future.successful(data))

        val result = primaryKeyValidator.processPrimaryKeysValidation("test.csv", integrityConstraint)
        result map (errors => assert(errors.get.errors.length == 1))
    }

    test("validate primary key for no errors") {
        val integrityConstraint = IntegrityConstraint(List("id"), Nil)
        val data = List(Map("id" -> "1"), Map("id" -> "4"), Map("id" -> "3"), Map("id" -> "2"))

        when(csvReader.getDataByColumns("test.csv", List("id"))).thenReturn(Future.successful(data))

        val result = primaryKeyValidator.processPrimaryKeysValidation("test.csv", integrityConstraint)
        result map (errors => assert(errors.isEmpty))
    }
}
