
%%// Options of the scanner

%class Lexer3	//Name
%unicode			//Use unicode
%standalone		//Tell that Jflex don't use a parser

//Declare exclusive states
%xstate YYINITIAL, COMMENT_STATE

%% //Identification of tokens

//switch between mode, default : YYINITIAL

<YYINITIAL> {
	"{"	   {yybegin(COMMENT_STATE);}
  [^"{"] {}
}

<COMMENT_STATE> {
	"}"     {yybegin(YYINITIAL);}
	[^"}"]+	{System.out.print(yytext());}
}