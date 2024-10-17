// CMSC430 Project 1
// Nov. 12, 2023
// Carlos Valencia
// This file contains the bodies of the functions that produces the compilation listing
// Added a vector of strings to hold the errors in each line
// Added int variables to hold different types of errors

#include <cstdio>
#include <string>
#include <vector>

using namespace std;

#include "listing.h"

static int lineNumber;
static vector<string> errors;
static int totalErrors = 0;

static int lexicalErrors = 0;
static int syntaxErrors = 0;
static int semanticErrors = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\n");
	int errorCount = 0;
	
	if(lexicalErrors > 0)
		errorCount += lexicalErrors;
	
	if(syntaxErrors > 0)
		errorCount += syntaxErrors;
	
	if(semanticErrors > 0)
		errorCount += lexicalErrors;
	
	if(totalErrors == 0)
		printf("Compiled Succesfully\n");
	else
	{
		printf("Lexical Errors: %d\n", lexicalErrors);
		printf("Syntax Errors: %d\n", syntaxErrors);
		printf("Semantic Errors: %d\n", semanticErrors);
	}
	
	return errorCount;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ",
		"Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	string error = messages[errorCategory] + message;
	errors.push_back(error);
	totalErrors++;
	
	switch(errorCategory)
	{
		case LEXICAL:
			lexicalErrors++;
			break;
		case SYNTAX:
			syntaxErrors++;
			break;
		default:
			semanticErrors++;
			break;
	}
}

void displayErrors()
{
	for(int i = 0; i < errors.size(); i++)
		printf("%s\n", errors.at(i).c_str());
	errors.clear();

}
