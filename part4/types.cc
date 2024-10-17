// CMSC430 - Project 4
// Dec. 12, 2023
// Carlos Valencia

// This file contains the bodies of the type checking functions
// Modified checkAssignment to check and generate narrowing error
// Added implementations for checking remainder, if, and case

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	
	if (lValue != MISMATCH && rValue != MISMATCH) 
	{
	
		if(lValue == INT_TYPE && rValue == REAL_TYPE)
		{
			appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
			return;
		}
			
		if(lValue != rValue)
		{
			appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
			return;
		}
	}
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	if (left == INT_TYPE && right == INT_TYPE)
		return INT_TYPE;
	else
		return REAL_TYPE;
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
		
	return BOOL_TYPE;
}

Types checkRem(Types left, Types right) 
{
	if (left != INT_TYPE || right != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainer Operator Requires Integer Operands");
		return MISMATCH;
	}
	return INT_TYPE;
}

Types checkIfStatement(Types exp, Types thenStat, Types elseStat)
{
	//exp must be boolean
	if(exp != BOOL_TYPE)
		appendError(GENERAL_SEMANTIC, "If Expression Must Be Boolean");
		
	if(thenStat != elseStat)
		appendError(GENERAL_SEMANTIC, "If-Then Type Mismatch");
	
	return checkArithmetic(thenStat, elseStat);
}

void checkCase(Types exp)
{
	if(exp != INT_TYPE)
		appendError(GENERAL_SEMANTIC, "Case Expression Not Integer");
}

Types checkCases(Types left, Types right)
{
	if(left == MISMATCH || right == MISMATCH)
	{
		appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
		return MISMATCH;
	}
		
	if(left == MATCH)
		return right;
		
	if(right == MATCH)
		return left;
	
	if(left == right)
		return left;
	else
	{
		appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
		return MISMATCH;
	}
	



	
}


