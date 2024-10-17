/* CMSC430 Project 2
   Nov. 12, 2023
   Carlos Valencia */

/* This file contains flex input file */
/* Added required reserved words, lexemes, and tokens, as well as
   regex for c_comment, real and bool literals, and modified id regex */

%{
#include <string>
#include <vector>

using namespace std;

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
"<"		{ ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"*"		{ ECHO; return(MULOP); }
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
{int}		{ ECHO; return(INT_LITERAL); }
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
"="		{ ECHO; return(RELOP); }
"/="		{ ECHO; return(RELOP); }
">"		{ ECHO; return(RELOP); }
">="		{ ECHO; return(RELOP); }
"<="		{ ECHO; return(RELOP); }
"/"		{ ECHO; return(MULOP); }
rem		{ ECHO; return(REMOP); }
"**"		{ ECHO; return(EXPOP); }
"-"		{ ECHO; return(ADDOP); }
{real_literal}	{ ECHO; return(REAL_LITERAL); }
{bool_literal}	{ ECHO; return(BOOL_LITERAL); }
{id}		{ ECHO; return(IDENTIFIER);}
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%
