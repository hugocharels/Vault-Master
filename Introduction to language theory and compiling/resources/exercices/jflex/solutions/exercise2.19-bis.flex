/* Counting alphanumeric characters with minimal (non-generated) Java code */
%%

%class Lexer2
%line
%standalone
%unicode

AlphaNum = [a-zA-Z0-9]+
NonAlphaNumChar = [^a-zA-Z0-9 \t\n\r] // Non alphanumeric and non space characters
LineTerminator = \r|\n|\r\n
Spaces = [ \t]+
EndOfWord = {Spaces}|{LineTerminator}
EmptyLine = [ \t]*{LineTerminator}

%{
// Counters declaration
private int letters=0;
private int words=0;
private int lines=0;

// Counter printing
public void printStats() {
    System.out.println("Alphanumeric characters: "+letters);
    System.out.println("Alphanumeric words: "+words);
    System.out.println("Alphanumeric lines: "+lines);
}
%}

// Code called after the scanning is complete (End Of File reached)
%eof{
printStats();
%eof}

%state NONALPHANUMLINE, NONALPHANUMWORD

%%

<YYINITIAL> { // Happy state: count everything
    ^{EmptyLine}       {}                              // Ignore empty lines
    ^{Spaces}          {}                              // Ignore starting spaces
    {AlphaNum}         {letters+=yylength();}          // Counting alphanumeric characters
    {Spaces}           {words+=1;}                     // Word ended
    {LineTerminator}   {words+=1;lines+=1;}            // Line (hence word) ended
    {NonAlphaNumChar}+ {yybegin(NONALPHANUMWORD);}     // Non alphanumeric char detected, going to NONALPHANUMWORD
}

<NONALPHANUMWORD> { // Within non-alphanumeric word: only count characters
    {AlphaNum}         {letters+=yylength();}          // Counting alphanumeric characters
    {Spaces}           {yybegin(NONALPHANUMLINE);}     // Word ended (not the line), going to NONALPHANUMLINE
    {LineTerminator}   {yybegin(YYINITIAL);}           // Line (hence word) ended, going back to YYINITIAL
    {NonAlphaNumChar}+ {}                              // Another non-alphanumeric (should not actually happen, though)
    .                  {}                              // Ignore the rest (no beginning of line shold be there anyway)
}

<NONALPHANUMLINE> { // Within non-alphanumeric line: only count characters and words
    {AlphaNum}         {letters+=yylength();}          // Counting alphanumeric characters
    {Spaces}           {words+=1;}                     // Word ended
    {LineTerminator}   {words+=1; yybegin(YYINITIAL);} // Line (hence word) ended, going back to YYINITIAL
    {NonAlphaNumChar}+ {yybegin(NONALPHANUMWORD);}     // Non alphanumeric char detected, going to NONALPHANUMWORD
    .                  {}                              // Ignore the rest (no beginning of line shold be there anyway)
}
