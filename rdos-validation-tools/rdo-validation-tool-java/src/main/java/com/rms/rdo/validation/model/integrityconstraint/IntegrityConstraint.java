package com.rms.rdo.validation.model.integrityconstraint;

import java.util.List;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class IntegrityConstraint {

    List<String> primaryKeys;

    List<ForeignKeyDetail> foreignKeys;
}
