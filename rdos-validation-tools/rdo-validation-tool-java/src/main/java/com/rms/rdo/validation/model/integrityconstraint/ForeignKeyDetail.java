package com.rms.rdo.validation.model.integrityconstraint;

import java.util.Map;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ForeignKeyDetail {

    String table;

    Map<String, String> columnMapping;
}
