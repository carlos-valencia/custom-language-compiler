/* CMSC430 Project 3
   Nov. 27, 2023
   Carlos Valencia */

/* This file contains flex input file */
/* Added required reserved words, lexemes, and tokens, as well as
   regex for c_comment, real and bool literals, and modified id regex */
/* Unchanged from previous project submission */

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n
line		[\n]
id		[A-Za-z]([A-Za-z0-9]|_[A-Za-z0-9])*
digit		[0-9]
int		{digit}+
punc		[\(\),:;]
arrow		=>
c_comment	\/\/.*\n
real_literal	[0-9]*\.[0-9]*([eE][\+-]?[0-9]*)?
bool_literal	true|false
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{c_comment}	{ ECHO; nextLine(); }
{line}		{ ECHO; nextLine();}
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
endcase		{ ECHO; return(ENDCASE); }
if		{ ECHO; return(IF); }
endif		{ ECHO; return(ENDIF); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
or		{ ECHO; return(OROP); }
not		{ ECHO; return(NOTOP); }
{arrow}		{ ECHO; return(ARROW); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"/="		{ ECHO; yylval.oper = NOT_EQUAL; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
">="		{ ECHO; yylval.oper = GREATER_EQUAL; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESS_EQUAL; return(RELOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
rem		{ ECHO; yylval.oper = REMAINDER; return(REMOP); }
"**"		{ ECHO; yylval.oper = EXPONENT; return(EXPOP); }
"-" 		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
{real_literal}	{ ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
{bool_literal}	{ ECHO; yylval.value = yytext == "true" ? 1 : 0; return(BOOL_LITERAL); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
