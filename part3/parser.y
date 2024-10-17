/* CMSC430 Project 3
   Nov. 26, 2023
   Carlos Valencia */

/* This file defines the grammar for the target language */
/* Added dynamic array for parameters, changed symbol table to double values, 
   expanded grammar to last project submission and incorporated interpreter function
   where necessary */

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<double> symbols;

double result;

double* params;
int curr = 0;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	double value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL
%token <value> REAL_LITERAL
%token <value> BOOL_LITERAL

%token <oper> ADDOP MULOP RELOP REMOP EXPOP
%token ANDOP OROP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token REAL IF THEN ELSE ENDIF CASE WHEN OTHERS ARROW ENDCASE

%type <value> body statement_ statement reductions expression relation term
	factor primary bool_addition power negation case cases
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' ;

optional_variable:
	variable optional_variable|
	%empty ;

variable:	
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;
	
parameters:
	parameter additional_parameters |
	parameter |
	%empty ;
	
additional_parameters:
	',' parameter additional_parameters |
	',' parameter;
	
parameter:
	IDENTIFIER ':' type {symbols.insert($1, params[curr++]);};

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = $2 == 1 ? $4 : $6;} |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE {$$ = isnan($4) ? $7 : $4;};
	
cases:
	cases case {$$ = isnan($1) ? $2 : $1;}|
	%empty {$$ = NAN;};
	
case:
	WHEN INT_LITERAL ARROW statement_  {
	$$ = $<value>-2 == $2 ? $4 : NAN;}|
	error ';' {$$ = 0;} ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	%empty {$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
	expression OROP bool_addition {$$ = $1 || $3;} |
	bool_addition ;

bool_addition:
	bool_addition ANDOP relation {$$ = $1 && $3;} | 
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP power {$$ = evaluateArithmetic($1, $2, $3);} | 
	factor REMOP power {$$ = evaluateArithmetic($1, $2, $3); } |
	power ;

power:
	negation |
	negation EXPOP power {$$ = evaluateArithmetic($1, $2, $3);};
	
negation:
	NOTOP negation {$$ = !$2;}| 
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
	params = new double[argc - 1];
	
	for(int i = 0; i < argc - 1; i++)
		params[i] = atof(argv[i + 1]);
		
	
	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
		
	delete[] params;
	return 0;
} 
