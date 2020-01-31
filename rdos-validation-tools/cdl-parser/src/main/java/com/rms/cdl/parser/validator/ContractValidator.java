package com.rms.cdl.parser.validator;

import com.rms.cdl.generated.CDLBaseListener;
import com.rms.cdl.generated.CDLParser;

import com.rms.cdl.parser.treebuilder.CdlParseTreeBuilder;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.*;

public class ContractValidator extends CDLBaseListener {

    public static void validate(String cdl) {
        CDLParser.CdlContext parseTree = CdlParseTreeBuilder.build(cdl);
        ContractValidator validator = new ContractValidator();
        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(validator, parseTree);
        validator.validate();
    }

    private LabelValidator labelValidator = new LabelValidator();
    private String currentSection = null;

    private ContractValidator() {}

    private void validate() {
        labelValidator.assertUniqueLabels();
    }

    @Override
    public void enterSection(CDLParser.SectionContext ctx) {
        currentSection = canonicalize(ctx.IDENT());
    }

    @Override
    public void exitSection(CDLParser.SectionContext ctx) {
        currentSection = null;
        add("sections", ctx.IDENT());
    }

    @Override
    public void enterCover(CDLParser.CoverContext ctx) {
        add(currentSection == null
            ? "contract covers"
            : "covers of section '" + currentSection + "'",
            ctx.label()
           );
    }

    @Override
    public void enterDeductible(CDLParser.DeductibleContext ctx) {
        add("deductibles", ctx.label());
    }

    @Override
    public void enterSublimit(CDLParser.SublimitContext ctx) {
        add("sublimits", ctx.label());
    }

    @Override
    public void enterDependentCashflow(CDLParser.DependentCashflowContext ctx) {
        add("cashflows", ctx.IDENT(0));
    }

    @Override
    public void enterIndependentCashflow(CDLParser.IndependentCashflowContext ctx) {
        add("cashflows", ctx.IDENT());
    }

    @Override
    public void enterReinstatementLine(CDLParser.ReinstatementLineContext ctx) {
        add("reinstatement lines", ctx.IDENT(0));
    }

    @Override
    public void enterSubschedule(CDLParser.SubscheduleContext ctx) {
        add("subschedules", ctx.IDENT());
    }

    private void add(String category, CDLParser.LabelContext labelCtx) {
        if (labelCtx != null) {
            add(category, labelCtx.IDENT());
        }
    }

    private void add(String category, TerminalNode token) {
        labelValidator.add(category, canonicalize(token));
    }

    private String canonicalize(ParseTree token) {
        return token == null
               ? ""
               : token.getText().toLowerCase();
    }

    private static class LabelValidator {

        private Map<String, List<String>> categoryToLabels = new LinkedHashMap<>();

        LabelValidator() {}

        LabelValidator add(String category, String label) {
            if (label.isEmpty()) {
                return this;
            }
            List<String> labels = categoryToLabels.getOrDefault(category, new ArrayList<>());
            labels.add(label);
            categoryToLabels.put(category, labels);
            return this;
        }

        void assertUniqueLabels() {
            categoryToLabels.forEach(this::assertUniquenessInSameCategory);
            categoryToLabels.forEach(this::assertUniquenessAcrossCategories);
        }

        private void assertUniquenessAcrossCategories(String category, List<String> labels) {
            for (String newLabel : labels) {
                categoryToLabels.forEach((otherCategory, otherCategoryLabels) -> {
                    if (!category.equals(otherCategory)) {
                        if (otherCategoryLabels.contains(newLabel)) {
                            throw new RuntimeException(
                                    String.format("Label '%s' in %s is repeated in %s",
                                                  newLabel,
                                                  otherCategory,
                                                  category)
                            );
                        }
                    }
                });
            }
        }

        private void assertUniquenessInSameCategory(String category, List<String> labels) {
            Set<String> uniqueLabels = new HashSet<>();
            for (String label : labels) {
                if (uniqueLabels.contains(label)) {
                    throw new RuntimeException(String.format("Label '%s' is repeated in %s", label, category));
                } else {
                    uniqueLabels.add(label);
                }
            }
        }
    }
}
