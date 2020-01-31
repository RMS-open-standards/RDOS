package com.rms.rdo.validation.csv;

import com.rms.rdo.validation.constants.Constants;
import com.rms.rdo.validation.datatype.DataTypeValidator;
import com.rms.rdo.validation.model.datatype.DataTypeValidationErrors;
import com.rms.rdo.validation.utility.Utility;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionStage;
import java.util.function.Function;
import java.util.stream.Collectors;

import akka.actor.ActorSystem;
import akka.stream.IOResult;
import akka.stream.alpakka.csv.javadsl.CsvParsing;
import akka.stream.alpakka.csv.javadsl.CsvToMap;
import akka.stream.javadsl.FileIO;
import akka.stream.javadsl.Sink;
import akka.stream.javadsl.Source;
import akka.util.ByteString;

public class CsvReader {

    private Logger logger = LoggerFactory.getLogger(this.getClass());
    private ActorSystem system;
    private Utility utility;

    public CsvReader(ActorSystem system, Utility utility) {
        this.system = system;
        this.utility = utility;
    }

    public CompletionStage<DataTypeValidationErrors> processDataTypeValidation(File file) {
        Path csvFile = Paths.get(file.getPath());
        Source<ByteString, CompletionStage<IOResult>> source = FileIO.fromPath(csvFile);
        String fileName = file.getName().split("\\.")[0];
        String validationFileName = fileName + "/data_type_validation.json";

        Optional<Map<String, String>> validationJsonOpt = utility.getDataTypeValidationJson(validationFileName,
                Constants.DATA_TYPE_VALIDATION_TYPE);


        String defaultErrorMessage = "Error in parsing the data type validation config file";
        CompletableFuture<DataTypeValidationErrors> defaultResult =
                CompletableFuture.completedFuture(DataTypeValidationErrors.builder().message(defaultErrorMessage).build());

        return validationJsonOpt.map(validationJson ->
                readFileAsStream(csvFile, validationJson, fileName))
                .orElse(defaultResult);
    }

    public CompletableFuture<List<Map<String, String>>> getDataByColumns(String filePath, List<String> columns) {
        Path csvFile = Paths.get(filePath);
        Source<ByteString, CompletionStage<IOResult>> source = FileIO.fromPath(csvFile);

        return source.via(CsvParsing.lineScanner())
                .via(CsvToMap.toMapAsStrings(StandardCharsets.UTF_8))
                .map(row -> columns.stream().collect(Collectors.toMap(res -> res, res -> row.get(res))))
                .runWith(Sink.seq(), system)
                .exceptionally(ex -> {
                    logger.error("Error in reading the file {} for integrity constraint validation", filePath);
                    return Collections.emptyList();
                })
                .toCompletableFuture();
    }

    private CompletableFuture<DataTypeValidationErrors> readFileAsStream(Path csvFile, Map<String,
            String> validationJson, String fileName) {

        Function<Throwable, DataTypeValidationErrors> throwableFunction = ex -> {
            String errorMessage = "Error in processing data type validation for file: " + fileName;
            logger.error(errorMessage);
            return DataTypeValidationErrors.builder().message(errorMessage).build();
        };

        return FileIO.fromPath(csvFile)
                .via(CsvParsing.lineScanner())
                .via(CsvToMap.toMapAsStrings(StandardCharsets.UTF_8))
                .map(row -> DataTypeValidator.validateDataType(row,
                        validationJson))
                .filter(list -> !list.isEmpty())
                .runWith(Sink.seq(), system)
                .thenApply(listOfList -> listOfList.stream()
                        .flatMap(Collection::stream)
                        .collect(Collectors.toList()))
                .thenApply(errorList -> DataTypeValidationErrors.builder()
                        .errors(errorList)
                        .build())
                .exceptionally(
                        throwableFunction)
                .toCompletableFuture();
    }
}
