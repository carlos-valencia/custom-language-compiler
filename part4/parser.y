/* CMSC430 - Project 4
   Dec. 9, 2023
   Carlos Valencia
   This file defines the grammar fot the target language 
   Expanded grammar to account for new tokens and generate appropriate errors*/

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL
%token <type> REAL_LITERAL
%token <type> BOOL_LITERAL


%token ADDOP MULOP RELOP ANDOP EXPOP OROP NOTOP REMOP
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token REAL IF THEN ELSE ENDIF CASE WHEN ARROW OTHERS ENDCASE

%type <type> type statement statement_ reductions expression relation term
	factor primary power bool_addition negation function_header body variable case cases

%%

function:	
	function_header optional_variable body {checkAssignment($1, $3, "Function Return");} ;
	
function_header:	
	FUNCTION IDENTIFIER RETURNS type ';' {$$ = $4;};

optional_variable:
	variable optional_variable |
	;

variable:	
	IDENTIFIER ':' type IS statement_ 
		{checkAssignment($3, $5, "Variable Initialization");
		if(!symbols.find($1, $$)) symbols.insert($1, $3);
		else appendError(DUPLICATE_IDENTIFIER, $1); } ;

type:
	INTEGER {$$ = INT_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} |
	REAL {$$ = REAL_TYPE; };

body:
	BEGIN_ statement_ END ';' {$$ = $2;};
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = checkIfStatement($2, $4, $6);} |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE {checkCase($2);} ;
	
cases:
	cases case {$$ = checkCases($1, $2);}|
	{$$ = MATCH;};
	
case:
	WHEN INT_LITERAL ARROW statement_ {$$ = $4;} |
	error {$$ = MISMATCH; } ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;
		    
expression:
	expression OROP bool_addition {$$ = checkLogical($1, $3);} |
	bool_addition ;
	
bool_addition:
	bool_addition ANDOP relation {$$ = checkLogical($1, $3); } |
	relation;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP power  {$$ = checkArithmetic($1, $3);} |
	factor REMOP power {$$ = checkRem($1, $3); } |
	power ;
	
power:
	negation |
	negation EXPOP power {$$ = checkArithmetic($1, $3); } ;
	
negation:
	NOTOP negation {$$ = checkLogical($2, $2); } | 
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
