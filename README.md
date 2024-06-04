# Flex-Bison Compiler
A project of designing a compiler for a simplified XML language.  
  
The XML language contains the following elements:
- **LinearLayout** 
- **RelativeLayout**
- **TextView**
- **ImageView**
- **Button**
- **RadioButton**
- **RadioGroup**
- **ProgressBar**
___
Also the XML language have the following specifications:
- The **main layout(root)** that can be followed is either of type LinearLayout, or of type RelativeLayout.
- **All elements** have android:layout_width and android:layout_height as required attributes. These can be of alphanumeric or positive integer type.
- The **LinearLayout** element has optional attributes android:id and android:orientation. Both attributes are of alphanumeric type.
- The content of the **LinearLayout** element cannot be empty and can contain any of the other elements, even other LinearLayout elements.
- The **RelativeLayout** element has an optional attribute of android:id, which is of alphanumeric type.
- The content of the **RelativeLayout** element can be empty or can contain any of the other elements, even other elements of type <RelativeLayout>.
- The **TextView** element has an additional required attribute of android:text, and has optional attributes of android:id and android:textColor. All of these attributes are of alphanumeric type. The content of the element is empty.
- The **ImageView** element has an additional required attribute of android:src and optional attributes of android:id and android:padding. The android:src and android:id are of alphanumeric type, while android:padding is of positive integer type. The content of the element is empty.
- The **Button** element has an additional required attribute of android:text, while it has optional attributes of android:id and android:padding. The android:text and android:id are of alphanumeric type, while the android:padding is of positive integer type. The content of the element is empty.
- The **RadioGroup** element must contain RadioButton elements. In addition, it has optional attributes android:id and android:checkedButton, which are of alphanumeric type.
- The **RadioButton** element appears only nested within a RadioGroup element. It carries the android:text as an additional required attribute, and the android:id as an optional attribute. The android:text and android:id are of alphanumeric type. The content of the element is empty.
- The **ProgressBar** element has optional attributes android:id, android:max and android:progress. The android:id is of alphanumeric type, while android:max and android:progress are of positive integer type. The content of the element is empty.
- At any point in the code, **XML comments** are supported.

***NOTE:*** The elements TextView, ImageView, Button, RadioButton, ProgressBar have self-closing tag.
___
Project files are the following ones:
- **BNF.txt:** It contains the grammar of the XML language in BNF markup. The compiler designed based on this grammar.
- **lexer.l:** This file is the lexer of the compiler written in Bison, which makes the lectical analysis of the code.
- **parser.y:** This file is the parser of the compiler written in Flex, which makes the grammar analysis of the code.
- **sample_code.txt:** A sample of XML code which is used to check the compiler.
___
Cmd commands to compile and run the lexer and parser files:  
bison –d parser.y  
flex lexer.l  
gcc –o run lex.yy.c parser.tab.c –lfl  
./run testFile  
  
These steps must be executed in Cygwin terminal. The link for downloading Cygwin to install terminal and Flex-Bison is the following:  
[https://cygwin.com/](https://cygwin.com/)
