package com.rms.rdo.validation.model.integrityconstraint;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.experimental.FieldDefaults;

@Getter
@Builder
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class IntegrityConstraintValidationError {

    String message;

    PrimaryKeyErrorDetail primaryKey;

    ForeignKeyErrorDetail foreignKey;
}

