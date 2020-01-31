package com.rms.rdo.validation.utility

import java.io.File

import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.model.{DataTypeValidationError, DataTypeValidationErrors, IntegrityConstraint}
import org.scalatest.BeforeAndAfterAll
import org.scalatest.funsuite.AnyFunSuite

class UtilityTest extends AnyFunSuite with BeforeAndAfterAll {

    override def afterAll(): Unit = {
        new File("src/test/resources/emp_errors").delete()
    }

    test("get validate data type json successfully") {
        val result = Utility.getValidationJson[Map[String, String]]("valid_data_type.json",
                                                                    Constants.DataTypeValidationType)
        assert(result.isDefined)
    }

    test("did not get validate data type json") {
        val result = Utility.getValidationJson[Map[String, String]]("invalid_data_type.json",
                                                                    Constants.DataTypeValidationType)
        assert(result.isEmpty)
    }

    test("get validate integrity constraint json successfully") {
        val result = Utility.getValidationJson[IntegrityConstraint]("valid_integrity_constraints.json",
                                                                    Constants.IntegrityConstraintValidationType)
        assert(result.isDefined)
    }

    test("did not get validate integrity constraint json") {
        val result = Utility.getValidationJson[IntegrityConstraint]("invalid_integrity_constraints.json",
                                                                    Constants.IntegrityConstraintValidationType)
        assert(result.isEmpty)
    }

    test("should get failure while writing errors in json file") {
        val error = DataTypeValidationErrors(List(DataTypeValidationError("accountId",
                                                                          "123abc",
                                                                          "The value is not a Time")))
        val result = Utility.writeErrorsIntoFile(error, "src/test/resources/1/q", Constants.DataTypeValidationType)
        assert(!result)
    }

    test("should be able to write errors in json file") {
        val error = DataTypeValidationErrors(List(DataTypeValidationError("accountId",
                                                                          "123abc",
                                                                          "The value is not a Time")))
        val result = Utility.writeErrorsIntoFile(error, "src/test/resources/emp", Constants.DataTypeValidationType)
        assert(result)
    }
}
