grammar wts;
WS: [\t ]+;
NL: [\n\r]+ -> skip;
ENCLOSED_STR: '{' NL* (~[}] | '\\}')+ NL* '}';
INT: [0-9]+;
IGNORED: ~[{] -> skip;
STRING_KEYWORD: 'STRING';
block: STRING_KEYWORD WS+ (num=INT) (NL | WS | INT | STRING_KEYWORD)* (str=ENCLOSED_STR);
root: (WS | NL)* block* (WS | NL)*;