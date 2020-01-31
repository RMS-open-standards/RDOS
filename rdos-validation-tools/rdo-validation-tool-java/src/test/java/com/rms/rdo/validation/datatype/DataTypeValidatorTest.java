package com.rms.rdo.validation.datatype;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasSize;


public class DataTypeValidatorTest {


    @Test
    public void getValidationErrorForLong() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "123abc");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Double");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationErrorForDouble() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "123abc");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Long");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationErrorForInteger() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "123abc");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Integer");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationErrorForByte() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "123abc");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Byte");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationErrorForShort() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "123abc");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Short");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationErrorForBit() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "2");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Bit");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationErrorForDate() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "2");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Date");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationErrorForTime() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "2");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Time");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationErrorForDateTime() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "2");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "DateTime");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((1)));
    }

    @Test
    public void getValidationStringDataType() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "2");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "String");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((0)));
    }
    @Test
    public void getNoValidationError() {
        Map<String, String> data = new HashMap<>();
        data.put("id", "1");
        data.put("accountId", "2");

        Map<String, String> validationMap = new HashMap<>();
        validationMap.put("id", "Long");
        validationMap.put("accountId", "Long");

        assertThat(DataTypeValidator.validateDataType(data, validationMap), hasSize((0)));
    }

}



