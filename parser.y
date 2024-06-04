%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
extern int yylineno;
extern char *yytext;
extern int yylex();

void yyerror(const char* err);

int layout_width_used = 0;
int layout_height_used = 0;
int id_used = 0;
int orientation_used = 0;
int text_used = 0;
int textColor_used = 0;
int src_used = 0;
int padding_used = 0;
int checkedButton_used = 0;
int progress_used = 0;
int max_used = 0;
int radioButtonsNum_used = 0;

int max = 0;
int progress = 0;

int radio_button_found = 0;
int checked_button_attribute_line;
char *checked_button_id;
char **radio_buttons_ids;
int radio_buttons_ids_length = 0;

char **ids_array;
int ids_array_length = 0;

int radio_buttons_num = 0;
int radio_buttons_counter = 0;
int radio_buttons_num_attribute_line;
%}

%define parse.error verbose

%token OPENING_BRACKET			"<"
%token CLOSING_BRACKET			">"
%token END_TAG_OPENING			"</"
%token SELF_CLOSING_TAG_CLOSING	"/>"

%token LAYOUT_WIDTH			"android:layout_width"
%token LAYOUT_HEIGHT		"android:layout_height"
%token ID					"android:id"
%token ORIENTATION			"android:orientation"
%token TEXT					"android:text"
%token TEXT_COLOR			"android:textColor"
%token SRC					"android:src"
%token PADDING				"android:padding"
%token CHECKED_BUTTON		"android:checkedButton"
%token PROGRESS				"android:progress"
%token MAX					"android:max"
%token RADIO_BUTTONS_NUM	"android:radioButtonsNum"

%token LINEAR_LAYOUT	"LinearLayout"
%token RELATIVE_LAYOUT	"RelativeLayout"
%token TEXT_VIEW 		"TextView"
%token IMAGE_VIEW 		"ImageView"
%token BUTTON 			"Button"
%token RADIO_BUTTON 	"RadioButton"
%token RADIO_GROUP 		"RadioGroup"
%token PROGRESS_BAR		"ProgressBar"

%token WRAP_CONTENT	"wrap_content"
%token MATCH_PARENT	"match_parent"

%token STRING 	"string"
%token NUMBER	"positive integer"

%start program

%%
/*PROGRAM*/
program: LinearLayout
	   | RelativeLayout;

/*ATTRIBUTES*/
layout_width: LAYOUT_WIDTH '=' WRAP_CONTENT 
			| LAYOUT_WIDTH '=' MATCH_PARENT 
			| LAYOUT_WIDTH '=' NUMBER;

layout_height: LAYOUT_HEIGHT '=' WRAP_CONTENT 
			 | LAYOUT_HEIGHT '=' MATCH_PARENT 
			 | LAYOUT_HEIGHT '=' NUMBER;

id: ID '=' STRING	{	
    					char *id = (char*)malloc(strlen(yytext));
    					strcpy(id, yytext);
						for(int i = 0; i < ids_array_length; i++){
							if(strcmp(ids_array[i], id) == 0)
								yyerror("The id is already in use");
						}

						ids_array = (char**)realloc(ids_array, (ids_array_length + 1) * sizeof(char*));
						ids_array[ids_array_length] = id;
						ids_array_length++;

						if(radio_button_found == 1){
							radio_buttons_ids = (char**)realloc(radio_buttons_ids, (radio_buttons_ids_length + 1) * sizeof(char*));
							radio_buttons_ids[radio_buttons_ids_length] = id;
							radio_buttons_ids_length++;
							radio_button_found = 0;
						}
					};

orientation: ORIENTATION '=' STRING;

text: TEXT '=' STRING;

textColor: TEXT_COLOR '=' STRING;

src: SRC '=' STRING;

padding: PADDING '=' NUMBER;

checkedButton: CHECKED_BUTTON '=' STRING	{	
												checked_button_id = (char*)malloc(strlen(yytext));
												strcpy(checked_button_id, yytext);
												checked_button_attribute_line = yylineno;
											};

progress: PROGRESS '=' NUMBER	{
									char *string_number = (char*)malloc(strlen(yytext));
									strcpy(string_number, yytext);
									char *number = (char*)malloc((strlen(string_number) - 2) * sizeof(char));
									strncpy(number, string_number + 1, strlen(string_number) - 2);
									progress = atoi(number);
								};

max: MAX '=' NUMBER	{
						char *string_number = (char*)malloc(strlen(yytext));
						strcpy(string_number, yytext);
						char *number = (char*)malloc((strlen(string_number) - 2) * sizeof(char));
						strncpy(number, string_number + 1, strlen(string_number) - 2);
						max = atoi(number);
					};

radioButtonsNum: RADIO_BUTTONS_NUM '=' NUMBER	{
													char *string_number = (char*)malloc(strlen(yytext));
													strcpy(string_number, yytext);
													char *number = (char*)malloc((strlen(string_number) - 2) * sizeof(char));
													strncpy(number, string_number + 1, strlen(string_number) - 2);
													radio_buttons_num = atoi(number);
													radio_buttons_num_attribute_line = yylineno;
												};

attribute: layout_width		{if(layout_width_used == 1) yyerror("Duplicate definition of \"layout_width\" attribute"); layout_width_used = 1;}
		 | layout_height	{if(layout_height_used == 1) yyerror("Duplicate definition of \"layout_height\" attribute"); layout_height_used = 1;}
		 | id				{if(id_used == 1) yyerror("Duplicate definition of \"id\" attribute"); id_used = 1;}
		 | orientation		{if(orientation_used == 1) yyerror("Duplicate definition of \"orientation\" attribute"); orientation_used = 1;}
		 | text				{if(text_used == 1) yyerror("Duplicate definition of \"text\" attribute"); text_used = 1;}
		 | textColor		{if(textColor_used == 1) yyerror("Duplicate definition of \"textColor\" attribute"); textColor_used = 1;}
		 | src				{if(src_used == 1) yyerror("Duplicate definition of \"src\" attribute"); src_used = 1;}
		 | padding			{if(padding_used == 1) yyerror("Duplicate definition of \"padding\" attribute"); padding_used = 1;}
		 | checkedButton	{if(checkedButton_used == 1) yyerror("Duplicate definition of \"checkedButton\" attribute"); checkedButton_used = 1;}
		 | progress			{if(progress_used == 1) yyerror("Duplicate definition of \"progress\" attribute"); progress_used = 1;}
		 | max				{if(max_used == 1) yyerror("Duplicate definition of \"max\" attribute"); max_used = 1;}
		 | radioButtonsNum	{if(radioButtonsNum_used == 1) yyerror("Duplicate definition of \"radioButtonsNum\" attribute"); radioButtonsNum_used = 1;}
		 ;

attributes_list: attribute attributes_list
			   | attribute;

/*ELEMENTS*/
LinearLayout: OPENING_BRACKET LINEAR_LAYOUT attributes_list CLOSING_BRACKET
			  {
				if(layout_width_used == 0) yyerror("Missing \"layout_width\" attribute");
				if(layout_height_used == 0) yyerror("Missing \"layout_height\" attribute");

				if(text_used == 1) yyerror("\"text\" atrribute is not valid for LinearLayout");
				if(textColor_used == 1) yyerror("\"textColor\" atrribute is not valid for LinearLayout");
				if(src_used == 1) yyerror("\"src\" atrribute is not valid for LinearLayout");
				if(padding_used == 1) yyerror("\"padding\" atrribute is not valid for LinearLayout");
				if(checkedButton_used == 1) yyerror("\"checkedButton\" atrribute is not valid for LinearLayout");
				if(progress_used == 1) yyerror("\"progress\" atrribute is not valid for LinearLayout");
				if(max_used == 1) yyerror("\"max\" atrribute is not valid for LinearLayout");
				if(radioButtonsNum_used == 1) yyerror("\"radioButtonsNum\" atrribute is not valid for LinearLayout");
				layout_width_used = 0; layout_height_used = 0; id_used = 0; orientation_used = 0; text_used = 0; textColor_used = 0; 
				src_used = 0; padding_used = 0; checkedButton_used = 0; progress_used = 0; max_used = 0; radioButtonsNum_used = 0;
			  } 
			  element_list END_TAG_OPENING LINEAR_LAYOUT CLOSING_BRACKET;

RelativeLayout: OPENING_BRACKET RELATIVE_LAYOUT attributes_list CLOSING_BRACKET
				{
					if(layout_width_used == 0) yyerror("Missing \"layout_width\" attribute");
					if(layout_height_used == 0) yyerror("Missing \"layout_height\" attribute");

					if(text_used == 1) yyerror("\"text\" atrribute is not valid for RelativeLayout");
					if(textColor_used == 1) yyerror("\"textColor\" atrribute is not valid for RelativeLayout");
					if(src_used == 1) yyerror("\"src\" atrribute is not valid for RelativeLayout");
					if(padding_used == 1) yyerror("\"padding\" atrribute is not valid for RelativeLayout");
					if(checkedButton_used == 1) yyerror("\"checkedButton\" atrribute is not valid for RelativeLayout");
					if(progress_used == 1) yyerror("\"progress\" atrribute is not valid for RelativeLayout");
					if(max_used == 1) yyerror("\"max\" atrribute is not valid for RelativeLayout");
					if(radioButtonsNum_used == 1) yyerror("\"radioButtonsNum\" atrribute is not valid for RelativeLayout");
					layout_width_used = 0; layout_height_used = 0; id_used = 0; orientation_used = 0; text_used = 0; textColor_used = 0; 
					src_used = 0; padding_used = 0; checkedButton_used = 0; progress_used = 0; max_used = 0; radioButtonsNum_used = 0;
			  	} 
			    element_list END_TAG_OPENING RELATIVE_LAYOUT CLOSING_BRACKET;

TextView: OPENING_BRACKET TEXT_VIEW attributes_list SELF_CLOSING_TAG_CLOSING
		  {
		  		if(layout_width_used == 0) yyerror("Missing \"layout_width\" attribute");
				if(layout_height_used == 0) yyerror("Missing \"layout_height\" attribute");
				if(text_used == 0) yyerror("Missing \"text\" attribute");

				if(src_used == 1) yyerror("\"src\" atrribute is not valid for TextView");
				if(padding_used == 1) yyerror("\"padding\" atrribute is not valid for TextView");
				if(checkedButton_used == 1) yyerror("\"checkedButton\" atrribute is not valid for TextView");
				if(progress_used == 1) yyerror("\"progress\" atrribute is not valid for TextView");
				if(max_used == 1) yyerror("\"max\" atrribute is not valid for TextView");
				if(radioButtonsNum_used == 1) yyerror("\"radioButtonsNum\" atrribute is not valid for TextView");
				layout_width_used = 0; layout_height_used = 0; id_used = 0; orientation_used = 0; text_used = 0; textColor_used = 0; 
				src_used = 0; padding_used = 0; checkedButton_used = 0; progress_used = 0; max_used = 0; radioButtonsNum_used = 0;
		  };

ImageView: OPENING_BRACKET IMAGE_VIEW attributes_list SELF_CLOSING_TAG_CLOSING
		   {
				if(layout_width_used == 0) yyerror("Missing \"layout_width\" attribute");
				if(layout_height_used == 0) yyerror("Missing \"layout_height\" attribute");
				if(src_used == 0) yyerror("Missing \"src\" attribute");

				if(text_used == 1) yyerror("\"text\" atrribute is not valid for ImageView");
				if(textColor_used == 1) yyerror("\"textColor\" atrribute is not valid for ImageView");
				if(checkedButton_used == 1) yyerror("\"checkedButton\" atrribute is not valid for ImageView");
				if(progress_used == 1) yyerror("\"progress\" atrribute is not valid for ImageView");
				if(max_used == 1) yyerror("\"max\" atrribute is not valid for ImageView");
				if(radioButtonsNum_used == 1) yyerror("\"radioButtonsNum\" atrribute is not valid for ImageView");
				layout_width_used = 0; layout_height_used = 0; id_used = 0; orientation_used = 0; text_used = 0; textColor_used = 0; 
				src_used = 0; padding_used = 0; checkedButton_used = 0; progress_used = 0; max_used = 0; radioButtonsNum_used = 0;
		   };

Button: OPENING_BRACKET BUTTON attributes_list SELF_CLOSING_TAG_CLOSING
		{	
			if(layout_width_used == 0) yyerror("Missing \"layout_width\" attribute");
			if(layout_height_used == 0) yyerror("Missing \"layout_height\" attribute");
			if(text_used == 0) yyerror("Missing \"text\" attribute");

			if(textColor_used == 1) yyerror("\"textColor\" atrribute is not valid for Button");
			if(src_used == 1) yyerror("\"src\" atrribute is not valid for Button");
			if(checkedButton_used == 1) yyerror("\"checkedButton\" atrribute is not valid for Button");
			if(progress_used == 1) yyerror("\"progress\" atrribute is not valid for Button");
			if(max_used == 1) yyerror("\"max\" atrribute is not valid for Button");
			if(radioButtonsNum_used == 1) yyerror("\"radioButtonsNum\" atrribute is not valid for Button");
			layout_width_used = 0; layout_height_used = 0; id_used = 0; orientation_used = 0; text_used = 0; textColor_used = 0; 
			src_used = 0; padding_used = 0; checkedButton_used = 0; progress_used = 0; max_used = 0; radioButtonsNum_used = 0;
		};

RadioButton: OPENING_BRACKET RADIO_BUTTON
			 {
				radio_button_found = 1;
			 }
			 attributes_list SELF_CLOSING_TAG_CLOSING
			 {
				if(layout_width_used == 0) yyerror("Missing \"layout_width\" attribute");
				if(layout_height_used == 0) yyerror("Missing \"layout_height\" attribute");
				if(text_used == 0) yyerror("Missing \"text\" attribute");

				if(textColor_used == 1) yyerror("\"textColor\" atrribute is not valid for RadioButton");
				if(src_used == 1) yyerror("\"src\" atrribute is not valid for RadioButton");
				if(padding_used == 1) yyerror("\"padding\" atrribute is not valid for RadioButton");
				if(checkedButton_used == 1) yyerror("\"checkedButton\" atrribute is not valid for RadioButton");
				if(progress_used == 1) yyerror("\"progress\" atrribute is not valid for RadioButton");
				if(max_used == 1) yyerror("\"max\" atrribute is not valid for RadioButton");
				if(radioButtonsNum_used == 1) yyerror("\"radioButtonsNum\" atrribute is not valid for RadioButton");
				layout_width_used = 0; layout_height_used = 0; id_used = 0; orientation_used = 0; text_used = 0; textColor_used = 0; 
				src_used = 0; padding_used = 0; checkedButton_used = 0; progress_used = 0; max_used = 0; radioButtonsNum_used = 0;

				radio_buttons_counter++;
			 };

RadioGroup: OPENING_BRACKET RADIO_GROUP attributes_list CLOSING_BRACKET
			{
				if(layout_width_used == 0) yyerror("Missing \"layout_width\" attribute");
				if(layout_height_used == 0) yyerror("Missing \"layout_height\" attribute");
				if(radioButtonsNum_used == 0) yyerror("Missing \"radioButtonsNum\" attribute");

				if(text_used == 1) yyerror("\"text\" atrribute is not valid for RadioGroup");
				if(textColor_used == 1) yyerror("\"textColor\" atrribute is not valid for RadioGroup");
				if(src_used == 1) yyerror("\"src\" atrribute is not valid for RadioGroup");
				if(padding_used == 1) yyerror("\"padding\" atrribute is not valid for RadioGroup");
				if(progress_used == 1) yyerror("\"progress\" atrribute is not valid for RadioGroup");
				if(max_used == 1) yyerror("\"max\" atrribute is not valid for RadioGroup");
				layout_width_used = 0; layout_height_used = 0; id_used = 0; orientation_used = 0; text_used = 0; textColor_used = 0; 
				src_used = 0; padding_used = 0; checkedButton_used = 0; progress_used = 0; max_used = 0; radioButtonsNum_used = 0;
			} 
			radio_buttons END_TAG_OPENING RADIO_GROUP CLOSING_BRACKET
			{	
				int id_exists = 0;
				for(int i = 0; i < radio_buttons_ids_length; i++){
					if(strcmp(radio_buttons_ids[i], checked_button_id) == 0){
						id_exists = 1;
						break;
					}
				}

				if(id_exists == 0){
					yylineno = checked_button_attribute_line;
					yyerror("The value of the \"checkedButton\" attribute must be the \"id\" value of one of the radio buttons that the RadioGroup contains");
				}

				radio_buttons_ids = realloc(radio_buttons_ids, 0);
				radio_buttons_ids_length = 0;


				if(radio_buttons_num != radio_buttons_counter){
					yylineno = radio_buttons_num_attribute_line;
					yyerror("The value of the \"radioButtonsNum\" attribute must be equal to the number of the radio buttons that the RadioGroup contains");
				}
				radio_buttons_counter = 0;
			};

radio_buttons: RadioButton radio_buttons
			 | RadioButton;

ProgressBar: OPENING_BRACKET PROGRESS_BAR attributes_list SELF_CLOSING_TAG_CLOSING
			 {
				if(max_used == 1 && progress_used ==1 && progress > max) yyerror("\"progress\" value have to be between 0 and \"max\" attribute value");
				if(max_used == 0 && progress_used ==1 && progress > 100) yyerror("\"progress\" value have to be between 0 and 100");
				max = 0; progress = 0;

				if(layout_width_used == 0) yyerror("Missing \"layout_width\" attribute");
				if(layout_height_used == 0) yyerror("Missing \"layout_height\" attribute");

				if(text_used == 1) yyerror("\"text\" atrribute is not valid for ProgressBar");
				if(textColor_used == 1) yyerror("\"textColor\" atrribute is not valid for ProgressBar");
				if(src_used == 1) yyerror("\"src\" atrribute is not valid for ProgressBar");
				if(padding_used == 1) yyerror("\"padding\" atrribute is not valid for ProgressBar");
				if(checkedButton_used == 1) yyerror("\"checkedButton\" atrribute is not valid for ProgressBar");
				if(radioButtonsNum_used == 1) yyerror("\"radioButtonsNum\" atrribute is not valid for ProgressBar");
				layout_width_used = 0; layout_height_used = 0; id_used = 0; orientation_used = 0; text_used = 0; textColor_used = 0; 
				src_used = 0; padding_used = 0; checkedButton_used = 0; progress_used = 0; max_used = 0; radioButtonsNum_used = 0;
			 };

element: LinearLayout 
	   | RelativeLayout
	   | TextView
	   | ImageView
	   | Button
	   | RadioGroup
	   | ProgressBar;

element_list: element element_list
			| element;

%%

void yyerror(const char* err){
	printf("[ERROR] - line %d: %s\n", yylineno, err);
	exit(-1);
}


int main(int argc, char *argv[]){
	
	if(argc>1){
		yyin = fopen(argv[1], "r");
		if(yyin == NULL){
			perror("[ERROR] Could not open file");
			return -1;
		}
	}else{
		perror("[ERROR] No input file\n");
		return -1;
	}

	yyparse();
	fclose(yyin);

	printf("Parsing was completed successful!\n");
	return 0;
}