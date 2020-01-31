package com.rms.rdo.validation.datatype;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;
import java.util.stream.Collectors;

public class Validator {

    public static <T> Optional<String> validateNumericType(Supplier<T> value, String dataType) {
        try {
            value.get();
            return Optional.empty();
        } catch (Exception ex) {
            return Optional.of("The value is not a " + dataType);
        }
    }

    public static Optional<String> validateDateAndTimeDataType(String value, List<String> formats, String dataType) {
        List<String> result = formats.stream().map(dateFormat -> isDateValid(value, dateFormat, dataType))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .collect(Collectors.toList());
        if (result.size() == formats.size()) {
            return Optional.of(result.get(0));
        } else {
            return Optional.empty();
        }
    }

    public static <T> Optional<String> validateBitType(String value, String dataType) {
        if (value.equals("0") || value.equals("1")) {
            return Optional.empty();
        } else {
            return Optional.of("The value is not a " + dataType);
        }
    }

    private static Optional<String> isDateValid(String value, String formats, String dataType) {
        try {
            SimpleDateFormat formatter = new SimpleDateFormat(formats);
            formatter.parse(value);
            return Optional.empty();
        } catch (Exception ex) {
            return Optional.of("The value is not a " + dataType);
        }
    }
}
