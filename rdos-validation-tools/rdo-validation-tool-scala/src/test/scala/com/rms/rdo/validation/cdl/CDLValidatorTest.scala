package com.rms.rdo.validation.cdl

import java.io.File

import org.scalatest.funsuite.AsyncFunSuite

class CDLValidatorTest extends AsyncFunSuite {

    test("should not be able to validate for wrong CDL file") {
        val result = CDLValidator.validateCDLFile(new File(""))
        assert(result.isEmpty)
    }

    test("validate valid CDL file") {
        val result = CDLValidator.validateCDLFile(new File("src/test/resources/cdl/valid.txt"))
        assert(result.isEmpty)
    }

    test("validate invalid CDL file") {
        val result = CDLValidator.validateCDLFile(new File("src/test/resources/cdl/invalid.txt"))
        assert(result.isDefined)
    }
}
