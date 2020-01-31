package com.rms.cdl.parser.treebuilder;

import com.rms.cdl.generated.CDLLexer;
import com.rms.cdl.generated.CDLParser;
import com.rms.cdl.generated.CDLParser.CdlContext;

import com.rms.cdl.parser.listener.CustomErrorListener;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;

public class CdlParseTreeBuilder {

    public static CdlContext build(String cdl) {
        ANTLRInputStream input;
        input = new ANTLRInputStream(cdl);
        CDLLexer lexer = new CDLLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        CDLParser parser = new CDLParser(tokens);
        parser.removeErrorListeners();
        parser.addErrorListener(new CustomErrorListener());
        return parser.cdl();
    }
}
