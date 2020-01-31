package com.rms.cdl.parser.listener;

import org.antlr.v4.runtime.*;

import java.util.Collections;
import java.util.List;

public class CustomErrorListener extends BaseErrorListener {

    private String formatError(String message, int linePos, int charPos, String input, int errorStart, int errorEnd) {

        final String nl = System.lineSeparator();
        /* Collect information for underlining the error. */
        String[] lines = input.split(nl);
        StringBuilder prefix = new StringBuilder(nl);
        if (linePos > 2) {
            prefix.append("...");
            prefix.append(nl);
        }
        if (linePos > 1) {
            prefix.append(lines[linePos - 2]);
            prefix.append(nl);
        }

        StringBuilder suffix = new StringBuilder(nl);
        if (lines.length > linePos) {
            suffix.append(lines[linePos]);
            suffix.append(nl);
        }
        if (lines.length > linePos + 1) {
            suffix.append("...");
            suffix.append(nl);
        }
        StringBuilder out = new StringBuilder(nl);
        out.append("at line " + linePos + ", col " + charPos + ": " + message);
        out.append(nl);
        out.append(prefix);
        out.append(lines[linePos - 1]);
        out.append(nl);
        for (int i = 0; i < charPos; i++) {
            out.append(' ');
        }
        for (int i = errorStart; i <= errorEnd; i++) {
            out.append('^');
        }
        out.append(suffix);
        return out.toString();
    }

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer,
                            Object offendingSymbol,
                            int line,
                            int charPositionInLine,
                            String msg,
                            RecognitionException e) {
        Parser parser = (Parser) recognizer;
        List<String> stack = parser.getRuleInvocationStack();
        Collections.reverse(stack);

        String message = msg + " with rule stack " + stack;

        Token offendingToken = (Token) offendingSymbol;
        TokenStream tokens = parser.getTokenStream();
        String input = tokens.getTokenSource().getInputStream().toString();

        int start = offendingToken.getStartIndex();
        int stop = offendingToken.getStopIndex();

        throw new RuntimeException(
                "[Cdl Compile Error] " + formatError(message, line, charPositionInLine, input, start, stop)
        );
    }
}