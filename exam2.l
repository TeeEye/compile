/* 把讨厌的注释去掉 */

%{

#include <stdio.h> 
#define LT					1
#define	LE					2
#define GT					3
#define	GE					4
#define	EQ					5
#define NE					6

#define WHILE				18
#define	DO					19
#define ID          20
#define NUMBER      21
#define RELOP       22
#define BRACKET  	1000
#define SEMICOLON   1001
#define ASSIGN		1002
#define IF			1003
#define ELSE		1004
#define ALGOP		1006

#define NEWLINE     23
#define ERRORCHAR   24


%}

 
delim		[ \t \n]
ws			{delim}+
letter	[A-Za-z_]
digit		[0-9]
id			{letter}({letter}|{digit})*
number	{digit}+(\.{digit}+)?(E[+-]?{digit}+)?
bracket [\(\)\{\}]
comment [/][/].*
algop   [\+\-\*/]



/* 状态（或条件）定义可以定义在这里 
 * INITIAL是一个默认的状态，不需要定义
 */
%s COMMENT

%%

<INITIAL>"/*"						{BEGIN COMMENT;ECHO;}
<COMMENT>"*/"						{BEGIN INITIAL;ECHO;}
<COMMENT>.|\n						{ECHO;}

 /* ECHO是一个宏，相当于 fprintf(yyout, "%s", yytext)*/

<INITIAL>{ws}	          {;}
<INITIAL>while					{return (WHILE);}
<INITIAL>if				  {return (IF);}
<INITIAL>else			  {return (ELSE);}
<INITIAL>do		          {return (DO);}
<INITIAL>{id}	          {return (ID);}
<INITIAL>{number}	      {return (NUMBER);}
<INITIAL>{bracket}		  {return (BRACKET);}
<INITIAL>"<"	          {return (RELOP);}
<INITIAL>"<="	          {return (RELOP);}
<INITIAL>"=="	          {return (RELOP);}
<INITIAL>"!="	          {return (RELOP);}
<INITIAL>">"	          {return (RELOP);}
<INITIAL>">="	          {return (RELOP);}
<INITIAL>";"		      {return (SEMICOLON);}
<INITIAL>"="			  {return (ASSIGN);}
<INITIAL>{comment}		  {;}
<INITIAL>{algop}		  {return (ALGOP);}
<INITIAL>.							{return ERRORCHAR;}

 
%%

int yywrap (){
  return 1;
}

void writeout(int c){
  switch(c){
  	case ERRORCHAR: fprintf(yyout, "(ERRORCHAR, \"%s\") ", yytext);break;
  	case RELOP: fprintf(yyout, "(RELOP, \"%s\") ", yytext);break;  	  
    case WHILE: fprintf(yyout, "(WHILE, \"%s\") ", yytext);break;
    case DO: fprintf(yyout, "(DO, \"%s\") ", yytext);break;
    case NUMBER: fprintf(yyout, "(NUM, \"%s\") ", yytext);break;
	case BRACKET: fprintf(yyout, "(BRACKET, \"%s\") ", yytext);break;
    case ID: fprintf(yyout, "(ID, \"%s\") ", yytext);break;
	case ASSIGN: fprintf(yyout, "(ASSIGN, \"%s\")", yytext);break;
	case SEMICOLON: fprintf(yyout, "(SEMICOLON, \"%s\")", yytext); break;
	case IF: fprintf(yyout, "(IF, \"%s\")", yytext); break;
	case ELSE: fprintf(yyout, "(ELSE, \"%s\")", yytext); break;
	case ALGOP: fprintf(yyout, "(ALGOP, \"%s\")", yytext); break;
    case NEWLINE: fprintf(yyout, "\n");break;
    default:break;
  }
  return;
}


int main (int argc, char ** argv){
	int c,j=0;
	if (argc>=2){
	  if ((yyin = fopen(argv[1], "r")) == NULL){
	    printf("Can't open file %s\n", argv[1]);
	    return 1;
	  }
	  if (argc>=3){
	    yyout=fopen(argv[2], "w");
	  }
	}

	while (c = yylex()){
		writeout(c);
		j++;
		if (j%5 == 0) writeout(NEWLINE);
	}
	if(argc>=2){
	  fclose(yyin);
	  if (argc>=3) fclose(yyout);
	}
	return 0;
}
