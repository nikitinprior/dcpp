#include "stdio.h"
#include <string.h>
#include "cpm.h"
#include <unixio.h>
#include <stdarg.h>
#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif

#if 0
static char sccsid[] = "@(#)cpp.c	1.6 7/1/83";
#endif

/* C command
/* written by John F. Reiser
/* July/August 1978
*/

/* File - CPP.H Created 08.02.2021 Last Modified 24.10.2021 */

#define STATIC	static

/* some code depends on whether characters are sign or zero extended */
/*	#if '\377' < 0		not used here, old cpp doesn't understand */
#if pdp11 | vax | '\377' < 0
#define COFF 128
#else
#define COFF 0
#endif

# if gcos
#define ALFSIZ 512	/* alphabet size */
# else
#define ALFSIZ 256	/* alphabet size */
# endif

/*	Used macros */

#define isslo (ptrtab==(slotab+COFF))
#define isid(a)  ((fastab+COFF)[a]&IB)
#define isspc(a) (ptrtab[a]&SB)
#define isnum(a) ((fastab+COFF)[a]&NB)
#define iscom(a) ((fastab+COFF)[a]&CB)
#define isquo(a) ((fastab+COFF)[a]&QB)
#define iswarn(a) ((fastab+COFF)[a]&WB)

#define eob(a) ((a)>=pend)
#define bob(a) (pbeg>=(a))

#define tmac1(c,bit) if (!xmac1(c,bit,&)) goto nomac
#define xmac1(c,bit,op) ((macbit+COFF)[c] op (bit))

#define tmac2(c0,c1,cpos)
#define xmac2(c0,c1,cpos,op)

#define BLANK	1
#define IDENT	2
#define NUMBR	3

/* a superimposed code is used to reduce the number of calls to the
/* symbol table lookup routine.  (if the kth character of an identifier
/* is 'a' and there are no macro names whose kth character is 'a'
/* then the identifier cannot be a macro name, hence there is no need
/* to look in the symbol table.)  'scw1' enables the test based on
/* single characters and their position in the identifier.  'scw2'
/* enables the test based on adjacent pairs of characters and their
/* position in the identifier.  scw1 typically costs 1 indexed fetch,
/* an AND, and a jump per character of identifier, until the identifier
/* is known as a non-macro name or until the end of the identifier.
/* scw1 is inexpensive.  scw2 typically costs 4 indexed fetches,
/* an add, an AND, and a jump per character of identifier, but it is also
/* slightly more effective at reducing symbol table searches.
/* scw2 usually costs too much because the symbol table search is
/* usually short; but if symbol table search should become expensive,
/* the code is here.
/* using both scw1 and scw2 is of dubious value.
*/
#define scw1 1
#define scw2 0

#define DROP  0xFE	/* special character not legal ASCII or EBCDIC */
#define WARN  DROP
#define SAME     0

#define MAXINC	10	/* nested includes */
#define MAXFRE	14	/* max buffers of macro pushback */
#define MAXFRM	31	/* max number of formals/actuals to a macro */
#define SBSIZE	12000	/* */

#ifndef BUFSIZ
#define BUFSIZ 512
#endif

#define NCPS	31 	/* */
#define symsiz	500	/* */
#define NPREDEF 20	/* */

#define SALT	'#'

#if scw1
#define b0 1
#define b1 2
#define b2 4
#define b3 8
#define b4 16
#define b5 32
#define b6 64
#define b7 128
#endif

#define IB	1
#define SB	2
#define NB	4
#define CB	8
#define QB	16
#define WB	32

#define BEG	0
#define LF	1

/*
   Declarations of variables and arrays
*/

/*char *alloc();*/
char *pbeg,*pbuf,*pend;
char *outp,*inp;
char *newp;
char cinit;

/* some code depends on whether characters are sign or zero extended */
/*  #if '\377' < 0	not used here, old cpp doesn't understand */


char macbit[ALFSIZ+11];
char toktyp[ALFSIZ];
#if scw2
char t21[ALFSIZ],t22[ALFSIZ],t23[ALFSIZ+NCPS];
#endif

char fastab[ALFSIZ];
char slotab[ALFSIZ];
char *ptrtab;

char buffer[NCPS+BUFSIZ+BUFSIZ+NCPS];

char	sbf[SBSIZE];
char	*savch	= sbf;


static char warnc = 0xFE    /* special character not legal ASCII or EBCDIC */;

int mactop,fretop;
char *instack[MAXFRE],*bufstack[MAXFRE],*endbuf[MAXFRE];
int plvl;	/* parenthesis level during scan for macro actuals */
int maclin; /* line number of macro call requiring actuals */
char *macfil;	/* file name of macro call requiring actuals */
char *macnam;	/* name of macro requiring actuals */
int maclvl; /* # calls since last decrease in nesting level */
char *macforw;	/* pointer which must be exceeded to decrease nesting level */
int macdam; /* offset to macforw due to buffer shifting */

int inctop[MAXINC];
char	*fnames[MAXINC];
char	*dirnams[MAXINC];	/* actual directory of #include files */
FILE	*fins[MAXINC];
int lineno[MAXINC];

char	*dirs[10];  /* -I and <> directories */
/*char *strdex(), *copy(), *subst(), *trmdir();
struct symtab *stsym();*/
FILE *	fin = stdin;   /* Code modified by Hi-Tech */
FILE	*fout = stdout;	/* */
int nd	= 1;
int pflag;  /* don't put out lines "# 12 foo.c" */
/*int inasm = FALSE;  / TRUE if we are in #asm stuff (Don't expand macros) */
int passcom;	/* don't delete comments */
int indef;	/* in define w_9cb2 */
int rflag;  /* allow macro recursion */


int ifno;

char *prespc[NPREDEF];
char **predef = prespc;
char *punspc[NPREDEF];
char **prund = punspc;
int exfail;
struct symtab {
    char    *name;
    char    *value;
} 
*lastsym/*, *lookup(), *slookup()*/;


struct symtab stab[symsiz];

struct symtab *defloc; /* w_9cb0 */ 
struct symtab *udfloc;
struct symtab *incloc;
struct symtab *ifloc;
struct symtab *elsloc;
struct symtab *eifloc;
struct symtab *ifdloc;
struct symtab *ifnloc;
/*struct symtab *ysysloc;*/
struct symtab *varloc; /* unused w_9cb8 */
struct symtab *lneloc;
struct symtab *ulnloc;
struct symtab *uflloc; /* w_9cb6 */ 
struct symtab *uccloc; /* Code added by Hi-Tech w_9ca0 */
struct symtab *asmloc;
struct symtab *easmloc;	/* w_9cb4 */ 
int trulvl;
int flslvl;

/*********************************************************************
  Prototype functions are located in sequence of being in original
  binary image of CPP.COM
 
  ok++ - Full binary compatibility with code in original file;
  ok+  - Code generated during compilation differs slightly,
         but is logically correct;
  ok   - C source code was compiled successfully, but not verified.
 *********************************************************************/
void             sayline(void);			/* sub_013dh */
void		 dump(void);			/* sub_016bh */
char 	       * refill(char *);		/* sub_01bch */
char 	       * cotoken(char *);		/* sub_0465h */
char 	       * skipbl(char *);		/* sub_0a47h */
char 	       * unfill(char *);		/* sub_0a7bh */
char 	       * doincl(char *);		/* sub_0c59h */
int		 equfrm(char *, char *, char *);/* sub_0f30h */
int              equdef(char *, char *);	/* sub_0f7bh */
char 	       * dodef(char *);			/* sub_10b2h */
void		 control(char *);		/* sub_16ach */
struct symtab  * stsym(char *);			/* sub_19cch */
struct symtab  * ppsym(char *);			/* sub_1a9bh */
void		 pperror(char *fmt, ...);	/* sub_1ad2h */
void		 yyerror(char *fmt, ...);	/* sub_1b49h */
void		 ppwarn(char *fmt, ...);	/* sub_1b67h */
struct symtab  * lookup(char *, int);		/* sub_1b97h */
struct symtab  * slookup(char *, char *, int);	/* sub_1d22h */
char 	       * subst(char *, struct symtab *);/* sub_1df5h */
char 	       * trmdir(char *);		/* sub_21efh */
char 	       * copy(char *);			/* sub_2242h */
char 	       * strdex(char *, int);		/* sub_2272h */
int		 yywrap(void);			/* sub_22a2h */
int		 main(int argc, char **argv);	/* sub_22a6h */

int		 yylex(void);			/* sub_29f6h */
int		 yyparse();			/* sub-2c76h */
int 		 tobinary(char *, int); 	/* sub_2892h */

/*char 	      ** _getargs(char *, char *);	/ sub_32bfh /
FILE 	       * fopen(char *, char *);		/ sub_3f61h /
int 	         fread(char *, int, unsigned, FILE *); / sub-43a4h */
#ifndef CPM
FILE           * open(char *, char *);
#endif


#ifdef CPM
extern char ** _getargs();
extern int     _argc_;
#endif

/*********************************************************************
 * sayline sub_013dh OK++			 Used in: 
 *********************************************************************/
void sayline(void) {

    if(pflag == 0)
	fprintf(fout, "# %d \"%s\"\n", lineno[ifno], fnames[ifno]);
}

/* data structure guide
/*
/* most of the scanning takes place in the buffer:
/*
/*  (low address)                                             (high address)
/*  pbeg                           pbuf                                 pend
/*  |      <-- BUFSIZ chars -->      |         <-- BUFSIZ chars -->        |
/*  _______________________________________________________________________
/* |_______________________________________________________________________|
/*          |               |               |
/*          |<-- waiting -->|               |<-- waiting -->
/*          |    to be      |<-- current -->|    to be
/*          |    written    |    token      |    scanned
/*          |               |               |
/*          outp            inp             p
/*
/*  *outp   first char not yet written to output file
/*  *inp    first char of current token
/*  *p      first char not yet scanned
/*
/* macro expansion: write from *outp to *inp (chars waiting to be written),
/* ignore from *inp to *p (chars of the macro call), place generated
/* characters in front of *p (in reverse order), update pointers,
/* resume scanning.
/*
/* symbol table pointers point to just beyond the end of macro definitions;
/* the first preceding character is the number of formal parameters.
/* the appearance of a formal in the body of a definition is marked by
/* 2 chars: the char WARN, and a char containing the parameter number.
/* the first char of a definition is preceded by a zero character.
/*
/* when macro expansion attempts to back up over the beginning of the
/* buffer, some characters preceding *pend are saved in a side buffer,
/* the address of the side buffer is put on 'instack', and the rest
/* of the main buffer is moved to the right.  the end of the saved buffer
/* is kept in 'endbuf' since there may be nulls in the saved buffer.
/*
/* similar action is taken when an 'include' statement is processed,
/* except that the main buffer must be completely emptied.  the array
/* element 'inctop[ifno]' records the last side buffer saved when
/* file 'ifno' was included.  these buffers remain dormant while
/* the file is being read, and are reactivated at end-of-file.
/*
/* instack[0 : mactop] holds the addresses of all pending side buffers.
/* instack[inctop[ifno]+1 : mactop-1] holds the addresses of the side
/* buffers which are "live"; the side buffers instack[0 : inctop[ifno]]
/* are dormant, waiting for end-of-file on the current file.
/*
/* space for side buffers is obtained from 'savch' and is never returned.
/* bufstack[0:fretop-1] holds addresses of side buffers which
/* are available for use.
*/

/*********************************************************************
 * dump sub_016bh    OK++			 Used in: 
 * 
 * Write part of buffer which lies between  outp  and  inp.
 * This should be a direct call to 'write', but the system slows
 * to a crawl if it has to do an unaligned copy.  thus we buffer.
 * This silly loop is 15% of the total time, thus even the 'putc'
 * macro is too slow.
 *********************************************************************/
void dump(void) {
    FILE * f;
    register char * p1;

    if((p1 = outp) == inp || flslvl != 0) return;
    f = fout;
    while(p1 < inp) putc(*p1++, f);
    outp = p1;
}

/*********************************************************************
 * refill sub_01bch OK++			 Used in: 
 *
 * Dump buffer. Save chars from inp to p. Read into buffer at pbuf,
 * contiguous with p.  Update pointers, return new p.
 *********************************************************************/
char * refill(register char *p) {
    char *  np;
    char *  op;
    int	    ninbuf;

    dump();
    np = pbuf - (p - inp);
    op = inp;
    if(bob(np+1)) {
        pperror("token too long");
        np = pbeg;
        p = inp + BUFSIZ;
    }
    macdam += np - inp; outp = inp = np;
    while(op < p) *np++ = *op++;
    p = np;
    for(;;) {
	if(inctop[ifno] < mactop) {
	    /* retrieve hunk of pushed-back macro text */
	    op = instack[--mactop];
	    np = pbuf;
	    do { while((*np++ = *op++) != '\0'); }
	    while(endbuf[mactop] > op); pend = np - 1;
	    /* make buffer space avail for 'include' processing */
	    if(fretop < MAXFRE) bufstack[fretop++] = instack[mactop];
	    return (p);
        } else { /* get more text from file(s) */
	    maclvl = 0;
	    if(((int)(ninbuf = fread(pbuf, 1, BUFSIZ, fin))) > (int)0) {
		pend = pbuf + ninbuf;
		*pend = '\0';
		return(p);
	    }
	    /* end of #include file */
	    if(ifno == 0) { /* end of input */
	        if(plvl != 0) {
	            int n = plvl, tlin = lineno[ifno];
	            char *tfil = fnames[ifno];
	            lineno[ifno] = maclin;
	            fnames[ifno] = macfil;
	            pperror("%s: unterminated macro\tcall", macnam);
	            lineno[ifno] = tlin;
	            fnames[ifno] = tfil;
	            np = p;
	            *np++ = '\n'; /* shut off unterminated quoted string */
	            while(--n>=0) *np++ = ')'; /* supply missing parens */
	            pend = np;
	            *np='\0';
	            if(plvl < 0) plvl = 0;
	            return(p);
	        }
	        inp = p; dump();
	        exit(exfail);
            }
	    fclose(fin);
	    fin = fins[--ifno];
	    dirs[0] = dirnams[ifno];
	    sayline();
        }
    }
}

/*********************************************************************
 * cotoken sub_0465h OK++			 Used in: 
 *********************************************************************/
char * cotoken(register char * p) {
    int  c, i;
    char quoc;
    static int state = BEG;

    if(state != BEG) goto prevlf;
    for (;;) {
again:
	while(!isspc(*p++));
	switch (*(inp = p-1)) {
	    case    0:	/* l0490h; */
		{
	            if(eob(--p)) { p = refill(p); goto again; }		/* m0: */
                    else ++p; /* ignore null byte */
                }
                break;
	    /*case  1: case  2: case  3: case  4: case  5:
	    case  6: case  7: case  8: case  9: case 11:
	    case 12: case 13: case 14: case 15: case 16:
	    case 17: case 18: case 19: case 20: case 21:
	    case 22: case 23: case 24: case 25: case 26:
	    case 27: case 28: case 29: case 30: case 31:
	    case 32: case 35: case 36: case 37: case 40:
	    case 41: case 42: case 43: case 44: case 45:
	    case 46: case 58: case 59: case 63: case 64:
	    case 91: case 93: case 94: case 96: case 123:	/ goto m7; l04ddh; /
		break;*/

	    case  '|':
	    case  '&':	   /* l04eah; */
		for (;;) { /* sloscan only */
		    if (*p++ == *inp) break;				/* m8: */
		    if (eob(--p)) p = refill(p);
		    else break;
		} /* goto m8; */
		break;

	    case '=':
	    case '!':
		for (;;) { /* sloscan only */
		    if (*p++ == '=') break;				/* m9: */
		    if (eob(--p)) p = refill(p);
		    else break;
		} /* goto m9; */
		break;

	    case  '<':
	    case  '>':	   /* l0536h; */
		for (;;) { /* sloscan only */
		    if (*p++ == '=' || p[-2] == p[-1]) break;		/* m10: */
		    if (eob(--p)) p = refill(p);
		    else break;
		} /* goto m10; */
		break;

	    case '\\':	/* l057dh; */
		for (;;) {
 		    if (*p++ == '\n') {++lineno[ifno]; break;}		/* m111: */
		    if (eob(--p)) p = refill(p);			/* m11: */
		    else {++p; break;} 					/* m12: */
		}
		break;

	    case  '/':	/* l075fh; */
		for(;;) {
		    if(*p++ == '*') {	/* comment K&R */
		        if((indef) || (!passcom)) {		/* Code changed by Hi-Tech */
		            inp = p - 2;				/* m31: */
		            while((toktyp+COFF)[*(inp-1)] == 1 && inp != outp) {		/* m14: */
    			        inp--;
			        }
		            dump(); ++flslvl;				/* m15: */
		        }
			for (;;) {
		            while (!iscom(*p++));			/* m16: */
			    if(p[-1] == '*') for (;;) {
			        if(*p++ == '/') goto endcom;		/* m17: */
				if(eob(--p)) {
				    if((indef) || (!passcom)) {	/* Code changed by Hi-Tech */
			                inp = p;			/* m18: */
					p = refill(p); 			/* m20: */
			            } else if((p - inp) >= BUFSIZ) {	/* split long comment */
					inp = p;			/* last char written is '*' */
					p = refill(p);			/* terminate first part */
					putc('/', fout);		/* and fake start of 2nd */
					outp = inp = p -= 3;
					*p++ = '/';
					*p++ = '*';
					*p++ = '*';
			            } else {
			                p = refill(p); 			/* m19: */
				    }
				} else {
				    break;
			        }
			    } else if(p[-1] == '\n') {			/* m21: */
				++lineno[ifno];
				if((indef) || (!passcom)) /* Code changed by Hi-Tech */
				    fputc('\n', fout);			/* m22: */
			    } else if(eob(--p)) {			/* m23: */
				if((indef) || (!passcom)) {	/* Code changed by Hi-Tech */
				    inp = p;				/* m24: */
				    p = refill(p); 			/* m25: */
				} else if((p - inp) >= BUFSIZ) { 	/* m26: */
				    /* split long comment */
				    inp = p;
				    p = refill(p);
				    putc('*', fout);
				    putc('/', fout);
				    outp = inp = p -= 2;
				    *p++ = '/';
				    *p++ = '*'; 
			        } else {
			            p = refill(p);			/* m25: */
			        }
			    } else {
			        ++p;	/* ignore null byte		   m27: */
			    }
			} /* goto m16; */
endcom:
		        if((indef) || (!passcom)) {		/* Code changed by Hi-Tech */ /* m28: */
			    outp = inp = p; --flslvl; goto again;	/* m29: */
			}
		        break;
		    }
		    if(eob(--p)) p = refill(p);				/* m30: */
		    else break;
		}
		break;

	    case  '"':
	    case  '\'':	/* l0782h; */
		quoc = p[-1];						/* m311: */
		for (;;) {
		    while (!isquo(*p++));				/* m32: */
		    if (p[-1] == quoc) break;
		    /* bare \n terminates quotation */
		    if (p[-1] == '\n') { --p; break; } 
		    if (p[-1] == '\\') {				/* m33: */
		        for (;;) {
		            /* escaped \n ignored */
		            if (*p++ == '\n') {++lineno[ifno]; break;}	/* m34: */
		            if (eob(--p)) p = refill(p);		/* m35: */
		            else {++p; break;}
		        } /* goto m34; */
		    } else if (eob(--p)) p = refill(p);			/* m37: */
		    else ++p; /* it was a different quote character	   m36: */
		} /* goto m32; */
	        break;

	    case '\n':	/* l080ch; */
		{
		    ++lineno[ifno]; if (isslo) {state = LF; return (p);}/* m311: */
prevlf:
		    state = BEG;					/* m1: */
		    for (;;) {
			if (*p++ == '#') return (p);			/* m2: */
			if (eob(inp = --p)) p = refill(p);
			else goto again;
		    }
		}

	    case '0': case '1': case '2': case '3': case  '4':
	    case '5': case '6': case '7': case '8': case  '9': 	/* l0852h; */
 		for(;;) {
		    while(isnum(*p++));					/* m39: */
		    if(eob(--p)) p = refill(p);
		    else break;
      		} /* goto m39; */
		break;

	    case 'A': case 'B': case 'C': case 'D': case 'E':
	    case 'F': case 'G': case 'H': case 'I': case 'J':
	    case 'K': case 'L': case 'M': case 'N': case 'O':
	    case 'P': case 'Q': case 'R': case 'S': case 'T':
	    case 'U': case 'V': case 'W': case 'X': case 'Y':
	    case 'Z': case '_':
	    case 'a': case 'b': case 'c': case 'd': case 'e':
	    case 'f': case 'g': case 'h': case 'i': case 'j':
	    case 'k': case 'l': case 'm': case 'n': case 'o':
	    case 'p': case 'q': case 'r': case 's': case 't':
	    case 'u': case 'v': case 'w': case 'x': case 'y':
	    case 'z':	/* l0880h; */
#if scw1
#define tmac1(c,bit) if (!xmac1(c,bit,&)) goto nomac
#define xmac1(c,bit,op) ((macbit+COFF)[c] op (bit))
#else
#define tmac1(c,bit)
#define xmac1(c,bit,op)
#endif

#if scw2
#define tmac2(c0,c1,cpos) if (!xmac2(c0,c1,cpos,&)) goto nomac
#define xmac2(c0,c1,cpos,op)\
	((macbit+COFF)[(t21+COFF)[c0]+(t22+COFF)[c1]] op (t23+COFF+cpos)[c0])
#else
#define tmac2(c0,c1,cpos)
#define xmac2(c0,c1,cpos,op)
#endif

		if(flslvl) goto nomac;					/* m391: */
		for(;;) {
			c= p[-1];                          tmac1(c,b0);
			i= *p++; if (!isid(i)) goto endid; tmac1(i,b1); tmac2(c,i,0);
			c= *p++; if (!isid(c)) goto endid; tmac1(c,b2); tmac2(i,c,1);
			i= *p++; if (!isid(i)) goto endid; tmac1(i,b3); tmac2(c,i,2);
			c= *p++; if (!isid(c)) goto endid; tmac1(c,b4); tmac2(i,c,3);
			i= *p++; if (!isid(i)) goto endid; tmac1(i,b5); tmac2(c,i,4);
			c= *p++; if (!isid(c)) goto endid; tmac1(c,b6); tmac2(i,c,5);
			i= *p++; if (!isid(i)) goto endid; tmac1(i,b7); tmac2(c,i,6);
															tmac2(i,0,7);

		    while (isid(*p++));					/* m40: */
		    if (eob(--p)) {refill(p); p = inp + 1; continue;}
		    goto lokid;

endid:		    if (eob(--p)) {refill(p); p = inp + 1; continue;}

lokid:		    slookup(inp, p, 0); if(newp) {p = newp; goto again;}
		    else break;

nomac:		    while (isid(*p++));					/* m43: */
		    if (eob(--p)) {p = refill(p); goto nomac;}
		    else break;
		}
		break;

	} /* end of switch */
	if(isslo) return p; /* goto m3;					    m7: */
    } /* end of infinite loop */
}

/****************************************************************
 * skipbl sub-0a47h OK++ Get next non-blank token	Used in: 
 ****************************************************************/
char * skipbl(register char * p) {

    do { outp = inp = p; p = cotoken(p); }
    while ((toktyp+COFF)[*inp] == BLANK); 
    return (p);
}

/****************************************************************
 * unfill sub_0a7bh OK++ 	Used in: 
 * take <= BUFSIZ chars from right end of buffer and put them on
 * instack. Slide rest of buffer to the right, update pointers,
 * return new p.
 ****************************************************************/
char * unfill(register char * p) {
    char * np, * op;
    int    d;

    if (mactop >= MAXFRE) {
	pperror("%s: too much pushback", macnam);
	p = inp = pend; dump(); /* begin flushing pushback */
	while(inctop[ifno] < mactop) {
	    p = refill(p); p = inp = pend; dump();
	}
    }
    if(0 < fretop) np = bufstack[--fretop];
    else {
	np = savch; savch += BUFSIZ;
	if(savch >= (char *)(sbf + SBSIZE)) { /* sbf + SBSIZE = 0x9605 */
	    pperror("no space"); exit(exfail);
	}
	*savch++ = '\0';
    }
    instack[mactop] = np; op = pend - BUFSIZ;
    if(op < p) op = p;
    for(;;) { while(*np++ = *op++);
    if(eob(op)) break;} 	/* out with old */
    endbuf[mactop++] = np;	/* mark end of saved text */
    np = pbuf + BUFSIZ;
    op = pend - BUFSIZ;
    pend = np;
    if(op < p) op = p;
    while(outp < op) *--np = *--op; /* slide over new */
    if(bob(np)) pperror("token too\tlong");
    d = np - outp;
    outp   += d;
    inp    += d; 
    macdam += d;
    return (d + p);

}

/****************************************************************
 * doincl  sub-0c59h OK++	Used in:	
 ****************************************************************/
char * doincl(register char * p) {
    int    filok;	/* l1; */
    int    inctype;	/* l2; */
    char * cp;		/* l3; */
    char ** dirp;	/* l4; */
    char * nfil;	/* l5; */
    char   filname[BUFSIZ];

    p = skipbl(p); cp = filname;
    if(*inp++ == '<') {			/* special <> syntax */
	inctype = 1;			   
	/*++flslvl;	/ prevent macro expansion   Code removed by Hi-Tech */
	for(;;) {
	    outp = inp = p; p = cotoken(p);
	    if(*inp == '\n') { --p; *cp='\0'; break; }
	    if(*inp == '>')  {	    *cp='\0'; break; }
	    while(inp < p) { *cp++ = *inp++; }
         }
         /*--flslvl;	/ reenable macro expansion   Code removed by Hi-Tech */
     } else if(inp[-1] == '"') {	/* regular "" syntax */
	inctype = 0;
	while(inp < p) *cp++ = *inp++;
	if(*--cp == '\"') *cp='\0';
     } else { pperror("bad include syntax", 0); inctype = 2; }
     /* flush current file to \n , then write \n */
     ++flslvl;
     do { outp = inp = p; p = cotoken(p); }
     while(*inp != '\n');
     --flslvl;
     inp = p; dump(); if(inctype == 2) return p;
     /* look for included file */
     if(ifno+1 >= MAXINC) {
	pperror("Unreasonable include nesting", 0);
	return p;
     }
     if(sbf+SBSIZE-BUFSIZ/*0x9405*/ < (nfil = savch)) {
         pperror("no\tspace");
         exit(exfail);
     }
     filok = 0;	
     for(dirp = dirs + inctype; *dirp; ++dirp) {
	 if((filname[0] == '/') || **dirp == '\0')
	     strcpy(nfil, filname); 	/* prcpy */
         else {
	     strcpy(nfil, *dirp);	/* prcpy */
             strcat(nfil, filname);	/* prcat */
         }
         if((fins[ifno+1] = fopen(nfil, "r")) != 0) {
	     filok = 1; fin = fins[++ifno]; break;
         }
     }
     if(filok == 0) pperror("Can't find include file %s", filname);
     else {
	lineno[ifno] = 1; fnames[ifno] = cp = nfil; while(*cp++); savch = cp;
	dirnams[ifno] = dirs[0] = trmdir(copy(nfil));
	sayline();
	/* save current contents of buffer */
	while (!eob(p)) p = unfill(p);
	inctop[ifno] = mactop;
     }
     return p;
}

/****************************************************************
 * equfrm  sub_0f30h OK++		 Used in: 
 ****************************************************************/
int equfrm(register char * a, char * p1, char * p2) {
    char c; int  flag;

    c     = *p2;
    *p2   = '\0';
    flag  = strcmp(a, p1);
    *p2   = c;
    return (flag == SAME);
}

/****************************************************************
 * equdef sub_0f7bh OK++		 Used in: dodef
 * Check whether two defines are equal. alltrim and then strcmp
 ****************************************************************/
int equdef(register char * p1, char * p2) {
    int    res;
    char * p1end;
    char * p2end;
    char   p1save;
    char   p2save;
    char * q;

	/* p1 skip leading whitespace */ /* Bug in original code s/b ' ','\t' */
	for (; *p1 && (*p1 == '\t' || *p1 == '\t'); p1++); /* m1 : */

	/* scan to the end */
	for (p1end = 0, q = p1; *q ; q++) { /* m3: */
		if (*q == ' ' || *q == '\t')
			continue;
        p1end = q;
	}
    if(p1end != 0) { /* token present */
	p1save  = *++p1end; /* end of token */
	*p1end = '\0'; /* trim right */
    }

	/* p2 */ /* Bug in original code s/b ' ','\t' */
	for (; *p2 && (*p2 == '\t' || *p2 == '\t'); p2++); /* m9 : */

	for (p2end = 0, q = p2; *q ; q++) { /* m10: */
		if (*q == ' ' || *q == '\t')
			continue;
        p2end = q;
	}
    if(p2end != 0) {
	p2save = *++p2end;
	*p2end = '\0';
    }

    res = strcmp(p1, p2);				/* m14: */
    if(p1end != 0) *p1end = p1save; /* revert right trim */
    if(p2end != 0) *p2end = p2save;				/* m15: */
    return res;						/* m16: */
}

/****************************************************************
 * dodef sub-10b2h OK++			 Used in: 
 ****************************************************************/
char * dodef(char * p) {
    char          * psav;	/* l1 */
    char          * cf;		/* l2 */
    char         ** pf;		/* l3 */
    char         ** qf;		/* l4 */
    int		    b;		/* l5 */
    int		    c;		/* l6 */
    int		    params;	/* l7 */
    struct symtab * np;		/* l8 */
    char	    quoc;	/* l9 */
    char	  * oldval;	/* l10 */
    char	  * oldsavch;	/* l11 */
    char	  * formal[MAXFRM];  /* formal[n] is name of nth formal */
    char	    formtxt[BUFSIZ]; /* space for formal names */
    register char * pin;

    if(sbf+SBSIZE-BUFSIZ /*0x9405*/< savch) { pperror("too much\tdefining"); return p; }
    oldsavch = savch; /* to reclaim space if redefinition */
    flslvl++; /* prevent macro expansion during 'define' */
    p = skipbl(p); pin = inp;
    if((toktyp+COFF)[*pin] != IDENT) {
	ppwarn("illegal\tmacro name"); while(*inp != '\n') p = skipbl(p); return(p);
    }
    np = slookup(pin, p, 1);
    if(oldval = np->value) savch = oldsavch;	/* was previously defined */
    b = 1; cf = pin;
    while(cf < p) { /* update macbit */
	c = *cf++; xmac1(c,b,|=); b = (b + b) & 0xFF;
    }
    params = 0; outp = inp = p; p = cotoken(p); pin = inp;
    if(*pin == '(') { /* with parameters; identify the formals */
	cf = formtxt; pf = formal;
	for (;;) {
	    p = skipbl(p); pin = inp;
	    if(*pin == '\n') {
		--lineno[ifno]; --p; pperror("%s: missing )", np->name); break;
	    }
	    if (*pin == ')') break;
	    if (*pin == ',') continue;
	    if((toktyp+COFF)[*pin] != IDENT) {
		c = *p; *p = '\0'; pperror("bad formal: %s", pin); *p = c;
	    } else if(pf >= &formal[MAXFRM]) {
		c = *p; *p = '\0'; pperror("too many formals: %s", pin); *p = c;
	    } else {
	        *pf++ = cf; while(pin < p) *cf++ = *pin++; *cf++ = '\0'; ++params;
	    }
	}
        if(params == 0) --params; /* #define foo() ... */
    } else if(*pin == '\n') {--lineno[ifno]; --p;}
    /* remember beginning of macro body, so that we can
     * warn if a redefinition is different from old value.
     */
    oldsavch = psav = savch;

    indef = 1;

    for(;;) { /* accumulate definition until linefeed */
	outp = inp = p; p = cotoken(p); pin = inp; 	 /* m19: */
	if(*pin == '\\' && pin[1] == '\n') { continue; } /* ignore escaped lf */
	if(*pin == '\n') break;
	if(params) { /* mark the appearance of formals in the definiton */
	    if((toktyp+COFF)[*pin] == IDENT) {
		for(qf = pf; --qf >= formal; ) {
		    if(equfrm(*qf, pin, p)) {
			*psav++ = qf - formal + 1;
			*psav++ = WARN;
			pin = p;
			break;
		    }
		}
	    } else if(*pin == '"' || *pin == '\'') { /* inside quotation marks, too */
		quoc = *pin;
		for(*psav++ = *pin++; pin < p && *pin != quoc; ) {
		    while(pin < p && !isid(*pin)) *psav++ = *pin++;
		    cf = pin;
		    while(cf < p && isid(*cf)) ++cf;
		    for(qf = pf; --qf >= formal; ) {
		        if(equfrm(*qf, pin, cf)) {
		            *psav++ = qf - formal + 1;
		            *psav++ = WARN;
		            pin = cf;
		            break;
		        }
		    }
		    while(pin < cf) *psav++ = *pin++;
		}
	    }
	}
	while(pin < p) *psav++= *pin++;
    }
    *psav++ = params;
    *psav++ = '\0';

    indef = 0;

    if((cf = oldval) != NULL) { /* redefinition */
	--cf;			/* skip no. of params, which may be zero */
	while(*--cf);		/* go back to the beginning */
#if CPM
	if(0 != equdef(++cf, oldsavch)) { /* redefinition different from old */
#else
	if(0 != strcmp(++cf, oldsavch)) {
#endif
	    --lineno[ifno];
	    ppwarn("%s redefined", np->name);
	    ++lineno[ifno];
	    np->value = psav - 1;
	} else psav = oldsavch;	/* identical redef.; reclaim space */
    } else np->value = psav - 1;
    --flslvl; 
    inp   = pin; 
    savch = psav; 
    return(p);
}

#define fasscan() ptrtab=fastab+COFF
#define sloscan() ptrtab=slotab+COFF

/****************************************************************
 * control sub-16ach OK++ 
 * Find and handle preprocessor control lines
 ****************************************************************/
void control(register char * p) {
    struct symtab * np;

    for(;;) {
	fasscan();						/* m1: */
	p = cotoken(p);
	if(*inp == '\n') ++inp;
	dump();							/* m2: */
	sloscan();
	p = skipbl(p);
	*--inp = SALT;
	outp = inp;
	++flslvl;
	np = slookup(inp, p, 0); 
	--flslvl;
	if(defloc == np) {			/* "define" */
	    if(flslvl == 0) {
	        p = dodef(p);					/* m3: */
	        continue;	/* goto m1; */
	    }
	} else if(incloc == np) { 		/* "include"	   m4: */
	    if(flslvl == 0) {
	        p = doincl(p);
	        continue;	/* goto m1; */
	    }
	} else if(ifnloc == np) {		/* "ifndef" 	   m5: */
	    ++flslvl; 
	    p  = skipbl(p); 
	    np = slookup(inp, p, 0); 
	    --flslvl;
	    if(flslvl == 0 && np->value == 0) ++trulvl;
	    else ++flslvl;
	} else if(ifdloc == np) { 		/* ifdef	   m8: */
	    ++flslvl; 
	    p = skipbl(p); 
	    np = slookup(inp, p, 0); 
	    --flslvl;
	    if(flslvl == 0 && np->value != 0) ++trulvl;
	    else ++flslvl;
	} else if(eifloc == np) { 		/* "endif"	   m11: */
	    if(flslvl) { if(--flslvl == 0) sayline(); }
	    else if(trulvl) --trulvl;
	    else pperror("If-less endif", 0);
	} else if(elsloc == np) { 		/* "else"	   m17: */
	    if(flslvl) {
		if(--flslvl != 0) ++flslvl;
		else {++trulvl; sayline();}
	    }
	    else if(trulvl) { ++flslvl; --trulvl; }
	    else pperror("If-less else", 0);
	} else if(udfloc == np) { 		/* "undef"	    m21: */
	    if(flslvl == 0) {
		++flslvl; 
		p = skipbl(p); 
		slookup(inp, p, DROP); 
		--flslvl;
	    }
	} else if(ifloc == np) { 		/* "if"		    m22: */
	    newp = p;
	    if(flslvl == 0 && yyparse()) ++trulvl; 
	    else ++flslvl;
	    p = newp;
	} else if(lneloc == np) { 		/* "line"	    m25: */
	    if(flslvl == 0 && pflag == 0) {
		outp = inp = p; 
		*--outp = '#'; 
		while(*inp != '\n') p = cotoken(p);  /* Code modified by Hi-Tech */
	    continue;
	    }
	} else if((asmloc == np) || (easmloc == np)) { /* "asm" & "endasm" */   /* Code added by Hi-Tech */
	    while(*inp != '\n') { 
	        inp = p; 
	        p = cotoken(p); 
	    }
	} else if(*++inp == '\n') outp = inp; /* allows blank line after # */
	else pperror("undefined\tcontrol", 0);			/* m32: */
	/* flush to lf */
	flslvl++; while(*inp != '\n') { 
	    outp = inp = p; 
	    p = cotoken(p); 
	} 
	flslvl--;
    }
}

/****************************************************************
 * stsym sub_19cch OK++
 * make definition look exactly like end of #define line
 * copy to avoid running off end of world when param list is at end
 ****************************************************************/
struct symtab * stsym(register char *s) {
    char *p; char buf[BUFSIZ];

    p = buf;
    while ((*p++ = *s++) != '\0');
    p = buf;
    while (isid(*p++)); /* skip first identifier */
    if (*--p == '=') {*p++ = ' '; while (*p++);}
    else {s = " 1"; while ((*p++ = *s++) != '\0');}
    pend = p;
    *--p = '\n';
    sloscan();
    dodef(buf);
    return (lastsym);
}

/****************************************************************
 * ppsym sub_1a9bh OK++
 ****************************************************************/
struct symtab * ppsym(char *s) {/* kluge */
    register struct symtab *sp;

    cinit    = SALT;
    *savch++ = SALT;
    sp       = stsym(s);
    --sp->name;
    cinit    = 0;
    return (sp);
}

/****************************************************************
 * pperror sub_1ad2h Function changed from original OK++
 ****************************************************************/
void pperror(char *fmt, ...) {
    if(fnames[ifno][0])
	fprintf(stderr, "%s: ", fnames[ifno]);
    fprintf(stderr, "%d: ",lineno[ifno]);

	fprintf(stderr, fmt, *(&fmt+1), *(&fmt+2));
	fprintf(stderr, "\n");
	exfail++;
}

/****************************************************************
 * yyerror sub_1b49h Function changed from original OK++
 ****************************************************************/
void yyerror(char *fmt, ...) {
    pperror(fmt, *(&fmt+1), *(&fmt+2));
}

/****************************************************************
 * ppwarn sub_1b67h Function changed from original OK++
 ****************************************************************/
void ppwarn(char *fmt, ...) {
    int fail = exfail;
	exfail = -1;
    pperror(fmt, *(&fmt+1));

    exfail = fail;
}

/****************************************************************
 * lookup sub_1b97h	OK++
 ****************************************************************/
struct symtab * lookup(char * namep, int enterf) {
    char	  * snp;	/* l1 */
    int		    c;		/* l2 */
    int		    i;		/* l3 */
    int		    around;	/* l4 */
    struct symtab * sp;		/* l5 */
    register char * np; 

    /*
     * namep had better not be too long (currently, <=NCPS chars)
     */
    np     = namep;
    around = 0;
    i      = (char)cinit;

#if CPM	 /* Code changed by Hi-Tech */
    while((np < namep+8) && ((c = (char)*np++) != 0))	/* m2: */
#else
    while(c = (char)*np++)
#endif
	i += i+c;					/* m1: */
    c  = i;	/* c=i for register usage on pdp11	   m3: */
    c %= symsiz;
    if(c < 0)
	c += symsiz;
    sp = &stab[c];					/* m4: */

    while(snp = sp->name) {
	np = namep;					/* m5: */
	while(*snp++ == *np) 				/* m6: */
	    if(*np++ == '\0') {				/* m7: */
	        if(enterf == DROP) {
	            sp->name[0] = DROP;
	            sp->value   = 0;
	        }
	        return (lastsym = sp);
	    }
	    if(--sp < &stab[0])
	        if(around) {
	            pperror("too many defines", 0);
	            exit(exfail);
	        } else {
	            ++around;				/* m9: */
	            sp = &stab[symsiz-1];
	        }
	}
#if CPM	/* Code changed by Hi-Tech */
    if(0 < enterf)
#else
    if(enterf == 1)
#endif
	sp->name = namep;
    return (lastsym = sp);				/* m8: */
}

/****************************************************************
 * slookup sub_1d22h OK++ 		 Used in: 
 ****************************************************************/
struct symtab * slookup(register char * p1, char * p2, int enterf) {
    char * p3;
    char   c2, c3;
    struct symtab *np;

    c2 = *p2; *p2='\0';	/* mark end of token */
    if(NCPS < p2-p1) p3 = p1 + NCPS; else p3 = p2; /* NCPS=0x1f */
    c3 = *p3; *p3='\0';		/* truncate to NCPS chars or less */
    if(enterf == 1) p1 = copy(p1);
    np = lookup(p1, enterf); *p3 = c3; *p2 = c2;
    if((np->value != 0) && (flslvl == 0)) newp = subst(p2, np);
    else newp = 0;
    return np;
}

/****************************************************************
 * sub-1df5h subst OK++ 		 Used in: 
 ****************************************************************/
    char match[] = "%s: argument mismatch";

char * subst(register char * p, struct symtab * sp) {
    char  * ca;			/* l1 */
    char  * vp;			/* l2 */
    int     params;		/* l3 */
    char ** pa;			/* l4 */ /* Code added by Hi-Tech */
    char  * actual[MAXFRM]; 	/* actual[n] is text of nth actual */
/*  char    actused[MAXFRM];   	   for newline processing in actuals  Removed by Hi-Tech*/
    char    acttxt[BUFSIZ];  	/* space for actuals */
/*  int     nlines = 0;	       	    Removed by Hi-Tech */

    if((vp = sp->value) == 0) return p;
    if(macdam >= (p - macforw)) {
	if(symsiz < ++maclvl  && !rflag) {
	    pperror("%s: macro recursion", sp->name); return (p);
	}
    } else maclvl = 0;		/* level decreased */
    macforw = p; macdam = 0;	/* new target for decrease in level */
    macnam  = sp->name;
    dump();
    if(sp == ulnloc) {		/* "__LINE__" */
	vp = acttxt; *vp++ = '\0';
	sprintf(vp, "%d", lineno[ifno]); while(*vp++);
    } else if(sp == uflloc) {	/* "__FILE__" */
	vp = acttxt; *vp++ = '\0';
	sprintf(vp, "\"%s\"", fnames[ifno]); while(*vp++);
    }
    if((params = *--vp & 0xFF) != 0) {
	ca = acttxt;
	pa = actual;
	if(params == 0xFF) params = 1; /* #define foo() ... */
	sloscan(); ++flslvl; /* no expansion during search for actuals */
	plvl = -1;
	do { p = skipbl(p); } while(*inp == '\n'); /* skip \n too */ /*m9: */
	if(*inp == '(') { /* goto m19; */
	    maclin = lineno[ifno]; macfil = fnames[ifno];
#if CPM	 /* Code changed by Hi-Tech */
	    plvl = 1;
m18:    while(plvl != 0) {					/* m18: */
#else
	    for(plvl = 1; plvl != 0; ) {
#endif
                *ca++ = '\0'; 					/* m10: */
                for(;;) {
                    outp = inp = p; p = cotoken(p);		/* m11: */
                    if(*inp == '(') ++plvl; /* goto m12; */
                    if(*inp == ')' && --plvl == 0) { /* goto m14; */
                         --params;
#ifdef CPM	 /* Code changed by Hi-Tech */
m13:                if(pa < &actual[MAXFRM]) break; /* goto m17; */
                        ppwarn(match, sp->name);
                        goto m18;
#else
			break;
#endif
                    }
                    if(plvl == 1 && *inp == ',') {		/* m14: */
                        --params;
#ifdef CPM	 /* Code changed by Hi-Tech */
                        goto m13;
#else
			break;
#endif
                    }
                    while(inp < p) *ca++ = *inp++;		/* m16: */
                    if(&acttxt[BUFSIZ] < ca) pperror("%s: actuals too long", sp->name);
                } 						/* goto m11; */
#ifndef CPM	 /* Code changed by Hi-Tech */
                if (pa >= &actual[MAXFRM]) ppwarn(match, sp->name);
                else { actused[pa - actual] = 0; *pa++ = ca; }
#else
                *pa++ = ca;					/* m17: */
#endif
	    } 							/* goto m18; */
#ifndef CPM	 /* Code changed by Hi-Tech */
	    nlines = lineno[ifno] - maclin;
 	    lineno[ifno] = maclin;   /* don't count newlines here */
#endif
	} 							/* end if */

        if(params != 0)				/* ----+ Ok        m19: */
            ppwarn(match, sp->name);		/*     V  */

	/* null string for missing actuals */
	while(--params>=0) *pa++ = "" + 1;
	--flslvl; fasscan();
    }
    for(;;) { /* push definition onto front of input stack */
	while(!iswarn(*--vp)) {					/* m24: */
            if(bob(p)) { outp = inp = p; p = unfill(p); }
            *--p = *vp;						/* m23: */
        }
	if(*vp == warnc) {	/* insert actual param */
            ca = actual[*--vp-1];
            while(*--ca) {
		if(bob(p)) { outp = inp = p; p = unfill(p); }	/* m25: */
	        /* actuals with newlines confuse line numbering */
#ifndef CPM	 /* Code changed by Hi-Tech */
	        if(*ca == '\n' && actused[*vp-1]) 
	            if (*(ca-1) == '\\') ca--;
	            else *--p = ' ';
	        else { *--p = *ca; if(*ca == '\n') nlines--; }
#else
	        *--p = *ca;
#endif
            }
#ifndef CPM	 /* Code changed by Hi-Tech */
	    actused[*vp-1] = 1;
	    } else {
		if(nlines > 0 )
		    while(nlines-- > 0)
			*--p = '\n';
		break;
	    }
#else
	    continue;
#
	}
	outp = inp = p;						/* m28: */
	return p;
    }
}

/****************************************************************
 * sub-21efh OK++ 		 Used in: 
 ****************************************************************/
char * trmdir(register char * s) {
    char * p = s;

    while (*p++); --p; while (p > s && *--p != '/');
#if unix
    if(p == s) *p++ = '.';
#endif
    *p = '\0';
    return (s);
}

/****************************************************************
 * sub-2242h OK++ 		 Used in: 
 ****************************************************************/
char * copy(register char * s) {
    char * old;

    old = savch;
    while(*savch++ = *s++);
    return (old);
}

/****************************************************************
 * sub-2272h strdex	OK++ 		 Used in: 
 ****************************************************************/
char * strdex(char *s,int c) {

    while (*s) if (*s++ == (char)c) return(--s);
    return (0);
}

/****************************************************************
 * sub-22a2h yywrap	OK++ 		 unused
 ****************************************************************/
yywrap(){ 
    return(1); 
}

/****************************************************************
 * sub_22a6h main  OK++
 ****************************************************************/
int main(int argc, char ** argv) {
    int    i;
    int    c;
    char * tf;
    char **cp2;
    register char * p;

    if(argc == 1) {			/* Code added by Hi-Tech */
	argv = _getargs(0, "cpp");	/* */
	argc = _argc_;			/* */
    }

    p = "_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    i = 0;
    while((c = *p++) != 0) {
	(fastab+COFF)[c] |= IB|NB|SB; (toktyp+COFF)[c] = IDENT;
#if scw2
			/* 53 == 63-10; digits rarely appear in identifiers,
			/* and can never be the first char of an identifier.
			/* 11 == 53*53/sizeof(macbit) .
			*/
			++i; (t21+COFF)[c]=(53*i)/11; (t22+COFF)[c]=i%11;
#endif
    }
    p = "0123456789.";
    while(c = *p++) {
	(fastab+COFF)[c] |= NB|SB; (toktyp+COFF)[c] = NUMBR;
    }
    p = "\n\"\'/\\";
    while(c = *p++) (fastab+COFF)[c] |= SB;

    p = "\n\"\'\\";
    while(c = *p++) (fastab+COFF)[c] |= QB;
    p = "*\n";
    while(c = *p++) (fastab+COFF)[c] |= CB;
    (fastab+COFF)[warnc] |= WB;
    (fastab+COFF)['\0'] |= CB|QB|SB|WB;

    for (i=ALFSIZ; --i>=0; )
	slotab[i] = fastab[i] | SB;		/* */

    p = " \t\013\f\r";	/* note no \n;	\v not legal for vertical tab? */
    while(c = *p++) (toktyp+COFF)[c] = BLANK;

    for(i=1; i<argc && argv[i][0]=='-'; i++) /* Code changed by Hi-Tech */
    {
	    switch(argv[i][1]) {				/* m16: */
	      case 'P':
	        pflag++;						/* m19: */
	        /*continue;*/
	      case 'E':
	        continue;
	      case 'R':
	        rflag++;						/* m20: */
	        continue;
	      case 'C':
	        passcom++;						/* m21: */
	        continue;
	      case 'D':
	        if(predef>prespc+NPREDEF) {					/* m22: */
	            pperror("too many -D options, ignoring %s", argv[i]); 	/* m23: */
	            continue;
	        }
	        if(argv[i][2]) *predef++ = argv[i]+2;			/* m24: */
	        continue;
	      case 'U':
	        if(prund>punspc+NPREDEF) {					/* m27: */
	            pperror("too many -U options, ignoring %s", argv[i]);
	            continue; /* goto m23; */
	        }
	        *prund++ = argv[i]+2;					/* m28: */
	        continue;  /* goto m25; */
	      case 'I':
	        if(nd>8) {						/* m29: */
	            pperror("excessive -I\tfile (%s) ignored", argv[i]);
	            /*break;  goto m23; */
	        } else
	        dirs[nd++] = argv[i]+2;				/* m30: */
	        continue;
	      case '\0':
	        continue;
	      default:	pperror("unknown flag %s", argv[i]);
	      continue;
	    }
	}
	if(i < argc) {						/* Code changed by Hi-Tech */ /* m32: */
		fin = freopen(argv[i], "r", stdin);	  /* */
		if(fin == 0) {
			pperror("No source file\t%s", argv[i]);
			exit(8);
		}
		fnames[ifno] = copy(argv[i]);			/* m33: */
		dirs[0] = dirnams[ifno] = trmdir(argv[i]);
		if(++i < argc) {				/* Code changed by Hi-Tech */
			fout = freopen(argv[i], "w", stdout);  /* */
			if(fout == 0) {
				pperror("Can't create %s", argv[i]);
				exit(8);
			}
		}
	}

     fins[ifno] = fin;							/* m34: */
     exfail     = 0;
     dirs[nd++] = 0;

     defloc     = ppsym("define");
     udfloc     = ppsym("undef");
     incloc     = ppsym("include");
     elsloc     = ppsym("else");
     eifloc     = ppsym("endif");
     ifdloc     = ppsym("ifdef");
     ifnloc     = ppsym("ifndef");
     ifloc      = ppsym("if");
     lneloc     = ppsym("line");
     asmloc     = ppsym("asm");		/* Code added by Hi-Tech */
     easmloc    = ppsym("endasm");	/* */

     for(i = sizeof(macbit)/sizeof(macbit[0]); --i>=0; ) /* m36: */
         macbit[i] = 0;							/* m35: */

     uccloc = stsym("z80");		/* Code added by Hi-Tech */
     ulnloc = stsym("__LINE__");
     uflloc = stsym("__FILE__");

     tf           = fnames[ifno];
     fnames[ifno] = "command line";
     lineno[ifno] = 1;
     cp2          = prespc;
     while(cp2 < predef) stsym(*cp2++);					/* m38: */
     cp2 = punspc;		/* 0xA5FE; */
     while(cp2 < prund) {						/* m41: */
	if (p=strdex(*cp2, '=')) *p++ = '\0';				/* m39: */
	lookup(*cp2++, DROP);						/* m40: */
     }
     fnames[ifno] = tf;
     pbeg = buffer + NCPS;	/* 0x9624; */
     pbuf = pbeg + BUFSIZ;
     pend = pbuf + BUFSIZ;
     flslvl = trulvl = 0;
     lineno[0] = 1;
     sayline();
     control(outp = inp = pend);

     if(fclose(stdout) == -1) {					/* Code added by Hi-Tech */
	fprintf(stderr ,"CPP: Error closing output file\n");	/* */
	return 1;						/* */
     }								/* */

    return (exfail);							/* m42: */
}
