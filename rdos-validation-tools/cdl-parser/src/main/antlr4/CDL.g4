// Contract Definition Language grammar, RIsk Data Open Standard version RDOS-1.0

grammar CDL;

cdl : contract EOF ;
// A CDL contract consists of the keyword 'Contract' followed by declarations and at least one cover. Other parts, such as cashflows, are optional.

contract : CONTRACT declarationPart cashflowPart? reinstatementPart? coverPart sectionPart? sublimitPart? deductiblePart? subschedulePart? ;

// Every contract has a list of declarations, introduced by the keyword 'Declarations'
declarationPart : DECLARATIONS declaration+ ;

// A contract can have premium reinstatements
reinstatementPart : REINSTATEMENTS reinstatementLine+ ;

// Every contract has an optional list of covers, introduced by the keyword 'Covers'.
// Covers specify which claims get paid, and for how much
coverPart : COVERS covers ;

// A contract has an optional list of terms, which consist of sublimits followed by deductibles.
// Terms provide 'haircuts' which reduce the subject seen by the covers.
// Terms can be sublimits or deductibles.
// Sublimits, if present, are introduced by the keyword 'Sublimits'
sublimitPart : SUBLIMITS sublimit+ ;

// Deductibles, if present, are introduced by the keyword 'Deductibles'
deductiblePart : DEDUCTIBLES deductible+ ;

// Sections, if present, are introduced by the keyword 'Sections'
sectionPart : SECTIONS section+ ;

// Cashflows, if present, are introduces by the keyword 'Cashflows`
cashflowPart: CASHFLOWS cashflow+ ;

// Subschedules, if present, are introduced by the keyword 'Subschedules'
subschedulePart : SUBSCHEDULES subschedule+ ;
//
// Declarations
//
declaration :
	  INCEPTION IS dateExpression    # inceptionDecl
	  | EXPIRATION IS dateExpression   # expirationDecl
      | CURRENCY IS currencyUnit       # currencyDecl
      | ATTACHMENTBASIS IS attachmentBasis  # attachmentBasisDecl
      | RISK IS EACH riskGranularity # riskDecl
      | IDENT '(' arguments ')' IS expression     # functionDecl
      | IDENT IS (expression | IDENT | phrase)    # identDecl
	  ;


riskGranularity : CONTRACT | SECTION | LOCATION ;

identOrPhrase : IDENT | phrase ;

// Attachment basis specifies a time filter on which losses to consider.
attachmentBasis :
    lossOccurrenceBasis
    | riskAttachmentBasis
    | riskAttachmentBasis AND lossOccurrenceBasis
    | lossOccurrenceBasis AND riskAttachmentBasis
    ;

// Default basis is loss occurring from inception to expiration
lossOccurrenceBasis : LOSS OCCURRING optionalDateRange ;

riskAttachmentBasis :
     RISK ATTACHING optionalDateRange
   | INFORCE POLICIES optionalDateRange
   | POLICIES ISSUED optionalDateRange ;

versionedRef : identOrPhrase version ;

//
// Reinstatements
//

reinstatementLine: IDENT COLON reinstatement (COMMA reinstatement)* ON IDENT WITH IDENT ;

reinstatement:
    reinstatementQuantifier FREE
    | reinstatementQuantifier ATSIGN fraction reinstatementProRataFactor
    ;

reinstatementQuantifier : INTEGER | UNLIMITED ;

reinstatementProRataFactor : /* empty */
    | PRT
    | PRC
    | PRT PRC
    | PRC PRT
    ;

//
//  Covers
//

covers : BY SECTION | cover+ ;

// A cover has a participation, a payout, an attachment and may have a constraint on subject
cover : label? participation payout attachment coverSubjectConstraint ;

participation : fraction SHARE ;

// Payout - if empty, cover will pay all losses it sees (above the attachment)
//    note: OF is inserted to make contracts more readable, e.g., 100% SHARE of 1M
payout : /* empty */
         | OF payoutSpec timeBasis ;

payoutSpec : amount | PAY amount ;

// Attachment - Cover attaches if cover subject exceeds the attachment.
//    If empty, cover will always attach.
//    If cover attaches, subject is reduced by value of attachment, unless it is a franchise.
attachment: /* empty */
         | XS amount franchise timeBasis ;

// Covers can derive subject from child covers and sections or by constraining the contract subject
coverSubjectConstraint : derivedSubject | subjectConstraint ;

// Derived subject can reference other covers or sections by name
derivedSubject : ON identifiers | ON functionCall ;

//
//  Terms
//

// Terms may be sublimits or deductibles. Every term may have a timeBasis and a constraint on the subject
termModifiers : timeBasis subjectConstraint ;

// Sublimits

// A sublimit has an amount and may have a time basis, subject constraint,  and resolution
// A sublimit can be labeled or unlabelled
sublimit : label? amount termModifiers ;

// Deductibles

// A deductible has an amount, may be franchise, may interact with other deductibles.
// As with sublimits, it may have a time basis, subject constraint, and resolution
// As with sublimits, it may be labelled
deductible : label? amount franchise interaction? termModifiers ;

// Default interaction is min deductible. Could instead be Max deductible.
interaction : MIN | MAX | MAXIMUM ;

//
// Sections
//

// A section has a name, and consists of declarations and covers. It does not contain sections or terms.
// A section is basically a named subcontract: It is executed within the context of the enclosing contract
// after the declarations and terms, and before the covers.  The payout of a section is determined by
// its covers, and can be referenced by other covers using its section name.
section : SECTION IDENT declarationPart? coverPart ;

//
// Cashflows
//

// A cashflow has a name and might have time clause
// A cashflow either is whole amount or a percentage of another cashflow
cashflow :
    IDENT IS wholeAmount timeClause?   # independentCashflow
    | IDENT IS number PERCENT OF IDENT timeClause?   # dependentCashflow
    ;

timeClause:
    AT date
    | AT baseDate=(INCEPTION|EXPIRATION) (op=(PLUS|MINUS) INTEGER DAY)?
    ;

//
// Sub-schedule Definitions
//

// A sub-schedule is a named collection of risks
subschedule : IDENT COLON identifiers ;

//
// Term (and cover term) amounts
//
amount :
    wholeAmount
    | fractionalAmount
    | functionalAmount
    | UNLIMITED
    ;

// For example, 100M USD
wholeAmount : expression currencyUnit? ;

// For example, 2% ReplacementCost
fractionalAmount : fraction amountBasis;

// Amount basis is the underlying
amountBasis : insuredValue | subjectClaims | sumInsured ;

// A fraction may be expressed as 0.02 or 2% or F(3) or G(x) %
fraction : expression PERCENT? ;

insuredValue : valuationBasis exposureBasis ;
valuationBasis : REPLACEMENTCOST | CASHVALUE ;
exposureBasis : /* empty */ | AFFECTED | COVERED;

subjectClaims : OF LOSS ;

sumInsured : TOTALSUMINSURED ;

functionalAmount: functionName '(' amount (COMMA amount)+ ')' ;

//
// An expression evaluates to a number (in some cases, per event)
//
expression :
    unaryOp=MINUS expression
    // This rule must appear before the (+|-) rule to have 1 + 2 * 3 = 1 + (2 * 3)
    | expression op=(TIMES|SLASH) expression
    | expression op=(PLUS|MINUS) expression
    | '(' expression ')'
    | number multiplier?
    | SUBJECT
    | functionCall
    ;

//
// A boolean expression evaluates to true / false
//
booleanExpression :
    | IDENT sign=(GREATERTHAN|GREATERTHANOREQUAL|LESSTHAN|LESSTHANOREQUAL) (IDENT|amount)
    | booleanExpression op=(AND|OR) booleanExpression
    | '(' booleanExpression ')'
    ;

//
// Functions may be called with any number of arguments, and must return a double
//
functionCall : functionName '(' arguments? ')' ;
functionName : IDENT | MIN | MAX | SUM;
arguments : argument (COMMA argument )* ;
// A function argument may be an expression or a labeled term, section or cover
argument : expression | IDENT ;



// All terms are per occurrence by default
timeBasis :  /* empty */
              | PEROCCURRENCE
              | AGGREGATE
			  ;

// Does term apply to each risk separately?  By default, no.
resolution :  /* empty */
              | PERRISK
			  ;

// Deductibles and attachment can be standard or franchise.
franchise : /* empty */
    | FRANCHISE ;

// Subject constraints - used on terms and covers as constraints against contract subject
subjectConstraint : 
    outcomeTypeConstraint scheduleConstraint causeOfLossConstraint resolution ;

causeOfLossConstraint : /* empty */ | BY IDENT (COMMA IDENT)*;

outcome : LOSS ;                   // In future, may also support | DAMAGE | HAZARD ;
outcomeType : IDENT | outcome;
outcomeTypeConstraint : /* empty */ | FOR outcomeType (COMMA outcomeType)*;

scheduleConstraint : /* empty */ | TO IDENT (COMMA IDENT)*;

currencyUnit : IDENT ;

// Time
optionalDateRange :
    /* empty */
    | FROM date UNTIL date
    | UNTIL date
	;

dateExpression: date | duration;
date : dayOfMonth month year
	   ;

duration : INTEGER durationTimeUnit;
durationTimeUnit : DAY | WEEK |  MONTH | YEAR ;
month : JAN | FEB | MAR | APR | MAY | JUN | JUL | AUG | SEP | OCT | NOV | DEC;
dayOfMonth : INTEGER;
year : INTEGER;

identifiers : IDENT (COMMA IDENT)* ;

multiplier : THOUSAND | MILLION | BILLION;

number : INTEGER | FLOAT;
phrase : PHRASE;
version : PHRASE;
label : IDENT COLON ;

/*
 * Lexer Rules
 */

SLASH : '/';
LPAREN : '(';
RPAREN : ')';
LSQUARE : '[';
RSQUARE : ']';
PERCENT : '%';
UNDERSCORE : '_';
SEMICOLON : ';';
COLON : ':';
PLUS : '+';
MINUS : '-';
TIMES : '*';
ELLIPSIS : '...';
DOT : '.';
COMMA : ',';
GREATERTHAN : '>';
GREATERTHANOREQUAL : '>=';
LESSTHAN : '<';
LESSTHANOREQUAL : '<=';
ATSIGN : '@';
AND : A N D;
OR : O R;
FOR : F O R;
ACV: A C V;
PERRISK : P E R WS R I S K;
PEROCCURRENCE : PER WS OCCURRENCE;
CONTRACT : C O N T R A C T;
PRODUCT  : P R O D U C T;
LOCATION : L O C A T I O N;
MIN : M I N;
MAX : M A X;
SUM : S U M;
MAXIMUM : M A X I M U M;
DECLARATIONS : D E C L A R A T I O N S;
COVERS : C O V E R S;
SUBLIMITS : S U B L I M I T S;
DEDUCTIBLES : D E D U C T I B L E S;
SECTION : S E C T I O N;
SECTIONS : SECTION S;
INCEPTION : I N C E P T I O N;
EXPIRATION : E X P I R A T I O N;
CURRENCY : C U R R E N C Y;
ATTACHMENTBASIS : A T T A C H M E N T WS B A S I S;
OCCURRENCES : OCCURRENCE S;
OCCURRENCE : O C C U R R E N C E;
USING : U S I N G;
SHARE : S H A R E;
LOSS : L O S S;
DAMAGE : D A M A G E;
HAZARD : H A Z A R D;
NOT : N O T;
ABSORBABLE : A B S O R B A B L E;
NET : N E T;
DEDUCTIBLE : D E D U C T I B L E;
RISK : R I S K;
ATTACHING : A T T A C H I N G;
INFORCE : I N F O R C E;
POLICIES : P O L I C I E S;
ISSUED : I S S U E D;
OCCURRING : O C C U R R I N G;
PAY : P A Y;
XS : X S;
FRANCHISE : F R A N C H I S E;
REPLACEMENTCOST : R E P L A C E M E N T WS C O S T | R C V;
TOTALSUMINSURED : T O T A L WS SUM I N S U R E D;
AFFECTED : A F F E C T E D;
CASHVALUE : A C T U A L WS C A S H WS V A L U E;
COVERED : C O V E R E D;
AGGREGATE : A G G R E G A T E;
TYPE : T Y P E;
HOUR : H O U R (S)?;
DAY : D A Y (S)?;
WEEK : W E E K (S)?;
MONTH : M O N T H (S)?;
YEAR : Y E A R (S)?;
IS : I S;
ARE : A R E;
HAS : H A S;
ON : O N;
OF : O F;
IF : I F;
PER : P E R;
PRT : P R T | P DOT R DOT T DOT | P R O WS R A T A WS T I M E;
PRC : P R C | P DOT R DOT C DOT | P R O WS R A T A WS A M O U N T;
BY :  B Y;
TO : T O;
AT : A T;
EACH : E A C H;
FROM : F R O M;
UNTIL : U N T I L;
UNLIMITED : U N L I M I T E D;
SUBSCHEDULES : S U B S C H E D U L E S;
SUBJECT : S U B J E C T;
CASHFLOWS : C A S H F L O W S;
REINSTATEMENTS : R E I N S T A T E M E N T S;
FREE : F R E E;
WITH : W I T H;
WITHIN : W I T H I N;
EVENTS: E V E N T S;
DISTANCEUNIT : M I L E S | K I L O M E T E R S;

JAN : J A N (U A R Y)?;
FEB : F E B (R U A R Y)?;
MAR : M A R (C H)?;
APR : A P R (I L)?;
MAY : M A Y;
JUN : J U N (E)?;
JUL : J U L (Y)?;
AUG : A U G (U S T)?;
SEP : S E P (T E M B E R)?;
OCT : O C T (O B E R)?;
NOV : N O V (E M B E R)?;
DEC : D E C (E M B E R)?;

COMMENT	: SLASH SLASH ~[\n\r]* -> skip;

MILLION : M | M I L L I O N;
BILLION : B | B I L L I O N;
THOUSAND : K | T H O U S A N D;

IDENT      : EXTENDEDALPHA (EXTENDEDALPHA | DIGIT | UNDERSCORE | DOT | MINUS)* ;
COLONIDENT : IDENT COLON IDENT ;

PHRASE	: '{' (~[{])* '}';
WS : [ \t\r\n]+ -> channel(HIDDEN);

FLOAT   : DIGIT* '.' DIGIT+;
INTEGER : DIGIT+;

fragment DIGIT : [0-9];
fragment EXTENDEDALPHA :  [a-zA-ZÀ-ÖØ-öø-ÿ];
fragment ALPHA : [a-zA-Z];

fragment A : [aA];
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];

