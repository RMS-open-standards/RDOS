package com.rms.rdo.validation.datatype

import com.rms.rdo.validation.constant.Constants
import org.scalatest.funsuite.AnyFunSuite

class ValidatorTest extends AnyFunSuite {

    test("value is an integer") {
        val result = Validator.validateNumericType(Some("2"), "Integer")
        assert(result.isEmpty)
    }

    test("value is not an integer") {
        val result = Validator.validateNumericType(None, "Integer")
        assert(result.isDefined)
    }

    test("value is a double") {
        val result = Validator.validateNumericType(Some("12.0"), "Double")
        assert(result.isEmpty)
    }

    test("value is not a double") {
        val result = Validator.validateNumericType(None, "Double")
        assert(result.isDefined)
    }

    test("value is a date with dd/MM/yyyy format") {
        val result = Validator.validateDateAndTimeDataType("16/01/2020", Constants.DateFormats, "Date")
        assert(result.isEmpty)
    }

    test("value is a date with MMM dd, yyyy format") {
        val result = Validator.validateDateAndTimeDataType("Jan 16, 2020", Constants.DateFormats, "Date")
        assert(result.isEmpty)
    }

    test("value is not a date") {
        val result = Validator.validateDateAndTimeDataType("Ja 16, 2020", Constants.DateFormats, "Date")
        assert(result.isDefined)
    }
}
