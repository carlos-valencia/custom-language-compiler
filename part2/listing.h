// CMSC430 Project 2
// Nov. 12, 2023
// Carlos Valencia
// This file contains the function prototypes for the functions that produce the
// compilation listing
// Unchanged from source

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

