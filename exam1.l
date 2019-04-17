/* ����ע�͵���ʽ����C�е�/*...* /ע����ͬ�� */
/* ��һ�����Ƕ��塢�������֡��ⲿ�����ݿ���Ϊ�ա�*/

%{

/* д�� %{...%}������������ڵ����ݻᱻֱ�ӿ�����C�ļ��С�
 *
 * �ⲿ��ͨ������һЩͷ�ļ�������������ȫ�֣��ⲿ��������
 * �Ķ��壬��C�﷨��
 *
 * %{��%}�������Ŷ�����λ������ 
 */

/* ���涨������Ҫʶ��ļǺ����������yacc����ʹ�ã���Щ�Ǻ�����Ӧ����yacc�ж��� */
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

#define NEWLINE     23
#define ERRORCHAR   24

int yylval;
/* yylval ��yacc�ж���ı�������������Ǻŵ�����ֵ��Ĭ����int���͡� 
 * ����lexʵ�ֵĴʷ��������п���ʹ������������Ǻŵ����Դ��ݸ���
 * yaccʵ�ֵ��﷨��������
 *
 * ע�⣺�ñ���ֻ��������ʹ��lex��yacc��д�ʷ����﷨������ʱ�ſ���lex
 *       ��ʹ�ã���ʱ�ñ�������Ҫ���弴��ʹ�á�
 *       ����ʹ��lexʱ���������Ҳ���������������ﶨ��ñ���Ϊ�ˡ���ƭ����������
 */
 
int installID();
int installNum(); 
/* �������������ʹ�õ��ĸ���������
 */

%}

/* ����������涨���״̬���塣
 * ����������涨�壬ע�⣬���涨���״̬���嶼Ҫ��������д��
 */
 
delim		[ \t\n]
/* \������ʾת�壬����\t��ʾ�Ʊ�����\n��ʾ���з���*/
ws			{delim}+
letter	[A-Za-z]
digit		[0-9]
id			{letter}({letter}|{digit})*
/* ע�⣺�������涨���г��ֵ�С���ű�ʾ���飬�����Ǳ�ƥ����ַ���
 *       ������������Ĳ��ֱ�ʾ���涨������
 */
number	{digit}+(\.{digit}+)?(E[+-]?{digit}+)?



/* %%��Ϊlex�ļ��������ֵķָ��������λ������ */
/* �������%%����ʡ�� */
%%

  /* �ڶ������Ƿ�����򲿷֡� */
  /* д����һ���ֵ�ע��Ҫ��ǰ���ո񣬷���lex���������*/
  /* ����������ʽ�ǣ�����ʽ  {����}
   * ���У�����ʽҪ������д������Ҫ��C�﷨д�������ᱻ������yylex()�����У�����\
   * ����ʽ�Ͷ���֮��Ҫ�ÿհ׷ָ
   */
  
{ws}	          {;/* ��ʱ�ʷ�������û�ж�����Ҳ�����أ����Ǽ��������� */}
  /* ����ʽ�����ô�������ס�ı�ʾ���涨����������{ws}��
   * û����ס��ֱ�ӱ�ʾ����ʽ������
   * һЩԪ�ַ�û�취��ʾ����������ʱ������ת���ַ���
   * ��˫����������������"<"
   */
while	          {return (WHILE);}
do		          {return (DO);}
{id}	          {yylval = installID (); return (ID);}
{number}	      {yylval = installNum (); return (NUMBER);}
"<"	            {yylval = LT; return (RELOP);}
"<="	          {yylval = LE; return (RELOP);}
"="	            {yylval = EQ; return (RELOP);}
"<>"	          {yylval = NE; return (RELOP);}
">"	            {yylval = GT; return (RELOP);}
">="	          {yylval = GE; return (RELOP);}

.								{yylval = ERRORCHAR; return ERRORCHAR;}
 /*.ƥ�������֮����κ��ַ���һ�����Ϊ���һ���������*/
 
%%
/* ���������Ǹ����������֣��ⲿ�������Լ�ǰ���%%������ʡ�� */
/* �����������Զ��塰��������ʹ�õ�һЩ��������Щ����
 * ʹ��C���Ա�д������ֱ�ӱ�������lex.yy.c�С�
 */

int installID () {
  /* �Ѵʷ���Ԫװ����ű�������ָ�롣*/
	return ID;
}


int installNum () {
	/* ��������Ĺ��̣����ʷ���Ԫ���Ǳ�ʶ�������� */
  return NUMBER;
}


/* yywrap������������Ǵʷ����������������ļ���βʱ����õģ�����������һ����ô����
 * ��yywrap����0�������ɨ�裻����1����ʷ����������ر����ļ��ѽ�����0��
 * lex���еı�׼yywrap������Ƿ���1����Ҳ���Զ����Լ���yywrap��
 */
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
    case ID: fprintf(yyout, "(ID, \"%s\") ", yytext);break;
    case NEWLINE: fprintf(yyout, "\n");break;
    default:break;
  }
  return;
}

/* �������������ʹ��yytext��yyleng��Щ�ⲿ����ı�����
 * yytextָ�����뻺������ǰ�ʷ���Ԫ(lexeme)�ĵ�һ���ַ���
 * yyleng�����ôʷ���Ԫ�ĳ���		*/

/* �����Ĵʷ���������������Ϊ�﷨���������ӳ���
 * �������Լ����������������������ﶨ����Ĵʷ�
 * ��������main������main��������Ե���yylex()
 */

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
	/* yyin��yyout��lex�ж������������ļ�ָ�룬����ָ����
	 * lex���ɵĴʷ����������������������������
	 * Ĭ�ϣ��������룬��Ļ����� 
	 */
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