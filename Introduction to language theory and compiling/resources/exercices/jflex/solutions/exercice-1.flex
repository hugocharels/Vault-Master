%%// Options of the scanner

%class Lexer1	//Name
%unicode			//Use unicode
%line         //Use line counter (yyline variable)
%standalone		//Tell that Jflex don't use a parser

//Extended Regular Expressions

Line				= .+

%% //Identification of tokens

{Line}$	{System.out.print(yyline+" "+yytext());}