
%%// Options of the scanner

%class Lexer4	//Name
%unicode			//Use unicode
%column       //Use character counter (by line)
%standalone		//Tell that Jflex don't use a parser

//Extended Regular Expressions

Space				= "\t" | " "
EndOfLine		= "\r"?"\n"
Line				= .*{EndOfLine}

//Declare exclusive states
%xstate YYINITIAL, NOPE, QMARK, BANG

%% //Identification of tokens

//switch between mode, default : YYINITIAL

<YYINITIAL> {
	^"a"			  {System.out.print("a"); yybegin(NOPE);}
	^"b"			  {System.out.print("b"); yybegin(QMARK);}
	^"c"			  {System.out.print("c"); yybegin(BANG);}
  .           {System.out.print(yytext());}
}

<NOPE>      {
  {Space}"compiler" {Space}     {System.out.print(" nope ");}
  {Space}"compiler"{EndOfLine}  {System.out.println(" nope");}
  {EndOfLine}                   {System.out.println(); yybegin(YYINITIAL);}
  .                             {System.out.print(yytext());}
}

<QMARK>     {
  {Space}"compiler" {Space}     {System.out.print(" ??? ");}
  {Space}"compiler"{EndOfLine}  {System.out.println(" ???");}
  {EndOfLine}                   {System.out.println(); yybegin(YYINITIAL);}
  .                             {System.out.print(yytext());}
}

<BANG>    {
  {Space}"compiler" {Space}     {System.out.print(" !!! ");}
  {Space}"compiler"{EndOfLine}  {System.out.println(" !!!");}
  {EndOfLine}                   {System.out.println(); yybegin(YYINITIAL);}
  .                             {System.out.print(yytext());}
}
