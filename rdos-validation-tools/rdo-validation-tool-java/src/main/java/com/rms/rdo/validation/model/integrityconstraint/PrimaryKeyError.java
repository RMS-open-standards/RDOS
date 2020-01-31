package com.rms.rdo.validation.model.integrityconstraint;

import java.util.List;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.experimental.FieldDefaults;

@Getter
@Builder
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class PrimaryKeyError {

    String columnName;

    List<String> columnValue;

    String errorMessage;
}
