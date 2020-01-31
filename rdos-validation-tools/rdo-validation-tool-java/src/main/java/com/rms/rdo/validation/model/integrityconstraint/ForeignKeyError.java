package com.rms.rdo.validation.model.integrityconstraint;

import java.util.List;
import java.util.Map;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.experimental.FieldDefaults;

@Getter
@Builder
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class ForeignKeyError {

    String file;

    List<Map<String, String>> columnValues;

    String message;
}
