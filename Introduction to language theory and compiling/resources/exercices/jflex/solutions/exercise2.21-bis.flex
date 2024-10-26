/* Note that the other solution does not take into account
 * the fact that 'compiler' starts with a 'c' and can be
 * at the beginning of a line. This one does. */
%%

%class Lexer4
%line
%standalone
%unicode

Keyword = "compiler"
Eol = \n|\r|\r\n
WordEnd = [ ]|{Eol}

%{
private static final int keyWordLength=8; // Length of the keyword (here compiler)
%}


%xstate YYINITIAL, ALINE, BLINE, CLINE

%%

<YYINITIAL> {
    ^"a" {System.out.print(yytext());yybegin(ALINE);}
    ^"b" {System.out.print(yytext());yybegin(BLINE);}
    ^{Keyword}{WordEnd} {System.out.print("!!!"+yytext().substring(keyWordLength));yybegin(CLINE);} // Because "compiler" starts with a 'c'
    ^"c" {System.out.print(yytext());yybegin(CLINE);}
    . |
    {Eol} {System.out.print(yytext());} // Ignore the rest
}

<ALINE> {
    {Eol} {System.out.print(yytext()); yybegin(YYINITIAL);}
    {Keyword}{WordEnd} {System.out.print("nope"+yytext().substring(keyWordLength));}
    .  {System.out.print(yytext());}
}

<BLINE> {
    {Eol} {System.out.print(yytext()); yybegin(YYINITIAL);}
    {Keyword}{WordEnd} {System.out.print("???"+yytext().substring(keyWordLength));}
    .  {System.out.print(yytext());}
}

<CLINE> {
    {Eol} {System.out.print(yytext()); yybegin(YYINITIAL);}
    {Keyword}{WordEnd} {System.out.print("!!!"+yytext().substring(keyWordLength));}
    .  {System.out.print(yytext());}
}


