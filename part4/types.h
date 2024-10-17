// CMSC430 - Project 4
// Dec. 12, 2023
// Carlos Valencia

// This file contains type definitions and the function
// prototypes for the type checking functions
// Added function definitions for functions that check
// remainder, if, and case
// Expanded Types enum to include value for empty when clause

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE, MATCH};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
Types checkRem(Types left, Types right);
Types checkIfStatement(Types exp, Types thenStat, Types elseStat);
void checkCase(Types exp);
Types checkCases(Types left, Types right);
