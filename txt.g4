grammar txt;
COMMENT: '//' ~[\n\r]*;
NL: [\n\r]+;
STR: (~[\n\r[\]=,"]+ '[' ~[\n\r[\]=,"]+ ']') | ~[\n\r[\]=,"]+ | '"' (~["\n\r]+ '"'?)?;
COMMA: ',' -> skip;
WS: [\t ]+ -> skip;
block: '[' category=STR ']' WS* NL (WS | NL | COMMENT)* (NL (WS | NL | COMMENT)* line)* (WS | NL | COMMENT)*;
line: key=STR '=' values+=STR* WS*;
root: (WS | NL | COMMENT)* block* (WS | NL | COMMENT)*;