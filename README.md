# Flex-Bison Compiler
A project of designing a compiler for a simplified XML language.  
  
The XML language contains the following elements:
- LinearLayout:
- RelativeLayout:
- TextView:
- ImageView:
- Button:
- RadioButton:
- RadioGroup: 
- ProgressBar:   
  
Project files are the following ones:
- BNF.txt: It contains the grammar of the XML language in BNF markup. The compiler designed based on this grammar.
- lexer.l: This file is the lexer of the compiler written in Bison, which makes the lectical analysis of the code.
- parser.y: This file is the parser of the compiler written in Flex, which makes the grammar analysis of the code.
- sample_code.txt: A sample of XML code which is used to check the compiler.
  
Cmd commands to compile and run the lexer and parser files:  
bison –d parser.y  
flex lexer.l  
gcc –o run lex.yy.c parser.tab.c –lfl  
./run testFile  
  
These steps must be executed in Cygwin terminal. The link for downloading Cygwin to install terminal and Flex-Bison is the following:  
[https://cygwin.com/](https://cygwin.com/)
