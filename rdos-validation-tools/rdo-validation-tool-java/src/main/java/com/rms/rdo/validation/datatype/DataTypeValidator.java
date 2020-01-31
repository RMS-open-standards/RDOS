package com.rms.rdo.validation.datatype;

import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.model.datatype.DataTypeValidationError;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

public class DataTypeValidator {

    public static List<DataTypeValidationError> validateDataType(Map<String, String> row,
                                                                 Map<String, String> validationMap) {
        List<String> columnNames = new ArrayList<>(row.keySet());
        return columnNames.stream().map(columnName ->
                checkDataTypes(row.get(columnName), validationMap.get(columnName))
                        .map(error -> DataTypeValidationError.builder()
                                .columnName(columnName)
                                .columnValue(row.get(columnName))
                                .errorMessage(error)
                                .build()))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .collect(Collectors.toList());
    }

    private static Optional<String> checkDataTypes(String columnValue, String dataType) {

        switch (dataType) {
            case "Double":
                return Validator.validateNumericType(() -> Double.valueOf(columnValue).toString(), dataType);
            case "Long":
                return Validator.validateNumericType(() -> Long.valueOf(columnValue).toString(), dataType);
            case "Byte":
                Validator.validateNumericType(() -> Byte.valueOf(columnValue).toString(), dataType);
            case "Short":
                return Validator.validateNumericType(() -> Short.valueOf(columnValue).toString(), dataType);
            case "Integer":
                return Validator.validateNumericType(() -> Integer.valueOf(columnValue).toString(), dataType);
            case "Date":
                return Validator.validateDateAndTimeDataType(columnValue, Constants.DATE_FORMATS, dataType);
            case "Time":
                return Validator.validateDateAndTimeDataType(columnValue, Constants.TIME_FORMATS, dataType);
            case "DateTime":
                return Validator.validateDateAndTimeDataType(columnValue, Constants.DATE_TIME_FORMATS, dataType);
            case "Bit":
                return Validator.validateBitType(columnValue, dataType);
            default:
                return Optional.empty();
        }
    }
}
