package com.rms.rdo.validation.model

case class IntegrityConstraint(primaryKeys: List[String],
                               foreignKeys: List[ForeignKeyDetail])

case class ForeignKeyDetail(table: String, columnMapping: Map[String, String])