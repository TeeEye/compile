%{
	#define LT 1
	int yylval;
%}

letter [A-Za-z]
digit [0-9]
id {letter}({letter}|{digit})*

while	{return (WHILE);}
do 		{return (DO);}
{id}	{yylval = installID(); return (ID);}

