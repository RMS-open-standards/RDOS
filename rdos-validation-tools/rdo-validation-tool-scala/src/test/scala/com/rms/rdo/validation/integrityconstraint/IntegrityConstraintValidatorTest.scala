package com.rms.rdo.validation.integrityconstraint

import java.io.File

import com.rms.rdo.validation.constant.Constants
import com.rms.rdo.validation.model.{ForeignKeyErrorDetail, IntegrityConstraint, IntegrityConstraintValidationError, PrimaryKeyError, PrimaryKeyErrorDetail}
import org.mockito.MockitoSugar
import org.scalatest.funsuite.AsyncFunSuite

import scala.concurrent.Future

class IntegrityConstraintValidatorTest extends AsyncFunSuite with MockitoSugar {

    private val primaryKeyValidator = mock[PrimaryKeyValidator]
    private val foreignKeyValidator = mock[ForeignKeyValidator]
    private val integrityConstraintValidator = new IntegrityConstraintValidator(foreignKeyValidator,
                                                                                primaryKeyValidator)

    test("should get error for parsing the integrity constraint config") {
        val file = new File("resources/emp.csv")
        val integrityConstraint = IntegrityConstraint(List("id", "salary"), Nil)
        when(primaryKeyValidator.processPrimaryKeysValidation(file.getPath,
                                                              integrityConstraint)).thenReturn(Future.successful(None))
        when(foreignKeyValidator.processForeignKeysValidation(file.getPath,
                                                              integrityConstraint,
                                                              "employee")).thenReturn(Future.successful(None))
        val result = integrityConstraintValidator.processIntegrityConstraintValidation(file, "employee")
        result.map(x => assert(x == IntegrityConstraintValidationError(Some(Constants
                                                                                    .IntegrityConstrainConfigParsingErrorMessage),
                                                                       None,
                                                                       None)))
    }

    test("should get integrity constraint error with only foreign key error") {
        val file = new File("employee.csv")
        val foreignKeyError = Some(ForeignKeyErrorDetail("error", Nil))
        val integrityConstraint = IntegrityConstraint(List("id", "salary"), Nil)
        when(primaryKeyValidator.processPrimaryKeysValidation(file.getPath,
                                                              integrityConstraint)).thenReturn(Future.successful(None))
        when(foreignKeyValidator.processForeignKeysValidation(file.getPath, integrityConstraint, "employee"))
                .thenReturn(Future.successful(foreignKeyError))
        val result = integrityConstraintValidator.processIntegrityConstraintValidation(file, "employee")
        result.map(x => assert(x == IntegrityConstraintValidationError(None, None, foreignKeyError)))
    }

    test("should get integrity constraint error with only primary key error") {
        val file = new File("employee.csv")
        val primaryKeyError = Some(PrimaryKeyErrorDetail(List(PrimaryKeyError("id",
                                                                              List("1"),
                                                                              Constants
                                                                                      .PrimaryKeyDuplicateValueErrorMessage))))
        val integrityConstraint = IntegrityConstraint(List("id", "salary"), Nil)
        when(primaryKeyValidator.processPrimaryKeysValidation(file.getPath, integrityConstraint))
                .thenReturn(Future.successful(primaryKeyError))
        when(foreignKeyValidator.processForeignKeysValidation(file.getPath, integrityConstraint, "employee"))
                .thenReturn(Future.successful(None))
        val result = integrityConstraintValidator.processIntegrityConstraintValidation(file, "employee")
        result.map(x => assert(x == IntegrityConstraintValidationError(None, primaryKeyError, None)))
    }

    test("should get integrity constraint error with no error") {
        val file = new File("employee.csv")
        val integrityConstraint = IntegrityConstraint(List("id", "salary"), Nil)
        when(primaryKeyValidator.processPrimaryKeysValidation(file.getPath, integrityConstraint))
                .thenReturn(Future.successful(None))
        when(foreignKeyValidator.processForeignKeysValidation(file.getPath, integrityConstraint, "employee"))
                .thenReturn(Future.successful(None))
        val result = integrityConstraintValidator.processIntegrityConstraintValidation(file, "employee")
        result.map(x => assert(x == IntegrityConstraintValidationError(Some(Constants
                                                                                    .NoIntegrityConstraintErrorMessage),
                                                                       None,
                                                                       None)))
    }
}
