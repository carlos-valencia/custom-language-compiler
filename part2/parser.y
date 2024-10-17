/* CMSC430 - Project 2
   Nov. 12, 2023
   Carlos Valencia 
   This file defines the grammar for the target language.*/

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL
%token REAL_LITERAL
%token BOOL_LITERAL

%token ADDOP MULOP RELOP ANDOP OROP NOTOP REMOP EXPOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token CASE ELSE ENDCASE IF ENDIF OTHERS REAL THEN WHEN ARROW NOT

%%

function:	
	function_header variables body ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ;
	
variables:
	variable variables| 
	;

variable:
	IDENTIFIER ':' type IS statement_ ;
	
parameters:
	parameter additional_parameters | 
	parameter |
	;
	
additional_parameters:
	',' parameter additional_parameters | 
	',' parameter;
	
parameter:
	IDENTIFIER ':' type;


type:
	INTEGER |
	BOOLEAN |
	REAL;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE ;
	
cases:
	case cases|
	;
	
	
case:
	WHEN INT_LITERAL ARROW statement_ | 
	error;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ |
	;
		    
expression:
	expression OROP bool_addition |
	bool_addition ;
	
bool_addition:
	bool_addition ANDOP relation |
	relation ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP power | factor REMOP power | 
	power ;

power:
	negation EXPOP power | 
	negation ;

negation:
	NOTOP negation | 
	primary;

primary:
	'(' expression ')' |
	INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
	IDENTIFIER ;
    
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
