#include "stdio.h"
#include <string.h>
#include "cpm.h"
#include <unixio.h>
#include <stdarg.h>

#ifndef	uchar
#define	uchar	unsigned char
#endif

#if CPM
/*
extern char ** _getargs();
extern int     _argc_;
*/
#define	O_RDONLY	0
#define	O_WRONLY	1
#define	O_RDWR		2
#endif

/*
   C command
   written by John F. Reiser
   July/August 1978
*/

// File - CPP.H Created 08.02.2021 Last Modified 28.03.2021

#define STATIC	static

#define COFF 0


//	Used macros

#define LO_CHAR(a)      *((unsigned char *)&a)
#define HI_CHAR(a)      *(((unsigned char *)&a) + 1)
#define LO_WORD(a)      *((unsigned int *)&a)
#define HI_WORD(a)      *(((unsigned int *)&a) + 1)

#define bittst(var,bitno) ((var) & 1    << (bitno))
#define bitset(var,bitno) ((var) |= 1   << (bitno))
#define bitclr(var,bitno) ((var) &= ~(1 << (bitno)))

#define isslo     (ptrtab==(slotab))
#define isid(a)   ((fastab)[a]&IB)
#define isspc(a)  (ptrtab[a]&SB)
#define isnum(a)  ((fastab)[a]&NB)
#define iscom(a)  ((fastab)[a]&CB)
#define isquo(a)  ((fastab)[a]&QB)
#define iswarn(a) ((fastab)[a]&WB)

#define eob(a) ((a)>=pend)
#define bob(a) (pbeg>=(a))

#define tmac1(c,bit) if (!xmac1(c,bit,&)) goto nomac
#define xmac1(c,bit,op) ((macbit+COFF)[c] op (bit))

#define tmac2(c0,c1,cpos)
#define xmac2(c0,c1,cpos,op)

#define BLANK	1
#define IDENT	2
#define NUMBR	3

#define	DNAMLEN	4	// ok!	length of device names

#define DROP  0xFE	//	Special character not legal ASCII or EBCDIC
#define WARN  DROP
#define SAME     0

#define MAXINC	10	// ok!	Nested includes
#define MAXFRE	14	// ok!	Max buffers of macro pushback
#define MAXFRM	31	//	Max number of formals/actuals to a macro
#define SBSIZE	12000	// ok!

#ifndef BUFSIZ
#define BUFSIZ 512	// ok!   in version Hi-Tech C v3.09 */
#endif

#define NCPS	31 	// ok!
#define SYMSIZ	500	// ok!
#define ALFSIZ	128	//	Alphabet size
#define NPREDEF 20	// ok!

#define SALT	'#'

#define b0	1
#define b1	2
#define b2	4
#define b3	8
#define b4	16
#define b5	32
#define b6	64
#define b7	128

#define IB	1
#define SB	2
#define NB	4
#define CB	8
#define QB	16
#define WB	32

#define BEG	0
#define LF	1

/*
   Descriptions of variables and arrays
  
   Declarations are located in sequence of being in original binary
   image of CPP.COM
*/

struct symtab {
    char * name;
    char * value;
} * lastsym;

extern char    sbf[SBSIZE];
extern char  * prespc[NPREDEF];
extern char  * punspc[NPREDEF];

char         * savch  = sbf;		// w_58be = 0x6725;
char           warnc  = WARN;		// b_58c0 = 0xFE;
FILE         * fin    = stdin;		// w_58c1 = stdin  = 0x63EF
FILE         * fout   = stdout;		// w_58c3 = stdout = 0x63F7
int	       nd     = 1;		// w_58c5 = 1
char        ** predef = prespc;		// w_58c7 = 0x9DBE;
char	    ** prund  = punspc;		// w_58c9 = 0xA5FE
int            state  = BEG;		// w_58cb = 0

int            ifdef = 0;		// w_5cf8 = 0

char	dnames[][DNAMLEN] = { // 642f
	"CON:",
	"RDR:",
	"PUN:",
	"LST:",
};

char		sbf[SBSIZE];		// 0x6725
//              31 + 512  +  512 + 31 = 
char	buffer[NCPS+BUFSIZ+BUFSIZ+NCPS];// 0x6905  len = 1086(0x43E)

/* 0x9405 */

/* 0x9624 */

int	        lineno[MAXINC];		// a_9a43[10]
char	      * instack[MAXFRE];	// a_9a57[14]
char		macbit[128];		// a_9a73[128]	ALFSIZ+11
char		array_9af3[139];	//  128+11

char	      * fnames[MAXINC];		// a_9b7e[128+11] 139
char	      * pend;			// w_9b92
char		toktyp[ALFSIZ];		// a_9c14[128]
char	      * macfil;			// w_9c94 File name of macro call requiring actuals
char	      * pbuf;			// w_9c96
int		pflag;			// w_9c98 Don't put out lines "# 12 foo.c"
struct symtab * incloc;			// w_9c9a
char	      * newp;			// w_9c9c
struct symtab * asmloc;			// w_9c9e
struct symtab * uclloc;			// w_9ca0
struct symtab * ifloc;			// w_9ca2
int		exfail; 		// w_9ca4
struct symtab * lneloc;			// w_9ca6
char	      * macnam;			// w_9ca8 Name of macro requiring actuals
struct symtab * eifloc;			// w_9caa
int		maclin;			// w_9cac Line number of macro call requiring actuals
int		flslvl;			// w_9cae
struct symtab * defloc;			// w_9cb0

int		word_9cb2;		//

struct symtab * easmloc;		// w_9cb4
struct symtab * uflloc;			// w_9cb6
int		rflag;			// w_9cba
int		fretop;			// w_9cbc

/* char	      * punspc[NPREDEF]; */	// ???[128]

char		fastab[ALFSIZ];		// a_9d3e[128]

char	      * prespc[NPREDEF];	// 0x9DBE [40]

char	      * dirs[10]; 		// a_9de6 -I and <> directories
struct symtab * ulnloc;			// w_9dfa
char	      * ptrtab;			// w_9dfc
FILE	      * fins[MAXINC];		// a_9dfe
int		plvl;			// w_9e12 Parenthesis level during scan for macro actuals
int		passcom;		// w_9e14
int		maclvl;			// w_9e16 # calls since last decrease in nesting level
int		inctop[MAXINC];		// a_9e18
struct		symtab * udfloc;	// w_9e2c
struct		symtab stab[SYMSIZ];	// a_9e2e

char	      * punspc[NPREDEF];	// 0xA5FE

struct symtab * ifdloc;  		// w_6621

char		cinit;
char		array_6625[];

char		slotab[ALFSIZ];		// a_66a5

int		ifno;			// w_a626
char	      * bufstack[MAXFRE];	// a_a629
char	      * endbuf[MAXFRE];		// a_a645
struct symtab * ifnloc;			// w_a661
char	      * macforw;  		// w_a663
char	      * pbeg;			// w_a665
int		mactop;			// w_a667
struct symtab * elsloc;			// w_a669
char	      * outp;			// w_a66b
int   		macdam;			// w_a66d Offset to macforw due to buffer shifting
char	      * dirnams[MAXINC];	// a_a66f Actual directory of #include files
int		trulvl;			// w_a683
char	      * inp;			// w_a685


/*********************************************************************
  Prototype functions are located in sequence of being in original
  binary image of CPP.COM
 
  ok++ - Full binary compatibility with code in original file;
  ok+  - Code generated during compilation differs slightly,
         but is logically correct;
  ok   - C source code was compiled successfully, but not verified.
 *********************************************************************/
void             sayline(void);			// sub_013dh
void		 dump(void);			// sub_016bh
char 	       * refill(char *);		// sub_01bch
char 	       * cotoken(char *);		// sub_0465h
char 	       * skipbl(char *);		// sub_0a47h
char 	       * unfill(char *);		// sub_0a7bh
char 	       * doincl(char *);		// sub_0c59h
int		 equfrm(char *, char *, char *);// sub_0f30h
int              sub_0f7bh(char *, char *);	// sub_0f7bh
char 	       * dodef(char *);			// sub_10b2h
void		 control(char *);		// sub_16ach
struct symtab  * stsym(char *);			// sub_19cch
struct symtab  * ppsym(char *);			// sub_1a9bh
void		 pperror(char *fmt, ...);	// sub_1ad2h
void		 yyerror(char *fmt, ...);	// sub_1b49h
void		 ppwarn(char *fmt, ...);	// sub_1b67h
struct symtab  * lookup(char *, int);		// sub_1b97h
struct symtab  * slookup(char *, char *, int);	// sub_1d22h
char 	       * subst(char *, struct symtab *);// sub_1df5h
char 	       * trmdir(char *);		// sub_21efh
char 	       * copy(char *);			// sub_2242h
char 	       * strdex(char *, char);		// sub_2272h
int		 main(int argc, char **argav);	// sub_22a6h

int		 yylex(void);			// sub_29f6h
int		 yyparse();			// sub-2c76h
int 		 tobinary(char *, int); 	// sub_2892h

#if CPM
char 	      ** _getargs(char *, char *);	// sub_32bfh
FILE 	       * open1(char *, char *);		// sub_3f61h
#else
FILE           * open(char *, char *);
#endif
int 	         read1(char *, int, unsigned, FILE *);// sub-43a4h

int		 iscomment(char *);		//
void		 newsbf(void);			//
struct symtab  * newsym(void);			//
int		 yywrap(void);			//
int		 vfprintf();			//

/*********************************************************************
 * sayline sub_013dh OK++			 Used in: 
 *********************************************************************/
void sayline(void) {

    if(pflag == 0)
	fprintf(fout, "# %d \"%s\"\n", lineno[ifno], fnames[ifno]);
}

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
 * refill sub_01bch OK			 Used in: 
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
	    // Retrieve hunk of pushed-back macro text
	    op = instack[--mactop];
	    np = pbuf;
	    do { while((*np++ = *op++) != '\0'); }
	    while(endbuf[mactop] > op); pend = np - 1;
	    // Make buffer space avail for 'include' processing
	    if(fretop < MAXFRE) bufstack[fretop++] = instack[mactop];
	    return (p);
        } else { // Get more text from file(s)
	    maclvl = 0;
	    if(((int)(ninbuf = read1(pbuf, 1, BUFSIZ, fin))) > (int)0) {
		pend = pbuf + ninbuf;
		*pend = '\0';
		return(p);
	    }
	    // End of #include file
	    if(ifno == 0) { // end of input
	        if(plvl != 0) {
	            unsigned int n = plvl, tlin = lineno[ifno];
	            char *tfil = fnames[ifno];
	            lineno[ifno] = maclin;
	            fnames[ifno] = macfil;
	            pperror("%s: unterminated macro\tcall", macnam);
	            lineno[ifno] = tlin;
	            fnames[ifno] = tfil;
	            np = p;
	            *np++ = '\n'; // Shut off unterminated quoted string
	            while((--n & 0x8000) == 0) *np++ = ')'; // Supply missing parens
	            pend = np;
	            *np='\0';
	            if(((unsigned)plvl & 0x8000) != 0) plvl = 0;
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
#if 0

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

#endif

#define tmac3(c,bit) if (!xmac3(c,bit,&)) goto nomac
#define xmac3(c,bit,op) ((array_9af3)[c] op (bit))
#define tmac4(c,bit) if (!xmac3(c,bit,&)) goto m40

/*********************************************************************
 * cotoken sub_0465h OK++			 Used in: 
 *********************************************************************/
char * cotoken(register char * p) {
    int  c, i;
    char quoc;

    if(state != BEG) goto prevlf;
    for (;;) {
again:
	while(!isspc(*p++));
	switch (*(inp = p-1)) {
	    case    0:	// goto m0; l0490h;
		{
	            if(eob(--p)) { p = refill(p); goto again; }		// m0:
                    else ++p; // ignore null byte
                }
                break;
	    case  1: case  2: case  3: case  4: case  5:
	    case  6: case  7: case  8: case  9: case 11:
	    case 12: case 13: case 14: case 15: case 16:
	    case 17: case 18: case 19: case 20: case 21:
	    case 22: case 23: case 24: case 25: case 26:
	    case 27: case 28: case 29: case 30: case 31:
	    case 32: case 35: case 36: case 37: case 40:
	    case 41: case 42: case 43: case 44: case 45:
	    case 46: case 58: case 59: case 63: case 64:
	    case 91: case 93: case 94: case 96: case 123:	// goto m7; l04ddh;
		break;

	    case  '|':
	    case  '&':	   // ok goto m8; l04eah;
		for (;;) { // Sloscan only
		    if (*p++ == *inp) break;				// m8:
		    if (eob(--p)) p = refill(p);
		    else break;
		} /* goto m8; */
		break;

	    case '=':
	    case '!':
		for (;;) { // Sloscan only
		    if (*p++ == '=') break;				// m9:
		    if (eob(--p)) p = refill(p);
		    else break;
		} /* goto m9; */
		break;

	    case  '<':
	    case  '>':	   // ok goto m10; l0536h;
		for (;;) { // Sloscan only
		    if (*p++ == '=' || p[-2] == p[-1]) break;		// m10:
		    if (eob(--p)) p = refill(p);
		    else break;
		} /* goto m10; */
		break;

	    case '\\':	// ok goto m111 l057dh;
		for (;;) {
 		    if (*p++ == '\n') {++lineno[ifno]; break;}		// m111:
		    if (eob(--p)) p = refill(p);			// m11:
		    else {++p; break;} 					// m12:
		}
		break;

	    case  '/':	// ok goto m301; l075fh;
		for(;;) {
#ifdef UW
		    if(*p == '/' && eolcom) {	// C++ style comment to end of line
		        p++;
			if(!passcom) {
			    inp = p - 2;
			    dump();
			    ++flslvl;
			}
			for(;;) {
			    while(*p && *p++ != '\n');
			    if(p[-1] == '\n') {
				p--;
				goto endcpluscom;
			    } else if(eob(--p)) {
				if(!passcom) {
				    inp = p;
				    p = refill(p);
				}
				else if((p-inp) >= BUFSIZ) { // Split long comment
				    inp = p; p = refill(p);
				} else p = refill(p);
			    } else ++p; // Ignore null byte
			}
endcpluscom:
			if(!passcom) {outp = inp = p; --flslvl;}
			goto newline;
			break;
		    } else
#endif
		    if(*p++ == '*') {	// Comment K&R
		        if((word_9cb2 != 0) || (!passcom)) {
		            inp = p - 2;				// m31:
		            while(toktyp[*inp-1] == 1) {		// m14:
    			        if(inp != outp) {inp--; continue;}
			    }
		            dump(); ++flslvl;				// m15:
		        }
			for (;;) {
		            while (!iscom(*p++));			// m16:
			    if(p[-1] == '*') for (;;) {
			        if(*p++ == '/') goto endcom;		// m17:
				if(eob(--p)) {
				    if((word_9cb2 != 0) || (passcom == 0)) {
			                inp = p;			// m18:
					p = refill(p); 			// m20:
			            } else if((p - inp) >= BUFSIZ) {	// split long comment
					inp = p;			// last char written is '*'
					p = refill(p);			// terminate first part
					cputc('/', fout);		// and fake start of 2nd
					outp = inp = p -= 3;
					*p++ = '/';
					*p++ = '*';
					*p++ = '*';
			            } else {
			                p = refill(p); 			// m19:
				    }
				} else {
				    break;
			        }
			    } else if(p[-1] == '\n') {			// m21:
				++lineno[ifno];
				if((word_9cb2 != 0) || (!passcom))
				    fputc('\n', fout);			// m22:
			    } else if(eob(--p)) {			// m23:
				if((word_9cb2 != 0) || (!passcom)) {
				    inp = p;				// m24:
				    p = refill(p); 			// m25:
				} else if((p - inp) >= BUFSIZ) { 	// m26:
				    // Split long comment
				    inp = p;
				    p = refill(p);
				    cputc('*', fout);
				    cputc('/', fout);
				    outp = inp = p -= 2;
				    *p++ = '/';
				    *p++ = '*'; 
			        } else {
			            p = refill(p);			// m25:
			        }
			    } else {
			        ++p;	// Ignore null byte		   m27:
			    }
			} // goto m16;
endcom:
		        if((word_9cb2 != 0) || (!passcom)) {		// m28:
			    outp = inp = p; --flslvl; goto again;	// m29:
			}
		        break;
		    }
		    if(eob(--p)) p = refill(p);				// m30:
		    else break;
		}
		break;

	    case  '"':
	    case  '\'':	// ok goto m311; l0782h;
		quoc = p[-1];						// m311:
		for (;;) {
		    while (!isquo(*p++));				// m32:
		    if (p[-1] == quoc) break;
		    /* Bare \n terminates quotation */
		    if (p[-1] == '\n') { --p; break; } 
		    if (p[-1] == '\\') {				// m33:
		        for (;;) {
		            /* Escaped \n ignored */
		            if (*p++ == '\n') {++lineno[ifno]; break;}	// m34:
		            if (eob(--p)) p = refill(p);		// m35:
		            else {++p; break;}
		        } /* goto m34; */
		    } else if (eob(--p)) p = refill(p);			// m37:
		    else ++p; // It was a different quote character	   m36:
		} // goto m32;
	        break;

	    case '\n':	// goto m371; l080ch;
		{
		    ++lineno[ifno]; if (isslo) {state = LF; return (p);}// m311:
prevlf:
		    state = BEG;					// m1:
		    for (;;) {
			if (*p++ == '#') return (p);			// m2:
			if (eob(inp = --p)) p = refill(p);
			else goto again;
		    }
		}

	    case '0': case '1': case '2': case '3': case  '4':
	    case '5': case '6': case '7': case '8': case  '9': 	// ok goto m39; l0852h;
 		for(;;) {
		    while(isnum(*p++));					// m39:
		    if(eob(--p)) p = refill(p);
		    else break;
      		} // goto m39;
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
	    case 'z':	// ok goto m391; l0880h;

		if(flslvl) goto nomac;					// m391:
		for(;;) {
		    c = p[-1];			       			// m41:
		    if(bittst(array_9af3[c], 0) == 0) goto nomac;

		    i = *p++; if (!isid(i)) goto endid;
		    if(bittst(array_9af3[i], 1) == 0) goto nomac;

		    c = *p++; if (!isid(c)) goto endid;
		    if(bittst(array_9af3[c], 2) == 0) goto nomac;

		    i = *p++; if (!isid(i)) goto endid;
		    if(bittst(array_9af3[i], 3) == 0) goto nomac;

		    c = *p++; if (!isid(c)) goto endid;
		    if(bittst(array_9af3[c], 4) == 0) goto nomac;

		    i = *p++; if (!isid(i)) goto endid;
		    if(bittst(array_9af3[i], 5) == 0) goto nomac;

		    c = *p++; if (!isid(c)) goto endid;
		    if(bittst(array_9af3[c], 6) == 0) goto nomac;

		    i = *p++; if (!isid(i)) goto endid;
		    if(bittst(array_9af3[i], 7) == 0) goto nomac;

		    while (isid(*p++));					// m40:
		    if (eob(--p)) {refill(p); p = inp + 1; continue;}
		    goto lokid;

endid:		    if (eob(--p)) {refill(p); p = inp + 1; continue;}

lokid:		    slookup(inp, p, 0); if(newp) {p = newp; goto again;}
		    else break;

nomac:		    while (isid(*p++));					// m43:
		    if (eob(--p)) {p = refill(p); goto nomac;}
		    else break;
		}
		break;

	} // End of switch
	if(isslo) return p; // goto m3;					    m7:
    } // End of infinite loop
}

/****************************************************************
 * skipbl sub-0a47h OK++ Get next non-blank token	Used in: 
 ****************************************************************/
char * skipbl(register char * p) {

    do { outp = inp = p; p = cotoken(p); }
    while (toktyp[*inp] == BLANK); 
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
	p = inp = pend; dump(); // Begin flushing pushback
	while(inctop[ifno] < mactop) {
	    p = refill(p); p = inp = pend; dump();
	}
    }
    if(0 < fretop) np = bufstack[--fretop];
    else {
	np = savch; savch += BUFSIZ;
	if(savch >= (char *)(sbf + SBSIZE)) {
	    pperror("no space"); exit(exfail);
	}
	*savch++ = '\0';  // sbf + SBSIZE = 0x9605
    }
    instack[mactop] = np; op = pend - BUFSIZ;
    if(op < p) op = p;
    for(;;) { while(*np++ = *op++);
    if(eob(op)) break;} 	// out with old
    endbuf[mactop++] = np;	// Mark end of saved text
    np = pbuf + BUFSIZ;
    op = pend - BUFSIZ;
    pend = np;
    if(op < p) op = p;
    while(outp < op) *--np = *--op; // Slide over new
    if(bob(np)) pperror("token too\tlong");
    d = np - outp;
    outp   += d;
    inp    += d; 
    macdam += d;
    return (d + p);

}

/****************************************************************
 * doincl  sub-0c59h OK+	Used in:	Problem with open
 ****************************************************************/
char * doincl(register char * p) {
    int    filok;	// l1;
    int    inctype;	// l2;
    char * cp;		// l3;
    char ** dirp;	// l4;
    char * nfil;	// l5;
    char   filname[BUFSIZ];

    p = skipbl(p); cp = filname;
    if(*inp++ == '<') {			// Special <> syntax
	inctype = 1;
	for(;;) {
	    outp = inp = p; p = cotoken(p);
	    if(*inp == '\n') { --p; *cp='\0'; break; }
	    if(*inp == '>')  {	    *cp='\0'; break; }
	    while(inp < p) { *cp++ = *inp++; }
         }
     } else if(inp[-1] == '"') {	// Regular "" syntax
	inctype = 0;
	while(inp < p) *cp++ = *inp++;
	if(*--cp == '\"') *cp='\0';
     } else { pperror("bad include syntax", 0); inctype = 2; }
     // Flush current file to \n , then write \n
     ++flslvl;
     do { outp = inp = p; p = cotoken(p); }
     while(*inp != '\n');
     --flslvl;
     inp = p; dump(); if(inctype == 2) return p;
     // Look for included file
     if(ifno >= MAXINC) {
	pperror("Unreasonable include neping", 0);
	return p;
     }
     if(sbf+SBSIZE-BUFSIZ/*0x9405*/ < (nfil = savch)) {
         pperror("no/tspace");
         exit(exfail);
     }
     filok = 0;	
     for(dirp = dirs + inctype; *dirp; ++dirp) {
	 if((filname[0] == '/') || **dirp == '\0')
	     strcpy(nfil, filname); 	// prcpy
         else {
	     strcpy(nfil, *dirp);	// prcpy
             strcat(nfil, filname);	// prcat
         }
         if((fins[ifno+1] = open1(nfil, "r")) != 0) {
	     filok = 1; fin = fins[++ifno]; break;
         }
     }
     if(filok == 0) pperror("Can't find include file %s", filname);
     else {
	lineno[ifno] = 1; fnames[ifno] = cp = nfil; while(*cp++); savch = cp;
	dirnams[ifno] = dirs[0] = trmdir(copy(nfil));
	sayline();
	// Save current contents of buffer
	while (!eob(p)) p = unfill(p);
	inctop[ifno] = mactop;
     }
     return p;
}

/****************************************************************
 * equfrm  sub_0f30h ++OK++		 Used in: 
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
 * sub-0f7bh OK++		 Used in: dodef
 ****************************************************************/
int sub_0f7bh(register char * st, char * p2) {
    int    l1;
    char * l2;
    char * l3;
    char   l4;
    char   l5;
    char * l6;

    goto m2;		

m1: st++;
m2: if(*st == 0) goto m3;
    if(*st == '\t') goto m1;
    if(*st == '\t') goto m1;
m3:
    l2 = 0;						// m3:
    l6 = st;
    while(*l6 != 0) {
       l6 = (((*l6 != ' ') && (*l6 != '\t')) ? l2 : l6 ) + 1;
    }
    if(l2 != 0) {
	l4  = *++l2;
	*l2 = '\0';
    }
    goto m9;

m8: p2++; 
m9: if(*p2 == 0) goto m10;
    if(*p2 == '\t') goto m8;
    if(*p2 == '\t') goto m8;
m10:
    l3 = 0;						// m10:
    l6 = p2;
    while(*l6 != 0) {
	if(*l6 == ' ') goto m12;
	if(*l6 == '\t') goto m12;
	l3 = l6;
m12:	++l6;
    }
    if(l3 != 0) {
	l5 = *++l3;
	*l3 = '\0';
    }
    l1 = strcmp(st, p2);				// m14:
    if(l2 != 0) *l2 = l4;
    if(l3 != 0) *l3 = l5;				// m15:
    return l1;						// m16:
}

/****************************************************************
 * dodef sub-10b2h OK++			 Used in: 
 ****************************************************************/
char * dodef(char * p) {
    char          * psav;	// l1
    char          * cf;		// l2
    char         ** pf;		// l3
    char         ** qf;		// l4
    int		    b;		// l5
    int		    c;		// l6
    int		    params;	// l7
    struct symtab * np;		// l8
    char	    quoc;	// l9
    char	  * oldval;	// l10
    char	  * oldsavch;	// l11
    char	  * formal[MAXFRM];  // Formal[n] is name of nth formal
    char	    formtxt[BUFSIZ]; // Space for formal names
    register char * pin;

    // MAXFRM+BUFSIZ = 287
    //  31   +	256  = 287

    // sbf+SBSIZE-BUFSIZ = 0x9405
    //    + 12000-  256  = 0x9405
    if(sbf+SBSIZE-BUFSIZ < savch) { pperror("too much\tdefining"); return p; }
    oldsavch = savch; // To reclaim space if redefinition
    flslvl++; // Prevent macro expansion during 'define'
    p = skipbl(p); pin = inp;
    if(toktyp[*pin] != IDENT) {
	ppwarn("illegal\tmacro name"); while(*inp != '\n') p = skipbl(p); return(p);
    }
    np = slookup(pin, p, 1);
    if(oldval = np->value) savch = oldsavch;	// Was previously defined
    b = 1; cf = pin;
    while(cf < p) { // Update macbit
	c = *cf++; xmac1(c,b,|=); b = (b + b) & 0xFF;
    }
    params = 0; outp = inp = p; p = cotoken(p); pin = inp;
    if(*pin == '(') { // With parameters; identify the formals
	cf = formtxt; pf = formal;
	for (;;) {
	    p = skipbl(p); pin = inp;
	    if(*pin == '\n') {
		--lineno[ifno]; --p; pperror("%s: missing )", np->name); break;
	    }
	    if (*pin == ')') break;
	    if (*pin == ',') continue;
	    if(toktyp[*pin] != IDENT) {
		c = *p; *p = '\0'; pperror("bad formal: %s", pin); *p = c;
	    } else if(pf >= &formal[MAXFRM]) {
		c = *p; *p = '\0'; pperror("too many formals: %s", pin); *p = c;
	    } else {
	        *pf++ = cf; while(pin < p) *cf++ = *pin++; *cf++ = '\0'; ++params;
	    }
	}
        if(params == 0) --params; /* #define foo() ... */
    } else if(*pin == '\n') {--lineno[ifno]; --p;}
    /* Remember beginning of macro body, so that we can
     * warn if a redefinition is different from old value.
     */
    oldsavch = psav = savch;

    word_9cb2 = 1;

    for(;;) { // Accumulate definition until linefeed
	outp = inp = p; p = cotoken(p); pin = inp; 	 // m19:
	if(*pin == '\\' && pin[1] == '\n') { continue; } // Ignore escaped lf
	if(*pin == '\n') break;
	if(params) { // Mark the appearance of formals in the definiton
	    if(toktyp[*pin] == IDENT) {
		for(qf = pf; --qf >= formal; ) {
		    if(equfrm(*qf, pin, p)) {
			*psav++ = qf - formal + 1;
			*psav++ = WARN;
			pin = p;
			break;
		    }
		}
	    } else if(*pin == '"' || *pin == '\'') { // Inside quotation marks, too
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

    word_9cb2 = 0;

    if((cf = oldval) != NULL) { // Redefinition
	--cf;			// Skip no. of params, which may be zero
	while(*--cf);		// Go back to the beginning
#if CPM
	if(0 != sub_0f7bh(++cf, oldsavch)) { /* Redefinition different from old */
#else
	if(0 != strcmp(++cf, oldsavch)) {
#endif
	    --lineno[ifno];
	    ppwarn("%s redefined", np->name);
	    ++lineno[ifno];
	    np->value = psav - 1;
	} else psav = oldsavch;	// Identical redef.; reclaim space
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
	fasscan();						// m1:
	p = cotoken(p);
	if(*inp == '\n') ++inp;
	dump();							// m2:
	sloscan();
	p = skipbl(p);
	*--inp = SALT;
	outp = inp;
	++flslvl;
	np = slookup(inp, p, 0); 
	--flslvl;
	if(defloc == np) {			// "define"
	    if(flslvl == 0) {
	        p = dodef(p);					// m3:
	        continue;	// goto m1;
	    }
	} else if(incloc == np) { 		// "include"	   m4:
	    if(flslvl == 0) {
	        p = dodef(doincl(p));
	        continue;	// goto m1;
	    }
	} else if(ifnloc == np) {		// "ifndef" 	   m5:
	    ++flslvl; 
	    p  = skipbl(p); 
	    np = slookup(inp, p, 0); 
	    --flslvl;
	    if(flslvl == 0 && np->value == 0) ++trulvl;
	    else ++flslvl;
	} else if(ifdloc == np) { 		// ifdef	   m8:
	    ++flslvl; 
	    p = skipbl(p); 
	    np = slookup(inp, p, 0); 
	    --flslvl;
	    if(flslvl == 0 && np->value != 0) ++trulvl;
	    else ++flslvl;
	} else if(eifloc == np) { 		// "endif"	   m11:
	    if(flslvl) { if(--flslvl == 0) sayline(); }
	    else if(trulvl) --trulvl;
	    else pperror("If-less endif", 0);
	} else if(elsloc == np) { 		// "else"	   m17:
	    if(flslvl) {
		if(--flslvl != 0) ++flslvl;
		else {++trulvl; sayline();}
	    }
	    else if(trulvl) { ++flslvl; --trulvl; }
	    else pperror("If-less else", 0);
	} else if(udfloc == np) { 		// "undef"	    m21:
	    if(flslvl == 0) {
		++flslvl; 
		p = skipbl(p); 
		slookup(inp, p, DROP); 
		--flslvl;
	    }
	} else if(ifloc == np) { 		// "if"		    m22:
	    newp = p;
	    if(flslvl == 0 && yyparse()) ++trulvl; 
	    else ++flslvl;
	    p = newp;
	} else if(lneloc == np) { 		// "line"	    m25:
	    if(flslvl == 0 && pflag == 0) {
		outp = inp = p; 
		*--outp = '#'; 
		while(*inp != '\n') p = cotoken(p);
	    }
	    continue;
	} else if((asmloc == np) || (easmloc == np)) { // "asm" & "endasm"
	    while(*inp != '\n') { 
	        inp = p; 
	        p = cotoken(p); 
	    }
	} else if(*++inp == '\n') outp = inp;
	else pperror("undefined\tcontrol", 0);			// m32:
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
    while (isid(*p++)); // Skip first identifier
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
 * verror	New function
 ****************************************************************/
void verror(char *fmt, va_list args) {

    if(fnames[ifno][0])
	fprintf(stderr, "%s: ", fnames[ifno]);
    fprintf(stderr, "%d: ",lineno[ifno]);

    (void)vfprintf(stderr, fmt, args);
    fputc('\n', stderr);
}

/****************************************************************
 * pperror Function changed from original 
 ****************************************************************/
/* VARARGS1 */
void pperror(char *fmt, ...) {
    va_list args;

    va_start(args, fmt);
    verror(fmt, args);
    va_end(args);

    exfail = 1;
}

/****************************************************************
 * yyerror Function changed from original 
 ****************************************************************/
/* VARARGS1 */
void yyerror(char *fmt, ...) {
    va_list args;

    va_start(args, fmt);
    verror(fmt, args);
    va_end(args);
}

/****************************************************************
 * ppwarn Function changed from original 
 ****************************************************************/
/* VARARGS1 */
void ppwarn(char *fmt, ...) {
    va_list args;
    int fail = exfail;

    va_start(args, fmt);
    verror(fmt, args);
    va_end(args);

    exfail = fail;
}

/****************************************************************
 * lookup sub_1b97h	ERROR !
 ****************************************************************/
struct symtab * lookup(char * namep, int enterf) {
    char	  * snp;	// l1
    int		    c;		// l2
    int		    i;		// l3
    int		    around;	// l4
    struct symtab * sp;		// l5
    register char * np; 

    /*
     * namep had better not be too long (currently, <=NCPS chars)
     */
    np     = namep;
    around = 0;
    i      = (char)cinit;

#if CPM
    while((np < namep+8) && ((c = (char)*np++) != 0))	// m2:
#else
    while(c = (char)*np++)
#endif
	i += i+c;					// m1:

    c  = i;	// c=i for register usage on pdp11	   m3:
    c %= SYMSIZ;
#if CPM
    if(((unsigned)c & 0x8000) != 0)
#else
    if(c < 0)
#endif
	c += SYMSIZ;
    sp = &stab[c];					// m4:

    while(snp = sp->name) {
	np = namep;					// m5:
	while(*snp++ == *np) {				// m6:
	    if(*np++ == '\0') {				// m7:
	        if(enterf == DROP) {
	            sp->name[0] = DROP;
	            sp->value   = 0;
	        }
	    }
	    return (lastsym = sp); /* ERROR ! */
	}
	if(--sp < &stab[0]) {
	    if(around) {
	        pperror("too many defines", 0);
	        exit(exfail);
	    } else {
	        ++around;				// m9:
	        sp = &stab[SYMSIZ-1];
	    }
	}
    }
#if CPM
    if(0 < enterf)
#else
    if(enterf == 1)
#endif
	sp->name = namep;
    return (lastsym = sp);				// m8:
}

/****************************************************************
 * slookup sub_1d22h OK++ 		 Used in: 
 ****************************************************************/
struct symtab * slookup(register char * p1, char * p2, int enterf) {
    char * p3;
    char   c2, c3;
    struct symtab *np;

    c2 = *p2; *p2='\0';	// Mark end of token
    if(NCPS < p2-p1) p3 = p1 + NCPS; else p3 = p2; // NCPS=0x1f
    c3 = *p3; *p3='\0';		// Truncate to NCPS chars or less
    if(enterf == 1) p1 = copy(p1);
    np = lookup(p1, enterf); *p3 = c3; *p2 = c2;
    if((np->value != 0) && (flslvl == 0)) newp = subst(p2, np);
    else newp = 0;
    return np;
}

/****************************************************************
 * sub-1df5h subst OK 		 Used in: 
 ****************************************************************/
    char match[] = "%s: argument mismatch";

//    Not finished. Problems with dimensions of arrays. One branch
//    instruction is not generated at the end of function.

char * subst(register char * p, struct symtab * sp) {
    char  * ca;			// l1
    char  * vp;			// l2
    int     params;		// l3
    char ** pa;			// l4
    char  * actual[MAXFRM]; 	// Actual[n] is text of nth actual
//  int     nlines;	       	   l5
//  char    actused[MAXFRM];   	   For newline processing in actuals
    char    acttxt[BUFSIZ];  	// Space for actuals

//  0xfdba; = -582
//  0xffba; =  -70
//  0xfff8; =   -8

    if((vp = sp->value) == 0) return p;
    if(macdam >= (p - macforw)) {
	if(SYMSIZ < ++maclvl  && !rflag) {
	    pperror("%s: macro recursion", sp->name); return (p);
	}
    } else maclvl = 0;		// Level decreased
    macforw = p; macdam = 0;	// New target for decrease in level
    macnam  = sp->name;
    dump();
    if(sp == ulnloc) {		// "__LINE__"
	vp = acttxt; *vp++ = '\0';
	sprintf(vp, "%d", lineno[ifno]); while(*vp++);
    } else if(sp == uflloc) {	// "__FILE__"
	vp = acttxt; *vp++ = '\0';
	sprintf(vp, "\"%s\"", fnames[ifno]); while(*vp++);
    }
    if((params = *--vp & 0xFF) != 0) {
	ca = acttxt;
	pa = actual;
	if(params == 0xFF) params = 1; // #define foo() ...
	sloscan(); ++flslvl; // No expansion during search for actuals
	plvl = -1;
	do { p = skipbl(p); } while(*inp == '\n'); // Skip \n too m9:
	if(*inp == '(') { // goto m19;
	    maclin = lineno[ifno]; macfil = fnames[ifno];
#if CPM
	    plvl = 1;
m18:        while(plvl != 0) {					// m18:/
#else
	    for(plvl = 1; plvl != 0; ) {
#endif
                *ca++ = '\0'; 					// m10:
                for(;;) {
                    outp = inp = p; p = cotoken(p);		// m11:
                    if(*inp == '(') ++plvl; // goto m12;
                    if(*inp == ')' && --plvl == 0) { // goto m14;
                         --params;
#ifdef CPM
m13:                    if(pa < actual /*ARR*/) break; // goto m17;
                        ppwarn(match, sp->name);
                        goto m18;
#else
			break;
#endif
                    }
                    if(plvl == 1 && *inp == ',') {		// m14:
                        --params;
#ifdef CPM
                        goto m13;
#else
			break;
#endif
                    }
                    while(inp < p) *ca++ = *inp++;		// m16:
                    if(&acttxt[BUFSIZ] < ca) pperror("%s: actuals too long", sp->name);
                } 						// goto m11;
#ifndef CPM
                if (pa >= &actual[MAXFRM]) ppwarn(match, sp->name);
                else { actused[pa - actual] = 0; *pa++ = ca; }
#else
                *pa++ = ca;					// m17:
#endif
	    } 							// goto m18;
#ifndef CPM
	    nlines = lineno[ifno] - maclin;
 	    lineno[ifno] = maclin;   // Don't count newlines here
#endif
	} 							// End if

        if(params != 0)				// ----+ Ok        m19: */
            ppwarn(match, sp->name);		//     V 

	// Null string for missing actuals
	while(((unsigned)--params & 0x8000) == 0) *pa++ = "" + 1;
	--flslvl; fasscan();
    }
    for(;;) { // Push definition onto front of input stack
	while(!iswarn(*--vp)) {					// m24:
            if(bob(p)) { outp = inp = p; p = unfill(p); }
            *--p = *vp;						// m23:
        }
	if(*vp == warnc) {	// Insert actual param
            ca = actual[*--vp-1];
            while(*--ca) {
		if(bob(p)) { outp = inp = p; p = unfill(p); }	// m25:
	        // Actuals with newlines confuse line numbering
#ifndef CPM
	        if(*ca == '\n' && actused[*vp-1]) 
	            if (*(ca-1) == '\\') ca--;
	            else *--p = ' ';
	        else { *--p = *ca; if(*ca == '\n') nlines--; }
#else
	        *--p = *ca;
#endif
            }
#ifndef CPM
	    actused[*vp-1] = 1;
	    } else {
		if(nlines > 0 )
		    while(nlines-- > 0)
			*--p = '\n';
		break;
	    }
#endif
	}
	outp = inp = p;						// m28:
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
 * sub-2272h strdex	OK+ 		 Used in: 
 * Original binary contains unused instructions:
 *	ld	hl,1
 *	ret
 ****************************************************************/
char * strdex(char *s,char c) {

    while (*s) if (*s++ == c) return(--s);
    return (0);
}

/****************************************************************
 * main	    Code recovery is incomplete. It compiles with errors.
 ****************************************************************/
#if 0
int main(int argc, char ** argv) {
    int    i;
    int    c;
    char * tf;
    char **cp2;
    register char * p;

    if(argc == 1) {			// Code added by Hi-Tech
	argv = _getargs(0, "cpp");	//
	argc = _argc_;			//
    }

    p = "_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    i = 0;
    while((c = *p++) != 0) {
	fastab[c] |= IB|NB|SB; toktyp[c] = IDENT;
    }
    p = "0123456789.";
    while(c = *p++) {
	fastab[c] |= NB|SB; toktyp[c] = NUMBR;
    }
    p = "\n\"\'/\\";
    while(c = *p++) fastab[c] |= SB;

    p = "\n\"\'\\";
    while(c = *p++) fastab[c] |= QB;
    p = "*\n";
    while(c = *p++ != 0) fastab[c] |= CB;
    fastab[warnc] |= WB;
    fastab['\0'] |= CB|QB|SB|WB;

    i = 16; /* ALFSIZ */			// Code changed by Hi-Tech
    while(((unsigned)--i & 0x8000) == 0 )	//
	array_6625[i] = punspc[i] | 2;		//

    p = " \t\v\f\r";	// Note no \n;	\v not legal for vertical tab?
    while(c = *p++) toktyp[c] = BLANK;

    for(i = 1; i < argc; i++) {
        switch(argv[i][0]) {
	  case '-':
m16:	    switch(argv[i][1]) {					// m16:
	      case  0:
	      case 'E':
	        continue;

	      case 'C':
m21:	        passcom++;						// m21:
	        continue;

	      case 'D':
m22:	        if(dirs < predef) {					// m22:
m23:	            pperror("too many -D options, ignoring %s", &argv[i][0]); 	// m23:
	            continue;
	        }
m24:	        if(argv[i][2]) *predef++ = argv[i][2];			// m24:
	        continue;

	      case 'I':
m29:	        if(8 < nd) {						// m29:
	            pperror("excessive -I\l1ile (%s) ignored", &argv[i][0]);
	            break; // goto m23;
	        }
m30:	        dirs[nd++] = argv[i][2];				// m30:
	        continue;

	      case 'P':
m19:	        pflag++;						// m19:
	        continue;

	      case 'R':
m20:	        rflag++;						// m20:
	        continue;

	      case 'U':
m27:	        if(ifno > prund) {					// m27:
	            pperror("too many -U options, ignoring %s", &argv[i][0]);
	            continue; // goto m23;
	        }
m28:	        *prund++ = argv[i][2];					// m28:
	        continue;  // goto m25;

	      default:	pperror("unknown flag %s", &argv[i][0]);
	      continue
	    }
	  default:
m32:	    if(i < argc) {						// m32:
	        fin = freopen(argv[i][0], "r", stdin);
	        if(fin == 0) {
	            pperror("No source file\t%s", argv[i][0]);
	            exit(8);
	        }
	        fnames[ifno] = copy(argv[i][0]);			// m33:
	        dirs[0] = dirnams[ifno] = trmdir(argv[i][0]);
	        if(++i < argc) {				// Code changed by Hi-Tech
	            fout = freopen(&argv[i][0], "w", stdout);
	            if(fout == 0) {
	                pperror("Can't create %s", &argv[i][0]);
	                exit(8);
	            }
	        }
	    }
	}
    }
m34: fins[ifno] = fin;							// m34:
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
     asmloc     = ppsym("asm");		// Code added by Hi-Tech
     easmloc    = ppsym("endasm");	//

     //      267 			       --i >= 0
     for(i = sizeof(macbit)/sizeof(macbit[0]); (unsigned)--i & 0x8000) == 0; ) // m36: */
         macbit[i] = 0;							// m35: */

     uclloc = stsym("z80");		// Code added by Hi-Tech
     ulnloc = stsym("__LINE__");
     uflloc = stsym("__FILE__");

     tf           = fnames[ifno];
     fnames[ifno] = "command line";
     lineno[ifno] = 1;
     cp2          = preps;
m38: while(cp2 < predef) stsym(*cp2++);					// m38:
     cp2 = punspc;		// 0xA5FE;
m41: while(cp2 < prund) {						// m41:
m39:	if(strdex(*cp2, '=') != 0) *p++ = '\0';				// m39:
m40:	lookup(*cp2++, DROP);						// m40:
     }
     fnames[ifno] = tf;
     pbeg = buffer + NCPS;	// 0x9624;
     pbuf = pbeg + BUFSIZ;
     pend = pbuf + BUFSIZ;
     flslvl = trulvl = 0;
     lineno[0] = 1;
     sayline();
     outp = inp = pend;
     control(outp);

     if(fclose(stdout) == 0) {					// Code added by Hi-Tech
	fprini(stderr ,"CPP: Error closing output file\n");	//
	return 1;						//
     }								//

m42: return {exfail};							// m42:
}
#endif
/*
 *	Code added by Hi-Tech
 */
/****************************************************************
 * sub-3f61h OK++		 Used in:
 ****************************************************************/
FILE * open1(char * name, char * mode) {
    register FILE * stream;

    stream = stdin;
    while(stream != stdin+8) {
	if((stream->_flag & 3) == 0) break;
	++stream;
    }
    if(stream == stdin+8) return 0; 
    return freopen(name, mode, stream);
}

/****************************************************************
 * read1 sub-43a4h OK+	 	Used in:
 ****************************************************************/
int read1(char * buf, int p2, unsigned count, register FILE * st) {
    char   * ptr_buf;
    unsigned int tot_count;
    unsigned int next_char;
			
    tot_count = p2 * count;
    ptr_buf = buf;

    while(tot_count != 0) {
	if((next_char = fgetc(st)) == EOF) break;
	--tot_count;
	*ptr_buf++ = (char)next_char;
    }
    return count - (tot_count + p2 - 1)/p2;
}

