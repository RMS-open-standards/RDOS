package com.rms.rdo.validation.constants;

import java.util.Arrays;
import java.util.List;

public class Constants {

    public static final String EMPTY_STRING = "";
    public static final String FOREIGN_KEY_ERROR_MESSAGE =
            "The below columnValues should not be present in this file as it is not present" +
                    " in primary keys of the below given file";
    public static final String PRIMARY_KEY_NULL_VALUE_ERROR_MESSAGE = "Primary Key contains null values";
    public static final String PRIMARY_KEY_DUPLICATE_VALUE_ERROR_MESSAGE = "Primary Key contains duplicate Values";
    public static final String DATA_TYPE_VALIDATION_TYPE = "data type validation";
    public static final String INTEGRITY_CONSTRAINT_VALIDATION_TYPE = "integrity constraint validation";
    public static final List<String> DATE_FORMATS = Arrays.asList("MM/dd/yyyy", "dd/MM/yyyy", "MMM dd, yyyy", "dd-MM" +
            "-yyyy");
    public static final List<String> TIME_FORMATS = Arrays.asList("hh:mm:ss", "hh:mm:ss[.nnnnnnn]", "hh-mm-ss");
    public static final List<String> DATE_TIME_FORMATS = Arrays.asList("MM/dd/yyyy hh:mm:ss", "dd/MM/yyyy hh:mm:ss",
            "MMM dd, yyyy hh:mm:ss", "dd-MM-yyyy hh:mm:ss");

    public static final String INTEGRITY_CONSTRAIN_CONFIG_PARSING_ERROR_MESSAGE = "Error in parsing the integrity " +
            "constraint config file";
    public static final String NO_INTEGRITY_CONSTRAINT_ERROR_MESSAGE = "There are no integrity constraint errors";
    public static final String RDO_VALIDATION_TYPE = "RDO";
    public static final String CDL_VALIDATION_TYPE = "CDL";
    public static final List<String> VALIDATION_TYPE = Arrays.asList(RDO_VALIDATION_TYPE, CDL_VALIDATION_TYPE);
}
