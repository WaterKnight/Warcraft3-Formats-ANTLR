grammar J;

CR: [\r] -> skip;
WS: [ \t] -> skip;
COMMENT: '//' ~[\n\r]* -> skip;

fragment DECIMAL_LITERAL: [1-9][0-9]*;

fragment OCTAL_LITERAL: '0'[0-7]*;

fragment HEX_LITERAL: '$'[0-9a-fA-F]+ | '0'[xX][0-9a-fA-F]+;

fragment ASCII_CHAR: ~[\n];
fragment ONECC: '\'' ASCII_CHAR '\'';
fragment FOURCC: '\'' ASCII_CHAR ASCII_CHAR ASCII_CHAR ASCII_CHAR '\'';

INT_LITERAL: DECIMAL_LITERAL | OCTAL_LITERAL | HEX_LITERAL | FOURCC;

REAL_LITERAL: [0-9]+'.'[0-9]* | '.'[0-9]+;

BOOL_LITERAL: 'true' | 'false';

STRING_LITERAL: '"' ~[\n]* '"';

ID: [a-zA-Z]([a-zA-Z0-9_]* [a-zA-Z0-9])?;

NEWLINE: '\n'+;

type: ID | 'code' | 'handle' | 'integer' | 'real' | 'boolean' | 'string';

program: file+;

file: NEWLINE* (declr NEWLINE+)* func* NEWLINE+;

declr: typedef | globals | native_func;

typedef: 'type' ID 'extends' ('handle' | ID);

globals: 'globals' NEWLINE+ global_var_list 'endglobals';

global_var_list: ('constant' type ID '=' expr NEWLINE+ | var_declr NEWLINE+)*;

native_func: 'constant'? 'native' func_declr;

func_declr: ID 'takes' ('nothing' | param_list) 'returns' (type | 'nothing');

param_list: type ID (',' type ID)*;

func: 'constant'? 'function' func_declr NEWLINE+ local_var_list statement_list 'endfunction' NEWLINE+;

local_var_list: ('local' var_declr NEWLINE+)*;

var_declr: type ID ('=' expr)? | type 'array' ID;

statement_list: (statement NEWLINE+)*;

statement: set | call | ifthenelse | loop | exitwhen | return | debug;

set: 'set' ID '=' expr | 'set' ID '[' expr ']' '=' expr;

call: 'call' ID '(' args? ')';

args: expr (',' expr)*;

ifthenelse: 'if' expr 'then' NEWLINE+ statement_list else_clause? 'endif';

else_clause: 'else' NEWLINE+ statement_list | 'elseif' expr 'then' NEWLINE+ statement_list else_clause?;

loop: 'loop' NEWLINE+ statement_list 'endloop';

exitwhen: 'exitwhen' expr; 

return: 'return' expr?;

debug: 'debug' (set | call | ifthenelse | loop);

expr: (unary_op | func_call | array_ref | func_ref | ID | literal | parens) (('+' | '-' | '*' | '/' | '==' | '!=' | '>' | '>=' | '<' | '<=' | 'and' | 'or') expr)?;

unary_op: ('+' | '-' | 'not' ) expr;

func_call: ID '(' args? ')';

array_ref: ID '[' expr ']';

func_ref: 'function' ID;

literal: INT_LITERAL | REAL_LITERAL | BOOL_LITERAL | STRING_LITERAL | 'null';

parens: '(' expr ')';