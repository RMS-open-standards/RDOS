package com.rms.rdo.validation.datatype

import com.rms.rdo.validation.model.DataTypeValidationError
import org.scalatest.funsuite.AnyFunSuite

class DataTypeValidatorTest extends AnyFunSuite {

    test("get a validation error for long type") {
        val data = Map("id" -> "1", "accountId" -> "123abc")
        val validationMap = Map("id" -> "Long", "accountId" -> "Long")

        val expectedResponse = List(DataTypeValidationError("accountId", "123abc", "The value is not a Long"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get a validation error for double type") {
        val data = Map("id" -> "1", "accountId" -> "123abc")
        val validationMap = Map("id" -> "Long", "accountId" -> "Double")

        val expectedResponse = List(DataTypeValidationError("accountId", "123abc", "The value is not a Double"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get a validation error for integer type") {
        val data = Map("id" -> "1", "accountId" -> "123abc")
        val validationMap = Map("id" -> "Long", "accountId" -> "Integer")

        val expectedResponse = List(DataTypeValidationError("accountId", "123abc", "The value is not a Integer"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get a validation error for byte type") {
        val data = Map("id" -> "1", "accountId" -> "123abc")
        val validationMap = Map("id" -> "Long", "accountId" -> "Byte")

        val expectedResponse = List(DataTypeValidationError("accountId", "123abc", "The value is not a Byte"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get a validation error for short type") {
        val data = Map("id" -> "1", "accountId" -> "123abc")
        val validationMap = Map("id" -> "Long", "accountId" -> "Short")

        val expectedResponse = List(DataTypeValidationError("accountId", "123abc", "The value is not a Short"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get a validation error for date type") {
        val data = Map("id" -> "1", "accountId" -> "123abc")
        val validationMap = Map("id" -> "String", "accountId" -> "Date")

        val expectedResponse = List(DataTypeValidationError("accountId", "123abc", "The value is not a Date"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get a validation error for time type") {
        val data = Map("id" -> "1", "accountId" -> "123abc")
        val validationMap = Map("id" -> "String", "accountId" -> "Time")

        val expectedResponse = List(DataTypeValidationError("accountId", "123abc", "The value is not a Time"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get a validation error for datetime type") {
        val data = Map("id" -> "1", "accountId" -> "123abc")
        val validationMap = Map("id" -> "String", "accountId" -> "DateTime")

        val expectedResponse = List(DataTypeValidationError("accountId", "123abc", "The value is not a DateTime"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get a validation error for bit type") {
        val data = Map("id" -> "1", "accountId" -> "2")
        val validationMap = Map("id" -> "String", "accountId" -> "Bit")

        val expectedResponse = List(DataTypeValidationError("accountId", "2", "The value is not a Bit"))

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == expectedResponse)
    }

    test("get no validation error ") {
        val data = Map("id" -> "1", "accountId" -> "123")
        val validationMap = Map("id" -> "Long", "accountId" -> "Long")

        val result = DataTypeValidator.validateDataType(data, validationMap)
        assert(result == Nil)
    }
}
