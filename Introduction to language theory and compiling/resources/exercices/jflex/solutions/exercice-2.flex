
%%// Options of the scanner

%class Lexer2	// Name
%unicode			// Use unicode
%standalone		// Tell that Jflex don't use a parser

%{//start adding Java code
		private int alphaNumCharCounter = 0;
		private int alphaNumWordCounter = 0;
		private int alphaNumLineCounter = 0;
		
		private boolean isAWord					= true;
		private boolean emptyWord				= true;
		
		private boolean nonAlphaNumCharFound = false;
		private boolean alphaNumCharFound    = false;
		
		private void spaces(){
			if(isAWord && !emptyWord){
				//prevent lines statring with spaces
				alphaNumWordCounter++;
			}
			isAWord		= true;
			emptyWord	= true;
		}
		private void endOfLine(){
			if(isAWord && !emptyWord){
				//prevent lines statring with spaces
				alphaNumWordCounter++;
			}
			isAWord		= true;
			emptyWord	= true;
			if(nonAlphaNumCharFound){
				//if not a alphanum is found, this is not an alphanum line
				nonAlphaNumCharFound = false;
			}else if(alphaNumCharFound){
				//if not an empty line, we count it
				alphaNumLineCounter++;
			}
			alphaNumCharFound = false;
	}
	private void alphaNumChar(){
		alphaNumCharFound = true;
		emptyWord         = false;
		alphaNumCharCounter++;
	}
	private void nonAlphaNumChar(){
		//if not a alphanum char, we specify that the current matching word
		//is not an alphanum word and the current line contains non-alphanum char
		isAWord              = false;
		nonAlphaNumCharFound = true;
	}
%}//end adding Java code

%eof{// called after scanning
	System.out.println("Alphanum chars: "+alphaNumCharCounter);
	System.out.println("Alphanum words: "+alphaNumWordCounter);
	System.out.println("Alphanum lines: "+alphaNumLineCounter);
%eof}

//Extended Regular Expressions

AlphaUpperCase = [A-Z]
AlphaLowerCase = [a-z]
Alpha          = {AlphaUpperCase}|{AlphaLowerCase}
Numeric        = [0-9]
AlphaNumChar	 = {Alpha}|{Numeric}

EndOfLine      = "\r"?"\n"
Space          = "\t" | " "

%% //Identification of tokens

{AlphaNumChar} { alphaNumChar(); }
{Space}+		   { spaces(); }
<<EOF>>		     { endOfLine(); return 0;}
{EndOfLine}    { endOfLine(); }
.				       { nonAlphaNumChar(); }

