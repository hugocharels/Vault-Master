/* Note that the other solution does not take into account empty lines.
 * This one does. Observe for instance the different behavior on test1.txt */
%%// Options of the scanner

%class Lexer1	//Name
%unicode			//Use unicode
%line         //Use line counter (yyline variable)
%standalone		//Tell that Jflex don't use a parser

//Extended Regular Expressions

Line				= .*
EndOfLine = "\r"?"\n"

%% //Identification of tokens

{Line}{EndOfLine}	{System.out.print(yyline+" "+yytext());}
