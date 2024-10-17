/* CMSC430 Project 3
   Nov. 27, 2023
   Carlos Valencia 

   This file contains function definitions for the evaluation functions
   Added additional operations to enum, and changed return and parameter types to double */

typedef char* CharPtr;
enum Operators {LESS, GREATER, LESS_EQUAL, GREATER_EQUAL, EQUAL, NOT_EQUAL, ADD, MULTIPLY, SUBTRACT, DIVIDE, EXPONENT, REMAINDER};

double evaluateReduction(Operators operator_, double head, double tail);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);

