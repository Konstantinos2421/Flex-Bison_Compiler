%{
#include "parser.tab.h"
#include <stdio.h>
%}

layout_width     "android:layout_width"
layout_height    "android:layout_height"
id               "android:id"
orientation      "android:orientation"
text             "android:text"
textColor        "android:textColor"
src              "android:src"
padding          "android:padding"
checkedButton    "android:checkedButton"
progress         "android:progress"
max              "android:max"
radioButtonsNum  "android:radioButtonsNum"

string	\"[^\"\n]+\"
number	\"[1-9][0-9]*\"
gap		(" "|"\t"|"\n")+

comment	"<!-- "[^\"\n]*" -->"

%option yylineno

%%
{layout_width} 	  {return LAYOUT_WIDTH;}
{layout_height}	  {return LAYOUT_HEIGHT;}
{id}			        {return ID;}
{orientation}	    {return ORIENTATION;}
{text}			      {return TEXT;}
{textColor}		    {return TEXT_COLOR;}
{src}			        {return SRC;}
{padding}		      {return PADDING;}
{checkedButton}	  {return CHECKED_BUTTON;}
{progress}		    {return PROGRESS;}
{max}			        {return MAX;}
{radioButtonsNum}	{return RADIO_BUTTONS_NUM;}

"</"	{return END_TAG_OPENING;}
"/>"	{return SELF_CLOSING_TAG_CLOSING;}
"<"		{return OPENING_BRACKET;}
">"		{return CLOSING_BRACKET;}
"="		{return '=';}

"\"wrap_content\""	{return WRAP_CONTENT;}
"\"match_parent\""	{return MATCH_PARENT;}

"LinearLayout"		{ return LINEAR_LAYOUT;}
"RelativeLayout"	{return RELATIVE_LAYOUT;}
"TextView"			  {return TEXT_VIEW;}
"ImageView"			  {return IMAGE_VIEW;}
"Button"			    {return BUTTON;}
"RadioButton"		  {return RADIO_BUTTON;}
"RadioGroup"		  {return RADIO_GROUP;}
"ProgressBar"		  {return PROGRESS_BAR;}

{number}	{return NUMBER;}
{string}	{return STRING;}

{comment}	{ }
{gap}		{ }

%%
