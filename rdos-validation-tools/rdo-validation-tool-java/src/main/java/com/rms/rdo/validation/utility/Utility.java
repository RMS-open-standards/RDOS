package com.rms.rdo.validation.utility;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.rms.rdo.validation.model.integrityconstraint.IntegrityConstraint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.util.Map;
import java.util.Optional;

public class Utility {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    private ObjectMapper mapper = new ObjectMapper();

    public Optional<Map<String, String>> getDataTypeValidationJson(String fileName, String validationType) {
        try {
            InputStream inputStream = getClass().getClassLoader().getResourceAsStream(fileName);
            Map<String, String> validationJson =
                    mapper.readValue(inputStream, new TypeReference<Map<String, String>>() {});
            return Optional.of(validationJson);
        } catch (Exception ex) {
            logger.error("Error in parsing the {} json for file: {}", validationType, fileName);
            return Optional.empty();
        }
    }

    public Optional<IntegrityConstraint> getIntegrityConstraintValidationJson(String fileName, String validationType) {
        try {
            InputStream inputStream = getClass().getClassLoader().getResourceAsStream(fileName);
            return Optional.of(mapper.readValue(inputStream, IntegrityConstraint.class));
        } catch (Exception ex) {
            logger.error("Error in parsing the {} json for file: {}", validationType, fileName);
            return Optional.empty();
        }
    }

    public <T> Boolean writeErrorsIntoFile(T errors, String filePath, String validationType) {
        try {
            mapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            FileWriter writer = new FileWriter(new File(filePath + "_errors"), true);
            writer.append("=============" + validationType + "errors =================\n");
            writer.append(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(errors) + "\n\n");
            writer.close();
            return true;
        } catch (Exception ex) {
            logger.error("Failure for writing errors in the file: {}", filePath);
            return false;
        }
    }
}
