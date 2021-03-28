; z80dasm 1.1.3
; command line: ./z80dasm -a -l -S cpp.sym -s cpp.sym1 -o cpp.mac -b cpp.blocks.txt CPP.COM

	org	00100h
BDOS:	equ	0x0005

__argc_:equ	0xAB0C
memtop: equ	0xAB10
__Hbss: equ	0xAB12


;
code_0100_start:
	ld	hl,(00006h)	;0100
	ld	sp,hl		;0103
	ld	de,__Lbss	;0104
	or	a		;0107
	ld	hl,__Hbss	;0108
	sbc	hl,de		;010b
	ld	c,l		;010d
	ld	b,h		;010e
	dec	bc		;010f
	ld	l,e		;0110
	ld	h,d		;0111
	inc	de		;0112
	ld	(hl),0		;0113
	ldir			;0115
	ld	hl,data		;0117
	push	hl		;011a
	ld	hl,80h		;011b
	ld	c,(hl)		;011e
	inc	hl		;011f
	ld	b,0		;0120
	add	hl,bc		;0122
	ld	(hl),0		;0123
	ld	hl,081h		;0125
	push	hl		;0128
	call	startup		;0129
	pop	bc		;012c
	pop	bc		;012d
	push	hl		;012e
	ld	hl,(__argc_)	;012f
	push	hl		;0132
	call	_main		;0133
	push	hl		;0136
	call	exit		;0137
	jp	0		;013a

; =============== F U N C T I O N ===========================================
;							; FILE *word_58c3;
;
sub_013dh:						; void sub_013dh(void) {
	ld	hl,(word_9c98)	;013d	; _pflag	;
	ld	a,l		;0140			;
	or	h		;0141			;
	ret	nz		;0142			; if(word_9c98 != 0) return;

	ld	de,array_9b7e	;0143	; _fnames	;
	ld	hl,(word_a626)	;0146	; _ifno		;
	add	hl,hl		;0149			;
	add	hl,de		;014a			;
	ld	c,(hl)		;014b			;
	inc	hl		;014c			;
	ld	b,(hl)		;014d			;
	push	bc	;\(4)	;014e			;
	ld	de,array_9a43	;014f	; _lineno	;
	ld	hl,(word_a626)	;0152	; _ifno		;
	add	hl,hl		;0155			;
	add	hl,de		;0156			;
	ld	c,(hl)		;0157			;
	inc	hl		;0158			;
	ld	b,(hl)		;0159			;
	push	bc	;\(3)	;015a			;
	ld	hl,l59ddh	;015b			;
	push	hl	;\(2)	;015e			;
	ld	hl,(word_58c3)	;015f	; _fout		;
	push	hl	;\(1)	;0162			;
	call	_fprintf	;0163	; _fprintf	; fprintf(word_58c3, "# %d \"%s\"\n", array_9a43[word_a626], array_9b7e[word_a626]);
	pop	bc		;0166			;
	pop	bc		;0167			;
	pop	bc		;0168			;
	pop	bc		;0169			;
	ret			;016a			; return;
							; }
; =============== F U N C T I O N =======================================
;							;
;	dump						; char *word_a66b, *word_a685;
;
sub_016bh:						; void sub_016bh(void) {
	call	csv		;016b			; FILE *l1;
	push	hl		;016e			; register char *st;
	ld	de,(word_a685)	;016f	; _inp)		;
	ld	iy,(word_a66b)	;0173	; _outp		;
	push	iy		;0177			;
	pop	hl		;0179			;
	or	a		;017a			;
	sbc	hl,de		;017b			;
	jp	z,cret		;017d			; if((st = word_a66b) != word_a685) return;

	ld	hl,(word_9cae)	;0180	; _flslvl	;
	ld	a,l		;0183			;
	or	h		;0184			;
	jp	nz,cret		;0185			; if(word_9cae != 0) return;

	ld	hl,(word_58c3)	;0188	; _fout		;
	ld	(ix-2),l	;018b			;
	ld	(ix-1),h	;018e			; l1 = word_58c3;
	jr	l01a9h		;0191			; goto m2;
l0193h:							; m1:
	ld	l,(ix-2)	;0193			;
	ld	h,(ix-1)	;0196			;
	push	hl	;\(2)	;0199			;
	ld	a,(iy+0)	;019a			;
	inc	iy		;019d			;
	ld	l,a		;019f			;
	rla			;01a0			;
	sbc	a,a		;01a1			;
	ld	h,a		;01a2			;
	push	hl	;\(1)	;01a3			;
	call	_fputc		;01a4	; _fputc	; fputc(*st, l1);
	pop	bc		;01a7			;
	pop	bc		;01a8			;
l01a9h:							; m2:
	ld	de,(word_a685)	;01a9	; _inp		;
	push	iy		;01ad			;
	pop	hl		;01af			;
	call	wrelop		;01b0			;
	jr	c,l0193h	;01b3			; if(st < word_a685) goto m1;

	ld	(word_a66b),iy	;01b5	; _outp		; word_a66b = st;
	jp	cret		;01b9			; return;
							; }
; =============== F U N C T I O N =======================================
;							; char * sub_01bch(register char *st) {
;							; char * l1;
_refill:
sub_01bch:						; char * l2;
	call	ncsv		;01bc
	defw	0fff4h	;-12	;01bf

	ld	l,(ix+6)	;01c1			;
	ld	h,(ix+7)	;01c4			;
	push	hl		;01c7			;
	pop	iy		;01c8			;

	call	sub_016bh	;01ca	; _dump		; sub_016bh();
	ld	de,(word_a685)	;01cd			;
	push	iy		;01d1			;
	pop	hl		;01d3			;
	
	or	a		;01d4			;
	sbc	hl,de		;01d5			;
	ex	de,hl		;01d7			;
	ld	hl,(word_9c96)	;01d8	; _pbuf		;
	or	a		;01db			;
	sbc	hl,de		;01dc			;
	ld	(ix-2),l	;01de			;
	ld	(ix-1),h ;l1	;01e1			; l1 = word_9c96 - (st - word_a685);
    
	ld	hl,(word_a685)	;01e4	; _inp		;
	ld	(ix-4),l	;01e7			;
	ld	(ix-3),h ;l2	;01ea			; l2 = word_a685;
    
	ld	e,(ix-2)	;01ed			;
	ld	d,(ix-1) ;l1	;01f0			;
	inc	de		;01f3			;
	ld	hl,(word_a665)	;01f4	; _pbeg		;
	call	wrelop		;01f7			;
	jr	c,l0218h	;01fa			; if(word_a665 < l1+1) goto m2;

	ld	hl,l59e8h	;01fc "token too long"	;
	push	hl		;01ff			;
	call	sub_1ad2h	;0200	; _pperror	; sub_1ad2h("token too long");
	pop	bc		;0203
    
	ld	hl,(word_a665)	;0204	; _pbeg		;
	ld	(ix-2),l	;0207			;
	ld	(ix-1),h ;l1	;020a			; l1 = word_a665;
    
	ld	de,(word_a685)	;020d	; _inp		;
	ld	hl,512		;0211			;
	add	hl,de		;0214			;
	push	hl		;0215			;
	pop	iy		;0216			; st = word_a685 + 512;
l0218h:							; m2:
	ld	de,(word_a685)	;0218	; _inp		;
	ld	l,(ix-2)	;021c			;
	ld	h,(ix-1) ;l1	;021f			;
	or	a		;0222			;
	sbc	hl,de		;0223			;
	ex	de,hl		;0225			;
	ld	hl,(word_a66d)	;0226	; _macdam	;
	add	hl,de		;0229			;
	ld	(word_a66d),hl	;022a	; _macdam	; word_a66d += (l1 - word_a685);
    
	ld	l,(ix-2)	;022d			;
	ld	h,(ix-1)	;0230			;
	ld	(word_a685),hl	;0233	; _inp		;
	ld	(word_a66b),hl	;0236	; _outp		; word_a66b = (word_a685 = l1);
	jr	l0258h		;0239			; goto m4;

l023bh:							; m3:
	ld	l,(ix-4)	;023b			;
	ld	h,(ix-3) ;l2	;023e			;
	ld	a,(hl)		;0241			;
	inc	hl		;0242			;
	ld	(ix-4),l	;0243			;
	ld	(ix-3),h ;l2	;0246			;
	ld	l,(ix-2)	;0249			;
	ld	h,(ix-1) ;l1	;024c			;
	inc	hl		;024f			;
	ld	(ix-2),l	;0250			;
	ld	(ix-1),h ;l1	;0253			;
	dec	hl		;0256
	ld	(hl),a		;0257			; *(l1++) = *(l2++);

l0258h:							; m4:
	push	iy		;0258			;
	pop	de		;025a			;
	ld	l,(ix-4)	;025b			;
	ld	h,(ix-3) ;l2	;025e			;
	call	wrelop		;0261			;
	jr	c,l023bh	;0264			; if(l2 < st) goto m3;
    
	ld	l,(ix-2)	;0266			;
	ld	h,(ix-1) ;l1	;0269			;
	push	hl		;026c			;
	pop	iy		;026d			; st = l1;

l026fh:							; m5:
	ld	de,array_9e18	;026f	; _inctop	;
	ld	hl,(word_a626)	;0272	; _ifno		;
	add	hl,hl		;0275			;
	add	hl,de		;0276			;
	ld	a,(hl)		;0277			;
	inc	hl		;0278			;
	ld	h,(hl)		;0279			;
	ld	l,a		;027a			;
	ld	de,(word_a667)	;027b	; _mactop	;
	call	wrelop		;027f			;
	jp	p,l0310h	;0282			; if(array_9e18[word_a626] >= word_a667) goto m8;

	ld	de,array_9a57	;0285	; _instack	;
	ld	hl,(word_a667)	;0288	; _mactop	;
	dec	hl		;028b			;
	ld	(word_a667),hl	;028c			;
	add	hl,hl		;028f			;
	add	hl,de		;0290			;
	ld	c,(hl)		;0291			;
	inc	hl		;0292			;
	ld	b,(hl)		;0293			;
	ld	(ix-4),c	;0294			;
	ld	(ix-3),b ;l2	;0297			; l2 = array_9a57[++word_a667];

	ld	hl,(word_9c96)	;029a	; _pbuf		;
	ld	(ix-2),l	;029d			;
	ld	(ix-1),h ;l1	;02a0			; l1 = word_9c96;
l02a3h:							; m6:
	ld	l,(ix-4)	;02a3			;
	ld	h,(ix-3) ;l2	;02a6			;
	ld	a,(hl)		;02a9			;
	inc	hl		;02aa			;
	ld	(ix-4),l	;02ab			;
	ld	(ix-3),h ;l2	;02ae			;
	ld	l,(ix-2)	;02b1			;
	ld	h,(ix-1) ;l1	;02b4			;
	inc	hl		;02b7			;
	ld	(ix-2),l	;02b8			;
	ld	(ix-1),h ;l1	;02bb			;
	dec	hl		;02be			;
	ld	(hl),a		;02bf			;
	or	a		;02c0			;
	jr	nz,l02a3h	;02c1			; if( (*(l1++)=*(l2++)) != 0) goto m6;

	ld	de,array_a645	;02c3	; _endbuf	;
	ld	hl,(word_a667)	;02c6	; _mactop	;
	add	hl,hl		;02c9			;
	add	hl,de		;02ca			;
	ld	e,(hl)		;02cb			;
	inc	hl		;02cc			;
	ld	d,(hl)		;02cd			;
	ld	l,(ix-4)	;02ce			;
	ld	h,(ix-3) ;l2	;02d1			;
	call	wrelop		;02d4			;
	jr	c,l02a3h	;02d7			; if(array_a645[word_a667] < l2) goto m6;

	ld	l,(ix-2)	;02d9			;
	ld	h,(ix-1) ;l1	;02dc			;
	dec	hl		;02df			;
	ld	(word_9b92),hl	;02e0	; _pend		; word_9b92 = l1 - 1;

	ld	de,0000eh	;02e3	; 14		;
	ld	hl,(word_9cbc)	;02e6	; _fretop		;
	call	wrelop		;02e9			;
	jp	p,l030ah	;02ec			; if(word_9cbc >= 0xE)  goto m7;

	ld	de,array_9a57	;02ef	; _instack	;
	ld	hl,(word_a667)	;02f2	; _mactop	;
	add	hl,hl		;02f5			;
	add	hl,de		;02f6			;
	ld	c,(hl)		;02f7			;
	inc	hl		;02f8			;
	ld	b,(hl)		;02f9			;
	ld	de,array_a629	;02fa	; _bufstack	;
	ld	hl,(word_9cbc)	;02fd	; _fretop	;
	inc	hl		;0300			;
	ld	(word_9cbc),hl	;0301	; _fretop	;
	dec	hl		;0304			;
	add	hl,hl		;0305			;
	add	hl,de		;0306			;
	ld	(hl),c		;0307			;
	inc	hl		;0308			;
	ld	(hl),b		;0309			; array_a629[word_9cbc++] = array_9a57[word_a667];
l030ah:							; m7:
	push	iy		;030a			;
	pop	hl		;030c			;
	jp	cret		;030d			; return st;
l0310h:							; m8:
	ld	hl,0		;0310
	ld	(word_9e16),hl	;0313	; _maclvl	; word_9e16 = 0;

	ld	hl,(word_58c1)	;0316	; _fin		;
	push	hl		;0319			;
	ld	hl,512		;031a			;
	push	hl		;031d			;
	ld	hl,1		;031e			;
	push	hl		;0321			;
	ld	hl,(word_9c96)	;0322	; _pbuf		;
	push	hl		;0325			;
	call	sub_43a4h	;0326	; _read1	;
	pop	bc		;0329			;
	pop	bc		;032a			;
	pop	bc		;032b			;
	pop	bc		;032c			;
	ex	de,hl		;032d			;
	ld	(ix-6),e	;032e			;
	ld	(ix-5),d ;l3	;0331			;
	ld	hl,0		;0334			;
	call	wrelop		;0337			;
	jp	p,l034fh	;033a			; if((l3 = sub_43a4h(word_9c96, 1, 512, word_58c1)) >= 0)
								goto m9;

	ld	de,(word_9c96)	;033d	; _pbuf		;
	ld	l,(ix-6)	;0341			;
	ld	h,(ix-5) ;l3	;0344			;
	add	hl,de		;0347			;
	ld	(word_9b92),hl	;0348	; _pend		;
	ld	(hl),0		;034b			; *(word_9b92 = word_9c96 + l3);
	jr	l030ah		;034d			; goto m7;
l034fh:							; m9:
	ld	hl,(word_a626)	;034f	; _ifno		;
	ld	a,l		;0352			;
	or	h		;0353			;
	jp	nz,l0435h	;0354			; if(word_a626 != 0) goto m13;

	ld	hl,(word_9e12)	;0357	; _plvl		;
	ld	a,l		;035a			;
	or	h		;035b			;
	jp	z,l0426h	;035c			; if(word_9e12 == 0) goto m12;

	ld	(ix-8),l	;035f			;
	ld	(ix-7),h ;l4	;0362			; l4 = word_9e12;
	ld	de,array_9a43	;0365	; _lineno	;
	ld	hl,(word_a626)	;0368	; _ifno		;
	add	hl,hl		;036b			;
	add	hl,de		;036c			;
	ld	c,(hl)		;036d			;
	inc	hl		;036e			;
	ld	b,(hl)		;036f			;
	ld	(ix-10),c	;0370			;
	ld	(ix-9),b ;l5	;0373			; l5 = array_9a43[word_a626];

	ld	de,array_9b7e	;0376	; _fnames	;
	ld	hl,(word_a626)	;0379	; _ifno		;
	add	hl,hl		;037c			;
	add	hl,de		;037d			;
	ld	c,(hl)		;037e			;
	inc	hl		;037f			;
	ld	b,(hl)		;0380			;
	ld	(ix-12),c	;0381			;
	ld	(ix-11),b ;l6	;0384			; l6 =array_9b7e[word_a626];

	ld	de,array_9a43	;0387	; _lineno	;
	ld	hl,(word_a626)	;038a	; _ifno		;
	add	hl,hl		;038d			;
	add	hl,de		;038e			;
	ld	de,(word_9cac)	;038f	; _maclin	;
	ld	(hl),e		;0393			;
	inc	hl		;0394			;
	ld	(hl),d		;0395			; array_9a43[word_a626] = word_9cac;

	ld	de,array_9b7e	;0396	; _fnames	;
	ld	hl,(word_a626)	;0399	; _ifno		;
	add	hl,hl		;039c			;
	add	hl,de		;039d			;
	ld	de,(word_9c94)	;039e	; _macfil	;
	ld	(hl),e		;03a2			;
	inc	hl		;03a3			;
	ld	(hl),d		;03a4			; array_9b7e[word_a626] = word_9c94;

	ld	hl,(word_9ca8)	;03a5	; _macnam	;
	push	hl		;03a8			;
	ld	hl,l59f7h	;03a9			;
	push	hl		;03ac			;
	call	sub_1ad2h	;03ad	; _pperror	; sub_1ad2h("%s: unterminated macro\tcall", word_9ca8);
	pop	bc		;03b0			;
	pop	bc		;03b1			;

	ld	de,array_9a43	;03b2	; _lineno	;
	ld	hl,(word_a626)	;03b5	; _ifno		;
	add	hl,hl		;03b8			;
	add	hl,de		;03b9			;
	ld	e,(ix-10)	;03ba			;
	ld	d,(ix-9) ;l5	;03bd			;
	ld	(hl),e		;03c0			;
	inc	hl		;03c1			;
	ld	(hl),d		;03c2			; array_9a43[word_a626] = l5;

	ld	de,array_9b7e	;03c3	; _fnames	;
	ld	hl,(word_a626)	;03c6	; _ifno		;
	add	hl,hl		;03c9			;
	add	hl,de		;03ca			;
	ld	e,(ix-12)	;03cb			;
	ld	d,(ix-11) ;l6	;03ce			;
	ld	(hl),e		;03d1			;
	inc	hl		;03d2			;
	ld	(hl),d		;03d3			; array_9b7e[word_a626] = l6;

	push	iy		;03d4			;
	pop	hl		;03d6			;
	ld	(ix-2),l	;03d7			;
	ld	(ix-1),h ;l1	;03da			; l1 = st;
	inc	hl		;03dd			;
	ld	(ix-2),l	;03de			;
	ld	(ix-1),h ;l1	;03e1			;
	dec	hl		;03e4			;
	ld	(hl),00ah	;03e5			; *(l1++) = 0xA;
	jr	l03f3h		;03e7			; goto m11;
l03e9h:							; m10:
	inc	hl		;03e9			;
	ld	(ix-2),l	;03ea			;
	ld	(ix-1),h ;l1	;03ed			;
	dec	hl		;03f0			;
	ld	(hl),029h ;')'	;03f1			; *(l1++) = ')';
l03f3h:							; m11:
	ld	l,(ix-8)	;03f3			;
	ld	h,(ix-7) ;l4	;03f6			;
	dec	hl		;03f9			;
	ld	(ix-8),l	;03fa			;
	ld	(ix-7),h ;l4	;03fd			;

	bit	7,h		;0400			;
	ld	l,(ix-2)	;0402			;
	ld	h,(ix-1) ;l1	;0405			;
	jr	z,l03e9h	;0408			; if(bittst(HI_CHAR(--l2),7) == 0) goto m10;

	ld	(word_9b92),hl	;040a	; _pend		; (word_9b92) = l1; 
	ld	l,(ix-2)	;040d			;
	ld	h,(ix-1) ;l1	;0410			;
	ld	(hl),0		;0413			; *l1 = 0;

	ld	hl,(word_9e12)	;0415	; _plvl		;
	bit	7,h		;0418			;
	jp	z,l030ah	;041a			; if(bittst(HI_CHAR(word_9e12),7) == 0) goto m7;

	ld	hl,0		;041d
	ld	(word_9e12),hl	;0420	; _plvl		; word_9e12 = 0;
	jp	l030ah		;0423			; goto m7;
l0426h:							; m12:
	ld	(word_a685),iy	;0426	; _inp		; word_a685 = st;
	call	sub_016bh	;042a	; _dump		; sub_016bh();
	ld	hl,(word_9ca4)	;042d	; _exfail	;
	push	hl		;0430			;
	call	exit		;0431			; exit(word_9ca4);
	pop	bc		;0434
l0435h:							; m13:
	ld	hl,(word_58c1)	;0435	; _fin		;
	push	hl		;0438			;
	call	_fclose		;0439	; _fclose	; _fclose(word_58c1);
	pop	bc		;043c			;

	ld	de,array_9dfe	;043d	; _fins		;
	ld	hl,(word_a626)	;0440	; _ifno		;
	dec	hl		;0443			;
	ld	(word_a626),hl	;0444	; _ifno		;
	add	hl,hl		;0447			;
	add	hl,de		;0448			;
	ld	c,(hl)		;0449			;
	inc	hl		;044a			;
	ld	b,(hl)		;044b			;
	ld	(word_58c1),bc	;044c	; _fin		; word_58c1 = array_9dfe[word_a626];

	ld	de,array_a66f	;0450	; _dirnams	;
	ld	hl,(word_a626)	;0453	; _ifno		;
	add	hl,hl		;0456			;
	add	hl,de		;0457			;
	ld	c,(hl)		;0458			;
	inc	hl		;0459			;
	ld	b,(hl)		;045a			;
	ld	(array_9de6),bc	;045b	; _dirs		; array_9de6 = array_a66f[word_a626];

	call	sub_013dh	;045f	; _sayline	; sub_013dh();
	jp	l026fh		;0462			; goto m5;

; =============== F U N C T I O N =======================================
;							; char * sub_0465h(register * st) {
;	cotoken						; char * l1;
;							; char * l2;
sub_0465h:						; char   l3;
	call	ncsv		;0465			;					; ------+ ok
	defw	0fffbh	;-5	;0468			;						;
	ld	l,(ix+6)	;046a			;						v
	ld	h,(ix+7)	;046d			;
	push	hl		;0470			;
	pop	iy		;0471			;

	ld	hl,(word_58cb)	;0473	; _state	;
	ld	a,l		;0476			;
	or	h		;0477			;
	jr	z,l04aah	;0478			; if(state == BEG) goto m4;
l047ah:						; m1:
	ld	hl,0		;047a			;
	ld	(word_58cb),hl	;047d	; _state	; state = BEG;
l0480h:						; m2:
	ld	a,(iy+0)	;0480			;
	inc	iy		;0483			;
	cp	023h	;'#'	;0485			;
	jp	nz,l0830h	;0487			; if(*(st++) != '#') goto m38;
l048ah:						; m3:
	push	iy		;048a			;
	pop	hl		;048c			;
	jp	cret		;048d			; returm st;

l0490h:						; m0:			case	 0:

	ld	de,-1		;0490			; if(eob(--p)) { p=refill(p); goto again; }
	add	iy,de		;0493			; else ++p; /* ignore null byte */
	push	iy		;0495			;
	pop	hl		;0497			;
	ld	de,(word_9b92)	;0498	; _pend		;
	call	wrelop		;049c			;
	jr	c,l04dbh	;049f			; if((st += (int)-1) < word_9b92) goto m6;

	push	iy		;04a1	; _refill	;
	call	sub_01bch	;04a3			;
	pop	bc		;04a6			;
	push	hl		;04a7			;
	pop	iy		;04a8			; st = sub_01bch(st);
l04aah:						; m4:
	ld	de,(word_9dfc)	;04aa	; _ptrtab	;
	ld	a,(iy+0)	;04ae			;
	inc	iy		;04b1			;
	ld	l,a		;04b3			;
	rla			;04b4			;
	sbc	a,a		;04b5			;
	ld	h,a		;04b6			;
	add	hl,de		;04b7			;
	bit	1,(hl)		;04b8			;
	jr	z,l04aah	;04ba			; if(bittst(word_9dfc[(char)*(st++)],1) == 0) goto m4;

	push	iy		;04bc			;
	pop	hl		;04be			;
	dec	hl		;04bf			;
	ld	(word_a685),hl	;04c0 	; _inp		; (word_a685) = st-1;
							;---------------------------------------------------------
	ld	l,(hl)		;04c3			;
	ld	h,0		;04c4			;
	ld	a,h		;04c6			;
	cp	h		;04c7			;
	jr	c,l04ddh	;04c8			; /* if((uchar)*word_a685 < 0) goto m7; */
	jr	nz,l04d1h	;04ca			; /* if((uchar)*word_a685 != 0) goto m5; */
	ld	a,07ch		;04cc
	cp	l		;04ce
	jr	c,l04ddh	;04cf			; /* if((uchar)*word_a685 < 124) goto m7; */
l04d1h:							; m5:
	add	hl,hl		;04d1			; switch ((uchar)*word_a685) {
	ld	de,l58cdh	;04d2			;  case	 0:			goto m0;	/* l0490h; */
	add	hl,de		;04d5			;	 1- 9, 11-31, 34-36,
	ld	a,(hl)		;04d6			;	39-45, 57,58, 62,63,
	inc	hl		;04d7			;	90,92, 93,95,   122:	goto m7;	/* l04ddh; */
	ld	h,(hl)		;04d8			;  case	10:			goto m371;	/* l080ch; */
	ld	l,a		;04d9			;  case	32, 60:			goto m9;	/* l0511h; */
	jp	(hl)		;04da			;  case	33, 38:			goto m311;	/* l0782h; */
							;  case	37, 123:		goto m8;	/* l04eah; */
							;  case	46:			goto m301;	/* l075fh; */
							;  case	47-56:			goto m39;	/* l0852h; */
							;  case	59, 61:			goto m10;	/* l0536h; */
							;  case	64-89, 94, 96-121:	goto m391;	/* l0880h; */
							;  case	91:			goto m111;	/* l057dh; */
							; }
l04dbh:							; m6:
	inc	iy		;04db			; st++;

l04ddh:						; m7:			CASE	 1:   2:   3: ...
	ld	de,word_66a5	;04dd	; _slotab	;
	ld	hl,(word_9dfc)	;04e0	; _ptrtab	;
	or	a		;04e3			;
	sbc	hl,de		;04e4			;						^
	jr	nz,l04aah	;04e6			; if(word_9dfc != 0x66A5) goto m4;		;
	jr	l048ah		;04e8			; goto m3;				; ------+ ok


l04eah:						; m8:			CASE	 '&', '|':
	ld	hl,(word_a685)	;04ea	; _inp		;					; ------+ ok
	ld	a,(iy+0)	;04ed			;						;
	inc	iy		;04f0			;						v
	cp	(hl)		;04f2			;
	jr	z,l04ddh	;04f3			; if(*(st++) == *word_a685) goto m7;

	ld	de,-1		;04f5			;
	add	iy,de		;04f8			;
	push	iy		;04fa			;
	pop	hl		;04fc			;
	ld	de,(word_9b92)	;04fd	; _pend		;
	call	wrelop		;0501			;
	jr	c,l04ddh	;0504			; if((st += (int)-1) < word_9b92) goto m7;

	push	iy		;0506			;
	call	sub_01bch	;0508	; _refill	;
	pop	bc		;050b			;
	push	hl		;050c			;						^
	pop	iy		;050d			; st = sub_01bch(st);				;
	jr	l04eah		;050f			; goto m8;				; ------+ ok

l0511h:						; m9:	ok		CASE	 '!': '=':
	ld	a,(iy+0)	;0511			;					; ------+ ok
	inc	iy		;0514			;						;
	cp	03dh	;'='	;0516			;						v
	jr	z,l04ddh	;0518			; if(*(st++) == '=') goto m7;

	ld	de,-1		;051a			;
	add	iy,de		;051d			;
	push	iy		;051f			;
	pop	hl		;0521			;
	ld	de,(word_9b92)	;0522	; _pend		;
	call	wrelop		;0526			;
	jr	c,l04ddh	;0529			; if((st += (int)-1) < word_9b92) goto m7;

	push	iy		;052b			;
	call	sub_01bch	;052d	; _refill	;
	pop	bc		;0530			;
	push	hl		;0531			;						^
	pop	iy		;0532			; st = sub_01bch(st);				;
	jr	l0511h		;0534			; goto m9;				; ------+ ok

l0536h:						; m10:			CASE	 '<', '>':
	ld	a,(iy+0)	;0536			;					; ------+ ok
	inc	iy		;0539			;						;
	cp	03dh	;'='	;053b			;						v
	jr	z,l04ddh	;053d			; if(((st++) == '=') goto m7;
    
	ld	a,(iy-2)	;053f			;
	cp	(iy-1)		;0542			;
	jr	z,l04ddh	;0545			; if(*(st-2) == *(st-1)) goto m7;

	ld	de,-1		;0547			;
	add	iy,de		;054a			;
	push	iy		;054c			;
	pop	hl		;054e			;
	ld	de,(word_9b92)	;054f			;
	call	wrelop		;0553	; _pend		;
	jr	c,l04ddh	;0556			; if((st += (int)-1) < word_9b92) goto m7;

	push	iy		;0558			;
	call	sub_01bch	;055a	; _refill	;
	pop	bc		;055d			;
	push	hl		;055e			;						^
	pop	iy		;055f			; st = sub_01bch(st);				;
	jr	l0536h		;0561			; goto m10;				; ------+ ok


l0563h:						; m11:
	ld	de,-1		;0563			;					; ------+ ok
	add	iy,de		;0566			;						;
	push	iy		;0568			;						v
	pop	hl		;056a			;
	ld	de,(word_9b92)	;056b	; _pend		;
	call	wrelop		;056f			;
	jr	c,l0598h	;0572			; if((st += (int)-1) < word_9b92) goto m12;

	push	iy		;0574			;
	call	sub_01bch	;0576			;
	pop	bc		;0579			;
	push	hl		;057a			;
	pop	iy		;057b			; st = sub_01bch(st);



l057dh:						; m111:			CASE	 '\\':
	ld	a,(iy+0)	;057d			;
	inc	iy		;0580			;
	cp	00ah	;'\n'	;0582			;
	jr	nz,l0563h	;0584			; if(*(st++) != 0xA) goto m11;

	ld	de,array_9a43	;0586	; _lineno	;
	ld	hl,(word_a626)	;0589	; _ifno		;
	add	hl,hl		;058c			;
	add	hl,de		;058d			;
	ld	c,(hl)		;058e			;
	inc	hl		;058f			;
	ld	b,(hl)		;0590			;
	inc	bc		;0591			;
	ld	(hl),b		;0592			;
	dec	hl		;0593			;
	ld	(hl),c		;0594			; array_9a43[word_a626] += 1;
	jp	l04ddh		;0595			; goto m7;

l0598h:						; m12:							^
	inc	iy		;0598			; st++;						;
	jp	l04ddh		;059a			; goto m7;				; ------+ ok


l059dh:							; m13:
	ld	hl,(word_a685)	;059d			;
	dec	hl		;05a0			;
	ld	(word_a685),hl	;05a1			; word_a685--;

l05a4h:							; m14:
	ld	hl,(word_a685)	;05a4			;
	dec	hl		;05a7			;
	ld	a,(hl)		;05a8			;
	ld	e,a		;05a9			;
	rla			;05aa			;
	sbc	a,a		;05ab			;
	ld	d,a		;05ac			;
	ld	hl,array_9c14	;05ad			;
	add	hl,de		;05b0			;
	ld	a,(hl)		;05b1			;
	cp	1		;05b2			;
	jr	nz,l05c2h	;05b4			; if(*(array_9c14 + (*word_a685-1)) != 1) goto m15;

	ld	de,(word_a66b)	;05b6			;
	ld	hl,(word_a685)	;05ba			;
	or	a		;05bd			;
	sbc	hl,de		;05be			;
	jr	nz,l059dh	;05c0			; if(word_a685 != word_a66b) goto m13;
;================================================================================================

l05c2h:						; m15:
	call	sub_016bh	;05c2			; dump();
	ld	hl,(word_9cae)	;05c5			;
	inc	hl		;05c8			;
	ld	(word_9cae),hl	;05c9			; ++flslvl;
l05cch:						; m16:
	ld	a,(iy+0)	;05cc			;
	inc	iy		;05cf			;
	ld	e,a		;05d1			;
	rla			;05d2			;
	sbc	a,a		;05d3			;
	ld	d,a		;05d4			;
	ld	hl,array_9d3e	;05d5 			;
	add	hl,de		;05d8			;
	bit	3,(hl)		;05d9			;
	jr	z,l05cch	;05db			; while(!iscom(*p++));	  	/* goto m16; */

	ld	a,(iy-1)	;05dd			;
	cp	02ah	;'*'	;05e0			;
	jp	nz,l066bh	;05e2			; if(p[-1] == '*') for(;;) {	/* goto m21; */
l05e5h:						; m17:
	ld	a,(iy+0)	;05e5			;
	inc	iy		;05e8			;
	cp	02fh	;'/'	;05ea			;
	jp	z,l0723h	;05ec			; if(*p++=='/') goto endcom;	/* goto m28; */

	ld	de,-1		;05ef			;
	add	iy,de		;05f2			;
	push	iy		;05f4			;
	pop	hl		;05f6			;
	ld	de,(word_9b92)	;05f7			;
	call	wrelop		;05fb			;
	jr	c,l05cch	;05fe			; if(eob(--p)) {		/* goto m16; */

	ld	hl,(word_9cb2)	;0600			;
	ld	a,l		;0603			;
	or	h		;0604			;
	jr	nz,l060eh	;0605			; if(!passcom) {		/* goto m18; */

	ld	hl,(word_9e14)	;0607			;
	ld	a,l		;060a			;
	or	h		;060b			;
	jr	nz,l061dh	;060c			; if(word_9e14 != 0) goto m20;
l060eh:						; m18:
	ld	(word_a685),iy	;060e			; inp = p;
l0612h:						; m19:
	push	iy		;0612			;
	call	sub_01bch	;0614			;
	pop	bc		;0617			;
	push	hl		;0618			;
	pop	iy		;0619			; p = refill(p);
	jr	l05e5h		;061b			; }				/* goto m17; */
l061dh:						; m20:
	ld	de,(word_a685)	;061d			;
	push	iy		;0621			;
	pop	hl		;0623			;
	or	a		;0624			;
	sbc	hl,de		;0625			;
	ld	de,0200h	;0627			;
	call	wrelop		;062a			;
	jp	m,l0612h	;062d			; else if((p - inp) >= BUFSIZ) { /* goto m19; */

	ld	(word_a685),iy	;0630			; inp = p;
	push	iy		;0634			;
	call	sub_01bch	;0636			;
	push	hl		;0639			;
	pop	iy		;063a			; p = refill(p);

	ld	hl,(word_58c3)	;063c			;
	ex	(sp),hl		;063f			;
	ld	hl,0002fh ;'/'	;0640			;
	push	hl		;0643			;
	call	_fputc		;0644			; fputc('/', fout);
	pop	bc		;0647			;
	pop	bc		;0648			;

	ld	de,0fffdh	;0649			;
	add	iy,de		;064c			;
	ld	(word_a685),iy	;064e			;
	ld	(word_a66b),iy	;0652			; outp = inp = p -= 3; 

	ld	(iy+0),02fh ;'/';0656			; *p++ = '/';
	inc	iy		;065a			;
	ld	(iy+0),2ah ;'*' ;065c			; *p++ = '*';
	inc	iy		;0660			;
	ld	(iy+0),2ah ;'*' ;0662			; *p++ = '*';
	inc	iy		;0666			;
	jp	l05e5h		;0668			; goto m17;
l066bh:						; m21:
	ld	a,(iy-1)	;066b			;
	cp	00ah	;'\n'	;066e			;
	jr	nz,l06a0h	;0670			; } else if(p[-1] == '\n') { /* goto m23; */

	ld	de,array_9a43	;0672			;
	ld	hl,(word_a626)	;0675			;
	add	hl,hl		;0678			;
	add	hl,de		;0679			;
	ld	c,(hl)		;067a			;
	inc	hl		;067b			;
	ld	b,(hl)		;067c			;
	inc	bc		;067d			;
	ld	(hl),b		;067e			;
	dec	hl		;067f			;
	ld	(hl),c		;0680			; ++lineno[ifno];

	ld	hl,(word_9cb2)	;0681			;
	ld	a,l		;0684			;
	or	h		;0685			;
	jr	nz,l0690h	;0686			; if(word_9cb2 != 0) goto m22;

	ld	hl,(word_9e14)	;0688			;
	ld	a,l		;068b			;
	or	h		;068c			;
	jp	nz,l05cch	;068d			; if(!passcom)			/* goto m16; */
l0690h:						; m22:
	ld	hl,(word_58c3)	;0690			;
	push	hl		;0693			;
	ld	hl,0000ah ;'\n'	;0694			;
	push	hl		;0697			;
	call	_fputc		;0698			; fputc('\n',fout);
	pop	bc		;069b			;
	pop	bc		;069c			;
	jp	l05cch		;069d			; goto m16;
l06a0h:						; m23:
	ld	de,-1		;06a0			;
	add	iy,de		;06a3			;
	push	iy		;06a5			;
	pop	hl		;06a7			;
	ld	de,(word_9b92)	;06a8			;
	call	wrelop		;06ac			;
	jr	c,l071eh	;06af			; } else if(eob(--p)) {		/* goto m27; */

	ld	hl,(word_9cb2)	;06b1			;
	ld	a,l		;06b4			;
	or	h		;06b5			;
	jr	nz,l06bfh	;06b6			; if(word_9cb2 != 0) goto m24;

	ld	hl,(word_9e14)	;06b8			;
	ld	a,l		;06bb			;
	or	h		;06bc			;
	jr	nz,l06cfh	;06bd			; if(!passcom) {		/* goto m26; */
l06bfh:						; m24:
	ld	(word_a685),iy	;06bf			; inp = p;
l06c3h:						; m25:
	push	iy		;06c3			;
	call	sub_01bch	;06c5			;
	pop	bc		;06c8			;
	push	hl		;06c9			;
	pop	iy		;06ca			; p = refill(p);
	jp	l05cch		;06cc			;  }				/* goto m16; */
l06cfh:						; m26:
	ld	de,(word_a685)	;06cf			;
	push	iy		;06d3			;
	pop	hl		;06d5			;
	or	a		;06d6			;
	sbc	hl,de		;06d7			;
	ld	de,0200h	;06d9			;
	call	wrelop		;06dc			;
	jp	m,l06c3h	;06df			; else if((p - inp) >= BUFSIZ) { /* goto m25; */

	ld	(word_a685),iy	;06e2			; inp  =p;
	push	iy		;06e6			;
	call	sub_01bch	;06e8			;
	push	hl		;06eb			;
	pop	iy		;06ec			; p = refill(p);

	ld	hl,(word_58c3)	;06ee			;
	ex	(sp),hl		;06f1			;
	ld	hl,0002ah ;'*'  ;06f2			;
	push	hl		;06f5			;
	call	_fputc		;06f6			; fputc('*',fout);
	pop	bc		;06f9			;
	ld	hl,(word_58c3)	;06fa			;
	ex	(sp),hl		;06fd			;
	ld	hl,0002fh ;'/'	;06fe			;
	push	hl		;0701			;
	call	_fputc		;0702			; fputc('/',fout);
	pop	bc		;0705			;
	pop	bc		;0706			;

	ld	de,0fffeh	;0707			;
	add	iy,de		;070a			;
	ld	(word_a685),iy	;070c			;
	ld	(word_a66b),iy	;0710			; outp = inp = p -= 2;

	ld	(iy+0),2fh ;'/'	;0714			; *p++ = '/';
	inc	iy		;0718			; 
	ld	(iy+0),2ah ;'*'	;071a			; *p++ = '*';
l071eh:						; m27:
	inc	iy		;071e			; st++;
	jp	l05cch		;0720			; goto m16;
;================================================================================================
l0723h:						; m28:
	ld	hl,(word_9cb2)	;0723			;
	ld	a,l		;0726			;
	or	h		;0727			;
	jr	nz,l0732h	;0728			; if(word_9cb2 != 0) goto m29;

	ld	hl,(word_9e14)	;072a			;
	ld	a,l		;072d			;
	or	h		;072e			;
	jp	nz,l04ddh	;072f			; if(word_9e14 != 0) goto m7;
l0732h:						; m29:
	ld	(word_a685),iy	;0732			;
	ld	(word_a66b),iy	;0736			; word_a66b = (word_a685 = st);

	ld	hl,(word_9cae)	;073a			;
	dec	hl		;073d			;
	ld	(word_9cae),hl	;073e			; word_9cae--;
	jp	l04aah		;0741			; goto m4;
l0744h:						; m30:
	ld	de,-1		;0744			;
	add	iy,de		;0747			;
	push	iy		;0749			;
	pop	hl		;074b			;
	ld	de,(word_9b92)	;074c			;
	call	wrelop		;0750			;
	jp	c,l04ddh	;0753			; if((st += (int)-1) < word_9b92) goto m7;

	push	iy		;0756			;
	call	sub_01bch	;0758			;
	pop	bc		;075b			;
	push	hl		;075c			;
	pop	iy		;075d			; st = sub_01bch(st);

l075fh:						; m301:			CASE	 '/':
	ld	a,(iy+0)	;075f			;
	inc	iy		;0762			;
	cp	02ah	;'*'	;0764			;
	jr	nz,l0744h	;0766			; if(*(st++) != '*') goto m30;

	ld	hl,(word_9cb2)	;0768			;
	ld	a,l		;076b			;
	or	h		;076c			;
	jr	nz,l0777h	;076d			; if(word_9cb2 != 0) goto m31;

	ld	hl,(word_9e14)	;076f			;
	ld	a,l		;0772			;
	or	h		;0773			;
	jp	nz,l05cch	;0774			; if(word_9e14 != 0) goto m16;
l0777h:						; m31:
	push	iy		;0777			;
	pop	hl		;0779			;
	dec	hl		;077a			;
	dec	hl		;077b			;
	ld	(word_a685),hl	;077c			; word_a685 = st-2;
	jp	l05a4h		;077f			; goto m14;

l0782h:						; m311:			CASE	 '\"', '\'':
	ld	a,(iy-1)	;0782			;					; ------+ ok
	ld	(ix-5),a ;l3	;0785			; l3 = *(st-1);					;
l0788h:						; m32:							v
	ld	a,(iy+0)	;0788			;
	inc	iy		;078b			;
	ld	e,a		;078d			;
	rla			;078e			;
	sbc	a,a		;078f			;
	ld	d,a		;0790			;
	ld	hl,array_9d3e	;0791	; _fastab	;
	add	hl,de		;0794			;
	bit	4,(hl)		;0795			;
	jr	z,l0788h	;0797			; if(bittst(array_9d3e + *(st++),4) == 0) goto m32;

	ld	a,(iy-1)	;0799			;
	cp	(ix-5) ;l3	;079c			;
	jp	z,l04ddh	;079f			; if(*(st-1) == l3) goto m7;

	cp	00ah		;07a2
	jr	nz,l07aeh	;07a4			; if(*(st-1) != 0xA) goto m33;

	ld	de,-1		;07a6			;
	add	iy,de		;07a9			; st--; 
	jp	l04ddh		;07ab			; goto m7;
l07aeh:						; m33:
	ld	a,(iy-1)	;07ae			;
	cp	05ch	;'\'	;07b1			;
	jr	nz,l07efh	;07b3			; if(*(st-1) != 0x5c) goto m37;
l07b5h:						; m34:
	ld	a,(iy+0)	;07b5			;
	inc	iy		;07b8			;
	cp	00ah		;07ba			;
	jr	nz,l07cfh	;07bc			; if(*(st++) != 0xA) goto m35;

	ld	de,array_9a43	;07be			;
	ld	hl,(word_a626)	;07c1			;
	add	hl,hl		;07c4			;
	add	hl,de		;07c5			;
	ld	c,(hl)		;07c6			;
	inc	hl		;07c7			;
	ld	b,(hl)		;07c8			;
	inc	bc		;07c9			;
	ld	(hl),b		;07ca			;
	dec	hl		;07cb			;
	ld	(hl),c		;07cc			; array_9a43[word_a626] += 1;
	jr	l0788h		;07cd			; goto m32;
l07cfh:						; m35:
	ld	de,-1		;07cf			;
	add	iy,de		;07d2			;
	push	iy		;07d4			;
	pop	hl		;07d6			;
	ld	de,(word_9b92)	;07d7			;
	call	wrelop		;07db			;
	jr	c,l07ebh	;07de			; if((st += (int)-1) < word_9b92) goto m36;

	push	iy		;07e0			;
	call	sub_01bch	;07e2			;
	pop	bc		;07e5			;
	push	hl		;07e6			;
	pop	iy		;07e7			; st = sub_01bch(st);
	jr	l07b5h		;07e9			; goto m34;
l07ebh:						; m36:
	inc	iy		;07eb			; st++;
	jr	l0788h		;07ed			; goto m32;
l07efh:						; m37:
	ld	de,-1		;07ef			;
	add	iy,de		;07f2			;
	push	iy		;07f4			;
	pop	hl		;07f6			;
	ld	de,(word_9b92)	;07f7			;
	call	wrelop		;07fb			;
	jr	c,l07ebh	;07fe			; if((st += (int)-1) < word_9b92) goto m36;

	push	iy		;0800			;
	call	sub_01bch	;0802			;
	pop	bc		;0805			;
	push	hl		;0806			;						^
	pop	iy		;0807			; st = sub_01bch(st);				;
	jp	l0788h		;0809			; goto m32;				; ------+ ok



l080ch:						; m371:			CASE	 '\n':
	ld	de,array_9a43	;080c			;					; ------+ ok
	ld	hl,(word_a626)	;080f			;						;
	add	hl,hl		;0812			;						v
	add	hl,de		;0813			;
	ld	c,(hl)		;0814			;
	inc	hl		;0815			;
	ld	b,(hl)		;0816			;
	inc	bc		;0817			;
	ld	(hl),b		;0818			;
	dec	hl		;0819			;
	ld	(hl),c		;081a			; array_9a43[word_a626] += 1;

	ld	de,word_66a5	;081b			;
	ld	hl,(word_9dfc)	;081e			;
	or	a		;0821			;
	sbc	hl,de		;0822			;
	jp	nz,l047ah	;0824			; if(word_9dfc != word_66a5) goto m1;

	ld	hl,1		;0827			;
	ld	(word_58cb),hl	;082a			; word_58cb = 1;
	jp	l048ah		;082d			; goto m3;
l0830h:						; m38:
	ld	de,-1		;0830			;
	add	iy,de		;0833			; st--;
	ld	(word_a685),iy	;0835			; word_a685 = st;

	push	iy		;0839			;
	pop	hl		;083b			;
	ld	de,(word_9b92)	;083c			;
	call	wrelop		;0840			;
	jp	c,l04aah	;0843			; if(st < word_9b92) goto m4;

	push	iy		;0846			;
	call	sub_01bch	;0848			;
	pop	bc		;084b			;
	push	hl		;084c			;						^
	pop	iy		;084d			; st = sub_01bch(st);				;
	jp	l0480h		;084f			; goto m2;				; ------+ ok


l0852h:						; m39:			CASE	'0' '1' '2' ... '9'
	ld	a,(iy+0)	;0852			;					; ------+ ok
	inc	iy		;0855			;						;
	ld	e,a		;0857			;						v
	rla			;0858			;
	sbc	a,a		;0859			;
	ld	d,a		;085a			;
	ld	hl,array_9d3e	;085b	; _fastab	;
	add	hl,de		;085e			;
	bit	2,(hl)		;085f			;
	jr	nz,l0852h	;0861			; if(bittst(array_9d3e + *(st++),2) != 0) goto m39;

	ld	de,-1		;0863			;
	add	iy,de		;0866			;
	push	iy		;0868			;
	pop	hl		;086a			;
	ld	de,(word_9b92)	;086b	; _pend		;
	call	wrelop		;086f			;
	jp	c,l04ddh	;0872			; if((st += (int)-1) < word_9b92) goto m7;

	push	iy		;0875			;
	call	sub_01bch	;0877	; _refill	;
	pop	bc		;087a			;
	push	hl		;087b			;						^
	pop	iy		;087c			; st = sub_01bch(st);				;
	jr	l0852h		;087e			; goto m39;				; ------+ ok







l0880h:							; m391:			CASE	 'A'-'Z', '_', 'a'-'z'
	ld	hl,(word_9cae)	;0880	; _flslvl	;
	ld	a,l		;0883			;
	or	h		;0884			;
	jr	z,l08bah	;0885			; if(flslvl == 0) goto m41;

	jp	l09d9h		;0887			; goto m42;

l088ah:							; m40:
	ld	a,(iy+0)	;088a			;
	inc	iy		;088d	; ++p		;
	ld	e,a		;088f			;
	rla			;0890			;
	sbc	a,a		;0891			;
	ld	d,a		;0892			;
	ld	hl,array_9d3e	;0893	; _fastab	;
	add	hl,de		;0896			;
	bit	0,(hl)		;0897			;
	jr	nz,l088ah	;0899			; if(bittst(fastab[p++],0) != 0) goto m40;

	ld	de,-1		;089b			;
	add	iy,de		;089e	; --p		;
	push	iy		;08a0			;

	pop	hl		;08a2			;
	ld	de,(word_9b92)	;08a3	; pend		;
	call	wrelop		;08a7			;
	jp	c,l0a07h	;08aa			; if(--p < pend) goto m44;

	push	iy		;08ad			;
	call	sub_01bch	;08af	; _refill	; refill(p);
	pop	bc		;08b2			;
	ld	hl,(word_a685)	;08b3	; _inp		;
	inc	hl		;08b6			;
	push	hl		;08b7			;
	pop	iy		;08b8			; p = inp + 1;

l08bah:							; m41:
	ld	a,(iy-1)	;08ba			;
	ld	l,a		;08bd			;
	rla			;08be			;
	sbc	a,a		;08bf			;
	ld	h,a		;08c0			;
	ld	(ix-2),l	;08c1			;
	ld	(ix-1),h ;l1	;08c4			; c = p[-1];

	ld	e,(ix-2)	;08c7			;
	ld	d,h		;08ca			;
	ld	hl,word_9af3	;08cb			;
	add	hl,de		;08ce			;
    	bit	0,(hl)		;08cf			;
	ld	a,(iy+0)	;08d1			;
	jp	z,l09dch	;08d4			; if(bittst(word_9af3[c], 0) == 0) goto m43;

	ld	l,a		;08d7			;
	rla			;08d8			;
	sbc	a,a		;08d9			;
	ld	h,a		;08da			;
	ld	(ix-4),l	;08db			;
	ld	(ix-3),h ;l2	;08de			; i = *p++;
	inc	iy		;08e1	; p++;		; 
	ld	e,(ix-4)	;08e3			;
	ld	d,h		;08e6			;
	ld	hl,array_9d3e	;08e7	; _fastab	;
	add	hl,de		;08ea			;
	bit	0,(hl)		;08eb			;
	jp	z,l0a26h	;08ed			; if(bittst(fastab[i], 0) == 0) goto m45;

	ld	hl,word_9af3	;08f0			;
	add	hl,de		;08f3			;
    	bit	1,(hl)		;08f4			;
	ld	a,(iy+0)	;08f6			;
	jp	z,l09dch	;08f9			; if(bittst(word_9af3[i], 1) == 0) goto m43;

	ld	l,a		;08fc			;
	rla			;08fd			;
	sbc	a,a		;08fe			;
	ld	h,a		;08ff			;
	ld	(ix-2),l	;0900			;
	ld	(ix-1),h ;l1	;0903			; c = *p++;
	inc	iy		;0906	; p++;		;
	ld	e,(ix-2)	;0908			;
	ld	d,h		;090b			;
	ld	hl,array_9d3e	;090c	; _fastab	;
	add	hl,de		;090f			;
	bit	0,(hl)		;0910			;
	jp	z,l0a26h	;0912			; if(bittst(fastab[c], 0) == 0) goto m45;
	
	ld	hl,word_9af3	;0915			;
	add	hl,de		;0918			;
    	bit	2,(hl)		;0919			;
	ld	a,(iy+0)	;091b			;
	jp	z,l09dch	;091e			; if(bittst(word_9af3[c], 2) == 0) goto m43;
	
	ld	l,a		;0921			;
	rla			;0922			;
	sbc	a,a		;0923			;
	ld	h,a		;0924			;
	ld	(ix-4),l	;0925			;
	ld	(ix-3),h ;l2	;0928			; i = *p++;
	inc	iy		;092b	; p++;		;
	ld	e,(ix-4)	;092d			;
	ld	d,h		;0930			;
	ld	hl,array_9d3e	;0931	; _fastab	;
	add	hl,de		;0934			;
	bit	0,(hl)		;0935			;
	jp	z,l0a26h	;0937			; if(bittst(fastab[i], 0) == 0) goto m45;

	ld	hl,word_9af3	;093a			;
	add	hl,de		;093d			;
    	bit	3,(hl)		;093e			;
	ld	a,(iy+0)	;0940			;
	jp	z,l09dch	;0943			; if(bittst(word_9af3[i], 3) == 0) goto m43;

	ld	l,a		;0946			;
	rla			;0947			;
	sbc	a,a		;0948			;
	ld	h,a		;0949			;
	ld	(ix-2),l	;094a			;
	ld	(ix-1),h	;094d			; c = *p++;
	inc	iy		;0950	; p++;		;
	ld	e,(ix-2)	;0952			;
	ld	d,h		;0955			;
	ld	hl,array_9d3e	;0956	; _fastab	;
	add	hl,de		;0959			;
	bit	0,(hl)		;095a			;
	jp	z,l0a26h	;095c			; if(bittst(fastab[c], 0) == 0) goto m45;
	
	ld	hl,word_9af3	;095f			;
	add	hl,de		;0962			;
    	bit	4,(hl)		;0963			;
	ld	a,(iy+0)	;0965			;
	jp	z,l09dch	;0968			; if(bittst(word_9af3[c], 4) == 0) goto m43;

	ld	l,a		;096b			;
	rla			;096c			;
	sbc	a,a		;096d			;
	ld	h,a		;096e			;
	ld	(ix-4),l	;096f			;
	ld	(ix-3),h	;0972			; i = *p++;
	inc	iy		;0975	; p++;		;
	ld	e,(ix-4)	;0977			;
	ld	d,h		;097a			;
	ld	hl,array_9d3e	;097b	; _fastab	;
	add	hl,de		;097e			;
	bit	0,(hl)		;097f			;
	jp	z,l0a26h	;0981			; if(bittst(fastab[i], 0) == 0) goto m45;

	ld	hl,word_9af3	;0984			;
	add	hl,de		;0987			;
    	bit	5,(hl)		;0988			;
	ld	a,(iy+0)	;098a			;
	jr	z,l09dch	;098d			; if(bittst(word_9af3[i], 5) == 0) goto m43;

	ld	l,a		;098f			;
	rla			;0990			;
	sbc	a,a		;0991			;
	ld	h,a		;0992			;
	ld	(ix-2),l	;0993			;
	ld	(ix-1),h	;0996			; c =  *p++;
	inc	iy		;0999	; p++;		;
	ld	e,(ix-2)	;099b			;
	ld	d,h		;099e			;
	ld	hl,array_9d3e	;099f	; _fastab	;
	add	hl,de		;09a2			;
	bit	0,(hl)		;09a3			;
	jp	z,l0a26h	;09a5			; if(bittst(fastab[c], 0) == 0) goto m45;

	ld	hl,word_9af3	;09a8			;
	add	hl,de		;09ab			;
    	bit	6,(hl)		;09ac			;
	ld	a,(iy+0)	;09ae			;
	jr	z,l09dch	;09b1			; if(bittst(word_9af3[c], 6) == 0) goto m43;

	ld	l,a		;09b3			;
	rla			;09b4			;
	sbc	a,a		;09b5			;
	ld	h,a		;09b6			;
	ld	(ix-4),l	;09b7			;
	ld	(ix-3),h	;09ba			; i = *p++;
	inc	iy		;09bd	; p++;		;
	ld	e,(ix-4)	;09bf			;
	ld	d,h		;09c2			;
	ld	hl,array_9d3e	;09c3	; _fastab	;
	add	hl,de		;09c6			;
	bit	0,(hl)		;09c7			;
	jr	z,l0a26h	;09c9			; if(bittst(fastab[i], 0) == 0) goto m45;

	ld	hl,word_9af3	;09cb			;
	add	hl,de		;09ce			;
	ld	a,(hl)		;09cf			;
	ld	l,a		;09d0			;
	rla			;09d1			;
	sbc	a,a		;09d2			;
	ld	h,a		;09d3			;
	bit	7,l		;09d4			;
	jp	nz,l088ah	;09d6			; if(bittst(word_9af3[i], 7) == 0) goto m40;
l09d9h:							; m42:
	ld	a,(iy+0)	;09d9
							; nomac:
l09dch:							; m43:
	inc	iy		;09dc	; p++;		;
	ld	e,a		;09de			;
	rla			;09df			;
	sbc	a,a		;09e0			;
	ld	d,a		;09e1			;
	ld	hl,array_9d3e	;09e2	; _fastab	;
	add	hl,de		;09e5			;
	bit	0,(hl)		;09e6			;
	jr	nz,l09d9h	;09e8			; if(bittst(fastab[p++], 0) != 0) goto m42;

	ld	de,-1		;09ea			;
	add	iy,de		;09ed			;
	push	iy		;09ef			;
	pop	hl		;09f1			;
	ld	de,(word_9b92)	;09f2	; _pend		;
	call	wrelop		;09f6			;
	jp	c,l04ddh	;09f9			; if((st += (int)-1) < pend) goto m7;

	push	iy		;09fc			;
	call	sub_01bch	;09fe	; _refill	;
	pop	bc		;0a01			;
	push	hl		;0a02			;
	pop	iy		;0a03			; p = refill(p);
	jr	l09d9h		;0a05			; goto m42;

							;lokid:
l0a07h:							; m44:
	ld	hl,0		;0a07			;
	push	hl		;0a0a			;
	push	iy		;0a0b			;
	ld	hl,(word_a685)	;0a0d	; _inp		;
	push	hl		;0a10			;
	call	sub_1d22h	;0a11   ; _slookup	; slookup(inp, p, 0);
	pop	bc		;0a14			;
	pop	bc		;0a15			;
	pop	bc		;0a16			;

	ld	hl,(word_9c9c)	;0a17	; _newp		;
	ld	a,l		;0a1a			;
	or	h		;0a1b			;
	jp	z,l04ddh	;0a1c			; if(inp == 0) goto m7;

	ld	iy,(word_9c9c)	;0a1f	; _newp		; p = inp;
	jp	l04aah		;0a23			; goto m4;

							;endid:
l0a26h:							; m45:
	ld	de,-1		;0a26			;
	add	iy,de		;0a29			;
	push	iy		;0a2b			;
	pop	hl		;0a2d			;
	ld	de,(word_9b92)	;0a2e	; _pend		;
	call	wrelop		;0a32			;
	jr	c,l0a07h	;0a35			; if(--p < pend) goto m44;

	push	iy		;0a37			;
	call	sub_01bch	;0a39	; _refill	; refill(p);
	pop	bc		;0a3c			;
	ld	hl,(word_a685)	;0a3d	; inp		;
	inc	hl		;0a40			;
	push	hl		;0a41			;
	pop	iy		;0a42			; st = inp + 1;
	jp	l08bah		;0a44			; goto m41;

;	End sub_0465h

; =============== F U N C T I O N =======================================
;
;
sub_0a47h:						; char * sub_0a47h(register char * st) {
	call	csv		;0a47
	ld	l,(ix+6)	;0a4a			;
	ld	h,(ix+7)	;0a4d			;
	push	hl		;0a50			;
	pop	iy		;0a51			;
l0a53h:							; m1:
	ld	(word_a685),iy	;0a53			;
	ld	(word_a66b),iy	;0a57			; word_a66b = (word_a685 = st);
	push	iy		;0a5b			;
	call	sub_0465h	;0a5d			;
	pop	bc		;0a60			;
	push	hl		;0a61			;
	pop	iy		;0a62			; st = sub_0465h(st);
	ld	hl,(word_a685)	;0a64			;
	ld	a,(hl)		;0a67			;
	ld	e,a		;0a68			;
	rla			;0a69			;
	sbc	a,a		;0a6a			;
	ld	d,a		;0a6b			;
	ld	hl,array_9c14	;0a6c			;
	add	hl,de		;0a6f			;
	ld	a,(hl)		;0a70			;
	cp	1		;0a71			;
	jr	z,l0a53h	;0a73			; if(array_9c14[*word_a685] == 1) goto m1;
	push	iy		;0a75			;
	pop	hl		;0a77			;
	jp	cret		;0a78			; return st;

;	End sub_0a47h

; =============== F U N C T I O N =======================================
;
;	unfill
;
sub_0a7bh:						; int sub_0a7bh(register char * st) {
	call	ncsv		;0a7b			; char * l1;
	defw	0fffah	;-6	;0a7e			; char * l2;
	ld	l,(ix+6)	;0a80			; int    l3;
	ld	h,(ix+7)	;0a83			;
	push	hl		;0a86			;
	pop	iy		;0a87			;

	ld	de,0000eh	;0a89			;
	ld	hl,(word_a667)	;0a8c			;
	call	wrelop		;0a8f			;
	jp	m,l0adbh	;0a92			; if(word_a667 < 0xE) goto m3;

	ld	hl,(word_9ca8)	;0a95			;
	push	hl		;0a98			;
	ld	hl,l5a13h	;0a99			;
	push	hl		;0a9c			;
	call	sub_1ad2h	;0a9d			; sub_1ad2h("%s: too much pushback", word_9ca8);
	pop	bc		;0aa0			;
	pop	bc		;0aa1			;

	ld	hl,(word_9b92)	;0aa2			;
	ld	(word_a685),hl	;0aa5			;
	push	hl		;0aa8			;
	pop	iy		;0aa9			; st = word_a685 = word_9b92;
	call	sub_016bh	;0aab			; sub_016bh();
	jr	l0ac5h		;0aae			; goto m2;
l0ab0h:							; m1:
	push	iy		;0ab0			;
	call	sub_01bch	;0ab2			;
	pop	bc		;0ab5			;
	push	hl		;0ab6			;
	pop	iy		;0ab7			; st = sub_01bch(st);

	ld	hl,(word_9b92)	;0ab9			;
	ld	(word_a685),hl	;0abc			;
	push	hl		;0abf			;
	pop	iy		;0ac0			; st = word_a685 = word_9b92;
	call	sub_016bh	;0ac2			; sub_016bh();
l0ac5h:							; m2:
	ld	de,array_9e18	;0ac5			;
	ld	hl,(word_a626)	;0ac8			;
	add	hl,hl		;0acb			;
	add	hl,de		;0acc			;
	ld	a,(hl)		;0acd			;
	inc	hl		;0ace			;
	ld	h,(hl)		;0acf			;
	ld	l,a		;0ad0			;
	ld	de,(word_a667)	;0ad1			;
	call	wrelop		;0ad5			;
	jp	m,l0ab0h	;0ad8			; if(array_9e18[word_a626] < word_a667) goto m1;
l0adbh:							; m3:
	ld	de,(word_9cbc)	;0adb			;
	ld	hl,0		;0adf			;
	call	wrelop		;0ae2			;
	jp	p,l0affh	;0ae5			; if(0 >= word_9cbc) goto m4;

	ld	de,array_a629	;0ae8			;
	ld	hl,(word_9cbc)	;0aeb			;
	dec	hl		;0aee			;
	ld	(word_9cbc),hl	;0aef			;
	add	hl,hl		;0af2			;
	add	hl,de		;0af3			;
	ld	c,(hl)		;0af4			;
	inc	hl		;0af5			;
	ld	b,(hl)		;0af6			;
	ld	(ix-2),c	;0af7			;
	ld	(ix-1),b ;l1	;0afa			; l1 = array_a629[--word_9cbc];
	jr	l0b33h		;0afd			; goto m6;
l0affh:							; m4:
	ld	hl,(word_58be)	;0aff			;
	ld	(ix-2),l	;0b02			;
	ld	(ix-1),h ;l1	;0b05			; l1 = word_58be;

	ld	de,0200h	;0b08			;
	ld	hl,(word_58be)	;0b0b			;
	add	hl,de		;0b0e			;
	ld	(word_58be),hl	;0b0f			; word_58be += 512;

	ld	de,09605h	;0b12			;
	call	wrelop		;0b15			;
	jr	c,l0b29h	;0b18			; if(word_58be < 0x9605) goto m5;

	ld	hl,l5a29h	;0b1a "no space"	;
	push	hl		;0b1d			;
	call	sub_1ad2h	;0b1e			; sub_1ad2h("no space");
	ld	hl,(word_9ca4)	;0b21			;
	ex	(sp),hl		;0b24			;
	call	exit		;0b25			; exit(word_9ca4);
	pop	bc		;0b28			;
l0b29h:							; m5:
	ld	hl,(word_58be)	;0b29			;
	inc	hl		;0b2c			;
	ld	(word_58be),hl	;0b2d			;
	dec	hl		;0b30			;
	ld	(hl),0		;0b31			; *(word_58be++) = 0;
l0b33h:							; m6:
	ld	de,array_9a57	;0b33			;
	ld	hl,(word_a667)	;0b36			;
	add	hl,hl		;0b39			;
	add	hl,de		;0b3a			;
	ld	e,(ix-2)	;0b3b			;
	ld	d,(ix-1) ;l1	;0b3e			;
	ld	(hl),e		;0b41			;
	inc	hl		;0b42			;
	ld	(hl),d		;0b43			; array_9a57[word_a667] = l1;

	ld	de,(word_9b92)	;0b44			;
	ld	hl,0fe00h	;0b48			;
	add	hl,de		;0b4b			;
	ld	(ix-4),l	;0b4c			;
	ld	(ix-3),h ;l2	;0b4f			;
	push	iy		;0b52			;
	pop	de		;0b54			;
	call	wrelop		;0b55			;
	jr	nc,l0b63h	;0b58			; if(l2 = word_9b92 + 0xFE00) >= st) goto m7;

	push	iy		;0b5a			;
	pop	hl		;0b5c			;
	ld	(ix-4),l	;0b5d			;
	ld	(ix-3),h ;l2	;0b60			; l2 = st;

l0b63h:							; m7:
	ld	l,(ix-4)	;0b63			;
	ld	h,(ix-3) ;l2	;0b66			;
	ld	a,(hl)		;0b69			;
	inc	hl		;0b6a			;
	ld	(ix-4),l	;0b6b			;
	ld	(ix-3),h ;l2	;0b6e			;

	ld	l,(ix-2)	;0b71			;
	ld	h,(ix-1) ;l1	;0b74			;
	inc	hl		;0b77			;
	ld	(ix-2),l	;0b78			;
	ld	(ix-1),h ;l1	;0b7b			;
	dec	hl		;0b7e			;
	ld	(hl),a		;0b7f			;
	or	a		;0b80			;
	jr	nz,l0b63h	;0b81			; if((*(++l1 -1) = *(l2++)) != 0) goto m7;

	ld	de,(word_9b92)	;0b83			;
	ld	l,(ix-4)	;0b87			;
	ld	h,(ix-3) ;l2	;0b8a			;
	call	wrelop		;0b8d			;
	jr	c,l0b63h	;0b90			; if(l2 < word_9b92) goto m7;

	ld	de,array_a645	;0b92			;
	ld	hl,(word_a667)	;0b95			;
	inc	hl		;0b98			;
	ld	(word_a667),hl	;0b99			;
	dec	hl		;0b9c			;
	add	hl,hl		;0b9d			;
	add	hl,de		;0b9e			;
	ld	e,(ix-2)	;0b9f			;
	ld	d,(ix-1) ;l1	;0ba2			;
	ld	(hl),e		;0ba5			;
	inc	hl		;0ba6			;
	ld	(hl),d		;0ba7			; array_a645[word_a667++] = l1;

	ld	de,(word_9c96)	;0ba8			;
	ld	hl,0200h	;0bac			;
	add	hl,de		;0baf			;
	ld	(ix-2),l	;0bb0			;
	ld	(ix-1),h ;l1	;0bb3			; l1 = word_9c96 + 512;

	ld	de,(word_9b92)	;0bb6
	ld	hl,0fe00h	;0bba
	add	hl,de		;0bbd
	ld	(ix-4),l	;0bbe
	ld	(ix-3),h ;l2	;0bc1			; l2 = word_9b92 + 0xFE00;

	ld	l,(ix-2)	;0bc4			;
	ld	h,(ix-1) ;l1	;0bc7			;
	ld	(word_9b92),hl	;0bca			; word_9b92 = l1;
	
	push	iy		;0bcd			;
	pop	de		;0bcf			;
	ld	l,(ix-4)	;0bd0			;
	ld	h,(ix-3) ;l2	;0bd3			;
	call	wrelop		;0bd6			;
	jr	nc,l0c02h	;0bd9			; if(l2 >= st) goto m9;

	push	iy		;0bdb			;
	pop	hl		;0bdd			;
	ld	(ix-4),l	;0bde			;
	ld	(ix-3),h ;l2	;0be1			; l2 = st;
	jr	l0c02h		;0be4			; goto m9;
l0be6h:							; m8:
	ld	l,(ix-4)	;0be6			;
	ld	h,(ix-3) ;l2	;0be9			;
	dec	hl		;0bec			;
	ld	(ix-4),l	;0bed			;
	ld	(ix-3),h ;l2	;0bf0			;
	ld	a,(hl)		;0bf3			;
	ld	l,(ix-2)	;0bf4			;
	ld	h,(ix-1) ;l1	;0bf7			;
	dec	hl		;0bfa			;
	ld	(ix-2),l	;0bfb			;
	ld	(ix-1),h ;l1	;0bfe			;
	ld	(hl),a		;0c01			; *(--l1) = *(--l2);
l0c02h:							; m9:
	ld	e,(ix-4)	;0c02			;
	ld	d,(ix-3) ;l2	;0c05			;
	ld	hl,(word_a66b)	;0c08			;
	call	wrelop		;0c0b			;
	jr	c,l0be6h	;0c0e			; if(word_a66b < l2) goto m8;

	ld	e,(ix-2)	;0c10			;
	ld	d,(ix-1) ;l1	;0c13			;
	ld	hl,(word_a665)	;0c16			;
	call	wrelop		;0c19			;
	jr	c,l0c26h	;0c1c			; if(word_a665 < l1) goto m10;

	ld	hl,l5a32h	;0c1e			;
	push	hl		;0c21			;
	call	sub_1ad2h	;0c22			; sub_1ad2h("token too\tlong");
	pop	bc		;0c25			;
l0c26h:							; m10:
	ld	de,(word_a66b)	;0c26			;
	ld	l,(ix-2)	;0c2a			;
	ld	h,(ix-1) ;l1	;0c2d			;
	or	a		;0c30			;
	sbc	hl,de		;0c31			;
	ld	(ix-6),l	;0c33			;
	ld	(ix-5),h ;l3	;0c36			; l3 = l1 - word_a66b;

	ex	de,hl		;0c39			;
	add	hl,de		;0c3a			;
	ld	(word_a66b),hl	;0c3b			; word_a66b += l3;

	ld	hl,(word_a685)	;0c3e			;
	add	hl,de		;0c41			;
	ld	(word_a685),hl	;0c42			; word_a685 += l3;

	ld	hl,(word_a66d)	;0c45			;
	add	hl,de		;0c48			;
	ld	(word_a66d),hl	;0c49			; word_a66d += l3;

	push	iy		;0c4c			;
	pop	de		;0c4e			;
	ld	l,(ix-6)	;0c4f			;
	ld	h,(ix-5) ;l3	;0c52			;
	add	hl,de		;0c55			;
	jp	cret		;0c56			; return l3 + st;

;	End sub_0a7bh					; }

; =============== F U N C T I O N =======================================
;
;	doincl
;							; char *sub_0c59h(register char * st) {
sub_0c59h:						; int    l1;
	call	ncsv		;0c59			; int    l2;
	dw	0FDF6H	; -522	;0c5c			; char * l3;

	ld	l,(ix+6)	;0c5e			; char * l4;
	ld	h,(ix+7)	;0c61			; char * l5;
	push	hl		;0c64			; char arr[512];
	pop	iy		;0c65			;
	
	push	hl		;0c67			;
	call	sub_0a47h	;0c68			;
	pop	bc		;0c6b			;
	push	hl		;0c6c			;
	pop	iy		;0c6d			; st = sub_0a47h(st);

	push	ix		;0c6f			;
	pop	de		;0c71			;
	ld	hl,0FDF6H	;0c72			;
	add	hl,de		;0c75			;
	ld	(ix-6),l	;0c76			;
	ld	(ix-5),h ;l3	;0c79			; l3 = arr;

	ld	hl,(word_a685)	;0c7c			;
	ld	a,(hl)		;0c7f			;
	inc	hl		;0c80			;
	ld	(word_a685),hl	;0c81			;
	cp	03ch	;'<'	;0c84			;
	jp	nz,l0ce8h	;0c86			; if(*(word_a685++) != '<') goto m6;

	ld	(ix-4),1	;0c89			;
	ld	(ix-3),0 ;l2	;0c8d			; l2 = 1;
l0c91h:						; m1:
	ld	(word_a685),iy	;0c91			;
	ld	(word_a66b),iy	;0c95			; word_a66b = (word_a685 = st);

	push	iy		;0c99			;
	call	sub_0465h	;0c9b			;
	pop	bc		;0c9e			;
	push	hl		;0c9f			;
	pop	iy		;0ca0			; st = sub_0465h(st);

	ld	hl,(word_a685)	;0ca2			;
	ld	a,(hl)		;0ca5			;
	cp	0ah		;0ca6			;
	jr	nz,l0cbah	;0ca8			; if(*word_a685 != 0xA) goto m3;

	ld	de,-1		;0caa
	add	iy,de		;0cad			; st--;
l0cafh:						; m2:
	ld	l,(ix-6)	;0caf			;
	ld	h,(ix-5) ;l3	;0cb2			;
	ld	(hl),0		;0cb5			; l3 = 0;
	jp	l0d47h		;0cb7			; goto m10;
l0cbah:						; m3:
	ld	hl,(word_a685)	;0cba			;
	ld	a,(hl)		;0cbd			;
	cp	03eh	;'>'	;0cbe			;
	jr	nz,l0cdbh	;0cc0			; if(*word_a685 != '>') goto m5;
	jr	l0cafh		;0cc2			; goto m2;
l0cc4h:						; m4:
	ld	hl,(word_a685)	;0cc4			;
	ld	a,(hl)		;0cc7			;
	inc	hl		;0cc8			;
	ld	(word_a685),hl	;0cc9			;
	ld	l,(ix-6)	;0ccc			;
	ld	h,(ix-5) ;l3	;0ccf			;
	inc	hl		;0cd2			;
	ld	(ix-6),l	;0cd3			;
	ld	(ix-5),h ;l3	;0cd6			;
	dec	hl		;0cd9			;
	ld	(hl),a		;0cda			; *l(3++) = *(word_a685++);
l0cdbh:						; m5:
	push	iy		;0cdb			;
	pop	de		;0cdd			;
	ld	hl,(word_a685)	;0cde			;
	call	wrelop		;0ce1			;
	jr	c,l0cc4h	;0ce4			; if(word_a685 < st) goto m4;
	jr	l0c91h		;0ce6			; goto m1;
l0ce8h:						; m6:
	ld	hl,(word_a685)	;0ce8			;
	dec	hl		;0ceb			;
	ld	a,(hl)		;0cec			;
	cp	22h	;'"'	;0ced			;
	jr	nz,l0d32h	;0cef			; if(*(word_a685-1) != 0x22) goto m9;

	ld	(ix-4),0	;0cf1			;
	ld	(ix-3),0 ;l2	;0cf5			; l2 = 0;
	jr	l0d12h		;0cf9			; goto m8;
l0cfbh:						; m7:
	ld	hl,(word_a685)	;0cfb			;
	ld	a,(hl)		;0cfe			;
	inc	hl		;0cff			;
	ld	(word_a685),hl	;0d00			;
	ld	l,(ix-6)	;0d03			;
	ld	h,(ix-5) ;l3	;0d06			;
	inc	hl		;0d09			;
	ld	(ix-6),l	;0d0a			;
	ld	(ix-5),h ;l3	;0d0d			;
	dec	hl		;0d10			;
	ld	(hl),a		;0d11			;*(l3++) = *(word_a685++);
l0d12h:						; m8:
	push	iy		;0d12			;
	pop	de		;0d14			;
	ld	hl,(word_a685)	;0d15			;
	call	wrelop		;0d18			;
	jr	c,l0cfbh	;0d1b			; if(word_a685 < st) goto m7;

	ld	l,(ix-6)	;0d1d			;
	ld	h,(ix-5) ;l3	;0d20			;
	dec	hl		;0d23			;
	ld	(ix-6),l	;0d24			;
	ld	(ix-5),h ;l3	;0d27			;
	ld	a,(hl)		;0d2a			;
	cp	22h	;'"'	;0d2b			;
	jr	nz,l0d47h	;0d2d			; if(*(--l3) != 0x22) goto m10;
	jp	l0cafh		;0d2f			; goto m2;
l0d32h:						; m9:
	ld	hl,0		;0d32			;
	push	hl		;0d35			;
	ld	hl,l5a41h	;0d36			;
	push	hl		;0d39			;
	call	sub_1ad2h	;0d3a			; sub_1ad2h("bad include syntax", 0);
	pop	bc		;0d3d			;
	pop	bc		;0d3e			;
	ld	(ix-4),2	;0d3f			;
	ld	(ix-3),0 ;l2	;0d43			; l2 = 2;
l0d47h:						; m10:
	ld	hl,(word_9cae)	;0d47			;
	inc	hl		;0d4a			;
	ld	(word_9cae),hl	;0d4b			; word_9cae++;
l0d4eh:						; m11:
	ld	(word_a685),iy	;0d4e			;
	ld	(word_a66b),iy	;0d52			; word_a66b = (word_a685 = st);
	push	iy		;0d56			;
	call	sub_0465h	;0d58			;
	pop	bc		;0d5b			;
	push	hl		;0d5c			;
	pop	iy		;0d5d			; st = sub_0465h(st);
	ld	hl,(word_a685)	;0d5f			;
	ld	a,(hl)		;0d62			;
	cp	0ah		;0d63			;
	jr	nz,l0d4eh	;0d65			; if(*word_a685 != 0xA) goto m11;

	ld	hl,(word_9cae)	;0d67			;
	dec	hl		;0d6a			;
	ld	(word_9cae),hl	;0d6b			; word_9cae++;

	ld	(word_a685),iy	;0d6e			; word_a685 = st;

	call	sub_016bh	;0d72			; sub_016bh();

	ld	de,2		;0d75			;
	ld	l,(ix-4)	;0d78			;
	ld	h,(ix-3) ;l2	;0d7b			;
	or	a		;0d7e			;
	sbc	hl,de		;0d7f			;
	jr	nz,l0d89h	;0d81			; if(l2 != 2) goto m13;
l0d83h:						; m12:
	push	iy		;0d83			;
	pop	hl		;0d85			;
	jp	cret		;0d86			; return st;
l0d89h:						; m13:
	ld	de,0000ah	;0d89			;
	ld	hl,(word_a626)	;0d8c			;
	inc	hl		;0d8f			;
	call	wrelop		;0d90			;
	jp	m,l0da5h	;0d93			; if(word_a626 < 0xA) goto m15;

	ld	hl,0		;0d96			;
	push	hl		;0d99			;
	ld	hl,l5a54h	;0d9a			;
l0d9dh:						; m14:
	push	hl		;0d9d			;
	call	sub_1ad2h	;0d9e			; sub_1ad2h("Unreasonable include nesting", 0);
	pop	bc		;0da1			;
	pop	bc		;0da2			;
	jr	l0d83h		;0da3			; goto m12;
l0da5h:						; m15:
	ld	de,(word_58be)	;0da5			;
	ld	(ix-10),e	;0da9			;
	ld	(ix-9),d ;l5	;0dac			; l5 = word_58be;

	ld	hl,09405h	;0daf			;
	call	wrelop		;0db2			;
	jr	nc,l0dc6h	;0db5			; if(0x9405 >= l5) goto m16;

	ld	hl,l5a71h	;0db7 "no/tspace"	;
	push	hl		;0dba			;
	call	sub_1ad2h	;0dbb			; sub_1ad2h("no/tspace");
	ld	hl,(word_9ca4)	;0dbe			;
	ex	(sp),hl		;0dc1			;
	call	exit		;0dc2			; exit(word_9ca4);
	pop	bc		;0dc5			;
l0dc6h:						; m16:
	ld	(ix-2),0	;0dc6			;
	ld	(ix-1),0 ;l1	;0dca			; l1 = 0;

	ld	de,array_9de6	;0dce			;
	ld	l,(ix-4)	;0dd1			;
	ld	h,(ix-3) ;l2	;0dd4			;
	add	hl,hl		;0dd7			;
	add	hl,de		;0dd8			;
	ld	(ix-8),l	;0dd9			;
	ld	(ix-7),h ;l4	;0ddc			; l4 = array_9de6 +  l2;
	jp	l0e88h		;0ddf			; goto m22;
l0de2h:						; m17:
	push	ix		;0de2			;
	pop	de		;0de4			;
	ld	hl,0fdf6h	;0de5			;
	add	hl,de		;0de8			;
	ld	a,(hl)		;0de9			;
	cp	02fh	;'/'	;0dea			;
	jr	z,l0dfch	;0dec			; if(arr[0] == '/') goto m18;

	ld	l,(ix-8)	;0dee			;
	ld	h,(ix-7) ;l4	;0df1			;
	ld	a,(hl)		;0df4			;
	inc	hl		;0df5			;
	ld	h,(hl)		;0df6			;
	ld	l,a		;0df7			;
	ld	a,(hl)		;0df8			;
	or	a		;0df9			;
	jr	nz,l0e12h	;0dfa			; if(*l4 != 0) goto m19;
l0dfch:						; m18:
	push	ix		;0dfc			;
	pop	de		;0dfe			;
	ld	hl,0fdf6h	;0dff			;
	add	hl,de		;0e02			;
	push	hl		;0e03			;
	ld	l,(ix-10)	;0e04			;
	ld	h,(ix-9) ;l5	;0e07			;
	push	hl		;0e0a			;
	call	strcpy		;0e0b			; strcpy(l5, arr[0]);
	pop	bc		;0e0e			;
	pop	bc		;0e0f			;
	jr	l0e3bh		;0e10			; goto m20;
l0e12h:						; m19:
	ld	l,(ix-8)	;0e12			;
	ld	h,(ix-7) ;l4	;0e15			;
	ld	c,(hl)		;0e18			;
	inc	hl		;0e19			;
	ld	b,(hl)		;0e1a			;
	push	bc	;\	;0e1b			;
	ld	l,(ix-10)	;0e1c			;
	ld	h,(ix-9) ;l5	;0e1f			;
	push	hl	;\	;0e22			;
	call	strcpy		;0e23			; strcpy(l5, *l4);
	pop	bc		;0e26			;
	push	ix		;0e27			;
	pop	de		;0e29			;
	ld	hl,0fdf6h	;0e2a			;
	add	hl,de		;0e2d			;
	ex	(sp),hl		;0e2e			;
	ld	l,(ix-10)	;0e2f			;
	ld	h,(ix-9) ;l5	;0e32			;
	push	hl		;0e35			;
	call	strcat		;0e36			; strcat(l5, arr[0]);
	pop	bc		;0e39			;
	pop	bc		;0e3a			;
l0e3bh:						; m20:
	ld	hl,l5a7ah	;0e3b "r"		;
	push	hl		;0e3e			;
	ld	l,(ix-10)	;0e3f			;
	ld	h,(ix-9) ;l5	;0e42			;
	push	hl		;0e45			;
	call	sub_3f61h	;0e46			;
	pop	bc		;0e49			;
	pop	bc		;0e4a			;
	push	hl		;0e4b\			;
	ld	de,array_9dfe	;0e4c			;
	ld	hl,(word_a626)	;0e4f			;
	inc	hl		;0e52			;
	add	hl,hl		;0e53			;
	add	hl,de		;0e54			;
	pop	de		;0e55/			;
	ld	(hl),e		;0e56			;
	inc	hl		;0e57			;
	ld	(hl),d		;0e58			;
	ld	a,e		;0e59			;
	or	d		;0e5a			;
	jr	z,l0e7ah	;0e5b			; if((array_9dfe[word_a626] = sub_3f61h(l5, "r")) == 0) goto m21;

	ld	(ix-2),1	;0e5d			;
	ld	(ix-1),0 ;l1	;0e61			; l1 = 1;

	ld	de,array_9dfe	;0e65			;
	ld	hl,(word_a626)	;0e68			;
	inc	hl		;0e6b			;
	ld	(word_a626),hl	;0e6c			;
	add	hl,hl		;0e6f			;
	add	hl,de		;0e70			;
	ld	c,(hl)		;0e71			;
	inc	hl		;0e72			;
	ld	b,(hl)		;0e73			;
	ld	(word_58c1),bc	;0e74			; word_58c1 = array_9dfe[++word_a626];
	jr	l0e94h		;0e78			; goto m23;
l0e7ah:							; m21:
	ld	l,(ix-8)	;0e7a			;
	ld	h,(ix-7) ;l4	;0e7d			;
	inc	hl		;0e80			;
	inc	hl		;0e81			;
	ld	(ix-8),l	;0e82			;
	ld	(ix-7),h ;l4	;0e85			; l4++;
l0e88h:							; m22:
	ld	l,(ix-8)	;0e88			;
	ld	h,(ix-7) ;l4	;0e8b			;
	ld	a,(hl)		;0e8e			;
	inc	hl		;0e8f			;
	or	(hl)		;0e90			;
	jp	nz,l0de2h	;0e91			; if(*l4 != *(l4+1)) goto m17;
l0e94h:							; m23:
	ld	a,(ix-2)	;0e94			;
	or	(ix-1) ;l1	;0e97			;
	jr	nz,l0eaah	;0e9a			; if(l1 != 0) goto m24;

	push	ix		;0e9c			;
	pop	de		;0e9e			;
	ld	hl,0fdf6h	;0e9f			;
	add	hl,de		;0ea2			;
	push	hl		;0ea3			;
	ld	hl,l5a7ch	;0ea4			; sub_1ad2h("Can't find include file %s", st+0xFDF6)
	jp	l0d9dh		;0ea7			; goto m12;
l0eaah:							; m24:
	ld	de,array_9a43	;0eaa			;
	ld	hl,(word_a626)	;0ead			;
	add	hl,hl		;0eb0			;
	add	hl,de		;0eb1			;
	ld	de,1		;0eb2			;
	ld	(hl),e		;0eb5			;
	inc	hl		;0eb6			;
	ld	(hl),d		;0eb7			; array_9a43[word_a626] = 1;

	ld	de,array_9b7e	;0eb8			;
	ld	hl,(word_a626)	;0ebb			;
	add	hl,hl		;0ebe			;
	add	hl,de		;0ebf			;
	ld	e,(ix-10)	;0ec0			;
	ld	d,(ix-9) ;l5	;0ec3			;
	ld	(ix-6),e	;0ec6			;
	ld	(ix-5),d ;l3	;0ec9			; l3 = l5;
	ld	(hl),e		;0ecc			;
	inc	hl		;0ecd			;
	ld	(hl),d		;0ece			; array_9b7e[word_a626] = l3;
l0ecfh:							; m25:
	ld	l,(ix-6)	;0ecf			;
	ld	h,(ix-5) ;l3	;0ed2			;
	ld	a,(hl)		;0ed5			;
	inc	hl		;0ed6			;
	ld	(ix-6),l	;0ed7			;
	ld	(ix-5),h ;l3	;0eda			;
	or	a		;0edd			;
	jr	nz,l0ecfh	;0ede			; if(*(l3++) != 0) goto m25;

	ld	(word_58be),hl	;0ee0	; _savch	; word_58be = cp;

	ld	l,(ix-10)	;0ee3			;
	ld	h,(ix-9) ;l5	;0ee6	; nfil		;
	push	hl		;0ee9			;
	call	sub_2242h	;0eea	; _copy		;
	ex	(sp),hl		;0eed			;
	call	sub_21efh	;0eee	; _trmdir	;
	pop	bc		;0ef1			;
	ex	de,hl		;0ef2			;
	ld	(array_9de6),de	;0ef3	; _dirs		;
	push	de		;0ef7\			;
	ld	de,array_a66f	;0ef8	; _dirnams	;
	ld	hl,(word_a626)	;0efb	; _ifno		;
	add	hl,hl		;0efe			;
	add	hl,de		;0eff			;
	pop	de		;0f00/			;
	ld	(hl),e		;0f01			;
	inc	hl		;0f02			;
	ld	(hl),d		;0f03			; array_a66f[word_a626] = trmdir(copy(nfil));
	call	sub_013dh	;0f04	; _sayline	; sub_013dh();
	jr	l0f12h		;0f07			; goto m27;
l0f09h:							; m26:
	push	iy		;0f09			;
	call	sub_0a7bh	;0f0b	; _unfill	;
	pop	bc		;0f0e			;
	push	hl		;0f0f			;
	pop	iy		;0f10			; st = sub_0a7bh(st);
l0f12h:							; m27:
	ld	de,(word_9b92)	;0f12			;
	push	iy		;0f16			;
	pop	hl		;0f18			;
	call	wrelop		;0f19			;
	jr	c,l0f09h	;0f1c			; if(st < word_9b92) goto m26;

	ld	de,array_9e18	;0f1e			;
	ld	hl,(word_a626)	;0f21			;
	add	hl,hl		;0f24			;
	add	hl,de		;0f25			;
	ld	de,(word_a667)	;0f26			;
	ld	(hl),e		;0f2a			;
	inc	hl		;0f2b			;
	ld	(hl),d		;0f2c			; array_9e18[++word_a626] = word_a667;
	jp	l0d83h		;0f2d			; goto m12;

;	End sub_0c59h

; =============== F U N C T I O N =======================================
;
;
sub_0f30h:						; int sub_0f30h(register char * st, int p2, char * p3) {
	call	csv		;0f30			; char l1;
	push	hl		;0f33			; int  l2l
	push	hl		;0f34
	ld	l,(ix+6)	;0f35			;
	ld	h,(ix+7)	;0f38			;
	push	hl		;0f3b			;
	pop	iy		;0f3c			;

	ld	l,(ix+0ah)	;0f3e			;
	ld	h,(ix+0bh) ;p3	;0f41			;
	ld	l,(hl)		;0f44			;
	ld	(ix-1),l ;l1	;0f45			; l1 = *p3;

	ld	l,(ix+0ah)	;0f48			;
	ld	(hl),0		;0f4b			; *p3 = 0;

	ld	l,(ix+8)	;0f4d			;
	ld	h,(ix+9) ;p2	;0f50			;
	push	hl		;0f53			;
	push	iy		;0f54			;
	call	strcmp		;0f56			;
	pop	bc		;0f59			;
	pop	bc		;0f5a			;
	ld	(ix-3),l	;0f5b			;
	ld	(ix-2),h ;l2	;0f5e			; l2 = strcmp(st, p2);

	ld	a,(ix-1) ;l1	;0f61			;
	ld	l,(ix+0ah)	;0f64			;
	ld	h,(ix+0bh) ;p3	;0f67			;
	ld	(hl),a		;0f6a			; *p3 = l1;

	ld	a,(ix-3)	;0f6b			;
	or	(ix-2)    ;l2	;0f6e			;
	ld	hl,1		;0f71			;
	jp	z,cret		;0f74			; if(l2 == 1) return 1;

	dec	hl		;0f77			;
	jp	cret		;0f78			; return 0;

;	End sub_0f30h					; }

; =============== F U N C T I O N =======================================
;
;
sub_0f7bh:						; int sub_0f7bh( register char * st, char * p2) {
	call	ncsv		;0f7b			; int    l1;
	dw	0FFF6H	;-10	;0f7e			; char * l2;
							; char * l3;
	ld	l,(ix+6)	;0f80			; char   l4;
	ld	h,(ix+7)	;0f83			; char   l5;
	push	hl		;0f86			; char * l6;
	pop	iy		;0f87			;
	jr	l0f8dh		;0f89			; goto m2;		
l0f8bh:						; m1:
	inc	iy		;0f8b			; st++;
l0f8dh:						; m2:
	ld	a,(iy+0)	;0f8d			;
	or	a		;0f90			;
	jr	z,l0f9bh	;0f91			; if(*st == 0) goto m3;
	
	cp	9		;0f93
	jr	z,l0f8bh	;0f95			; if(*st == '\t') goto m1;
	
	cp	9		;0f97
	jr	z,l0f8bh	;0f99			; if(*st == '\t') goto m1;
l0f9bh:						; m3:
	ld	(ix-4),0	;0f9b			;
	ld	(ix-3),0 ;l2	;0f9f			; l2 = 0;
	push	iy		;0fa3			;
	pop	hl		;0fa5			;
	ld	(ix-10),l	;0fa6			;
	ld	(ix-9),h ;l6	;0fa9			; l6 = st;
;;-----
	jr	l0fcbh		;0fac			; goto m6;

l0faeh:						; m4:
	ld	l,(ix-10)	;0fae			;
	ld	h,(ix-9) ;l6	;0fb1			;
	ld	a,(hl)		;0fb4			;
	cp	020h ; ' '	;0fb5			; /* hl = l6 */
	jr	z,l0fc4h	;0fb7	; hl = l6	; if(*l6 == ' ') goto m5;

	ld	a,(hl)		;0fb9			;
	cp	9		;0fba			;
	jr	z,l0fc4h	;0fbc			; if(*l6 == '\t') goto m5;

	ld	(ix-4),l	;0fbe			;
	ld	(ix-3),h ;l2	;0fc1	; hl = l2	;				
l0fc4h:						; m5: /* hl = l2 */
	inc	hl		;0fc4			;
	ld	(ix-10),l	;0fc5			;
	ld	(ix-9),h ;l6	;0fc8			; l6 = hl+1;
l0fcbh:						; m6:
	ld	l,(ix-10)	;0fcb			;
	ld	h,(ix-9) ;l6	;0fce			;
	ld	a,(hl)		;0fd1			;
	or	a		;0fd2			;
	jr	nz,l0faeh	;0fd3			; if(*l6 != 0) goto m4;
;;-----
	ld	a,(ix-4)	;0fd5			;
	or	(ix-3) ;l2	;0fd8			;
	jr	z,l1002h	;0fdb			; if(l2 == 0) goto m9;

	ld	l,(ix-4)	;0fdd			;
	ld	h,(ix-3) ;l2	;0fe0			;
	inc	hl		;0fe3			;
	ld	(ix-4),l	;0fe4			;
	ld	(ix-3),h ;l2	;0fe7			;
	ld	l,(hl)		;0fea			;
	ld	(ix-7),l ;l4	;0feb			; l4 = *(++l2);

	ld	l,(ix-4) ;l2	;0fee			;
	ld	(hl),0		;0ff1			; *l2 = 0

	jr	l1002h		;0ff3			; goto m9;
l0ff5h:						; m7:
	ld	l,(ix+8)	;0ff5			;
	ld	h,(ix+9) ;p2	;0ff8			;
l0ffbh:						; m8:
	inc	hl		;0ffb			;
	ld	(ix+8),l	;0ffc			;
	ld	(ix+9),h ;p2	;0fff			; p2++; 
l1002h:						; m9:
	ld	l,(ix+8)	;1002			;
	ld	h,(ix+9) ;p2	;1005			;
	ld	a,(hl)		;1008			;
	or	a		;1009			;
	jr	z,l1016h	;100a			; if(*p2 == 0) goto m10;

	ld	a,(hl)		;100c			;
	cp	9		;100d			;
	jr	z,l0ffbh	;100f			; if(*p2 == '\t') goto m8;

	ld	a,(hl)		;1011			;
	cp	9		;1012			;
	jr	z,l0ff5h	;1014			; if(*p2 == '\t') goto m7;
l1016h:						; m10:
	ld	(ix-6),0	;1016
	ld	(ix-5),0   ;l3	;101a			; l3 = 0;

	ld	l,(ix+8)	;101e			;
	ld	h,(ix+9) ;p2	;1021			;			^
	ld	(ix-10),l	;1024			;			;
	ld	(ix-9),h ;l6	;1027			; l6 = p2;	;-------+ ok

	jr	l1049h		;102a			; goto m13;

l102ch:							; m11:
	ld	l,(ix-10)	;102c			;
	ld	h,(ix-9) ;l6	;102f			;
	ld	a,(hl)		;1032			;
	cp	20h	; ' '	;1033			;
	jr	z,l1042h	;1035			; if(*l6 == ' ') goto m12;

	ld	a,(hl)		;1037			;
	cp	9		;1038			;
	jr	z,l1042h	;103a			; if(*l6 == '\t') goto m12;

	ld	(ix-6),l	;103c			;
	ld	(ix-5),h ;l3	;103f			; l3 = l6;
l1042h:							; m12:
	inc	hl		;1042			;
	ld	(ix-10),l	;1043			;
	ld	(ix-9),h ;l6	;1046			; l6 = l6+1;
l1049h:							; m13:
	ld	l,(ix-10)	;1049			;		;-------+ ok
	ld	h,(ix-9) ;l6	;104c			;			;
	ld	a,(hl)		;104f			;			v
	or	a		;1050			;
	jr	nz,l102ch	;1051			; if(*l6 != 0) goto m11;
    
	ld	a,(ix-6)	;1053			;
	or	(ix-5)   ;l3	;1056			;
	jr	z,l1071h	;1059			; if(l3 == 0) goto m14;
    
	ld	l,(ix-6)	;105b			;
	ld	h,(ix-5) ;l3	;105e			;
	inc	hl		;1061			;
	ld	(ix-6),l	;1062			;
	ld	(ix-5),h ;l3	;1065			; l3++;
    
	ld	l,(hl)		;1068			;
	ld	(ix-8),l ;l5	;1069			; l5 = *l3;

	ld	l,(ix-6) ;l3	;106c			;
	ld	(hl),0		;106f			; *l3 = 0;
l1071h:						; m14:
	ld	l,(ix+8)	;1071			;
	ld	h,(ix+9) ; p2	;1074			;
	push	hl		;1077			;
	push	iy		;1078			;
	call	strcmp		;107a			;
	pop	bc		;107d			;
	pop	bc		;107e			;
	ld	(ix-2),l	;107f			;
	ld	(ix-1),h ;l1	;1082			; l1 = strcmp(st, p2);

	ld	a,(ix-4)	;1085			;
	or	(ix-3)   ;l2	;1088			;
	jr	z,l1097h	;108b			; if(l2 == 0) goto m15;

	ld	a,(ix-7) ;l4	;108d			;
	ld	l,(ix-4)	;1090			;
	ld	h,(ix-3) ;l2	;1093			;
	ld	(hl),a		;1096			; *l2 = l4;
l1097h:						; m15:
	ld	a,(ix-6)	;1097			;
	or	(ix-5)   ;l3	;109a			;
	jr	z,l10a9h	;109d			; if(l3 == 0) goto m16;

	ld	a,(ix-8) ;l5	;109f			;
	ld	l,(ix-6)	;10a2			;
	ld	h,(ix-5) ;l3	;10a5			; *l3 = l5;
	ld	(hl),a		;10a8
l10a9h:						; m16:
	ld	l,(ix-2)	;10a9			;
	ld	h,(ix-1) ;l1	;10ac			;
	jp	cret		;10af			; return l1;

;	End sub_0f7bh					; }

; =============== F U N C T I O N =======================================
; dodef
;							; sub_10b2h() {
							;  	ix+0FFh (ix+-1)  (ix-1h)
							; l1  	ix+0FEh (ix+-2)  (ix-2h) 
							;  	ix+0FDh (ix+-3)  (ix-3h)
							; l2  	ix+0FCh (ix+-4)  (ix-4h) 
							;  	ix+0FBh (ix+-5)  (ix-5h)
							; l3  	ix+0FAh (ix+-6)  (ix-6h) 
							;  	ix+0F9h (ix+-7)  (ix-7h)
							; l4  	ix+0F8h (ix+-8)  (ix-8h) 
							;  	ix+0F7h (ix+-9)  (ix-9h)
							; l5  	ix+0F6h (ix+-10) (ix-Ah) 
							;	ix+0F5h (ix+-11) (ix-Bh)
							; l6  	ix+0F4h (ix+-12) (ix-Ch) 
							;	ix+0F3h (ix+-13) (ix-Dh)
							; l7	ix+0F2h (ix+-14) (ix-Eh) 
							;	ix+0F1h (ix+-15) (ix-Fh)
							; l8	ix+0F0h (ix+-16) (ix-10h)
							; l9	ix+0EFh (ix+-17) (ix-11h)
							;	ix+0EEh (ix+-18) (ix-12h)
							; l10	ix+0EDh (ix+-19) (ix-13h)
							;	ix+0ECh (ix+-20) (ix-14h)
							; l11	ix+0EBh (ix+-21) (ix-15h)	
sub_10b2h:
	call	ncsv		;10b2
	DW	0FDADH	; -595	;10b5

	ld	de,(word_58be)	;10b7			;
	ld	hl,09405h	;10bb			;
	call	wrelop		;10be			;
	jr	nc,l10d4h	;10c1			; if(0x9405 >= word_58be) goto m2;

	ld	hl,l5a97h	;10c3			;	    
	push	hl		;10c6			;
	call	sub_1ad2h	;10c7			; sub_1ad2h("too much\tdefining");
	pop	bc		;10ca			;
l10cbh:						; m1:
	ld	l,(ix+6)	;10cb			;
	ld	h,(ix+7)   ;p1	;10ce			; return p1;
	jp	cret		;10d1			;
l10d4h:						; m2:
	ld	hl,(word_58be)	;10d4			;
	ld	(ix-15h),l	;10d7			;
	ld	(ix-14h),h ;l11 ;10da			; l11 = word_58be;

	ld	hl,(word_9cae)	;10dd			;
	inc	hl		;10e0			;
	ld	(word_9cae),hl	;10e1			; word_9cae++;

	ld	l,(ix+6)	;10e4			;
	ld	h,(ix+7)  ;p1	;10e7			;
	push	hl		;10ea			;
	call	sub_0a47h	;10eb			;
	pop	bc		;10ee			;
	ld	(ix+6),l	;10ef			;
	ld	(ix+7),h  ;p1	;10f2			; p1 = sub_0a47h(p1);

	ld	iy,(word_a685)	;10f5			; st = word_a685;

	ld	a,(iy+0)	;10f9			;
	ld	e,a		;10fc			;
	rla			;10fd			;
	sbc	a,a		;10fe			;
	ld	d,a		;10ff			;
	ld	hl,array_9c14	;1100			;
	add	hl,de		;1103			;
	ld	a,(hl)		;1104			;
	cp	2		;1105			;
	jr	z,l112eh	;1107			; if(array_9c14[*st] == 2) goto m5;

	ld	hl,l5aa9h	;1109 			;
	push	hl		;110c			;
	call	sub_1b67h	;110d			; sub_1b67h("illegal\tmacro name");
	pop	bc		;1110			;
	jr	l1124h		;1111			; goto m4;
l1113h:						; m3:
	ld	l,(ix+6)	;1113			;
	ld	h,(ix+7) ;p1	;1116			;
	push	hl		;1119			;
	call	sub_0a47h	;111a			;
	pop	bc		;111d			;
	ld	(ix+6),l	;111e			;
	ld	(ix+7),h ;p1	;1121			; p1 = sub_0a47h(p1);
l1124h:						; m4:
	ld	hl,(word_a685)	;1124			;
	ld	a,(hl)		;1127			;
	cp	0ah		;1128			;
	jr	nz,l1113h	;112a			; if(*word_a685 != 0xA) goto m3;
	jr	l10cbh		;112c			; goto m1;
l112eh:						; m5:
	ld	hl,1		;112e			;
	push	hl		;1131			;
	ld	l,(ix+6)	;1132			;
	ld	h,(ix+7) ;p1	;1135			;
	push	hl		;1138			;
	push	iy		;1139			;
	call	sub_1d22h	;113b			; 
	pop	bc		;113e			;
	pop	bc		;113f			;
	pop	bc		;1140			;
	ld	(ix-010h),l	;1141			;
	ld	(ix-00fh),h ;l8	;1144			; l8 = sub_1d22h(st, p1, 1);

	inc	hl		;1147			;
	inc	hl		;1148			;
	ld	c,(hl)		;1149			;
	inc	hl		;114a			;
	ld	b,(hl)		;114b			;
	ld	(ix-013h),c	;114c			;
	ld	(ix-012h),b ;l10;114f			; 
	ld	a,c		;1152			;
	or	b		;1153			;
	jr	z,l115fh	;1154			; if((l10 = *(l8+2)) == 0) goto m6;

	ld	l,(ix-015h)	;1156			;
	ld	h,(ix-014h) ;l11;1159			;
	ld	(word_58be),hl	;115c			; word_58be = l11;
l115fh:						; m6:
	ld	(ix-10),1	;115f			;
	ld	(ix-9),0 ;l5	;1163			; l5 = 1;

	push	iy		;1167			;
	pop	hl		;1169			;
	ld	(ix-4),l	;116a			;
	ld	(ix-3),h ;l2	;116d			; l2 = st;
	jr	l11a5h		;1170			; goto m8;
l1172h:						; m7:
	ld	l,(ix-4)	;1172			;
	ld	h,(ix-3) ;l2	;1175			;
	ld	a,(hl)		;1178			;
	inc	hl		;1179			;
	ld	(ix-4),l	;117a			;
	ld	(ix-3),h ;l2	;117d			;
	ld	l,a		;1180			;
	rla			;1181			;
	sbc	a,a		;1182			;
	ld	h,a		;1183			;
	ld	(ix-12),l	;1184			;
	ld	(ix-11),h ;l6	;1187			; l6 = *(l2++);
	
	ex	de,hl		;118a			;
	ld	hl,word_9af3	;118b			;
	add	hl,de		;118e			;
	ld	a,(hl)		;118f			;
	or	(ix-10)		;1190			;
	ld	(hl),a		;1193			; *(word_9af3 + l6) |= (char)l5;

	ld	e,(ix-10)	;1194			;
	ld	d,(ix-9) ;l5	;1197			;
	ld	l,e		;119a			;
	ld	h,d		;119b			;
	add	hl,de		;119c			;
	xor	a		;119d			;
	ld	h,a		;119e			;
	ld	(ix-10),l	;119f			;
	ld	(ix-9),h ;l5	;11a2			; l5 = (unsigned)(l5*2);
l11a5h:						; m8:
	ld	e,(ix+6)	;11a5			;
	ld	d,(ix+7) ;p1	;11a8			;
	ld	l,(ix-4)	;11ab			;
	ld	h,(ix-3) ;l2	;11ae			;
	call	wrelop		;11b1			;
	jr	c,l1172h	;11b4			; if(l2 < p1) goto m7;

	ld	(ix-0eh),0	;11b6			;
	ld	(ix-0dh),0 ;l7	;11ba			; l7 = 0;

	ld	l,(ix+6)	;11be			;
	ld	h,(ix+7) ;p1	;11c1			;
	ld	(word_a685),hl	;11c4			;
	ld	(word_a66b),hl	;11c7			; word_a66b = (word_a685 = p1);

	ld	l,(ix+6)	;11ca			;
	ld	h,(ix+7) ;p1	;11cd			;
	push	hl		;11d0			;
	call	sub_0465h	;11d1			;
	pop	bc		;11d4			;
	ld	(ix+6),l	;11d5			;
	ld	(ix+7),h ;p1	;11d8			; p1 = sub_0465h(p1);

	ld	iy,(word_a685)	;11db			; st = word_a685;

	ld	a,(iy+0)	;11df			;
	cp	028h	;'('	;11e2			;
	jp	nz,l133fh	;11e4			; if(*st != '(') goto m17;

	push	ix		;11e7			;
	pop	de		;11e9			;
	ld	hl,0fdadh	;11ea			;
	add	hl,de		;11ed			;
	ld	(ix-4),l	;11ee			;
	ld	(ix-3),h ;l2	;11f1			; l2 = arr;

	push	ix		;11f4			;
	pop	de		;11f6			;
	ld	hl,0ffadh	;11f7			;
	add	hl,de		;11fa			;
	ld	(ix-6),l	;11fb			;
	ld	(ix-5),h ;l3	;11fe			; l3 = arr;
l1201h:						; m9:
	ld	l,(ix+6)	;1201			;
	ld	h,(ix+7) ;p1	;1204			;
	push	hl		;1207			;
	call	sub_0a47h	;1208			;
	pop	bc		;120b			;
	ld	(ix+6),l	;120c			;
	ld	(ix+7),h ;p1	;120f			; p1 = sub_0a47h(p1);

	ld	iy,(word_a685)	;1212			; st = word_a685;

	ld	a,(iy+0)	;1216			;
	cp	0ah		;1219			;
	jp	nz,l1266h	;121b			; if(*st != 0xA) goto m11;

	ld	de,array_9a43	;121e			;
	ld	hl,(word_a626)	;1221			;
	add	hl,hl		;1224			;
	add	hl,de		;1225			;
	ld	c,(hl)		;1226			;
	inc	hl		;1227			;
	ld	b,(hl)		;1228			;
	dec	bc		;1229			;
	ld	(hl),b		;122a			;
	dec	hl		;122b			;
	ld	(hl),c		;122c			; array_9a43[word_a626]--;

	ld	l,(ix+6)	;122d			;
	ld	h,(ix+7) ;p1	;1230			;
	dec	hl		;1233			;
	ld	(ix+6),l	;1234			;
	ld	(ix+7),h ;p1	;1237			; p1--;

	ld	l,(ix-010h)	;123a			;
	ld	h,(ix-00fh) ;l8	;123d			;
	ld	c,(hl)		;1240			;
	inc	hl		;1241			;
	ld	b,(hl)		;1242			;
	push	bc		;1243			;
	ld	hl,l5abch	;1244			;
	push	hl		;1247			;
	call	sub_1ad2h	;1248			; sub_1ad2h("%s: missing )", *l8);
	pop	bc		;124b			;
	pop	bc		;124c			;
l124dh:						; m10:
	ld	a,(ix-00eh)	;124d			;
	or	(ix-00dh) ;l7	;1250			;
	jp	nz,l1362h	;1253			; if(l7 != 0) goto m18;

	ld	l,(ix-00eh)	;1256			;
	ld	h,(ix-00dh)	;1259			;
	dec	hl		;125c			;
	ld	(ix-00eh),l	;125d			;
	ld	(ix-00dh),h	;1260			; l7--;
	jp	l1362h		;1263			; goto m18;
l1266h:						; m11:
	ld	a,(iy+0)	;1266			;
	cp	029h		;1269			;
	jr	z,l124dh	;126b			; if(*st == ')') goto m10;

	cp	02ch		;126d			;
	jr	z,l1201h	;126f			; if(*st == ',') goto m9;

	ld	e,a		;1271			;
	rla			;1272			;
	sbc	a,a		;1273			;
	ld	d,a		;1274			;
	ld	hl,array_9c14	;1275			;
	add	hl,de		;1278			;
	ld	a,(hl)		;1279			;
	cp	2		;127a			;
	jr	z,l12afh	;127c			; if(array_9c14[*st] == 2) goto m13;

	ld	l,(ix+6)	;127e			;
	ld	h,(ix+7) ;p1	;1281			;
	ld	a,(hl)		;1284			;
	ld	l,a		;1285			;
	rla			;1286			;
	sbc	a,a		;1287			;
	ld	h,a		;1288			;
	ld	(ix-12),l	;1289			;
	ld	(ix-11),h ;l6	;128c			; l6 = *p1;

	ld	l,(ix+6)	;128f			;
	ld	h,(ix+7) ;p1	;1292			;
	ld	(hl),0		;1295			; *p1 = 0;
	push	iy		;1297			;
	ld	hl,l5acah	;1299 			;
l129ch:						; m12:
	push	hl		;129c
	call	sub_1ad2h	;129d			; sub_1ad2h ("bad formal: %s", st);
	pop	bc		;12a0			;
	pop	bc		;12a1			;
							; m121:
	ld	a,(ix-12)	;12a2			;
	ld	l,(ix+6)	;12a5			;
	ld	h,(ix+7) ;p1	;12a8			;
	ld	(hl),a		;12ab			; *p1 = l6;
	jp	l1201h		;12ac			; goto m9;
l12afh:						; m13:
	push	ix		;12af			;
	pop	de		;12b1			;
	ld	hl,0ffebh	;12b2			;
	add	hl,de		;12b5			;
	ex	de,hl		;12b6			;
	ld	l,(ix-6)	;12b7			;
	ld	h,(ix-5) ;l3	;12ba			;
	call	wrelop		;12bd			;
	jr	c,l12e2h	;12c0			; if(l3 < arr) goto m14;

	ld	l,(ix+6)	;12c2			;
	ld	h,(ix+7) ;p1	;12c5			;
	ld	a,(hl)		;12c8			;
	ld	l,a		;12c9			;
	rla			;12ca			;
	sbc	a,a		;12cb			;
	ld	h,a		;12cc			;
	ld	(ix-12),l	;12cd			;
	ld	(ix-11),h ;l6	;12d0			; l6 = *p1;

	ld	l,(ix+6)	;12d3			;
	ld	h,(ix+7) ;p1	;12d6			;
	ld	(hl),0		;12d9			;
	push	iy		;12db			;
	ld	hl,l5ad9h	;12dd			; sub_1ad2h("too many formals: %s", p1);
	jr	l129ch		;12e0			; goto m121;
l12e2h:						; m14:
	ld	e,(ix-4)	;12e2			;
	ld	d,(ix-3) ;l2	;12e5			;
	ld	l,(ix-6)	;12e8			;
	ld	h,(ix-5) ;l3	;12eb			;
	inc	hl		;12ee			;
	inc	hl		;12ef			;
	ld	(ix-6),l	;12f0			;
	ld	(ix-5),h ;l3	;12f3			;
	dec	hl		;12f6			;
	dec	hl		;12f7			;
	ld	(hl),e		;12f8			;
	inc	hl		;12f9			;
	ld	(hl),d		;12fa			; *(l3++) = l2;
	jr	l1311h		;12fb			; goto m16;
l12fdh:						; m15:
	ld	a,(iy+0)	;12fd			;
	ld	l,(ix-4)	;1300			;
	ld	h,(ix-3) ;l2	;1303			;
	inc	hl		;1306			;
	ld	(ix-4),l	;1307			;
	ld	(ix-3),h ;l2	;130a			;
	dec	hl		;130d			;
	ld	(hl),a		;130e			; *(l2++) = *sp;
	inc	iy		;130f			; sp++;
l1311h:						; m16:
	ld	e,(ix+6)	;1311			;
	ld	d,(ix+7) ;p1	;1314			;
	push	iy		;1317			;
	pop	hl		;1319			;
	call	wrelop		;131a			;
	jr	c,l12fdh	;131d			; if(st < p1) goto m15;

	ld	l,(ix-4)	;131f			;
	ld	h,(ix-3) ;l2	;1322			;
	inc	hl		;1325			;
	ld	(ix-4),l	;1326			;
	ld	(ix-3),h ;l2	;1329			;
	dec	hl		;132c			;
	ld	(hl),0		;132d			; *(l2++) = 0;

	ld	l,(ix-0eh)	;132f			;
	ld	h,(ix-0dh)	;1332			;
	inc	hl		;1335			;
	ld	(ix-0eh),l	;1336			;
	ld	(ix-0dh),h	;1339			; l7++;
	jp	l1201h		;133c			; goto m9;
l133fh:						; m17:
	ld	a,(iy+0)	;133f			;
	cp	0ah		;1342			;
	jr	nz,l1362h	;1344			; if(*st != 0xA) goto m18;

	ld	de,array_9a43	;1346			;
	ld	hl,(word_a626)	;1349			;
	add	hl,hl		;134c			;
	add	hl,de		;134d			;
	ld	c,(hl)		;134e			;
	inc	hl		;134f			;
	ld	b,(hl)		;1350			;
	dec	bc		;1351			;
	ld	(hl),b		;1352			;
	dec	hl		;1353			;
	ld	(hl),c		;1354			; array_9a43[word_a626]--;

	ld	l,(ix+6)	;1355			;
	ld	h,(ix+7) ;p1	;1358			;
	dec	hl		;135b			;
	ld	(ix+6),l	;135c			;
	ld	(ix+7),h ;p1	;135f			; p1--;
l1362h:						; m18:
	ld	hl,(word_58be)	;1362	; _savch	;
	ld	(ix-2),l	;1365			;
	ld	(ix-1),h ;l1	;1368	; psav		;
	ld	(ix-015h),l	;136b			;
	ld	(ix-014h),h ;l11;136e	; oldsavch	; oldsavch = psav = savch;

	ld	hl,1		;1371			;
	ld	(word_9cb2),hl	;1374			; word_9cb2 = 1;
l1377h:						; m19:
	ld	l,(ix+6)	;1377			;
	ld	h,(ix+7) ;p1	;137a			;
	ld	(word_a685),hl	;137d			;
	ld	(word_a66b),hl	;1380			; outp = inp = p;

	ld	l,(ix+6)	;1383			;
	ld	h,(ix+7) ;p1	;1386			;
	push	hl		;1389			;
	call	sub_0465h	;138a	; cotoken	;
	pop	bc		;138d			;
	ld	(ix+6),l	;138e			;
	ld	(ix+7),h ;p1	;1391			; p = cotoken(p);

	ld	iy,(word_a685)	;1394			; pin = inp;
	ld	a,(iy+0)	;1398			;
	cp	05ch		;139b			;
	jr	nz,l13a6h	;139d			; if(*st != '\\') goto m20;

	ld	a,(iy+1)	;139f			;
	cp	0ah		;13a2			;
	jr	z,l1377h	;13a4			; if(*(st+1) == '\n') goto m19;
l13a6h:						; m20:
	ld	a,(iy+0)	;13a6			;
	cp	0ah		;13a9			;
	ld	a,(ix-0eh)	;13ab			;
	jp	z,l15c2h	;13ae			; if(*st == == '\n') goto m351;

	or	(ix-0dh)	;13b1
	jp	z,l15b1h	;13b4			; if(l7 == 0) goto m35;

	ld	a,(iy+0)	;13b7			;
	ld	e,a		;13ba			;
	rla			;13bb			;
	sbc	a,a		;13bc			;
	ld	d,a		;13bd			;
	ld	hl,array_9c14	;13be			;
	add	hl,de		;13c1			;
	ld	a,(hl)		;13c2			;
	cp	2		;13c3			;
	jp	nz,l144ch	;13c5			; if(array_9c14[*st] != 2) goto m22;

	ld	l,(ix-6)	;13c8			;
	ld	h,(ix-5) ;l3	;13cb			;
	ld	(ix-8),l	;13ce			;
	ld	(ix-7),h ;l4	;13d1			; l4 = l3;

	push	ix		;13d4			;
	pop	de		;13d6			;
	ld	hl,0ffadh	;13d7			;
l13dah:						; m21:
	add	hl,de		;13da			;
	ex	de,hl		;13db			;
	ld	l,(ix-8)	;13dc			;
	ld	h,(ix-7) ;l4	;13df			;
	dec	hl		;13e2			;
	dec	hl		;13e3			;
	ld	(ix-8),l	;13e4			;
	ld	(ix-7),h ;l4	;13e7			;
	call	wrelop		;13ea			;
	jp	c,l15b1h	;13ed			; if(--l4 < arr) goto m35;

	ld	l,(ix+6)	;13f0			;
	ld	h,(ix+7) ;p1	;13f3			;
	push	hl		;13f6\			;
	push	iy		;13f7\			;
	ld	l,(ix-8)	;13f9			;
	ld	h,(ix-7) ;l4	;13fc			;
	ld	c,(hl)		;13ff			;
	inc	hl		;1400			;
	ld	b,(hl)		;1401			;
	push	bc		;1402\			;
	call	sub_0f30h	;1403			;
	pop	bc		;1406			;
	pop	bc		;1407			;
	pop	bc		;1408			;
	ld	a,l		;1409			;
	or	h		;140a			;
	push	ix		;140b			;
	pop	de		;140d			;
	ld	hl,0ffadh	;140e			;
	jr	z,l13dah	;1411			; if(sub_0f30h(*l4, st, p1) == 0) goto m21;

	add	hl,de		;1413			;
	ex	de,hl		;1414 de = arr		;
	ld	l,(ix-8)	;1415			;
	ld	h,(ix-7) ;l4	;1418			;
	or	a		;141b			;
	sbc	hl,de		;141c l4-arr		;
	ld	de,2		;141e			;
	call	adiv		;1421 (l4-arr)\2-1	;
	inc	hl		;1424			;
	ld	a,l		;1425			;
	ld	l,(ix-2)	;1426			;
	ld	h,(ix-1) ;l1	;1429			;
	inc	hl		;142c			;
	ld	(ix-2),l	;142d			;
	ld	(ix-1),h ;l1	;1430			;
	dec	hl		;1433			;
	ld	(hl),a		;1434			; *(l1++) = ((l4-arr)+1);
	inc	hl		;1435			;
	inc	hl		;1436			;
	ld	(ix-2),l	;1437			;
	ld	(ix-1),h ;l1	;143a			; l1 += 1;
	dec	hl		;143d			;
	ld	(hl),0feh	;143e			; *(l1-1) = 0xFE;

	ld	l,(ix+6)	;1440			;
	ld	h,(ix+7) ;p1	;1443			;
	push	hl		;1446			;
	pop	iy		;1447			; st = p1;
	jp	l15b1h		;1449			; goto m35;
l144ch:						; m22:
	ld	a,(iy+0)	;144c			;
	cp	022h		;144f			;
	jr	z,l1458h	;1451			; if(*st == 0x22) goto m23;
	cp	027h		;1453			;
	jp	nz,l15b1h	;1455			; if(*st != 0x27) goto m35;
l1458h:						; m23:
	ld	(ix-011h),a ;l9	;1458			; l9 = *st;

	ld	a,(iy+0)	;145b			;
	ld	l,(ix-2)	;145e			;
	ld	h,(ix-1) ;l1	;1461			;
	inc	hl		;1464			;
	ld	(ix-2),l	;1465			;
	ld	(ix-1),h ;l1	;1468			;
	dec	hl		;146b			;
	ld	(hl),a		;146c			; *(l1++) = *st;
	inc	iy		;146d			; st++;
	jp	l1584h		;146f			; goto m33;
l1472h:						; m24:
	ld	a,(iy+0)	;1472			;
	ld	l,(ix-2)	;1475			;
	ld	h,(ix-1) ;l1	;1478			;
	inc	hl		;147b			;
	ld	(ix-2),l	;147c			;
	ld	(ix-1),h ;l1	;147f			;
	dec	hl		;1482			;
	ld	(hl),a		;1483			; *(l1++) = *st;
	inc	iy		;1484			; st++;
l1486h:						; m25:
	ld	e,(ix+6)	;1486			;
	ld	d,(ix+7) ;p1	;1489			;
	push	iy		;148c			;
	pop	hl		;148e			;
	call	wrelop		;148f			;
	jr	nc,l14a3h	;1492			; if(st >= p1) goto m26;

	ld	a,(iy+0)	;1494			;
	ld	e,a		;1497			;
	rla			;1498			;
	sbc	a,a		;1499			;
	ld	d,a		;149a			;
	ld	hl,array_9d3e	;149b			; 
	add	hl,de		;149e			;
	bit	0,(hl)		;149f			;
	jr	z,l1472h	;14a1			; if(bittst(array_9d3e + *st, 0) == 0) goto m24;
l14a3h:						; m26:
	push	iy		;14a3			;
	pop	hl		;14a5			;
	ld	(ix-4),l	;14a6			;
	ld	(ix-3),h ;l2	;14a9			; l2 = st;
	jr	l14bbh		;14ac			; goto m28;
l14aeh:						; m27:
	ld	l,(ix-4)	;14ae			;
	ld	h,(ix-3) ;l2	;14b1			;
	inc	hl		;14b4			;
	ld	(ix-4),l	;14b5			;
	ld	(ix-3),h ;l2	;14b8			; l2++;
l14bbh:						; m28:
	ld	e,(ix+6)	;14bb			;
	ld	d,(ix+7) ;p1	;14be			;
	ld	l,(ix-4)	;14c1			;
	ld	h,(ix-3) ;l2	;14c4			;
	call	wrelop		;14c7			;
	jr	nc,l14dfh	;14ca			; if(l2 >= p1) goto m29;

	ld	l,(ix-4)	;14cc			;
	ld	h,(ix-3) ;l2	;14cf			;
	ld	a,(hl)		;14d2			;
	ld	e,a		;14d3			;
	rla			;14d4			;
	sbc	a,a		;14d5			;
	ld	d,a		;14d6			;
	ld	hl,array_9d3e	;14d7			;
	add	hl,de		;14da			;
	bit	0,(hl)		;14db			;
	jr	nz,l14aeh	;14dd			; if(bittst(array_9d3e + *l2, 0) != 0) goto m27;
l14dfh:						; m29:
	ld	l,(ix-6)	;14df			;
	ld	h,(ix-5) ;l3	;14e2			;
	ld	(ix-8),l	;14e5			;
	ld	(ix-7),h ;l4	;14e8			; l4 = l3;

	push	ix		;14eb			;
	pop	de		;14ed			;
	ld	hl,0ffadh	;14ee			;
l14f1h:						; m30:
	add	hl,de		;14f1			;
	ex	de,hl		;14f2			;
	ld	l,(ix-8)	;14f3			;
	ld	h,(ix-7) ;l4	;14f6			;
	dec	hl		;14f9			;
	dec	hl		;14fa			;
	ld	(ix-8),l	;14fb			;
	ld	(ix-7),h ;l4	;14fe			;
	call	wrelop		;1501			;
	jp	c,l1576h	;1504			; if(--l4 < arr) goto m32;

	ld	l,(ix-4)	;1507			;
	ld	h,(ix-3) ;l2	;150a			;
	push	hl		;150d\			;
	push	iy		;150e\			;
	ld	l,(ix-8)	;1510			;
	ld	h,(ix-7) ;l4	;1513			;
	ld	c,(hl)		;1516			;
	inc	hl		;1517			;
	ld	b,(hl)		;1518			;
	push	bc		;1519\			;
	call	sub_0f30h	;151a			;
	pop	bc		;151d			;
	pop	bc		;151e			;
	pop	bc		;151f			;
	ld	a,l		;1520			;
	or	h		;1521			;
	push	ix		;1522			;
	pop	de		;1524			;
	ld	hl,0ffadh	;1525			;
	jr	z,l14f1h	;1528			; if(sub_0f30h(*l4, st, l2) == 0) goto m30;

	add	hl,de		;152a			;
	ex	de,hl		;152b			;
	ld	l,(ix-8)	;152c			;
	ld	h,(ix-7) ;l4	;152f			;
	or	a		;1532			;
	sbc	hl,de		;1533			;
	ld	de,2		;1535			;
	call	adiv		;1538			;
	inc	hl		;153b			;
	ld	a,l		;153c			;
	ld	l,(ix-2)	;153d			;
	ld	h,(ix-1) ;l1	;1540			;
	inc	hl		;1543			;
	ld	(ix-2),l	;1544			;
	ld	(ix-1),h ;l1	;1547			;
	dec	hl		;154a			;
	ld	(hl),a		;154b			; *(l1++) = (char)((l4-arr)*2-1);
	inc	hl		;154c			;
	inc	hl		;154d			;
	ld	(ix-2),l	;154e			;
	ld	(ix-1),h ;l1	;1551			; l1 += 2;
	dec	hl		;1554			;
	ld	(hl),0feh	;1555			; *(l1-1) = 0xFE;

	ld	l,(ix-4)	;1557			;
	ld	h,(ix-3) ;l2	;155a			;
	push	hl		;155d			;
	pop	iy		;155e			; st = l2;
	jr	l1576h		;1560			; goto m32;
l1562h:						; m31:
	ld	a,(iy+0)	;1562			;
	ld	l,(ix-2)	;1565			;
	ld	h,(ix-1) ;l1	;1568			;
	inc	hl		;156b			;
	ld	(ix-2),l	;156c			;
	ld	(ix-1),h ;l1	;156f			;
	dec	hl		;1572			;
	ld	(hl),a		;1573			; *(l1++) = *st;
	inc	iy		;1574			; st++;
l1576h:						; m32:
	ld	e,(ix-4)	;1576			;
	ld	d,(ix-3) ;l2	;1579			;
	push	iy		;157c			;
	pop	hl		;157e			;
	call	wrelop		;157f			;
	jr	c,l1562h	;1582			; if(st < l2) goto m31;
l1584h:						; m33:
	ld	e,(ix+6)	;1584			;
	ld	d,(ix+7) ;p1	;1587			;
	push	iy		;158a			;
	pop	hl		;158c			;
	call	wrelop		;158d			;
	jr	nc,l15b1h	;1590			; if(st >= p1) goto m35;

	ld	a,(iy+0)	;1592			;
	cp	(ix-011h) ;l9	;1595			;
	jp	nz,l1486h	;1598			; if(*st != *l9) goto m25;
	jr	l15b1h		;159b			; goto m35;
l159dh:						; m34:
	ld	a,(iy+0)	;159d			;
	ld	l,(ix-2)	;15a0			;
	ld	h,(ix-1) ;l1	;15a3			;
	inc	hl		;15a6			;
	ld	(ix-2),l	;15a7			;
	ld	(ix-1),h ;l1	;15aa			;
	dec	hl		;15ad			;
	ld	(hl),a		;15ae			; *(l1++) = *st; /* ra = *st */
	inc	iy		;15af			; st++;
l15b1h:						; m35:
	ld	e,(ix+6)	;15b1			;
	ld	d,(ix+7) ;p1	;15b4			;
	push	iy		;15b7			;
	pop	hl		;15b9			;
	call	wrelop		;15ba			;
	jr	c,l159dh	;15bd			; if(st < p1) goto m34;
	jp	l1377h		;15bf			; goto m19;
l15c2h:						; m351:
	ld	l,(ix-2)	;15c2			;
	ld	h,(ix-1) ;l1	;15c5			;
	inc	hl		;15c8			;
	ld	(ix-2),l	;15c9			;
	ld	(ix-1),h ;l1	;15cc			;
	dec	hl		;15cf			;
	ld	(hl),a		;15d0			; *(l1++) = ra; ?????

	inc	hl		;15d1			;
	inc	hl		;15d2			;
	ld	(ix-2),l	;15d3			;
	ld	(ix-1),h ;l1	;15d6			; l1 += 2;

	dec	hl		;15d9			;
	ld	(hl),0		;15da			; *(l1-1) = 0;

	ld	hl,0		;15dc			;
	ld	(word_9cb2),hl	;15df			; word_9cb2 = 0;

	ld	l,(ix-013h)	;15e2			;
	ld	h,(ix-012h) ;l10;15e5			;
	ld	(ix-4),l	;15e8			;
	ld	(ix-3),h ;l2	;15eb			; l2 = l10;

	ld	a,l		;15ee			;
	or	h		;15ef			;
	jp	z,l1683h	;15f0			; if(l2 == 0) goto m38;

	ld	l,(ix-4)	;15f3			;
	ld	h,(ix-3) ;l2	;15f6			;
	dec	hl		;15f9			;
	ld	(ix-4),l	;15fa			;
	ld	(ix-3),h  ;l2	;15fd			; l2--;
l1600h:						; m36:
	ld	l,(ix-4)	;1600			;
	ld	h,(ix-3)  ;l2	;1603			;
	dec	hl		;1606			;
	ld	(ix-4),l	;1607			;
	ld	(ix-3),h  ;l2	;160a			;
	ld	a,(hl)		;160d			;
	or	a		;160e			;
	jr	nz,l1600h	;160f			; if(*(--l2) != 0) goto m36;

	ld	l,(ix-015h)	;1611			;
	ld	h,(ix-014h) ;l11;1614			;
	push	hl		;1617			;
	ld	l,(ix-4)	;1618			;
	ld	h,(ix-3)  ;l2	;161b			;
	inc	hl		;161e			;
	ld	(ix-4),l	;161f			;
	ld	(ix-3),h  ;l2	;1622			;
	push	hl		;1625			;
	call	sub_0f7bh	;1626			;
	pop	bc		;1629			;
	pop	bc		;162a			;
	ld	a,l		;162b			;
	or	h		;162c			;
	jp	z,l1675h	;162d			; if(sub_0f7bh(++l2, l11) == 0) goto m37;

	ld	de,array_9a43	;1630			;
	ld	hl,(word_a626)	;1633			;
	add	hl,hl		;1636			;
	add	hl,de		;1637			;
	ld	c,(hl)		;1638			;
	inc	hl		;1639			;
	ld	b,(hl)		;163a			;
	dec	bc		;163b			;
	ld	(hl),b		;163c			;
	dec	hl		;163d			;
	ld	(hl),c		;163e			; array_9a43[word_a626]--;

	ld	l,(ix-010h)	;163f			;
	ld	h,(ix-00fh) ;l8	;1642			;
	ld	c,(hl)		;1645			;
	inc	hl		;1646			;
	ld	b,(hl)		;1647			;
	push	bc		;1648			;
	ld	hl,l5aeeh	;1649			;
	push	hl		;164c			;
	call	sub_1b67h	;164d			; sub_1b67h("%s redefined", *l8);
	pop	bc		;1650			;
	pop	bc		;1651			;

	ld	de,array_9a43	;1652			;
	ld	hl,(word_a626)	;1655			;
	add	hl,hl		;1658			;
	add	hl,de		;1659			;
	ld	c,(hl)		;165a			;
	inc	hl		;165b			;
	ld	b,(hl)		;165c			;
	inc	bc		;165d			;
	ld	(hl),b		;165e			;
	dec	hl		;165f			;
	ld	(hl),c		;1660			; array_9a43[word_a626]++;

	ld	e,(ix-2)	;1661			;
	ld	d,(ix-1)    ;l1	;1664			;
	dec	de		;1667			;
	ld	l,(ix-010h)	;1668			;
	ld	h,(ix-00fh) ;l8	;166b			;
	inc	hl		;166e			;
	inc	hl		;166f			;
	ld	(hl),e		;1670			;
	inc	hl		;1671			;
	ld	(hl),d		;1672			; *(l8+1) = l1-1;
	jr	l1695h		;1673			; goto m39;
l1675h:						; m37:
	ld	l,(ix-015h)	;1675			;
	ld	h,(ix-014h) ;l11;1678			;
	ld	(ix-2),l	;167b			;
	ld	(ix-1),h    ;l1	;167e			; l1 = l11;
	jr	l1695h		;1681			; goto m39;
l1683h:						; m38:
	ld	e,(ix-2)	;1683			;
	ld	d,(ix-1)    ;l1	;1686			;
	dec	de		;1689			;
	ld	l,(ix-010h)	;168a			;
	ld	h,(ix-00fh) ;l8	;168d			;
	inc	hl		;1690			;
	inc	hl		;1691			;
	ld	(hl),e		;1692			;
	inc	hl		;1693			;
	ld	(hl),d		;1694			; *(l8+1) = l1-1;
l1695h:						; m39:
	ld	hl,(word_9cae)	;1695			;
	dec	hl		;1698			;
	ld	(word_9cae),hl	;1699			; word_9cae--;

	ld	(word_a685),iy	;169c			; word_a685 = st;

	ld	l,(ix-2)	;16a0			;
	ld	h,(ix-1)   ;l1	;16a3			;
	ld	(word_58be),hl	;16a6			; word_58be = l1;
	jp	l10cbh		;16a9			; goto m1;

;	End sub_10b2h

; =============== F U N C T I O N =======================================
;
;	control
;
sub_16ach:						; sub_16ach(register char * st) {
	call	csv		;16ac			; char * l1;
	push	hl		;16af
	ld	l,(ix+6)	;16b0			;
	ld	h,(ix+7)	;16b3			;
	push	hl		;16b6			;
	pop	iy		;16b7			;
l16b9h:						; m1:
	ld	hl,array_9d3e	;16b9  ; _fastab
	ld	(word_9dfc),hl	;16bc  ; _ptrtab	; word_9dfc = array_9d3e;

	push	iy		;16bf			;
	call	sub_0465h	;16c1  ; _cotoken	;
	pop	bc		;16c4			;
	push	hl		;16c5			;
	pop	iy		;16c6			; st = cotoken(st);

	ld	hl,(word_a685)	;16c8  ; _inp		;
	ld	a,(hl)		;16cb			;
	cp	0ah	;'\n'	;16cc			;
	jr	nz,l16d4h	;16ce			; if(*(word_a685++) != '\n') goto m2;

	inc	hl		;16d0			;
	ld	(word_a685),hl	;16d1  ; _inp		;
l16d4h:						; m2:
	call	sub_016bh	;16d4  ; _dump		; dump();

	ld	hl,word_66a5	;16d7  ; slotab		; sloscan();
	ld	(word_9dfc),hl	;16da  ; ptrtab		; /* word_9dfc = word_66a5; */

	push	iy		;16dd			;
	call	sub_0a47h	;16df	; _skipbl	;
	pop	bc		;16e2			;
	push	hl		;16e3			;
	pop	iy		;16e4			; p = skipbl(p);

	ld	hl,(word_a685)	;16e6	; _inp		;
	dec	hl		;16e9			;
	ld	(word_a685),hl	;16ea	; _inp		;
	ld	(hl),023h ;'#'	;16ed			; *--inp = SALT;

	ld	(word_a66b),hl	;16ef	; _outp		; outp = inp;
	
	ld	hl,(word_9cae)	;16f2	; flslvl	;
	inc	hl		;16f5			;
	ld	(word_9cae),hl	;16f6	; flslvl	; ++flslvl;

	ld	hl,0		;16f9			;
	push	hl		;16fc			;
	push	iy		;16fd			;
	ld	hl,(word_a685)	;16ff	; inp		;
	push	hl		;1702			;
	call	sub_1d22h	;1703	; _slookup	;
	pop	bc		;1706			;
	pop	bc		;1707			;
	pop	bc		;1708			;
	ld	(ix-2),l	;1709			;
	ld	(ix-1),h ;l1	;170c			; np = slookup(inp, p, 0);

	ld	hl,(word_9cae)	;170f	; flslvl	;
	dec	hl		;1712			;
	ld	(word_9cae),hl	;1713	; flslvl	; --flslvl;

	ld	de,(word_9cb0)	;1716	; defloc	;
	ld	l,(ix-2)	;171a			;
	ld	h,(ix-1)	;171d			;
	or	a		;1720			;
	sbc	hl,de		;1721			;
	jr	nz,l1738h	;1723			; if(defloc != np) goto m4;

	ld	hl,(word_9cae)	;1725	; flslvl	;
	ld	a,l		;1728			;
	or	h		;1729			;
	jp	nz,l19a0h	;172a			; if(flslvl != 0) goto m33;

	push	iy		;172d			;
	call	sub_10b2h	;172f	; _dodef	;
l1732h:						; m3:
	pop	bc		;1732			;
	push	hl		;1733			;
	pop	iy		;1734			; p = dodef(p);
	jr	l16b9h		;1736			; goto m1;
l1738h:						; m4:
	ld	de,(word_9c9a)	;1738	; _incloc	;
	ld	l,(ix-2)	;173c			;
	ld	h,(ix-1)	;173f			;
	or	a		;1742			;
	sbc	hl,de		;1743			;
	jr	nz,l1756h	;1745			; if(incloc != np) goto m5;

	ld	hl,(word_9cae)	;1747	; _flslvl	;
	ld	a,l		;174a			;
	or	h		;174b			;
	jp	nz,l19a0h	;174c			; if(flslvl != 0) goto m33;

	push	iy		;174f			;
	call	sub_0c59h	;1751	; _doincl	; p = dodef(doincl(p));
	jr	l1732h		;1754			; goto m3;
l1756h:						; m5:
	ld	de,(word_a661)	;1756	; _ifnloc	;
	ld	l,(ix-2)	;175a			;
	ld	h,(ix-1)	;175d			;
	or	a		;1760			;
	sbc	hl,de		;1761			;
	jp	nz,l17afh	;1763			; if(ifnloc != np) goto m8;

	ld	hl,(word_9cae)	;1766	; _flslvl	;
	inc	hl		;1769			;
	ld	(word_9cae),hl	;176a	; _flslvl	; word_9cae++;

	push	iy		;176d			;
	call	sub_0a47h	;176f	; _skipbl	;
	push	hl		;1772			;
	pop	iy		;1773			; p = skipbl(p);

	ld	hl,0		;1775			;
	ex	(sp),hl		;1778			;
	push	iy		;1779			;
	ld	hl,(word_a685)	;177b	; _inp		;
	push	hl		;177e			;
	call	sub_1d22h	;177f	; _slookup	;
	pop	bc		;1782			;
	pop	bc		;1783			;
	pop	bc		;1784			;
	ld	(ix-2),l	;1785			;
	ld	(ix-1),h	;1788			; l1 = sub_1d22h(word_a685, st, 0);

	ld	hl,(word_9cae)	;178b	; _flslvl	;
	dec	hl		;178e			;
	ld	(word_9cae),hl	;178f	; _flslvl	;
	ld	a,l		;1792			;
	or	h		;1793			;
	jp	nz,l17fch	;1794			; if(--word_9cae != 0) goto m9,

	ld	l,(ix-2)	;1797			;
	ld	h,(ix-1) ;l1	;179a			;
	inc	hl		;179d			;
	inc	hl		;179e			;
	ld	a,(hl)		;179f			;
	inc	hl		;17a0			;
	or	(hl)		;17a1			;
	jp	nz,l17fch	;17a2			; if(*(l1+1) != 0) goto m9;
l17a5h:							; m6:
	ld	hl,(word_a683)	;17a5	; _trulvl	;
	inc	hl		;17a8			;
l17a9h:						; m7:
	ld	(word_a683),hl	;17a9	; _trulvl	; word_a683++;
	jp	l19a0h		;17ac			; goto m33;
l17afh:						; m8:
	ld	de,(word_6621)	;17af	; _ifdloc	;
	ld	l,(ix-2)	;17b3			;
	ld	h,(ix-1)	;17b6			;
	or	a		;17b9			;
	sbc	hl,de		;17ba			;
	jp	nz,l1806h	;17bc			; if(word_6621 != l1) goto m11;

	ld	hl,(word_9cae)	;17bf	; _flslvl	;
	inc	hl		;17c2			;
	ld	(word_9cae),hl	;17c3	; _flslvl	; word_9cae++;

	push	iy		;17c6			;
	call	sub_0a47h	;17c8	; _skipbl	;
	push	hl		;17cb			;
	pop	iy		;17cc			; st = sub_0a47h(st);

	ld	hl,0		;17ce			;
	ex	(sp),hl		;17d1			;
	push	iy		;17d2			;
	ld	hl,(word_a685)	;17d4	; _inp		;
	push	hl		;17d7			;
	call	sub_1d22h	;17d8	; _slookup	;
	pop	bc		;17db			;
	pop	bc		;17dc			;
	pop	bc		;17dd			;
	ld	(ix-2),l	;17de			;
	ld	(ix-1),h	;17e1			; l1 = sub_1d22h(word_a685, st, 0);

	ld	hl,(word_9cae)	;17e4	; _flslvl	;
	dec	hl		;17e7			;
	ld	(word_9cae),hl	;17e8	; _flslvl	;
	ld	a,l		;17eb			;
	or	h		;17ec			;
	jr	nz,l17fch	;17ed			; if(--word_9cae != 0) goto m9;

	ld	l,(ix-2)	;17ef			;
	ld	h,(ix-1) ; l1	;17f2			;
	inc	hl		;17f5			;
	inc	hl		;17f6			;
	ld	a,(hl)		;17f7			;
	inc	hl		;17f8			;
	or	(hl)		;17f9			;
	jr	nz,l17a5h	;17fa			; if(*(l1+1) != 0) goto m6;
l17fch:						; m9:
	ld	hl,(word_9cae)	;17fc	; _flslvl	;
	inc	hl		;17ff			;
l1800h:						; m10:
	ld	(word_9cae),hl	;1800	; _flslvl	; word_9cae++;
	jp	l19a0h		;1803			; goto m33;
l1806h:						; m11:
	ld	de,(word_9caa)	;1806	; _eifloc	;
	ld	l,(ix-2)	;180a			;
	ld	h,(ix-1)	;180d			;
	or	a		;1810			;
	sbc	hl,de		;1811			;
	jp	nz,l184ah	;1813			; if(word_9caa != l1) goto m17;

	ld	hl,(word_9cae)	;1816	; _flslvl	;
	ld	a,l		;1819			;
	or	h		;181a			;
	jr	z,l182ch	;181b			; if(word_9cae == 0) goto m13;

	dec	hl		;181d			;
	ld	(word_9cae),hl	;181e	; _flslvl	;
	ld	a,l		;1821			;
	or	h		;1822			;
	jp	nz,l19a0h	;1823			; if(word_9cae-- != 0) goto m33;
l1826h:						; m12:
	call	sub_013dh	;1826	; _sayline	; sub_013dh();
	jp	l19a0h		;1829			; goto m33;
l182ch:						; m13:
	ld	hl,(word_a683)	;182c	; _trulvl	;
	ld	a,l		;182f			;
	or	h		;1830			;
	jr	z,l183ah	;1831			; if(word_a683 == 0) goto m15;
l1833h:						; m14:
	ld	hl,(word_a683)	;1833	; _trulvl	;
	dec	hl		;1836			; word_a683--;
	jp	l17a9h		;1837			; goto m33;
l183ah:						; m15:
	ld	hl,0		;183a			;
	push	hl		;183d			;
	ld	hl,l5afbh	;183e			;
l1841h:						; m16:
	push	hl		;1841			;
	call	sub_1ad2h	;1842	; _pperror	; sub_1ad2h("If-less endif", 0);
	pop	bc		;1845
	pop	bc		;1846
	jp	l19a0h		;1847			; goto m33;
l184ah:						; m17:
	ld	de,(word_a669)	;184a	; _elsloc	;
	ld	l,(ix-2)	;184e			;
	ld	h,(ix-1)	;1851			;
	or	a		;1854			;
	sbc	hl,de		;1855			;
	jp	nz,l188eh	;1857			; if(word_a669 != l1) goto m21;

	ld	hl,(word_9cae)	;185a	; _flslvl	;
	ld	a,l		;185d			;
	or	h		;185e			;
	jr	z,l1875h	;185f			; if(word_9cae == 0) goto m19;

	dec	hl		;1861			;
	ld	(word_9cae),hl	;1862	; _flslvl	;
	ld	a,l		;1865			;
	or	h		;1866			;
	jr	z,l186ch	;1867			; if(--word_9cae == 0) goto m18;

	inc	hl		;1869
	jr	l1800h		;186a			; goto m10;
l186ch:						; m18:
	ld	hl,(word_a683)	;186c	; _trulvl	;
	inc	hl		;186f			;
	ld	(word_a683),hl	;1870	; _trulvl	; word_a683++;
	jr	l1826h		;1873			; goto m12;
l1875h:						; m19:
	ld	hl,(word_a683)	;1875	; _trulvl	;
	ld	a,l		;1878			;
	or	h		;1879			;
	jr	z,l1885h	;187a			; if(word_a683 == 0) goto m20;

	ld	hl,(word_9cae)	;187c	; _flslvl	;
	inc	hl		;187f			;
	ld	(word_9cae),hl	;1880	; _flslvl	; word_9cae++;
	jr	l1833h		;1883			; goto m14;
l1885h:						; m20:
	ld	hl,0		;1885			;
	push	hl		;1888			;
	ld	hl,l5b09h	;1889 			; sub_1ad2h("If-less else", 0);
	jr	l1841h		;188c			; goto m33;
l188eh:						; m21:
	ld	de,(word_9e2c)	;188e	; _udfloc	;
	ld	l,(ix-2)	;1892			;
	ld	h,(ix-1)	;1895			;
	or	a		;1898			;
	sbc	hl,de		;1899			;
	jp	nz,l18c9h	;189b			; if(word_9e2c != l1) goto m22;

	ld	hl,(word_9cae)	;189e	; _flslvl	;
	ld	a,l		;18a1			;
	or	h		;18a2			;
	inc	hl		;18a3			;
	ld	(word_9cae),hl	;18a4	; _flslvl	;
	jp	nz,l19bah	;18a7			; if(word_9cae++ != 0) goto m35;

	push	iy		;18aa			;
	call	sub_0a47h	;18ac	; _skipbl	;
	push	hl		;18af			;
	pop	iy		;18b0			; st = sub_0a47h(st);

	ld	hl,000feh ;254	;18b2			;
	ex	(sp),hl		;18b5			;
	push	iy		;18b6			;
	ld	hl,(word_a685)	;18b8	; _inp		;
	push	hl		;18bb			;
	call	sub_1d22h	;18bc	; _slookup	; sub_1d22h(word_a685, st , 0xFE);
	pop	bc		;18bf			;
	pop	bc		;18c0			;
	pop	bc		;18c1			;

	ld	hl,(word_9cae)	;18c2	; _flslvl	;
	dec	hl		;18c5			; word_9cae--;
	jp	l1800h		;18c6			; goto m33;
l18c9h:						; m22:
	ld	de,(word_9ca2)	;18c9	; _ifloc	;
	ld	l,(ix-2)	;18cd			;
	ld	h,(ix-1)	;18d0			;
	or	a		;18d3			;
	sbc	hl,de		;18d4			;
	jp	nz,l1902h	;18d6			; if(word_9ca2 != l1) goto m25;

	ld	(word_9c9c),iy	;18d9	; _newp		; word_9c9c = st;
	ld	hl,(word_9cae)	;18dd	; _flslvl	;
	ld	a,l		;18e0			;
	or	h		;18e1			;
	jr	nz,l18f4h	;18e2			; if(word_9c9c != 0) goto m23;

	call	sub_2c76h	;18e4	; _yyparse	;
	ld	a,l		;18e7			;
	or	h		;18e8			;
	jr	z,l18f4h	;18e9			; if(sub_2c76h() == 0) goto m23;

	ld	hl,(word_a683)	;18eb	; _trulvl	;
	inc	hl		;18ee			;
	ld	(word_a683),hl	;18ef	; _trulvl	; word_a683++;
	jr	l18fbh		;18f2			; goto m24;
l18f4h:						; m23:
	ld	hl,(word_9cae)	;18f4	; _flslvl	;
	inc	hl		;18f7			;
	ld	(word_9cae),hl	;18f8	; _flslvl	; word_9c9c++;
l18fbh:						; m24:
	ld	iy,(word_9c9c)	;18fb	; _newp		; st = word_9c9c;
	jp	l19a0h		;18ff			; goto m33;
l1902h:						; m25:
	ld	de,(word_9ca6)	;1902	; _lneloc	;
	ld	l,(ix-2)	;1906			;
	ld	h,(ix-1)	;1909			;
	or	a		;190c			;
	sbc	hl,de		;190d			;
	jp	nz,l1949h	;190f			; if(word_9ca6 != l1) goto m28;

	ld	hl,(word_9cae)	;1912	; _flslvl	;
	ld	a,l		;1915			;
	or	h		;1916			;
	jp	nz,l19a0h	;1917			; if(word_9cae != 0) goto m33;

	ld	hl,(word_9c98)	;191a	; _pflag	;
	ld	a,l		;191d			;
	or	h		;191e			;
	jp	nz,l19a0h	;191f			; if(word_9c98 != 0) goto m33;

	ld	(word_a685),iy	;1922	; _inp		;
	ld	(word_a66b),iy	;1926	; _outp		; word_a66b = (word_a685 = st);

	ld	hl,(word_a66b)	;192a	; _outp		;
	dec	hl		;192d			;
	ld	(word_a66b),hl	;192e	; _outp		;
	ld	(hl),23h ;'#'	;1931			; *(--word_a66b) = '#';
	jr	l193eh		;1933			; goto m27;
l1935h:						; m26:
	push	iy		;1935			;
	call	sub_0465h	;1937	; _cotoken	;
	pop	bc		;193a			;
	push	hl		;193b			;
	pop	iy		;193c			; st = sub_0465h(st);
l193eh:						; m27:
	ld	hl,(word_a685)	;193e	; _inp		;
	ld	a,(hl)		;1941			;
	cp	0ah	;'\n'	;1942			;
	jr	nz,l1935h	;1944			; if(*word_a685 != '\n') goto m26;
	jp	l16b9h		;1946			; goto m1;
l1949h:						; m28:
	ld	de,(word_9c9e)	;1949	; _asmloc	;
	ld	l,(ix-2)	;194d			;
	ld	h,(ix-1) ; l1	;1950			;
	or	a		;1953			;
	sbc	hl,de		;1954			;
	jp	z,l1977h	;1956			; if(word_9c9e == l1) goto m30;

	ld	de,(word_9cb4)	;1959	; _easmloc	;
	ld	l,(ix-2)	;195d			;
	ld	h,(ix-1) ; l1	;1960			;
	or	a		;1963			;
	sbc	hl,de		;1964			;
	jr	nz,l1982h	;1966			; if(word_9cb4 != l1) goto m31;
	jr	l1977h		;1968			; goto m30;
l196ah:						; m29:
	ld	(word_a685),iy	;196a	; _inp		; word_a685 = st;
	push	iy		;196e			;
	call	sub_0465h	;1970	; _cotoken	;
	pop	bc		;1973			;
	push	hl		;1974			;
	pop	iy		;1975			; st = sub_0465h(st);
l1977h:						; m30:
	ld	hl,(word_a685)	;1977	; _inp		;
	ld	a,(hl)		;197a			;
	cp	0ah	;'\n'	;197b			;
	jr	nz,l196ah	;197d			; if(*word_a685 != '\n') goto m29;
	jp	l19a0h		;197f			; goto m33;
l1982h:						; m31:
	ld	hl,(word_a685)	;1982	; _inp		;
	inc	hl		;1985			;
	ld	(word_a685),hl	;1986	; _inp		;
	ld	a,(hl)		;1989			;
	cp	0ah	;'\n'	;198a			;
	jr	nz,l1993h	;198c			; if(*(++word_a685) != '\n') goto m32;

	ld	(word_a66b),hl	;198e	; _outp		; word_a66b = word_a685;
	jr	l19a0h		;1991			; goto m33;
l1993h:						; m32:
	ld	hl,0		;1993			;
	push	hl		;1996			;
	ld	hl,l5b16h	;1997			;
	push	hl		;199a			;
	call	sub_1ad2h	;199b	; _pperror	; sub_1ad2h("undefined\tcontrol", 0);
	pop	bc		;199e			;
	pop	bc		;199f			;
l19a0h:						; m33:
	ld	hl,(word_9cae)	;19a0	; _flslvl	;
	inc	hl		;19a3			;
	ld	(word_9cae),hl	;19a4	; _flslvl	; word_9cae++;
	jr	l19bah		;19a7			; goto m35;
l19a9h:						; m34:
	ld	(word_a685),iy	;19a9	; _inp		;
	ld	(word_a66b),iy	;19ad	; _outp		; word_a66b = (word_a685 = sst);

	push	iy		;19b1			;
	call	sub_0465h	;19b3	; _cotoken	;
	pop	bc		;19b6			;
	push	hl		;19b7			;
	pop	iy		;19b8			; st = sub_0465h(st);
l19bah:						; m35:
	ld	hl,(word_a685)	;19ba	; _inp		;
	ld	a,(hl)		;19bd			;
	cp	0ah	;'\n'	;19be			;
	jr	nz,l19a9h	;19c0			; if(*word_a685 != '\n') goto m34;

	ld	hl,(word_9cae)	;19c2	; _flslvl	;
	dec	hl		;19c5			;
	ld	(word_9cae),hl	;19c6	; _flslvl	; word_9cae--;
	jp	l16b9h		;19c9			; goto m1;

;	End sub_16ach					; }

; =============== F U N C T I O N =======================================
;
;	stsym
;
sub_19cch:						; sub_19cch(register char *) {
	call	ncsv		;19cc			; char * l1;
	dw	0FDFEH	; -514	;19cf			; char arr[512];

	ld	l,(ix+6)	;19d1			;
	ld	h,(ix+7)	;19d4			;
	push	hl		;19d7			;
	pop	iy		;19d8			;

	push	ix		;19da			;
	pop	de		;19dc			;
	ld	hl,0fdfeh	;19dd			;
	add	hl,de		;19e0			;
	ld	(ix-2),l	;19e1			;
	ld	(ix-1),h ;l1	;19e4			; l1 = arr;
l19e7h:							; m1:
	ld	a,(iy+0)	;19e7			;
	inc	iy		;19ea			;
	ld	l,(ix-2)	;19ec			;
	ld	h,(ix-1) ;l1	;19ef			;
	inc	hl		;19f2			;
	ld	(ix-2),l	;19f3			;
	ld	(ix-1),h ;l1	;19f6			;
	dec	hl		;19f9			;
	ld	(hl),a		;19fa			;
	or	a		;19fb			;
	jr	nz,l19e7h	;19fc			; if((*(l1++) = *(st++)) != 0) goto m1;

	push	ix		;19fe			;
	pop	de		;1a00			;
	ld	hl,0fdfeh	;1a01			;
	add	hl,de		;1a04			;
	ld	(ix-2),l	;1a05			;
	ld	(ix-1),h ;l1	;1a08			; l1 = arr;
l1a0bh:							; m2:
	ld	a,(hl)		;1a0b			;
	inc	hl		;1a0c			;
	ld	(ix-2),l	;1a0d			;
	ld	(ix-1),h ;l1	;1a10			;
	ld	e,a		;1a13			;
	rla			;1a14			;
	sbc	a,a		;1a15			;
	ld	d,a		;1a16			;
	ld	hl,array_9d3e	;1a17			;
	add	hl,de		;1a1a			;
	bit	0,(hl)		;1a1b			;
	ld	l,(ix-2)	;1a1d			;
	ld	h,(ix-1) ;l1	;1a20			;
	jr	nz,l1a0bh	;1a23			; if(bittst(array_9d3e + *(l1++), 0) != ) goto m2;

	dec	hl		;1a25			;
	ld	(ix-2),l	;1a26			;
	ld	(ix-1),h ;l1	;1a29			;
	ld	a,(hl)		;1a2c			;
	cp	03dh	;'='	;1a2d			;
	jp	nz,l1a50h	;1a2f			; if(*(--l1) != '=') goto m4;

	inc	hl		;1a32			;
	ld	(ix-2),l	;1a33			;
	ld	(ix-1),h ;l1	;1a36			;
	dec	hl		;1a39			;
	ld	(hl),020h ;' '	;1a3a			; *(l1++) = ' ';
l1a3ch:							; m3:
	ld	l,(ix-2)	;1a3c			;
	ld	h,(ix-1) ;l1	;1a3f			;
	ld	a,(hl)		;1a42			;
	inc	hl		;1a43			;
	ld	(ix-2),l	;1a44			;
	ld	(ix-1),h ;l1	;1a47			;
	or	a		;1a4a			;
	jr	nz,l1a3ch	;1a4b			; if(*(l1++) != 0) goto m3;
	jp	l1a6bh		;1a4d			; goto m6;
l1a50h:							; m4:
	ld	iy,l5b28h	;1a50	    		; st = " 1";
l1a54h:							; m5:
	ld	a,(iy+0)	;1a54			;
	inc	iy		;1a57			;
	ld	l,(ix-2)	;1a59			;
	ld	h,(ix-1) ;l1	;1a5c			;
	inc	hl		;1a5f			;
	ld	(ix-2),l	;1a60			;
	ld	(ix-1),h ;l1	;1a63			;
	dec	hl		;1a66			;
	ld	(hl),a		;1a67			;
	or	nz,l1a54h	;1a69			; if((*(l1++) = *(st++)) != 0) goto m5;
l1a6bh:							; m6:
	ld	l,(ix-2)	;1a6b			;
	ld	h,(ix-1) ;l1	;1a6e			;
	ld	(word_9b92),hl	;1a71			; word_9b92 = l1;

	ld	l,(ix-2)	;1a74			;
	ld	h,(ix-1) ;l1	;1a77			;
	dec	hl		;1a7a			;
	ld	(ix-2),l	;1a7b			;
	ld	(ix-1),h ;l1	;1a7e			;
	ld	(hl),0ah ;'\n'	;1a81			; *(--l1) = '\n';
	
	ld	hl,word_66a5	;1a83			;
	ld	(word_9dfc),hl	;1a86			; word_9dfc = &word_66a5;

	push	ix		;1a89			;
	pop	de		;1a8b			;
	ld	hl,0fdfeh	;1a8c			;
	add	hl,de		;1a8f			;
	push	hl		;1a90			;
	call	sub_10b2h	;1a91			; sub_10b2h(arr);
	pop	bc		;1a94			;
	ld	hl,(word_6623)	;1a95			;
	jp	cret		;1a98			; return word_6623;

;	End sub_19cch	stsym				; }

; =============== F U N C T I O N =======================================
;
;	ppsym
;
sub_1a9bh:						; char *sub_1a9bh(register char * p) {
	call	csv		;1a9b			; register struct aaa * st;
	ld	a,23h	; '#'	;1a9e			;
	ld	(byte_6623),a	;1aa0			; byte_6623 = '#';

	ld	hl,(word_58be)	;1aa3			;
	inc	hl		;1aa6			;
	ld	(word_58be),hl	;1aa7			;
	dec	hl		;1aaa			;
	ld	(hl),23h ; '#'	;1aab			; *(word_58be++) = '#';

	ld	l,(ix+6)	;1aad			;
	ld	h,(ix+7)	;1ab0			;
	push	hl		;1ab3			;
	call	sub_19cch	;1ab4			;
	pop	bc		;1ab7			;
	push	hl		;1ab8			;
	pop	iy		;1ab9			; st = sub_19cch(p);
	
	ld	l,(iy+0)	;1abb			;
	ld	h,(iy+1)	;1abe			;
	dec	hl		;1ac1			;
	ld	(iy+0),l	;1ac2			;
	ld	(iy+1),h	;1ac5			; st->p_1--;
	xor	a		;1ac8			;
	ld	(byte_6623),a	;1ac9			; byte_6623 = 0;
	push	iy		;1acc			;
	pop	hl		;1ace			;
	jp	cret		;1acf			; return st;

;	End sub_1a9bh					; }

; =============== F U N C T I O N =======================================
;
;		bad!
sub_1ad2h:						; int sub_1ad2h(char * p1, char * p2, char * p3) {
	call	csv		;1ad2			;
	ld	de,array_9b7e	;1ad5			;
	ld	hl,(word_a626)	;1ad8			;
	add	hl,hl		;1adb			;
	add	hl,de		;1adc			;
	ld	a,(hl)		;1add			;
	inc	hl		;1ade			;
	ld	h,(hl)		;1adf			;
	ld	l,a	;1ae0 hl=array_9b7e[word_a626]	;
	ld	a,(hl)		;1ae1			;
	or	a		;1ae2			;
	jr	z,l1afch	;1ae3			; if(array_9b7e[word_a626] == 0) goto m1;

	ld	hl,(word_a626)	;1ae5			;
	add	hl,hl		;1ae8			;
	add	hl,de		;1ae9			;
	ld	c,(hl)		;1aea			;
	inc	hl		;1aeb			;
	ld	b,(hl)		;1aec			;
	push	bc		;1aed\			;
	ld	hl,l5b2bh	;1aee "%s: "		;
	push	hl		;1af1\			;
	ld	hl,l63ffh	;1af2 __iob+16			;
	push	hl		;1af5\			;
	call	_fprintf	;1af6			; fprintf(l63ffh, "%s: ", array_9b7e[word_a626]);
	pop	bc		;1af9			;
	pop	bc		;1afa			;
	pop	bc		;1afb			;
l1afch:							; m1:
	ld	de,array_9a43	;1afc			;
	ld	hl,(word_a626)	;1aff			;
	add	hl,hl		;1b02			;
	add	hl,de		;1b03			;
	ld	b,(hl)		;1b06			;
	push	bc		;1b07\			;
	ld	hl,l5b30h	;1b08 "%d: "		;
	push	hl		;1b0b\			;
	ld	hl,l63ffh	;1b0c __iob+16			;
	push	hl		;1b0f\			;
	call	_fprintf	;1b10			; fprintf(l63ffh, "%d: ", array_9a43[word_a626]);
	pop	bc		;1b13			;
	pop	bc		;1b14			;

	ld	l,(ix+0ah)	;1b15			;
	ld	h,(ix+0bh) ;p3	;1b18			;
	ex	(sp),hl		;1b1b			;
	ld	l,(ix+8)	;1b1c			;
	ld	h,(ix+9) ; p2	;1b1f			;
	push	hl		;1b22\			;
	ld	h,(ix+7) ; p1	;1b26			;
	push	hl		;1b29\			;
	ld	hl,l63ffh	;1b2a __iob+16			;
	push	hl		;1b2d\			;
	call	_fprintf	;1b2e			; fprintf(l63ffh, p1, p2, p3);
	pop	bc		;1b31			;
	pop	bc		;1b32			;
	pop	bc		;1b33			;

	ld	hl,l5b35h	;1b34 "\n"		;
	ex	(sp),hl		;1b37			;
	ld	hl,l63ffh	;1b38 __iob+16			;
	push	hl		;1b3b\			;
	call	_fprintf	;1b3c			; fprintf(l63ffh, "\n");

	ld	hl,(word_9ca4)	;1b3f			;
	inc	hl		;1b42			;
	ld	(word_9ca4),hl	;1b43			;
	jp	cret		;1b46			; return word_9ca4++;

;	End sub_1ad2h					; }

; =============== F U N C T I O N =======================================
;
;
sub_1b49h:				    ; void sub_1b49h(p1, p2, p3) {
	call	csv		;1b49	    ;	sub_1ad2h(p1, p2, p3);
	ld	l,(ix+00ah)	;1b4c	    ;	}
	ld	h,(ix+00bh)	;1b4f
	push	hl		;1b52
	ld	l,(ix+8)	;1b53
	ld	h,(ix+9)	;1b56
	push	hl		;1b59
	ld	l,(ix+6)	;1b5a
	ld	h,(ix+7)	;1b5d
	push	hl		;1b60
	call	sub_1ad2h	;1b61
	jp	cret		;1b64

;	End sub_1b49h

; =============== F U N C T I O N =======================================
;
;
sub_1b67h:						; sub_1b67h(p1, p2) {
	call	csv		;1b67
	push	hl		;1b6a			; int l1;
	ld	hl,(word_9ca4)	;1b6b			;
	ld	(ix-2),l	;1b6e			;
	ld	(ix-1),h	;1b71			; l1 = word_9ca4;

	ld	hl,-1		;1b74			;
	ld	(word_9ca4),hl	;1b77			; word_9ca4 = -1;

	ld	l,(ix+8)	;1b7a			;
	ld	h,(ix+9) ;p2	;1b7d			;
	push	hl		;1b80			;
	ld	l,(ix+6)	;1b81			;
	ld	h,(ix+7) ;p1	;1b84			;
	push	hl		;1b87			;
	call	sub_1ad2h	;1b88			; sub_1ad2h(p1, p2);
	ld	l,(ix-2)	;1b8b			;
	ld	h,(ix-1)	;1b8e			;
	ld	(word_9ca4),hl	;1b91			; word_9ca4 = l1;
	jp	cret		;1b94

;	End sub_1b67h					; }

; =============== F U N C T I O N =======================================
;
;		lookup
sub_1b97h:						; int sub_1b97h(register char * st, p2) {
	call	ncsv		;1b97			; l1;
	dw	0FFF6H	;-10	;1b9a			; l2;
	ld	l,(ix+6)	;1b9c			; l3;
	ld	h,(ix+7)	;1b9f			; l4;
	push	hl		;1ba2			; l5;
	pop	iy		;1ba3			;

	ld	(ix-8),0	;1ba5			;
	ld	(ix-7),0 ;l4	;1ba9	; around	; around = 0;
	ld	a,(byte_6623)	;1bad			;
	ld	l,a		;1bb0			;
	rla			;1bb1			;
	sbc	a,a		;1bb2			;
	ld	h,a		;1bb3			;
	ld	(ix-6),l	;1bb4			;
	ld	(ix-5),h ;l3	;1bb7	; i		; i = (char)cinit;
	jp	l1bd8h		;1bba			; goto m2;
l1bbdh:						; m1:
	ld	e,(ix-4)	;1bbd			;
	ld	d,(ix-3) ;l2	;1bc0			;
	ld	l,(ix-6)	;1bc3			;
	ld	h,(ix-5) ;l3	;1bc6			;
	add	hl,de		;1bc9 hl =l3+l2		;
	ex	de,hl		;1bca de =l3+l2		;
	ld	l,(ix-6)	;1bcb			;
	ld	h,(ix-5) ;l3	;1bce			;
	add	hl,de		;1bd1 l3+l3+l2		;
	ld	(ix-6),l	;1bd2			;
	ld	(ix-5),h ;l3	;1bd5			; i += i+c;
l1bd8h:						; m2:
	ld	e,(ix+6)	;1bd8			;
	ld	d,(ix+7) ;p1	;1bdb			;
	ld	hl,8		;1bde			;
	add	hl,de		;1be1			;
	ex	de,hl		;1be2			;
	push	iy		;1be3			;
	pop	hl		;1be5			;
	call	wrelop		;1be6			;
	jr	nc,l1bfeh	;1be9			; if(np >= namep+8) goto m3;

	ld	a,(iy+0)	;1beb			;
	inc	iy		;1bee			;
	ld	l,a		;1bf0			;
	rla			;1bf1			;
	sbc	a,a		;1bf2			;
	ld	h,a		;1bf3			;
	ld	(ix-4),l	;1bf4			;
	ld	(ix-3),h ;l2	;1bf7			;
	ld	a,l		;1bfa			;
	or	h		;1bfb			;
	jr	nz,l1bbdh	;1bfc			; if((c = *np++) != 0) goto m1;
l1bfeh:						; m3:
	ld	l,(ix-6)	;1bfe			;
	ld	h,(ix-5) ;l3	;1c01			;
	ld	(ix-4),l	;1c04			;
	ld	(ix-3),h ;l2	;1c07			; c  = i;
	ld	de,0x1F4	;1c0a			;
	push	ix		;1c0d			;
	pop	hl		;1c0f			;
	dec	hl		;1c10			;
	dec	hl		;1c11			;
	dec	hl		;1c12			;
	dec	hl		;1c13			;
	call	asamod	;1c14				; c %= SYMSIZ;
	bit	7,(ix-3) ;l2	;1c17			;
	jr	z,l1c2dh	;1c1b			; if(c & 0x8000 == 0) goto m4;

	ld	de,0x1F4	;1c1d			;
	ld	l,(ix-4)	;1c20			;
	ld	h,(ix-3) ;l2	;1c23	; c		;
	add	hl,de		;1c26			;
	ld	(ix-4),l	;1c27			;
	ld	(ix-3),h ;l2	;1c2a	; c		; c += SYMSIZ;
l1c2dh:						; m4:
	ld	de,09e2eh	;1c2d			;
	ld	l,(ix-4)	;1c30			;
	ld	h,(ix-3) ;l2	;1c33	; c		;
	add	hl,hl		;1c36			;
	add	hl,hl		;1c37			;
	add	hl,de		;1c38			;
	ld	(ix-10),l	;1c39			;
	ld	(ix-9),h ;l5	;1c3c	; sp		; sp = &stab[c];
	jp	l1ce8h		;1c3f			; goto m10;

l1c42h:						; m5:
	ld	l,(ix+6)	;1c42			;
	ld	h,(ix+7) ;p1	;1c45	; namep		;
	push	hl		;1c48			;
	pop	iy		;1c49	; np		; np = namep;
l1c4bh:						; m6:
	ld	l,(ix-2)	;1c4b			;
	ld	h,(ix-1) ;l1	;1c4e	; snp		;
	ld	a,(hl)		;1c51			;
	inc	hl		;1c52			;
	ld	(ix-2),l	;1c53			;
	ld	(ix-1),h ;l1	;1c56	; snp		;
	cp	(iy+0)		;1c59			;
	jp	z,l1c98h	;1c5c			; if(*snp++ == *np) goto m7;
	
	ld	de,09e2eh	;1c5f			;
	ld	l,(ix-10)	;1c62			;
	ld	h,(ix-9) ;l5	;1c65	; sp		;
	dec	hl		;1c68			;
	dec	hl		;1c69			;
	dec	hl		;1c6a			;
	dec	hl		;1c6b			;
	ld	(ix-10),l	;1c6c			;
	ld	(ix-9),h ;l5	;1c6f	; sp		;
	call	wrelop		;1c72			;
	jp	nc,l1ce8h	;1c75			; if(l5-- >= array_9e2e) goto m10;

	ld	a,(ix-8)	;1c78			;
	or	(ix-7) ;l4	;1c7b   ; around;
	jp	z,l1cd2h	;1c7e			; if(around == 0) goto m9;

	ld	hl,0		;1c81			;
	push	hl		;1c84			;
	ld	hl,l5b37h	;1c85			;
	push	hl		;1c88			;
	call	sub_1ad2h	;1c89	; pperror	; pperror("too many defines", 0);
	pop	bc		;1c8c			;

	ld	hl,(word_9ca4)	;1c8d			;
	ex	(sp),hl		;1c90			;
	call	exit		;1c91			; exit(exfail);
	pop	bc		;1c94			;
	jp	l1ce8h		;1c95			; goto m10;
l1c98h:						; m7:
	ld	a,(iy+0)	;1c98			;
	inc	iy		;1c9b			;
	or	a		;1c9d			;
	jr	nz,l1c4bh	;1c9e			; if(*np++ != 0) goto m6;

	ld	de,000feh	;1ca0			;
	ld	l,(ix+8)	;1ca3			;
	ld	h,(ix+9) ;p2	;1ca6	; enterf	;
	or	a		;1ca9			;
	sbc	hl,de		;1caa			;
	ld	l,(ix-10)	;1cac			;
	ld	h,(ix-9) ;l5	;1caf	; sp		;
	jp	nz,l1ccch	;1cb2			; if(enterf != 0xFE) goto m8;

	ld	a,(hl)		;1cb5			;
	inc	hl		;1cb6			;
	ld	h,(hl)		;1cb7			;
	ld	l,a		;1cb8			;
	ld	(hl),0feh	;1cb9			; *sp = 0xFE;
	ld	de,0		;1cbb			;
	ld	l,(ix-10)	;1cbe			;
	ld	h,(ix-9) ;l5	;1cc1			;
	inc	hl		;1cc4			;
	inc	hl		;1cc5			;
	ld	(hl),e		;1cc6			;
	inc	hl		;1cc7			;
	ld	(hl),d		;1cc8			; (l5+1)->p_1 = 0;
	
	dec	hl		;1cc9			;
	dec	hl		;1cca			;
	dec	hl		;1ccb			;
l1ccch:						; m8:
	ld	(word_6623),hl	;1ccc			; word_6623 = (char)l5 - 3;
	jp	cret		;1ccf			; return;
l1cd2h:						; m9:
	ld	l,(ix-8)	;1cd2			;
	ld	h,(ix-7) ;l4	;1cd5			;
	inc	hl		;1cd8			;
	ld	(ix-8),l	;1cd9			;
	ld	(ix-7),h ;l4	;1cdc	; around	; ++around;

	ld	hl,0a5fah	;1cdf			;
	ld	(ix-10),l	;1ce2			;
	ld	(ix-9),h ;l5	;1ce5	; sp		; sp = &stab[SYMSIZ-1];
l1ce8h:						; m10:
	ld	l,(ix-10)	;1ce8			;
	ld	h,(ix-9) ;l5	;1ceb	; sp		;
	ld	c,(hl)		;1cee			;
	inc	hl		;1cef			;
	ld	b,(hl)		;1cf0			;
	ld	(ix-2),c	;1cf1			;
	ld	(ix-1),b ;l1	;1cf4	; snp		;
	ld	a,c		;1cf7			;
	or	b		;1cf8			;
	jp	nz,l1c42h	;1cf9			; if((l1 = *l5) != 0) goto m5;

	ld	e,(ix+8)	;1cfc			;
	ld	d,(ix+9) ; p2	;1cff	; enterf	;
	ld	hl,0		;1d02			;
	call	wrelop		;1d05			;
	jp	p,l1d1ah	;1d08			; if(0 >= enterf) goto m11;

	ld	e,(ix+6)	;1d0b			;
	ld	d,(ix+7) ;p1	;1d0e	; namep		;
	ld	l,(ix-10)	;1d11			;
	ld	h,(ix-9) ;l5	;1d14	; sp		;
	ld	(hl),e		;1d17			;
	inc	hl		;1d18			;
	ld	(hl),d		;1d19			; *l5 = p1;
l1d1ah:						; m11:
	ld	l,(ix-10)	;1d1a
	ld	h,(ix-9) ;l5	;1d1d	; sp		; word_6623 = l5;
	jr	l1ccch		;1d20			; return; /* goto m8; */

;	End sub_1b97h	lookup				; }

; =============== F U N C T I O N =======================================
;
;							; 
sub_1d22h:						; int sub_1d22h(register chat * st, char * p2, int p3) {
	call	ncsv		;1d22			; char * l1;
	defw	0fffah	;-6	;1d25			; char   l2, l3;
	ld	l,(ix+6)	;1d27			; int  * l4;	/* ??? */
	ld	h,(ix+7)	;1d2a			;
	push	hl		;1d2d			;
	pop	iy		;1d2e			;

	ld	l,(ix+8)	;1d30			;
	ld	h,(ix+9) ;p2	;1d33			;
	ld	l,(hl)		;1d36			; l2 = (char)*p2;

	ld	(ix-3),l ;l2	;1d37			;
	ld	l,(ix+8) ;p2	;1d3a			;
	ld	(hl),0		;1d3d			; *p2 = 0;

	push	iy		;1d3f			;
	pop	de		;1d41			;
	or	a		;1d42			;
	sbc	hl,de		;1d43			;
	ex	de,hl		;1d45			;
	ld	hl,0001fh	;1d46			;
	call	wrelop		;1d49			;
	jp	p,l1d5eh	;1d4c			; if(0x1f >= p2-st) goto m1;

	push	iy		;1d4f			;
	pop	de		;1d51			;
	ld	hl,0001fh	;1d52			;
	add	hl,de		;1d55			;
	ld	(ix-2),l	;1d56			;
	ld	(ix-1),h ;l1	;1d59			; l1 = st + 0x1F;
	jr	l1d6ah		;1d5c			; goto m2;
l1d5eh:							; m1:
	ld	l,(ix+8)	;1d5e			;
	ld	h,(ix+9) ;p2	;1d61			;
	ld	(ix-2),l	;1d64			;
	ld	(ix-1),h ;l1	;1d67			; l1 = p2;
l1d6ah:							; m2:
	ld	l,(ix-2)	;1d6a			;
	ld	h,(ix-1) ;l1	;1d6d			;
	ld	l,(hl)		;1d70			;
	ld	(ix-4),l ;l3	;1d71			; l3 = *l1;

	ld	l,(ix-2) ;l1	;1d74			;
	ld	(hl),0		;1d77			; *l1 = 0;

	ld	de,1		;1d79			;
	ld	l,(ix+0ah)	;1d7c			;
	ld	h,(ix+0bh) ;p3	;1d7f			;
	or	a		;1d82			;
	sbc	hl,de		;1d83			;
	jr	nz,l1d90h	;1d85			; if(p3 != 1) goto m3;

	push	iy		;1d87			;
	call	sub_2242h	;1d89			;
	pop	bc		;1d8c			;
	push	hl		;1d8d			;
	pop	iy		;1d8e			; st = sub_2242h(st);
l1d90h:							; m3:
	ld	l,(ix+0ah)	;1d90			;
	ld	h,(ix+0bh) ;p3	;1d93			;
	push	hl		;1d96			;
	push	iy		;1d97			;
	call	sub_1b97h	;1d99			;
	pop	bc		;1d9c			;
	pop	bc		;1d9d			;
	ld	(ix-6),l	;1d9e			;
	ld	(ix-5),h ;l4	;1da1			; l4 = sub_1b97h(st, p3);
	
	ld	a,(ix-4) ;l3	;1da4			;
	ld	l,(ix-2)	;1da7			;
	ld	h,(ix-1) ;l1	;1daa			;
	ld	(hl),a		;1dad			; *l1 = l3;

	ld	a,(ix-3) ;l2	;1dae			;
	ld	l,(ix+8)	;1db1			;
	ld	h,(ix+9) ;p2	;1db4			;
	ld	(hl),a		;1db7			; *p2 = l2;

	ld	l,(ix-6)	;1db8			;
	ld	h,(ix-5) ;l4	;1dbb			;
	inc	hl		;1dbe			;
	inc	hl		;1dbf			;
	ld	a,(hl)		;1dc0			;
	inc	hl		;1dc1			;
	or	(hl)		;1dc2			;
	jp	z,l1de6h	;1dc3			; if(*(l4+1) == 0) goto m4;

	ld	hl,(word_9cae)	;1dc6			;
	ld	a,l		;1dc9			;
	or	h		;1dca			;
	jp	nz,l1de6h	;1dcb			; if(word_9cae != 0) goto m4;

	ld	l,(ix-6)	;1dce			;
	ld	h,(ix-5) ;l4	;1dd1			;
	push	hl		;1dd4			;
	ld	l,(ix+8)	;1dd5			;
	ld	h,(ix+9) ;p2	;1dd8			;
	push	hl		;1ddb			;
	call	sub_1df5h	;1ddc			;
	pop	bc		;1ddf			;
	pop	bc		;1de0			;
	ld	(word_9c9c),hl	;1de1			; word_9c9c = sub_1df5h(p2, l4);
	jr	l1dech		;1de4			; goto m5;
l1de6h:							; m4:
	ld	hl,0		;1de6			;
	ld	(word_9c9c),hl	;1de9			; word_9c9c = 0;
l1dech:							; m5:
	ld	l,(ix-6)	;1dec			;
	ld	h,(ix-5) ;l4	;1def			;
	jp	cret		;1df2			; return l4;

;	End sub_1d22h					; }

; =============== F U N C T I O N =======================================
;
;	subst
;
sub_1df5h:
	call	ncsv		;1df5			;
	defw	0fdbah	; -582	;1df8			;
							;
	ld	l,(ix+6)	;1dfa			;
	ld	h,(ix+7)	;1dfd			;
	push	hl		;1e00			;
	pop	iy		;1e01			;
							;
	ld	l,(ix+8)	;1e03			;
	ld	h,(ix+9) ;p2	;1e06			;
	inc	hl		;1e09			;
	inc	hl		;1e0a			;
	ld	c,(hl)		;1e0b			;
	inc	hl		;1e0c			;
	ld	b,(hl)		;1e0d			;
	ld	(ix-4),c	;1e0e			;
	ld	(ix-3),b ;l2	;1e11			;
	ld	a,c		;1e14			;
	or	b		;1e15			;
	jr	nz,l1e1eh	;1e16			; if((vp = sp->value) == 0) 	/* goto m2; */
l1e18h:						; m1:
	push	iy		;1e18			;
	pop	hl		;1e1a			;
	jp	cret		;1e1b			; return (p);
l1e1eh:						; m2:
	ld	de,(word_a663)	;1e1e	macforw		;
	push	iy		;1e22			;
	pop	hl		;1e24			;
	or	a		;1e25			;
	sbc	hl,de		;1e26			;
	ex	de,hl		;1e28			;
	ld	hl,(word_a66d)	;1e29	macdam		;
	call	wrelop		;1e2c			;
	jp	m,l1e60h	;1e2f			; if(macdam >= (p - macforw)) {	/* goto m3; */

	ld	hl,(word_9e16)	;1e32	maclvl		;
	inc	hl		;1e35			;
	ld	(word_9e16),hl	;1e36			;
	ex	de,hl		;1e39			;
	ld	hl,0x1F4	;1e3a	500		;
	call	wrelop		;1e3d			;
	jp	p,l1e66h	;1e40			;

	ld	hl,(word_9cba)	;1e43	rflag		;
	ld	a,l		;1e46			;
	or	h		;1e47			;
	jp	nz,l1e66h	;1e48			; if(SYMSIZ < ++maclvl  && !rflag) { /* goto k3; */

	ld	l,(ix+8)	;1e4b			;
	ld	h,(ix+9) ;p2	;1e4e			;
	ld	c,(hl)		;1e51			;
	inc	hl		;1e52			;
	ld	b,(hl)		;1e53			;
	push	bc		;1e54			;
	ld	hl,l5b48h	;1e55			;
	push	hl		;1e58			;
	call	sub_1ad2h	;1e59	pperror		; pperror("%s: macro recursion", *p2);
	pop	bc		;1e5c			;
	pop	bc		;1e5d			;
	jr	l1e18h		;1e5e			; return (p); 	}			/* goto m1; */
l1e60h:						; m3:
	ld	hl,0		;1e60			;
	ld	(word_9e16),hl	;1e63	maclvl		; } else maclvl = 0;
l1e66h:						; k3:
	ld	(word_a663),iy	;1e66	macforw		; macforw = p; 
	ld	hl,0		;1e6a			;
	ld	(word_a66d),hl	;1e6d	macdam		; macdam = 0;
	ld	l,(ix+8)	;1e70			;
	ld	h,(ix+9) ;p2	;1e73			;
	ld	c,(hl)		;1e76			;
	inc	hl		;1e77			;
	ld	b,(hl)		;1e78			;
	ld	(word_9ca8),bc	;1e79	macnam		; macnam  = sp->name;
	call	sub_016bh	;1e7d	dump()		; dump();
	ld	de,(word_9dfa)	;1e80	ulnloc		;
	ld	l,(ix+8)	;1e84			;
	ld	h,(ix+9) ;p2	;1e87			;
	or	a		;1e8a			;
	sbc	hl,de		;1e8b			;
	jp	nz,l1ed8h	;1e8d			; if(sp == ulnloc) {		/* goto m5; */

	push	ix		;1e90			;
	pop	de		;1e92			;
	ld	hl,0fdbah	;1e93	-582		;
	add	hl,de		;1e96			;
	ld	(ix-4),l	;1e97			;
	ld	(ix-3),h ;l2	;1e9a			; lvp = acttxt;
	inc	hl		;1e9d			;
	ld	(ix-4),l	;1e9e			;
	ld	(ix-3),h ;l2	;1ea1			;
	dec	hl		;1ea4			;
	ld	(hl),0		;1ea5			; *vp++ = '\0';
	ld	de,array_9a43	;1ea7	lineno		;
	ld	hl,(word_a626)	;1eaa	ifno		;
	add	hl,hl		;1ead			;
	add	hl,de		;1eae			;
	ld	c,(hl)		;1eaf			;
	inc	hl		;1eb0			;
	ld	b,(hl)		;1eb1			;
	push	bc		;1eb2\			;
	ld	hl,l5b5ch	;1eb3 "%d"		;
	push	hl		;1eb6\			;
	ld	l,(ix-4)	;1eb7			;
	ld	h,(ix-3) ;l2	;1eba			;
	push	hl		;1ebd\			;
	call	_sprintf	;1ebe	sprintf		; sprintf(vp, "%d", lineno[ifno]);
	pop	bc		;1ec1			;
	pop	bc		;1ec2			;
	pop	bc		;1ec3			;
l1ec4h:						; m4:
	ld	l,(ix-4)	;1ec4			;
	ld	h,(ix-3) ;l2	;1ec7			;
	ld	a,(hl)		;1eca			;
	inc	hl		;1ecb			;
	ld	(ix-4),l	;1ecc			;
	ld	(ix-3),h ;l2	;1ecf			;
	or	a		;1ed2			;
	jr	nz,l1ec4h	;1ed3			; while(*vp++);
	jp	l1f2dh		;1ed5			; goto m7;
l1ed8h:						; m5:
	ld	de,(word_9cb6)	;1ed8	uflloc		;
	ld	l,(ix+8)	;1edc			;
	ld	h,(ix+9) ;p2	;1edf			;
	or	a		;1ee2			;
	sbc	hl,de		;1ee3			;
	jp	nz,l1f2dh	;1ee5			; } else if(sp == uflloc) {	/* goto m7; */
	push	ix		;1ee8			;
	pop	de		;1eea			;
	ld	hl,0fdbah	;1eeb	-582		;
	add	hl,de		;1eee			;
	ld	(ix-4),l	;1eef			;
	ld	(ix-3),h ;l2	;1ef2			; vp = acttxt; /* ??? */
	inc	hl		;1ef5			;
	ld	(ix-4),l	;1ef6			;
	ld	(ix-3),h ;l2	;1ef9			;
	dec	hl		;1efc			;
	ld	(hl),0		;1efd			;  *vp++ = '\0';
	ld	de,array_9b7e	;1eff	fnames		; 
	ld	hl,(word_a626)	;1f02	ifno		; 
	add	hl,hl		;1f05			; 
	add	hl,de		;1f06			; 
	ld	c,(hl)		;1f07			; 
	inc	hl		;1f08			; 
	ld	b,(hl)		;1f09			; 
	push	bc		;1f0a\			; 
	ld	hl,l5b5fh	;1f0b "\"%s\""		; 
	push	hl		;1f0e\			; 
	ld	l,(ix-4)	;1f0f			; 
	ld	h,(ix-3) ;l2	;1f12			; 
	push	hl		;1f15\			; 
	call	_sprintf	;1f16	sprintf		; sprintf(vp, "\"%s\"", fnames[ifno]);
	pop	bc		;1f19			; 
	pop	bc		;1f1a			; 
	pop	bc		;1f1b			; 
l1f1ch:						; m6:
	ld	l,(ix-4)	;1f1c			;
	ld	h,(ix-3) ;l2	;1f1f			;
	ld	a,(hl)		;1f22			;
	inc	hl		;1f23			;
	ld	(ix-4),l	;1f24			;
	ld	(ix-3),h ;l2	;1f27			;
	or	a		;1f2a			;
	jr	nz,l1f1ch	;1f2b			; while(*vp++); }
l1f2dh:						; m7:
	ld	l,(ix-4)	;1f2d			;
	ld	h,(ix-3) ;l2	;1f30			;
	dec	hl		;1f33			;
	ld	(ix-4),l	;1f34			;
	ld	(ix-3),h ;l2	;1f37			;
	ld	a,(hl)		;1f3a			;
	ld	l,a		;1f3b			;
	rla			;1f3c			;
	xor	a		;1f3d			;
	ld	h,a		;1f3e			;
	ld	(ix-6),l	;1f3f			;
	ld	(ix-5),h ;l3	;1f42			;
	ld	a,l		;1f45			;
	or	h		;1f46			;
	jp	z,l2159h	;1f47			; if((params = *--vp & 0xFF) != 0) { /* goto m24; */

	push	ix		;1f4a			;
	pop	de		;1f4c			;
	ld	hl,0fdbah	;1f4d	-582		;
	add	hl,de		;1f50			;
	ld	(ix-2),l	;1f51			;
	ld	(ix-1),h ;l1	;1f54			; ca = acttxt;
	push	ix		;1f57			;
	pop	de		;1f59			;
	ld	hl,0ffbah	;1f5a	-50 ???		;
	add	hl,de		;1f5d			;
	ld	(ix-8),l	;1f5e			;
	ld	(ix-7),h ;l4	;1f61			; pa = actual; /* ??? */
	ld	de,000ffh	;1f64			;
	ld	l,(ix-6)	;1f67			;
	ld	h,(ix-5) ;l3	;1f6a			;
	or	a		;1f6d			;
	sbc	hl,de		;1f6e			;
	jr	nz,l1f7ah	;1f70			; if(params == 0xFF)	/* goto m8; */

	ld	(ix-6),1	;1f72			;
	ld	(ix-5),0 ;l3	;1f76			; params = 1;
l1f7ah:						; m8:
	ld	hl,word_66a5	;1f7a	slotab		;
	ld	(word_9dfc),hl	;1f7d	ptrtab		; sloscan()		/* ptrtab = slotab; */
	ld	hl,(word_9cae)	;1f80	flslvl		;
	inc	hl		;1f83			;
	ld	(word_9cae),hl	;1f84			; ++flslvl;
	ld	hl,-1		;1f87			;
	ld	(word_9e12),hl	;1f8a	plvl		; plvl = -1;
l1f8dh:						; m9:
	push	iy		;1f8d			; do {
	call	sub_0a47h	;1f8f	skipbl		;
	pop	bc		;1f92			;
	push	hl		;1f93			;
	pop	iy		;1f94			; p = skipbl(p);
	ld	hl,(word_a685)	;1f96	inp		; }
	ld	a,(hl)		;1f99			;
	cp	0ah ; '\n'	;1f9a			;
	jr	z,l1f8dh	;1f9c			; while(*inp == '\n'); 	/* goto m9; */
	ld	a,(hl)		;1f9e			;
	cp	028h ;'('	;1f9f			;
	jp	nz,l20d7h	;1fa1			; if(*inp == '(') { 	/* goto m19; */
	ld	de,array_9a43	;1fa4	lineno		;
	ld	hl,(word_a626)	;1fa7	ifno		;
	add	hl,hl		;1faa			;
	add	hl,de		;1fab			;
	ld	c,(hl)		;1fac			;
	inc	hl		;1fad			;
	ld	b,(hl)		;1fae			;
	ld	(word_9cac),bc	;1faf	maclin		; maclin = lineno[ifno];
	ld	de,array_9b7e	;1fb3	fnames		;
	ld	hl,(word_a626)	;1fb6	ifno		;
	add	hl,hl		;1fb9			;
	add	hl,de		;1fba			;
	ld	c,(hl)		;1fbb			;
	inc	hl		;1fbc			;
	ld	b,(hl)		;1fbd			;
	ld	(word_9c94),bc	;1fbe	macfil		; macfil = fnames[ifno];
	ld	hl,1		;1fc2			;
	ld	(word_9e12),hl	;1fc5	plvl		; plvl = 1;
	jp	l20cfh		;1fc8			; goto m18;
l1fcbh:						; m10:
	ld	l,(ix-2)	;1fcb			;
	ld	h,(ix-1) ;l1	;1fce			;
	inc	hl		;1fd1			;
	ld	(ix-2),l	;1fd2			;
	ld	(ix-1),h ;l1	;1fd5			;
	dec	hl		;1fd8			;
	ld	(hl),0		;1fd9			; *ca++ = '\0';
l1fdbh:						; m11:
	ld	(word_a685),iy	;1fdb	inp		;
	ld	(word_a66b),iy	;1fdf	outp		; outp = inp = p;
	push	iy		;1fe3			;
	call	sub_0465h	;1fe5	cotoken()	;
	pop	bc		;1fe8			;
	push	hl		;1fe9			;
	pop	iy		;1fea			; p = cotoken(p);
	ld	hl,(word_a685)	;1fec	inp		;
	ld	a,(hl)		;1fef			;
	cp	028h ;'('	;1ff0			;
	jr	nz,l1ffbh	;1ff2			; if(*inp == '(') 	/* goto m12; */
	ld	hl,(word_9e12)	;1ff4	plvl		;
	inc	hl		;1ff7			;
	ld	(word_9e12),hl	;1ff8			; ++plvl;
l1ffbh:						; m12:
	ld	hl,(word_a685)	;1ffb	inp		;
	ld	a,(hl)		;1ffe			;
	cp	029h	;')'	;1fff	')'		;
	jp	nz,l2047h	;2001			; if(*inp == ')' && 	/* goto m14; */
	ld	hl,(word_9e12)	;2004	plvl		;
	dec	hl		;2007			;
	ld	(word_9e12),hl	;2008	plvl		;
	ld	a,l		;200b			;
	or	h		;200c			;
	jp	nz,l2047h	;200d			; --plvl == 0|) {	/* goto m14; */
	ld	l,(ix-6)	;2010			;
	ld	h,(ix-5) ;l3	;2013			;
	dec	hl		;2016			;
	ld	(ix-6),l	;2017			;					^
	ld	(ix-5),h ;l3	;201a			; --params; 		    ------------| ok
l201dh:						; m13:
	push	ix		;201d			;
	pop	de		;201f			;
	ld	hl,0fff8h	;2020	-8 ???		;
	add	hl,de		;2023			;
	ex	de,hl		;2024			;
	ld	l,(ix-8)	;2025			;
	ld	h,(ix-7) ;l4	;2028			;
	call	wrelop		;202b			;
	jp	c,l20b6h	;202e			; if(pa < actual /*ARR*/)	/* goto m17; */

	ld	l,(ix+8)	;2031			;
	ld	h,(ix+9) ;p2	;2034			;
	ld	c,(hl)		;2037			;
	inc	hl		;2038			;
	ld	b,(hl)		;2039			;
	push	bc		;203a\			;
	ld	hl,l59c7h	;203b 			;
	push	hl		;203e\			;
	call	sub_1b67h	;203f			; ppwarn(match, sp->name);
	pop	bc		;2042			;
	pop	bc		;2043			;
	jp	l20cfh		;2044			; goto m18;
l2047h:						; m14:
	ld	de,1		;2047			;
	ld	hl,(word_9e12)	;204a	plvl		;
	or	a		;204d			;
	sbc	hl,de		;204e			;
	jp	nz,l2082h	;2050			;
	ld	hl,(word_a685)	;2053			;
	ld	a,(hl)		;2056			;
	cp	02ch	;','	;2057			;
	jp	nz,l2082h	;2059			; if(plvl == 1 && *inp == ',') { /*  goto m16; */
	ld	l,(ix-6)	;205c			;
	ld	h,(ix-5) ;l3	;205f			;
	dec	hl		;2062			;
	ld	(ix-6),l	;2063			;
	ld	(ix-5),h ;l3	;2066			; --params;
	jr	l201dh		;2069			; goto m13;
l206bh:						; m15:
	ld	hl,(word_a685)	;206b			;
	ld	a,(hl)		;206e			;
	inc	hl		;206f			;
	ld	(word_a685),hl	;2070			;
	ld	l,(ix-2)	;2073			;
	ld	h,(ix-1) ;l1	;2076			;
	inc	hl		;2079			;
	ld	(ix-2),l	;207a			;
	ld	(ix-1),h ;l1	;207d			;
	dec	hl		;2080			;
	ld	(hl),a		;2081			;
l2082h:						; m16:
	push	iy		;2082			;
	pop	de		;2084			;
	ld	hl,(word_a685)	;2085			;
	call	wrelop		;2088			;
	jr	c,l206bh	;208b			; while(inp < p) *ca++ = *inp++; /* goto m15;*/
	push	ix		;208d			;
	pop	de		;208f			;
	ld	hl,0ffbah	;2090			;
	add	hl,de		;2093			;
	ld	e,(ix-2)	;2094			;
	ld	d,(ix-1) ;l1	;2097			;
	call	wrelop		;209a			;
	jp	nc,l1fdbh	;209d			; if(acttxt/*ARR*/ < ca) /* goto m11; */
	ld	l,(ix+8)	;20a0			;
	ld	h,(ix+9) ;p2	;20a3			;
	ld	c,(hl)		;20a6			;
	inc	hl		;20a7			;
	ld	b,(hl)		;20a8			;
	push	bc		;20a9			;
	ld	hl,l5b64h	;20aa			;
	push	hl		;20ad			;
	call	sub_1ad2h	;20ae	pperror		; pperror("%s: actuals too long", sp->name);
	pop	bc		;20b1			;
	pop	bc		;20b2			;
	jp	l1fdbh		;20b3			; goto m11;
l20b6h:						; m17:
	ld	e,(ix-2)	;20b6			;
	ld	d,(ix-1) ;l1	;20b9	ca		;
	ld	l,(ix-8)	;20bc			;
	ld	h,(ix-7) ;l4	;20bf			;
	inc	hl		;20c2			;
	inc	hl		;20c3			;
	ld	(ix-8),l	;20c4			;
	ld	(ix-7),h ;l4	;20c7			;
	dec	hl		;20ca			;
	dec	hl		;20cb			;
	ld	(hl),e		;20cc			;
	inc	hl		;20cd			;
	ld	(hl),d		;20ce	pa		; *pa++ = ca;
l20cfh:						; m18:
	ld	hl,(word_9e12)	;20cf			;
	ld	a,l		;20d2			;
	or	h		;20d3			;
	jp	nz,l1fcbh	;20d4			; while(plvl != 0) {	/* goto m10;*/
l20d7h:						; m19:
	ld	a,(ix-6)	;20d7			;
	or	(ix-5)	 ;l3	;20da			;
	jp	z,l210ch	;20dd	nc ???		; if(params != 0)	/* goto m21; */

	ld	l,(ix+8)	;20e0			; ok +
	ld	h,(ix+9) ;p2	;20e3			;    |
	ld	c,(hl)		;20e6			;    v
	inc	hl		;20e7			;
	ld	b,(hl)		;20e8			;
	push	bc		;20e9	sp->name	;
	ld	hl,l59c7h	;20ea			;
	push	hl		;20ed			;	 match[]="%s: argument mismatch";
	call	sub_1b67h	;20ee	ppwarn		; ppwarn(match, sp->name);
	pop	bc		;20f1			;
	pop	bc		;20f2			;
	jp	l210ch		;20f3			; goto m21;
l20f6h:						; m20:
	ld	de,array_5b79	;20f6			;
	ld	l,(ix-8)	;20f9			;
	ld	h,(ix-7) ;l4	;20fc	pa		;
	inc	hl		;20ff			;
	inc	hl		;2100			;
	ld	(ix-8),l	;2101			;
	ld	(ix-7),h ;l4	;2104	pa		;
	dec	hl		;2107			;
	dec	hl		;2108			;
	ld	(hl),e		;2109			;
	inc	hl		;210a			;
	ld	(hl),d		;210b			;
l210ch:						; m21:
	ld	l,(ix-6)	;210c			;
	ld	h,(ix-5) ;l3	;210f			;
	dec	hl		;2112			;
	ld	(ix-6),l	;2113			;
	ld	(ix-5),h ;l3	;2116			;
	bit	7,h		;2119			;
	jr	z,l20f6h	;211b			; while(((unsigned)--params & 0x8000) == 0) *pa++ = "" + 1; /* goto m20; */

	ld	hl,(word_9cae)	;211d	flslvl		;
	dec	hl		;2120			;
	ld	(word_9cae),hl	;2121			; --flslvl;
	ld	hl,array_9d3e	;2124	fastab		;
	ld	(word_9dfc),hl	;2127	ptrtab		; fasscan();		/* ptrtab = fastab; */
	jp	l2159h		;212a			; } /* goto m24; */
l212dh:						; m22:
	push	iy		;212d			;
	pop	de		;212f			;
	ld	hl,(word_a665)	;2130	pbeg		;
	call	wrelop		;2133			;
	jp	c,l214ah	;2136			; if(word_a665 < st) goto m23;

	ld	(word_a685),iy	;2139	inp		;
	ld	(word_a66b),iy	;213d	outp		; outp = inp = p;
	push	iy		;2141			;
	call	sub_0a7bh	;2143	unfill		;
	pop	bc		;2146			;
	push	hl		;2147			;
	pop	iy		;2148			; p = unfill(p); }
l214ah:						; m23:
	ld	l,(ix-4)	;214a			;
	ld	h,(ix-3) ;l2	;214d			;
	ld	l,(hl)		;2150			;
	ld	de,-1		;2151			;
	add	iy,de		;2154			;
	ld	(iy+0),l	;2156			; *--p = *vp;
l2159h:						; m24:
	ld	l,(ix-4)	;2159			;
	ld	h,(ix-3) ;l2	;215c			;
	dec	hl		;215f			;
	ld	(ix-4),l	;2160			;
	ld	(ix-3),h ;l2	;2163			;
	ld	a,(hl)		;2166 			;
	ld	e,a		;2167			;
	rla			;2168			;
	sbc	a,a		;2169			;
	ld	d,a		;216a			;
	ld	hl,array_9d3e	;216b 	fastab		;
	add	hl,de		;216e			;
	bit	5,(hl)		;216f			;
	jr	z,l212dh	;2171			; while(!iswarn(*--vp)) { /* goto m22; */

	ld	a,(byte_58c0)	;2173	warnc		;
	ld	e,a		;2176			;
	ld	l,(ix-4)	;2177			;
	ld	h,(ix-3) ;l2	;217a			;
	ld	a,(hl)		;217d			;
	cp	e		;217e			;
	jp	nz,l21e4h	;217f	z ???		; if(*vp == warnc) {	/* goto m28; */

	push	ix		;2182			;
	pop	de		;2184			;
	dec	hl		;2185			;
	ld	(ix-4),l	;2186			;
	ld	(ix-3),h ;l2	;2189			;
	ld	a,(hl)		;218c			; 
	ld	l,a		;218d			;
	rla			;218e			;
	sbc	a,a		;218f			;
	ld	h,a		;2190			;
	dec	hl		;2191			;
	add	hl,hl		;2192			;
	add	hl,de		;2193			;
	ld	de,0ffbah	;2194	-50 ???		; 
	add	hl,de		;2197			;
	ld	c,(hl)		;2198			;
	inc	hl		;2199			;
	ld	b,(hl)		;219a			;
	ld	(ix-2),c	;219b			;
	ld	(ix-1),b ;l1	;219e			; ca = actual[*--vp-1];
	jp	l21d0h		;21a1			; goto m27;
l21a4h:						; m25:
	push	iy		;21a4			;
	pop	de		;21a6			;
	ld	hl,(word_a665)	;21a7			;
	call	wrelop		;21aa			;
	jp	c,l21c1h	;21ad			; if(bob(p)) { /*  goto m26; */
	ld	(word_a685),iy	;21b0	inp		;
	ld	(word_a66b),iy	;21b4	outp		; outp = inp = p;
	push	iy		;21b8			;
	call	sub_0a7bh	;21ba	unfill()	;
	pop	bc		;21bd			;
	push	hl		;21be			;
	pop	iy		;21bf			; p = unfill(p); }
l21c1h:						; m26:
	ld	l,(ix-2)	;21c1			;
	ld	h,(ix-1) ;l1	;21c4			;
	ld	l,(hl)		;21c7			;
	ld	de,-1		;21c8			;
	add	iy,de		;21cb			;
	ld	(iy+0),l	;21cd			; *--p = *vp; }
l21d0h:						; m27:
	ld	l,(ix-2)	;21d0			;
	ld	h,(ix-1) ;l1	;21d3			;
	dec	hl		;21d6			;
	ld	(ix-2),l	;21d7			;
	ld	(ix-1),h ;l1	;21da			;
	ld	a,(hl)		;21dd			;
	or	a		;21de			;
	jr	nz,l21a4h	;21df			; while(*--ca) { 	/* goto m25; */
	jp	l2159h		;21e1			; goto m24;
l21e4h:						; m28:
	ld	(word_a685),iy	;21e4	inp		;
	ld	(word_a66b),iy	;21e8	outp		; outp = inp = p;
	jp	l1e18h		;21ec			; return p;		/* goto m1; */

;	End sub_1df5h

; =============== F U N C T I O N =======================================
;
;		trmdir
sub_21efh:						; char * sub_21efh(register * st) {
	call	csv		;21ef			; char * l1;
	push	hl		;21f2
	ld	l,(ix+6)	;21f3			;
	ld	h,(ix+7)	;21f6			;
	push	hl		;21f9			;
	pop	iy		;21fa			;

	ld	(ix-2),l	;21fc			;
	ld	(ix-1),h ;l1	;21ff			; l1 = st;
l2202h:							; m1:
	ld	l,(ix-2)	;2202			;
	ld	h,(ix-1) ;l1	;2205			;
	ld	a,(hl)		;2208			;
	inc	hl		;2209			;
	ld	(ix-2),l	;220a			;
	ld	(ix-1),h ;l1	;220d			;
	or	a		;2210			;
	jr	nz,l2202h	;2211			; if(*(l1++) != 0) goto m1;

	dec	hl		;2213			;
	ld	(ix-2),l	;2214			;
	ld	(ix-1),h ;l1	;2217			; l1--;
l221ah:							; m2:
	ld	e,(ix-2)	;221a			;
	ld	d,(ix-1) ;l1	;221d			;
	push	iy		;2220			;
	pop	hl		;2222			;
	call	wrelop		;2223			;
	ld	l,(ix-2)	;2226			;
	ld	h,(ix-1) ;l1	;2229			;
	jr	nc,l223ah	;222c			; if(st >= l1) goto m3;
	
	dec	hl		;222e			;
	ld	(ix-2),l	;222f			;
	ld	(ix-1),h ;l1	;2232			;
	ld	a,(hl)		;2235			;
	cp	02fh	;'/'	;2236			;
	jr	nz,l221ah	;2238			; if(*(--l1) != '/') goto m2;
l223ah:							; m3:
	ld	(hl),0		;223a			; *l1 = 0;
	push	iy		;223c			;
	pop	hl		;223e			;
	jp	cret		;223f			; return st;

;	End sub_21efh	trmdir				; }

; =============== F U N C T I O N =======================================
;
;		copy
sub_2242h:						; int sub_2242h(register * st) {
	call	csv		;2242			; char * l1;
	push	hl		;2245			;
	ld	l,(ix+6)	;2246			;
	ld	h,(ix+7)	;2249			;
	push	hl		;224c			;
	pop	iy		;224d			;

	ld	hl,(word_58be)	;224f			;
	ld	(ix-2),l	;2252			;
	ld	(ix-1),h ;l1	;2255			; l1 = word_58be;
l2258h:							; m1:
	ld	a,(iy+0)	;2258			;
	inc	iy		;225b			;
	ld	hl,(word_58be)	;225d			;
	inc	hl		;2260			;
	ld	(word_58be),hl	;2261			;
	dec	hl		;2264			;
	ld	(hl),a		;2265			; 
	or	a		;2266			;
	jr	nz,l2258h	;2267			; if((*(word_58be++) = *(st++)) != 0) goto m1;

	ld	l,(ix-2)	;2269			;
	ld	h,(ix-1) ;l1	;226c			;
	jp	cret		;226f			; return l1;

;	End sub_2242h	copy				; }

; =============== F U N C T I O N =======================================
;
;		strdex
sub_2272h:						; int sub_2272h(p1, p2) {
	call	csv		;2272			;
	ld	l,(ix+6)	;2275			;
	ld	h,(ix+7) ;p1	;2278			;
l227bh:							; m1:		    
	ld	a,(hl)		;227b			;
	or	a		;227c			;
	jr	nz,l2285h	;227d			; if(*p1 != 0) goto m2;
	ld	hl,0		;227f			; return 0;
	jp	cret		;2282			;
l2285h:							; m2:		    
	ld	l,(ix+6)	;2285			;
	ld	h,(ix+7)	;2288			;
	ld	a,(hl)		;228b			;
	inc	hl		;228c			;
	ld	(ix+6),l	;228d			;
	ld	(ix+7),h	;2290			;
	cp	(ix+8)		;2293			;
	jr	nz,l227bh	;2296			; if(*(p1++) != p2) goto m1;

	dec	hl		;2298			;
	ld	(ix+6),l	;2299			;
	ld	(ix+7),h	;229c			; p1--;
	jp	cret		;229f			; return;
	ld	hl,1		;22a2			;
	ret			;22a5			; return 1;

;	End sub_2272h	strdex				; }

; =============== F U N C T I O N =======================================
;   main
;
_main:							; int main(int argc, char **argv) {
	call	ncsv		;22a6
	dw	0FFF8H	; -8	;22a9

	ld	de,1		;22ab			;
	ld	l,(ix+6)	;22ae			;
	ld	h,(ix+7)	;22b1 argc		;
	or	a		;22b4			;
	sbc	hl,de		;22b5			;
	jp	nz,l22d6h	;22b7			; if(argc != 1) goto m1;
    
	ld	hl,l5b7ah	;22ba hl="cpp"		;
	push	hl		;22bd \(2)		;
	ld	hl,0		;22be			;
	push	hl		;22c1 \(1)		;
	call	__getargs	;22c2			;
	pop	bc		;22c5			;
	pop	bc		;22c6			;
	ld	(ix+8),l	;22c7			;
	ld	(ix+9),h ;argv	;22ca			; argv = __getargs(0, "cpp");
	
	ld	hl,(__argc_)	;22cd			;
	ld	(ix+6),l	;22d0			;
	ld	(ix+7),h ;argc	;22d3			; argc = __argc_;
	
l22d6h:						; m1:
	ld	iy,l5b7eh	;22d6			; st = "_ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	ld	(ix-2),0	;22da			;      "abcdefghijklmnopqrstuvwxyz0123456789"
	ld	(ix-1),0 ;l1	;22de l1		; l1 = 0;
	jp	l22f9h		;22e2			; goto m3;
	
l22e5h:						; m2:
	ld	e,(ix-4)	;22e5			;
	ld	d,(ix-3) ;l2	;22e8 l2		;
	ld	hl,array_9d3e	;22eb			;
	add	hl,de		;22ee			; 
	ld	a,(hl)		;22ef			;
	or	7		;22f0			;
	ld	(hl),a		;22f2			; array_9d3e[l2] |= 7;
	
	ld	hl,array_9c14	;22f3			;
	add	hl,de		;22f6			;
	ld	(hl),2		;22f7			; array_9c14[l2] = 2;
l22f9h:						; m3:
	ld	a,(iy+0)	;22f9			;
	inc	iy		;22fc			; 
	ld	l,a		;22fe			;
	rla			;22ff			;
	sbc	a,a		;2300			;
	ld	h,a		;2301			;
	ld	(ix-4),l	;2302			;
	ld	(ix-3),h ;l2	;2305			;
	ld	a,l		;2308			;
	or	h		;2309			;
	jr	nz,l22e5h	;230a			; if((l2 = *(st++)) != 0) goto m2;
	
	ld	iy,l5bbeh	;230c			; iy = "0123456789.";
	jp	l2327h		;2310			; goto m5;
	
l2313h:						; m4:
	ld	e,(ix-4)	;2313			;
	ld	d,(ix-3) ;l2	;2316			;
	ld	hl,array_9d3e	;2319			;
	add	hl,de		;231c			;
	ld	a,(hl)		;231d			;
	or	6		;231e			;
	ld	(hl),a		;2320			; array_9d3e[l2] |= 6;
	ld	hl,array_9c14	;2321			;
	add	hl,de		;2324			;
	ld	(hl),3		;2325			; array_9c14[l2] = 3;
l2327h:						; m5:
	ld	a,(iy+0)	;2327			;
	inc	iy		;232a			;
	ld	l,a		;232c			;
	rla			;232d			;
	sbc	a,a		;232e			;
	ld	h,a		;232f			;
	ld	(ix-4),l	;2330			;
	ld	(ix-3),h ;l2	;2333			;
	ld	a,l		;2336			;
	or	h		;2337			;
	jr	nz,l2313h	;2338			; if((l2 = *(st++)) != 0) goto m4;
    
	ld	iy,l5bcah	;233a			; st = "\n\"'/\";
	jr	l234ch		;233e			; goto m7;
l2340h:						; m6:
	ld	e,(ix-4)	;2340			;
	ld	d,(ix-3) ;l2	;2343			;
	ld	hl,array_9d3e	;2346			;
	add	hl,de		;2349			;
	set	1,(hl)		;234a			; bitset(array_9d3e[l2],1);
l234ch:						; m7:
	ld	a,(iy+0)	;234c			;
	inc	iy		;234f			;
	ld	l,a		;2351			;
	rla			;2352			;
	sbc	a,a		;2353			;
	ld	h,a		;2354			;
	ld	(ix-4),l	;2355			;
	ld	(ix-3),h ;l2	;2358			;
	ld	a,l		;235b			;
	or	h		;235c			;
	jr	nz,l2340h	;235d			; if((l2 = *(st++)) != 0) goto m6;
    
	ld	iy,l5bd0h	;235f			; st = "\n\"'\";
	jr	l2371h		;2363			; goto m9;
l2365h:						; m8:
	ld	e,(ix-4)	;2365			;
	ld	d,(ix-3) ;l2	;2368			;
	ld	hl,array_9d3e	;236b			;
	add	hl,de		;236e			;
	set	4,(hl)		;236f			; bitset(array_9d3e[l2],4);
l2371h:						; m9:
	ld	a,(iy+0)	;2371			;
	inc	iy		;2374			;
	ld	l,a		;2376			;
	rla			;2377			;
	sbc	a,a		;2378			;
	ld	h,a		;2379			;
	ld	(ix-4),l	;237a			;
	ld	(ix-3),h ;l2	;237d			;
	ld	a,l		;2380			;
	or	h		;2381			;
	jr	nz,l2365h	;2382			; if((l2 = *(st++)) != 0) goto m8;

	ld	iy,l5bd5h	;2384			; st = "*\n";
	jr	l2396h		;2388			; goto m11;
l238ah:						; m10:
	ld	e,(ix-4)	;238a			;
	ld	d,(ix-3) ;l2	;238d			;
	ld	hl,array_9d3e	;2390			;
	add	hl,de		;2393			;
	set	3,(hl)		;2394			; bitset(array_9d3e[l2],3);
l2396h:						; m11:
	ld	a,(iy+0)	;2396			;
	inc	iy		;2399			;
	ld	l,a		;239b			;
	rla			;239c			;
	sbc	a,a		;239d			;
	ld	h,a		;239e			;
	ld	(ix-4),l	;239f			;
	ld	(ix-3),h ;l2	;23a2			;
	ld	a,l		;23a5			;
	or	h		;23a6			;
	jr	nz,l238ah	;23a7			; if((l2 = *(st++)) != 0) goto m10;

	ld	a,(byte_58c0)	;23a9			;
	ld	e,a		;23ac			;
	rla			;23ad			;
	sbc	a,a		;23ae			;
	ld	d,a		;23af			;
	ld	hl,array_9d3e	;23b0			;
	add	hl,de		;23b3			;
	set	5,(hl)		;23b4			; bitset(array_9d3e[byte_58c0],5);

	ld	hl,array_9d3e	;23b6			;
	ld	a,(hl)		;23b9			;
	or	03ah	;':'	;23ba			;
	ld	(hl),a		;23bc			; array_9d3e[0] |= ':';

	ld	(ix-2),0	;23bd
	ld	(ix-1),1 ;l1	;23c1			; l1 = 16;
	jp	l23dah		;23c5			; goto m13;
l23c8h:						; m12:
	ld	e,(ix-2)	;23c8			;
	ld	d,(ix-1) ;l1	;23cb			;
	ld	hl,array_9cbe	;23ce			;
	add	hl,de		;23d1			;
	ld	a,(hl)		;23d2			;
	or	2		;23d3			;
	ld	hl,array_6625	;23d5			;
	add	hl,de		;23d8			;
	ld	(hl),a		;23d9			; array_6625[l1] = array_9cbe[l1] | 2;
l23dah:						; m13:
	ld	l,(ix-2)	;23da			;
	ld	h,(ix-1) ;l1	;23dd			;
	dec	hl		;23e0			;
	ld	(ix-2),l	;23e1			;
	ld	(ix-1),h ;l1	;23e4			;
	bit	7,h		;23e7			;
	jr	z,l23c8h	;23e9			; if((unsigned)--l1 & 0x8000) == 0) goto m12;

	ld	iy,l5bd8h	;23eb			; st = " \t\v\f\r"
	jp	l23feh		;23ef			; goto m15;
l23f2h:						; m14:
	ld	e,(ix-4)	;23f2			;
	ld	d,(ix-3) ;l2	;23f5			;
	ld	hl,array_9c14	;23f8			;
	add	hl,de		;23fb			;
	ld	(hl),1		;23fc			; array_9c14[l2] = 1;
l23feh:						; m15:
	ld	a,(iy+0)	;23fe			;
	inc	iy		;2401			;
	ld	l,a		;2403			;
	rla			;2404			;
	sbc	a,a		;2405			;
	ld	h,a		;2406			;
	ld	(ix-4),l	;2407			;
	ld	(ix-3),h ;l2	;240a			;
	ld	a,l		;240d			;
	or	h		;240e			;
	jr	nz,l23f2h	;240f			; if((l2 = *(st++)) != 0) goto m14;

	ld	(ix-2),1	;2411			;
	ld	(ix-1),0 ;l1	;2415			; l1 = 1;
	jp	l2479h		;2419			; goto m18;

			

l241ch:						; m16:
	ld	e,(ix+8)	;241c	
	ld	d,(ix+9) ;argv	;241f	
	ld	l,(ix-2)	;2422	
	ld	h,(ix-1) ;l1	;2425	
	add	hl,hl		;2428	
	add	hl,de		;2429	
	ld	a,(hl)		;242a	
	inc	hl		;242b	
	ld	h,(hl)		;242c	
	ld	l,a		;242d	
	inc	hl		;242e	
	ld	a,(hl)		;242f	
	or	a		;2430	
	jp	z,l246ch	;2431			; if(argv[0][l1] == 0) goto m17;
	cp	'C'		;2434 'C'
	jp	z,l24a0h	;2436			; if(argv[0][l1] == 'C') goto m21;
	cp	'D'		;2439 'D'
	jp	z,l24a9h	;243b			; if( == 'D') goto m22;
	cp	'E'		;243e 'E'
	jp	z,l246ch	;2440			; if( == 'E') goto m17;
	cp	'I'		;2443 'I'
	jp	z,l2536h	;2445			; if( == 'I') goto m29;
	cp	'P'		;2448 'P'
	jp	z,l248eh	;244a			; if( == 'P') goto m19;
	cp	'R'		;244d 'R'
	jp	z,l2497h	;244f			; if( == 'R') goto m20;
	cp	'U'		;2452 'U'
	jp	z,l2502h	;2454			; if( == 'U') goto m27;

	ld	l,(ix-2)	;2457			;
	ld	h,(ix-1) ;l1	;245a			;
	add	hl,hl		;245d			;
	add	hl,de		;245e			;
	ld	c,(hl)		;245f			;
	inc	hl		;2460			;
	ld	b,(hl)		;2461			;
	push	bc		;2462\			;
	ld	hl,l5c3fh	;2463 			;
	push	hl		;2466\			;
	call	sub_1ad2h	;2467			; sub_1ad2h("unknown flag %s", &argv[l1][0]);
	pop	bc		;246a			;
	pop	bc		;246b			;
l246ch:				;	'E'	; m17:
	ld	l,(ix-2)	;246c			;
	ld	h,(ix-1) ;l1	;246f			;
	inc	hl		;2472			;
	ld	(ix-2),l	;2473			;
	ld	(ix-1),h ;l1	;2476			; ++l1;
l2479h:						; m18:
	ld	e,(ix+6)	;2479			;
	ld	d,(ix+7) ;argc	;247c			;
	ld	l,(ix-2)	;247f			;
	ld	h,(ix-1) ;l1	;2482			;
	call	wrelop		;2485			;
	jp	m,l2571h	;2488			; if(argc < l1) goto m31;
	jp	l2589h		;248b			; goto m32;

l248eh:				;	'P'	; m19:
	ld	hl,(word_9c98)	;248e			;
	inc	hl		;2491			;
	ld	(word_9c98),hl	;2492			; (word_9c98)++;		    
	jr	l246ch		;2495			; goto m17;

l2497h:				;	'R'	; m20:
	ld	hl,(word_9cba)	;2497			;
	inc	hl		;249a			;
	ld	(word_9cba),hl	;249b			; (word_9cba)++;
	jr	l246ch		;249e			; goto m17;

l24a0h:				;	'C'	; m21:
	ld	hl,(word_9e14)	;24a0			;
	inc	hl		;24a3			;
	ld	(word_9e14),hl	;24a4			; (word_9e14)++;
	jr	l246ch		;24a7			; goto m17;

l24a9h:				;	'D'	; m22:
	ld	de,(word_58c7)	;24a9			;
	ld	hl,array_9de6	;24ad			;
	call	wrelop		;24b0			;
	ld	e,(ix+8)	;24b3			;
	ld	d,(ix+9) ;argv	;24b6			;
	ld	l,(ix-2)	;24b9			;
	ld	h,(ix-1) ;l1	;24bc			;
	jp	nc,l24d3h	;24bf			; if(array_9de6 >= word_58c7) goto m24;

	add	hl,hl		;24c2			;		
	add	hl,de		;24c3			;
	ld	c,(hl)		;24c4			;
	inc	hl		;24c5			;
	ld	b,(hl)		;24c6			;
	push	bc		;24c7\			;
	ld	hl,l5bdeh	;24c8 "too many -D	;
				; options, ignoring %s"	;
l24cbh:						; m23:
	push	hl		;24cb\			;
	call	sub_1ad2h	;24cc			; sub_1ad2h("too many -D options, ignoring %s", &argv[l1][0]);
	pop	bc		;24cf			;
	pop	bc		;24d0			;
	jr	l246ch		;24d1			; goto m17;
l24d3h:						; m24:
	add	hl,hl		;24d3			;
	add	hl,de		;24d4			;
	ld	a,(hl)		;24d5			;
	inc	hl		;24d6			;
	ld	h,(hl)		;24d7			;
	ld	l,a		;24d8			;
	inc	hl		;24d9			;
	inc	hl		;24da			;
	ld	a,(hl)		;24db			;
	or	a		;24dc			;
	jr	z,l246ch	;24dd			; if(argv[l1][2] == 0) goto m17;

	ld	e,(ix+8)	;24df			;
	ld	d,(ix+9) ;argv	;24e2			;
	ld	l,(ix-2)	;24e5			;
	ld	h,(ix-1) ;l1	;24e8			;
	add	hl,hl		;24eb			;
	add	hl,de		;24ec			;
	ld	c,(hl)		;24ed			;
	inc	hl		;24ee			;
	ld	b,(hl)		;24ef			;
	inc	bc		;24f0			;
	inc	bc		;24f1			;
	ld	hl,(word_58c7)	;24f2			;
	inc	hl		;24f5			;
	inc	hl		;24f6			;
	ld	(word_58c7),hl	;24f7			;
l24fah:						; m25:
	dec	hl		;24fa			; /* -- */
	dec	hl		;24fb			;
l24fch:						; m26:
	ld	(hl),c		;24fc			;
	inc	hl		;24fd			;
	ld	(hl),b		;24fe			; *(word_58c7++) = argv[l1][2];
	jp	l246ch		;24ff			; goto m17;
l2502h:				;	'U'		; m27:
	ld	de,(word_58c9)	;2502			;
	ld	hl,word_a626	;2506			;
	call	wrelop		;2509			;
	ld	e,(ix+8)	;250c			;
	ld	d,(ix+9) ;argv	;250f			;
	ld	l,(ix-2)	;2512			;
	ld	h,(ix-1) ;l1	;2515			;
	jr	nc,l2525h	;2518			; if(word_a626 >= word_58c9) goto m28;

	add	hl,hl		;251a			;
	add	hl,de		;251b			;
	ld	c,(hl)		;251c			;
	inc	hl		;251d			;
	ld	b,(hl)		;251e			;
	push	bc		;251f\			;
	ld	hl,l5bffh	;2520			; sub_1ad2h("too many -U options, ignoring %s", &argv[l1][0]);
	jr	l24cbh		;2523			; goto m17; /* goto m23; */
l2525h:						; m28:
	add	hl,hl		;2525			;
	add	hl,de		;2526			;
	ld	c,(hl)		;2527			;
	inc	hl		;2528			;
	ld	b,(hl)		;2529			;
	inc	bc		;252a			;
	inc	bc		;252b			;
	ld	hl,(word_58c9)	;252c			;
	inc	hl		;252f			;
	inc	hl		;2530			;
	ld	(word_58c9),hl	;2531			; *(word_58c9++) = argv[l1][2];
	jr	l24fah		;2534			; goto m17;  /* goto m25; */

l2536h:				;	'I'	; m29:
	ld	de,(word_58c5)	;2536			;
	ld	hl,8		;253a			;
	call	wrelop		;253d			;
	ld	e,(ix+8)	;2540			;
	ld	d,(ix+9) ;argv	;2543			;
	ld	l,(ix-2)	;2546			;
	ld	h,(ix-1) ;l1	;2549			;
	jp	p,l255bh	;254c			; if(8 >= word_58c5) goto m30;

	add	hl,hl		;254f 			;
	add	hl,de		;2550 			;
	ld	c,(hl)		;2551 			;
	inc	hl		;2552 			;
	ld	b,(hl)		;2553 			;
	push	bc		;2554\ 			;
	ld	hl,l5c20h	;2555 			; sub_1ad2h("excessive -I\tfile (%s) ignored", &argv[l1][0]);
	jp	l24cbh		;2558			; goto m17; /* goto m23; */
l255bh:						; m30:
	add	hl,hl		;255b			;
	add	hl,de		;255c			;
	ld	c,(hl)		;255d			;
	inc	hl		;255e			;
	ld	b,(hl)		;255f			;
	inc	bc		;2560			;
	inc	bc		;2561			;
	ld	de,array_9de6	;2562			;
	ld	hl,(word_58c5)	;2565			;
	inc	hl		;2568			;
	ld	(word_58c5),hl	;2569			; array_9de6[word_58c5++] = argv[l1][2];
	dec	hl		;256c			;
	add	hl,hl		;256d			;
	add	hl,de		;256e			;
	jr	l24fch		;256f			; goto m17; /* goto m26; */
l2571h:						; m31:
	ld	e,(ix+8)	;2571			;
	ld	d,(ix+9) ;argv	;2574			;
	ld	l,(ix-2)	;2577			;
	ld	h,(ix-1) ;l1	;257a			;
	add	hl,hl		;257d			;
	add	hl,de		;257e			;
	ld	a,(hl)		;257f			;
	inc	hl		;2580			;
	ld	h,(hl)		;2581			;
	ld	l,a		;2582			;
	ld	a,(hl)		;2583			;
	cp	02dh	; '-'	;2584			;
	jp	z,l241ch	;2586			; if(argv[l1][0] == '-') goto m16;



l2589h:							; m32:
	ld	e,(ix+6)	;2589			;
	ld	d,(ix+7) ;argc	;258c			;
	ld	l,(ix-2)	;258f			;
	ld	h,(ix-1) ;l1	;2592			;
	call	wrelop		;2595			;
	jp	p,l2692h	;2598			; if(l1 >= ;argc) goto m34;

	ld	hl,l63efh	;259b			;
	push	hl		;259e\			;
	ld	hl,l5c4fh	;259f "r"		;
	push	hl		;25a2\			;
	ld	e,(ix+8)	;25a3			;
	ld	d,(ix+9) ;argv	;25a6			;
	ld	l,(ix-2)	;25a9			;
	ld	h,(ix-1) ;l1	;25ac			;
	add	hl,hl		;25af			;
	add	hl,de		;25b0			;
	ld	c,(hl)		;25b1			;
	inc	hl		;25b2			;
	ld	b,(hl)		;25b3			;
	push	bc		;25b4\			;
	call	_freopen	;25b5			;
	pop	bc		;25b8			;
	pop	bc		;25b9			;
	pop	bc		;25ba			;
	ld	(word_58c1),hl	;25bb			; word_58c1 = freopen(argv[l1][0], "r", stdin);
	ld	a,l		;25be			;
	or	h		;25bf			;
	ld	e,(ix+8)	;25c0			;
	ld	d,(ix+9) ;argv	;25c3			;
	ld	l,(ix-2)	;25c6			;
	ld	h,(ix-1) ;l1	;25c9	i		;
	jp	nz,l25f1h	;25cc			; if(word_58c1 != 0) goto m33;

	add	hl,hl		;25cf			;
	add	hl,de		;25d0			;
	ld	c,(hl)		;25d1			;
	inc	hl		;25d2			;
	ld	b,(hl)		;25d3			;
	push	bc		;25d4\			;
	ld	hl,l5c51h	;25d5			;
	push	hl		;25d8\			;
	call	sub_1ad2h	;25d9			; sub_1ad2h("No source file\t%s", argv[i][0]);
	pop	bc		;25dc			;
	ld	hl,8		;25dd			;
	ex	(sp),hl		;25e0			;
	call	exit		;25e1			; exit(8);
	pop	bc		;25e4			;

	ld	e,(ix+8)	;25e5			;
	ld	d,(ix+9) ;argv	;25e8			;
	ld	l,(ix-2)	;25eb			;
	ld	h,(ix-1) ;l1	;25ee	i		;
l25f1h:							; m33:
	add	hl,hl		;25f1			;
	add	hl,de		;25f2			;
	ld	c,(hl)		;25f3			;
	inc	hl		;25f4			;
	ld	b,(hl)		;25f5			;
	push	bc		;25f6\			;
	call	sub_2242h	;25f7 ;	copy		;
	pop	bc		;25fa/			;
	push	hl		;25fb\			;
	ld	de,array_9b7e	;25fc	fnames		;
	ld	hl,(word_a626)	;25ff	ifno		;
	add	hl,hl		;2602			;
	add	hl,de		;2603			;
	pop	de		;2604/			;
	ld	(hl),e		;2605			;
	inc	hl		;2606			;
	ld	(hl),d		;2607			; fnames[ifno] = copy(argv[i][0]);

	ld	e,(ix+8)	;2608			;
	ld	d,(ix+9) ;argv	;260b			;
	ld	l,(ix-2)	;260e			;
	ld	h,(ix-1) ;l1	;2611	i		;
	add	hl,hl		;2614			;
	add	hl,de		;2615			;
	ld	c,(hl)		;2616			;
	inc	hl		;2617			;
	ld	b,(hl)		;2618			;
	push	bc		;2619			;
	call	sub_21efh	;261a	trmdir		;
	pop	bc		;261d			;
	push	hl		;261e\			;
	ld	de,array_a66f	;261f	dirnams		;
	ld	hl,(word_a626)	;2622	ifno		;
	add	hl,hl		;2625			;
	add	hl,de		;2626			;
	pop	de		;2627/			;
	ld	(hl),e		;2628			;
	inc	hl		;2629			;
	ld	(hl),d		;262a			; 

	ld	(array_9de6),de	;262b	dirs		; dirs = dirnams[ifno] = trmdir(argv[i][0]);
	ld	e,(ix+6)	;262f			;
	ld	d,(ix+7) ;argc	;2632			;
	ld	l,(ix-2)	;2635			;
	ld	h,(ix-1) ;l1	;2638	i		;
	inc	hl		;263b			;
	ld	(ix-2),l	;263c			;
	ld	(ix-1),h ;l1	;263f			;
	call	wrelop		;2642			;
	jp	p,l2692h	;2645			; if(++i >= argc) goto m34:

	ld	hl,l63f7h	;2648			;
	push	hl		;264b\			;
	ld	hl,l5c63h	;264c "w"		;
	push	hl		;264f\			;
	ld	e,(ix+8)	;2650			;
	ld	d,(ix+9) ;argv	;2653			;
	ld	l,(ix-2)	;2656			;
	ld	h,(ix-1) ;l1	;2659			;
	add	hl,hl		;265c			;
	add	hl,de		;265d			;
	ld	c,(hl)		;265e			;
	inc	hl		;265f			;
	ld	b,(hl)		;2660			;
	push	bc		;2661\			;
	call	_freopen	;2662			;
	pop	bc		;2665			;
	pop	bc		;2666			;
	pop	bc		;2667			;
	ld	(word_58c3),hl	;2668	fout		; fout = freopen(&argv[l1][0], "w", stdout);
	ld	a,l		;266b
	or	h		;266c
	jp	nz,l2692h	;266d			; if(fout != 0) goto m34:
    
	ld	e,(ix+8)	;2670			;
	ld	d,(ix+9) ;argv	;2673			;
	ld	l,(ix-2)	;2676			;
	ld	h,(ix-1) ;l1	;2679			;
	add	hl,hl		;267c			;
	add	hl,de		;267d			;
	ld	c,(hl)		;267e			;
	inc	hl		;267f			;
	ld	b,(hl)		;2680			;
	push	bc		;2681\			;
	ld	hl,l5c65h	;2682			;
	push	hl		;2685\			;
	call	sub_1ad2h	;2686			; sub_1ad2h("Can't create %s", &argv[l1][0]);
	pop	bc		;2689			;
	ld	hl,8		;268a			;
	ex	(sp),hl		;268d			;
	call	exit		;268e			; exit(8);
	pop	bc		;2691			;



l2692h:					    	; m34:
	ld	de,array_9dfe	;2692			;
	ld	hl,(word_a626)	;2695			;
	add	hl,hl		;2698			;
	add	hl,de		;2699			;
	ld	de,(word_58c1)	;269a			;
	ld	(hl),e		;269e			;
	inc	hl		;269f			;
	ld	(hl),d		;26a0			; array_9dfe[word_a626] = word_58c1;

	ld	hl,0		;26a1			;
	ld	(word_9ca4),hl	;26a4			; word_9ca4 = 0;

	ld	de,array_9de6	;26a7			;
	ld	hl,(word_58c5)	;26aa			;
	inc	hl		;26ad			;
	ld	(word_58c5),hl	;26ae			;
	dec	hl		;26b1			;
	add	hl,hl		;26b2			;
	add	hl,de		;26b3			;
	ld	de,0		;26b4			;
	ld	(hl),e		;26b7			;
	inc	hl		;26b8			;
	ld	(hl),d		;26b9			; array_9de6[word_58c5++] = 0;

	ld	hl,l5c75h	;26ba "define"		;
	push	hl		;26bd			;
	call	sub_1a9bh	;26be			;
	ld	(word_9cb0),hl	;26c1			; word_9cb0 = sub_1a9bh("define");

	ld	hl,l5c7ch	;26c4 "undef"		;
	ex	(sp),hl		;26c7			;
	call	sub_1a9bh	;26c8			;
	ld	(word_9e2c),hl	;26cb			; word_9e2c = sub_1a9bh("undef");

	ld	hl,l5c82h	;26ce "include"		;
	ex	(sp),hl		;26d1			;
	call	sub_1a9bh	;26d2			;
	ld	(word_9c9a),hl	;26d5			; word_9c9a = sub_1a9bh("include");

	ld	hl,l5c8ah	;26d8 "else"		;
	ex	(sp),hl		;26db			;
	call	sub_1a9bh	;26dc			;
	ld	(word_a669),hl	;26df			; word_a669 = sub_1a9bh("else");

	ld	hl,l5c8fh	;26e2 "endif"		;
	ex	(sp),hl		;26e5			;
	call	sub_1a9bh	;26e6			;
	ld	(word_9caa),hl	;26e9			; word_9caa = sub_1a9bh("endif");

	ld	hl,l5c95h	;26ec "ifdef"		;
	ex	(sp),hl		;26ef			;
	call	sub_1a9bh	;26f0			;
	ld	(word_6621),hl	;26f3			; word_6621 = sub_1a9bh("ifdef");
	
	ld	hl,l5c9bh	;26f6 "ifndef"		;
	ex	(sp),hl		;26f9			;
	call	sub_1a9bh	;26fa			;
	ld	(word_a661),hl	;26fd			; word_a661 = sub_1a9bh("ifndef");
	
	ld	hl,l5ca2h	;2700 "if"		;
	ex	(sp),hl		;2703			;
	call	sub_1a9bh	;2704			;
	ld	(word_9ca2),hl	;2707			; word_9ca2 = sub_1a9bh("if");
	
	ld	hl,l5ca5h	;270a "line"		;
	ex	(sp),hl		;270d			;
	call	sub_1a9bh	;270e			;
	ld	(word_9ca6),hl	;2711			; word_9ca6 = sub_1a9bh("line");
	
	ld	hl,l5caah	;2714 "asm"		;
	ex	(sp),hl		;2717			;
	call	sub_1a9bh	;2718			;
	ld	(word_9c9e),hl	;271b			; word_9c9e = sub_1a9bh("asm");
	
	ld	hl,l5caeh	;271e "endasm"		;
	ex	(sp),hl		;2721			;
	call	sub_1a9bh	;2722			;
	pop	bc		;2725			;
	ld	(word_9cb4),hl	;2726			; word_9cb4 = sub_1a9bh("endasm");
	
	ld	(ix-2),0bh	;2729			;
	ld	(ix-1),01h ;l1	;272d			; l1 = 0x10B;
	jp	l2740h		;2731			; goto m36;
l2734h:						; m35:
	ld	e,(ix-2)	;2734			;
	ld	d,(ix-1) ;l1	;2737			;
	ld	hl,array_9a73	;273a			;
	add	hl,de		;273d			;
	ld	(hl),0		;273e			; array_9a73[l1] = 0;
l2740h:						; m36:
	ld	l,(ix-2)	;2740			;
	ld	h,(ix-1) ;l1	;2743			;
	dec	hl		;2746			;
	ld	(ix-2),l	;2747			;
	ld	(ix-1),h ;l1	;274a			;
	bit	7,h		;274d			;
	jr	z,l2734h	;274f			; if(((unsigned)--l1 & 0x8000) == 0) goto m35;

	ld	hl,l5cb5h	;2751 "z80"		;
	push	hl		;2754			;
	call	sub_19cch	;2755			;
	ld	(word_9ca0),hl	;2758			; word_9ca0 = sub_19cch("z80");

	ld	hl,l5cb9h	;275b "__LINE__"	;
	ex	(sp),hl		;275e			;
	call	sub_19cch	;275f			;
	ld	(word_9dfa),hl	;2762			; word_9dfa = sub_19cch("__LINE__");

	ld	hl,l5cc2h	;2765 "__FILE__"	;
	ex	(sp),hl		;2768			;
	call	sub_19cch	;2769			;
	pop	bc		;276c			;
	ld	(word_9cb6),hl	;276d			; word_9cb6 = sub_19cch("__FILE__");

	ld	de,array_9b7e	;2770			;
	ld	hl,(word_a626)	;2773			;
	add	hl,hl		;2776			;
	add	hl,de		;2777			;
	ld	c,(hl)		;2778			;
	inc	hl		;2779			;
	ld	b,(hl)		;277a			;
	ld	(ix-6),c	;277b			;
	ld	(ix-5),b ;l3	;277e			; l3 = array_9b7e[word_a626];

	ld	hl,(word_a626)	;2781			;
	add	hl,hl		;2784			;
	add	hl,de		;2785			;
	ld	de,l5ccbh	;2786 "command line"	;
	ld	(hl),e		;2789			;
	inc	hl		;278a			;
	ld	(hl),d		;278b			; array_9b7e[word_a626] = "command line";

	ld	de,array_9a43	;278c			;
	ld	hl,(word_a626)	;278f			;
	add	hl,hl		;2792			;
	add	hl,de		;2793			;
	ld	de,1		;2794			;
	ld	(hl),e		;2797			;
	inc	hl		;2798			;
	ld	(hl),d		;2799			; array_9a43[word_a626] = 1;

	ld	hl,09dbeh	;279a			;
	ld	(ix-8),l	;279d			;
	ld	(ix-7),h ;l4	;27a0			; l4 = 0x9DBE; /* ??? */
	jp	l27bbh		;27a3			; goto m38;
l27a6h:							; m37:
	ld	l,(ix-8)	;27a6			;
	ld	h,(ix-7) ;l4	;27a9			;
	ld	c,(hl)		;27ac			;
	inc	hl		;27ad			;
	ld	b,(hl)		;27ae			;
	inc	hl		;27af			;
	ld	(ix-8),l	;27b0			;
	ld	(ix-7),h ;l4	;27b3			;
	push	bc		;27b6			;
	call	sub_19cch	;27b7			; sub_19cch(*(l4++));
	pop	bc		;27ba			;
l27bbh:							; m38:
	ld	de,(word_58c7)	;27bb			;
	ld	l,(ix-8)	;27bf			;
	ld	h,(ix-7) ;l4	;27c2			;
	call	wrelop		;27c5			;
	jr	c,l27a6h	;27c8			; if(l4 < word_58c7) goto m37;

	ld	hl,0a5feh	;27ca			;
	ld	(ix-8),l	;27cd			;
	ld	(ix-7),h ;l4	;27d0			; l4 = 0xA5FE; /* ??? */
	jp	l2810h		;27d3			; goto m41;

l27d6h:							; m39:
	ld	hl,0003dh	;27d6			;
	push	hl		;27d9			;
	ld	l,(ix-8)	;27da			;
	ld	h,(ix-7) ;l4	;27dd			;
	ld	c,(hl)		;27e0			;
	inc	hl		;27e1			;
	ld	b,(hl)		;27e2			;
	push	bc		;27e3			;
	call	sub_2272h	;27e4			;
	pop	bc		;27e7			;
	pop	bc		;27e8			;
	push	hl		;27e9			;
	pop	iy		;27ea			;
	ld	a,l		;27ec			;
	or	h		;27ed			;
	jr	z,l27f6h	;27ee			; if(sub_2272h(*l4, 0x3D) == 0) goto m40;

	ld	(iy+0),0	;27f0			; *(st++) = 0;
	inc	iy		;27f4			;
l27f6h:							; m40:
	ld	hl,000feh	;27f6			;
	push	hl		;27f9			;
	ld	l,(ix-8)	;27fa			;
	ld	h,(ix-7) ;l4	;27fd			;
	ld	c,(hl)		;2800			;
	inc	hl		;2801			;
	ld	b,(hl)		;2802			;
	inc	hl		;2803			;
	ld	(ix-8),l	;2804			;
	ld	(ix-7),h ;l4	;2807			;
	push	bc		;280a			;
	call	sub_1b97h	;280b			; sub_1b97h(*(l4++), 0xFE);
	pop	bc		;280e			;
	pop	bc		;280f			;
l2810h:							; m41:
	ld	de,(word_58c9)	;2810			;
	ld	l,(ix-8)	;2814			;
	ld	h,(ix-7) ;l4	;2817			;
	call	wrelop		;281a			;
	jr	c,l27d6h	;281d			; if(l4 < word_58c9) goto m39;

	ld	de,array_9b7e	;281f			;
	ld	hl,(word_a626)	;2822			;
	add	hl,hl		;2825			;
	add	hl,de		;2826			;
	ld	e,(ix-6)	;2827			;
	ld	d,(ix-5) ;l3	;282a			;
	ld	(hl),e		;282d			;
	inc	hl		;282e			;
	ld	(hl),d		;282f			; array_9b7e[word_a626] = l3;

	ld	hl,09624h	;2830			;
	ld	(word_a665),hl	;2833			; word_a665 = 0x9624;	/* ??? */

	ld	de,(word_a665)	;2836			;
	ld	hl,0200h	;283a			;
	add	hl,de		;283d			;
	ld	(word_9c96),hl	;283e			; word_9c96 = 512 + word_a665;

	ex	de,hl		;2841			;
	ld	hl,0200h	;2842			;
	add	hl,de		;2845			;
	ld	(word_9b92),hl	;2846			; word_9b92 = 512 + word_9c96;

	ld	hl,0		;2849			;
	ld	(word_a683),hl	;284c			;
	ld	(word_9cae),hl	;284f			; word_9cae = word_a683 = 0;

	ld	hl,1		;2852			;
	ld	(array_9a43),hl	;2855			; array_9a43 = 1;

	call	sub_013dh	;2858			; sub_013dh();

	ld	hl,(word_9b92)	;285b			;
	ld	(word_a685),hl	;285e			;
	ld	(word_a66b),hl	;2861			; word_a66b = (word_a685 = word_9b92);

	push	hl		;2864			;
	call	sub_16ach	;2865			; sub_16ach(word_a66b);

	ld	hl,l63f7h	;2868			;
	ex	(sp),hl		;286b			;
	call	_fclose		;286c			;
	pop	bc		;286f			;
	ld	de,-1		;2870			;
	or	a		;2873			;
	sbc	hl,de		;2874			;
	jp	nz,l288ch ;-+	;2876			; if(fclose(stdout) != 0) goto m42:
			    ;
	ld	hl,l5cd8h   ;	;2879			;
	push	hl	    ;	;287c			;
	ld	hl,l63ffh   ;	;287d __iob+16			;
	push	hl	    ;	;2880			;
	call	_fprintf    ;	;2881			; fprintf(stderr ,"CPP: Error closing output file\n")
	pop	bc	    ;	;2884			;
	pop	bc	    ;	;2885			;
	ld	hl,1	    ;	;2886			;
	jp	cret	    ;	;2889			; return 1;
l288ch:			;<--+				; m42:
	ld	hl,(word_9ca4)	;288c			;
	jp	cret		;288f			; return word_9ca4;

; 	End _main					; }

; =============== F U N C T I O N =======================================
;
;		tobinary
sub_2892h:						; sub_2892h(char * p1, int p2) {
	call	ncsv		;2892			; int    l1;
	defw	0fff8h	;-8	;2895			; int    l2;
							; int    l3;
	ld	(ix-2),0	;2897			; char * l4;
	ld	(ix-1),0 ;l1	;289b			; l1 = 0;

	ld	l,(ix+6)	;289f			;
	ld	h,(ix+7) ;p1	;28a2			;
	ld	(ix-8),l	;28a5			;
	ld	(ix-7),h ;l4	;28a8			; l4 = p1;
	jp	l29d0h		;28ab			; goto m11;
l28aeh:						; m1:
	ld	l,(ix-4)	;28ae			;
	ld	h,(ix-3) ;l2	;28b1			;
	ld	a,h		;28b4			;
	or	a		;28b5			;
	jr	nz,l2918h	;28b6			; if(l2 != 0) goto m2;

	ld	a,l		;28b8			; switch(l2)
	cp	030h	; '0'	;28b9			;   case '0':
	jp	z,l2930h	;28bb			;
	cp	031h	; '1'	;28be			;   case '1':
	jp	z,l2930h	;28c0			;
	cp	032h	; '2'	;28c3			;   case '2':
	jr	z,l2930h	;28c5			;
	cp	033h	; '3'	;28c7			;   case '3':
	jr	z,l2930h	;28c9			;
	cp	034h	; '4'	;28cb			;   case '4':
	jr	z,l2930h	;28cd			;
	cp	035h	; '5'	;28cf			;   case '5': 
	jr	z,l2930h	;28d1			;
	cp	036h	; '6'	;28d3			;   case '6':
	jr	z,l2930h	;28d5			;
	cp	037h	; '7'	;28d7			;   case '7':
	jr	z,l2930h	;28d9			;
	cp	038h	; '8'	;28db			;   case '8':
	jr	z,l2930h	;28dd			;
	cp	039h	; '9'	;28df			;   case '9': goto m3;
	jr	z,l2930h	;28e1			;
	cp	041h	; 'A'	;28e3			;   case 'A':
	jp	z,l2969h	;28e5			;
	cp	042h	; 'B'	;28e8			;   case 'B':
	jp	z,l2969h	;28ea			;
	cp	043h	; 'C'	;28ed			;   case 'C':
	jp	z,l2969h	;28ef			;
	cp	044h	; 'D'	;28f2			;   case 'D':
	jp	z,l2969h	;28f4			;
	cp	045h	; 'E'	;28f7			;   case 'E':
	jp	z,l2969h	;28f9			;
	cp	046h	; 'F'	;28fc			;   case 'F': goto m6;
	jr	z,l2969h	;28fe			;
	cp	061h	; 'a'	;2900			;   case 'a':
	jr	z,l294ah	;2902			;
	cp	062h	; 'b'	;2904			;   case 'b':
	jr	z,l294ah	;2906			;
	cp	063h	; 'c'	;2908			;   case 'c':
	jr	z,l294ah	;290a			;
	cp	064h	; 'd'	;290c			;   case 'd':
	jr	z,l294ah	;290e			;
	cp	065h	; 'e'	;2910			;   case 'e':
	jr	z,l294ah	;2912			;
	cp	066h	; 'f'	;2914			;   case 'f': goto m5;
	jr	z,l294ah	;2916
l2918h:						; m2:
	ld	(ix-6),0ffh	;2918			;
	ld	(ix-5),0ffh	;291c			; l3 = -1;

	ld	de,0006ch	;2920			;
	ld	l,(ix-4)	;2923			;
	ld	h,(ix-3) ;l2	;2926			;
	or	a		;2929			;
	sbc	hl,de		;292a			;
	jr	nz,l298ah	;292c			; if(l2 != 0x6C) goto m7;
	jr	l2998h		;292e			; goto m8;
l2930h:						; m3:
	ld	e,(ix-4)	;2930			;
	ld	d,(ix-3) ;l2	;2933			;
	ld	hl,0ffd0h	;2936			;
	add	hl,de		;2939			;
	ld	(ix-6),l	;293a			;
	ld	(ix-5),h ;l3	;293d			; l3 = l2 + 0ffd0h;
l2940h:						; m4:
	bit	7,(ix-5)	;2940			; 
	jp	z,l29b4h	;2944			; if(((unsigned)l3 & 0x8000) == 0) goto m10;
	jp	l29edh		;2947			; goto m12;
l294ah:						; m5:
	ld	e,(ix-4)	;294a			;
	ld	d,(ix-3) ;l2	;294d			;
	ld	hl,0ff9fh	;2950			;
	add	hl,de		;2953			;
	ld	(ix-6),l	;2954			;
	ld	(ix-5),h ;l3	;2957			; l3 = l2 + 0ff9fh;

	ld	e,(ix+8)	;295a			;
	ld	d,(ix+9) ;p2	;295d			;
	ld	hl,0000ah	;2960			;
	call	wrelop		;2963			;
	jp	m,l2940h	;2966			; if(p2 > 10) goto m4;
l2969h:						; m6:
	ld	e,(ix-4)	;2969			;
	ld	d,(ix-3) ;l2	;296c			;
	ld	hl,0ffbfh	;296f			;
	add	hl,de		;2972			;
	ld	(ix-6),l	;2973			;
	ld	(ix-5),h ;l3	;2976			; l3 = l2 + 0ffbfh;

	ld	e,(ix+8)	;2979			;
	ld	d,(ix+9) ;p2	;297c			;
	ld	hl,0000ah	;297f			;
	call	wrelop		;2982			;
	jp	p,l2918h	;2985			; if(p2 < 10) goto m2;
	jr	l2940h		;2988			; goto m4;
l298ah:						; m7:
	ld	de,0004ch	;298a			;
	ld	l,(ix-4)	;298d			;
	ld	h,(ix-3) ;l2	;2990			;
	or	a		;2993			;
	sbc	hl,de		;2994			;
	jr	nz,l29a2h	;2996			; if(l2 != 0x4C) goto m9;
l2998h:						; m8:
	ld	l,(ix-8)	;2998			;
	ld	h,(ix-7) ;l4	;299b			;
	ld	a,(hl)		;299e			;
	or	a		;299f			;
	jr	z,l2940h	;29a0			; if(l4 == 0) goto m4;
l29a2h:						; m9:
	ld	l,(ix+6)	;29a2			;
	ld	h,(ix+7) ;p1	;29a5			;
	push	hl		;29a8			;
	ld	hl,l62ach	;29a9			;
	push	hl		;29ac			;
	call	sub_1ad2h	;29ad			;
	pop	bc		;29b0			; sub_1ad2h("Illegal number\t%s", p1);
	pop	bc		;29b1			;
	jr	l2940h		;29b2			; goto m4;
l29b4h:						; m10:
	ld	e,(ix+8)	;29b4			;
	ld	d,(ix+9) ;p2	;29b7			;
	ld	l,(ix-2)	;29ba			;
	ld	h,(ix-1) ;l1	;29bd			;
	call	lmul		;29c0			;
	ld	e,(ix-6)	;29c3			;
	ld	d,(ix-5) ;l3	;29c6			;
	add	hl,de		;29c9			;
	ld	(ix-2),l	;29ca			;
	ld	(ix-1),h ;l1	;29cd			; l1 = l3 + l1*p2;
l29d0h:						; m11:
	ld	l,(ix-8)	;29d0			;
	ld	h,(ix-7) ;l4	;29d3			;
	ld	a,(hl)		;29d6			;
	inc	hl		;29d7			;
	ld	(ix-8),l	;29d8			;
	ld	(ix-7),h ;l4	;29db			;
	ld	l,a		;29de			;
	rla			;29df			;
	sbc	a,a		;29e0			;
	ld	h,a		;29e1			;
	ld	(ix-4),l	;29e2			;
	ld	(ix-3),h ;l2	;29e5			; l2 = *(l4++);
	ld	a,l		;29e8
	or	h		;29e9
	jp	nz,l28aeh	;29ea			; if(l2 != 0) goto m1;
l29edh:						; m12:
	ld	l,(ix-2)	;29ed
	ld	h,(ix-1) ;l1	;29f0			; return l1;
	jp	cret		;29f3

;	End sub_2892h					; }

; =============== F U N C T I O N =======================================
;
;		yylex
sub_29f6h:						; int sub_29f6h() {
	call	ncsv		;29f6			; char l1, l5;
	defw	0fff8h	;-8	;29f9			; int l3; char * l2; char ** l4;
l29fbh:							; m0:
	ld	hl,(word_9c9c)	;29fb			;
	push	hl		;29fe			;
	call	sub_0a47h	;29ff			;
	pop	bc		;2a02			;
	ld	(word_9c9c),hl	;2a03			; word_9c9c = sub_0a47h(word_9c9c);

	ld	hl,(word_a685)	;2a06			;
	ld	a,(hl)		;2a09			;
	cp	'\n'		;2a0a			;
	jr	nz,l2a14h	;2a0c			; if(*word_a685 != '\n') goto m1;

	ld	hl,0x0102	;2a0e			;
	jp	cret		;2a11			; return 0x0102;
l2a14h:							; m1:
	ld	hl,(word_9c9c)	;2a14			;
	ld	l,(hl)		;2a17			;
	ld	(ix-1),l ;l1	;2a18			; l1 = *word_9c9c;

	ld	hl,(word_9c9c)	;2a1b			;
	ld	(hl),0		;2a1e			; *word_9c9c = 0;
	ld	hl,array_5d0a	;2a20			;
	ld	(ix-7),l	;2a23			;
	ld	(ix-6),h ;l4	;2a26			; l4 = array_5d0a;

	ld	de,array_5cfa	;2a29			;
l2a2ch:							; m2:
	dec	hl		;2a2c			;
	dec	hl		;2a2d			;
	ld	(ix-7),l	;2a2e			;
	ld	(ix-6),h ;l4	;2a31			;
	call	wrelop		;2a34			;
	jr	nc,l2a8bh	;2a37			; if(++l4 < array_5cfa) goto m4;

	ld	hl,l62e3h	;2a39			;
	ld	(ix-3),l	;2a3c			;
	ld	(ix-2),h ;l2	;2a3f			; l2 =  "+-*/%<>&^|?:!~(),";
l2a42h:							; m3:
	ld	a,(hl)		;2a42			;
	or	a		;2a43			;
	jp	nz,l2ad8h	;2a44			; if(l2 != 0) goto m6;

	ld	hl,(word_a685)	;2a47			;
	ld	a,(hl)		;2a4a			;
	ld	e,a		;2a4b			;
	rla			;2a4c			;
	sbc	a,a		;2a4d			;
	ld	d,a		;2a4e			;
	ld	hl,00039h	;2a4f			;
	call	wrelop		;2a52			;
	jp	m,l2b35h	;2a55			; if(0x39 < *word_a685) goto m12;

	ld	b,030h		;2a58			;
	ld	hl,(word_a685)	;2a5a			;
	ld	a,(hl)		;2a5d			;
	call	brelop		;2a5e			;
	ld	hl,(word_a685)	;2a61			;
	ld	a,(hl)		;2a64			;
	jp	m,l2b39h	;2a65			; if(*word_a685 < 0x30) goto m13;

	cp	030h	;'0'	;2a68			;
	jp	nz,l2b1bh	;2a6a			; if(*word_a685 != '0') goto m9;

	inc	hl		;2a6d			;
	ld	a,(hl)		;2a6e			;
	cp	078h	;'x'	;2a6f			;
	jp	z,l2b07h	;2a71			; if(*(word_a685+1) == 'x') goto m7;

	ld	a,(hl)		;2a74			;
	cp 	058h	;'X'	;2a75			;
	jp	z,l2b07h	;2a77			; if(*(word_a685+1) == 'X') goto m7;

	ld	hl,8		;2a7a			;
	push	hl		;2a7d			;
	ld	hl,(word_a685)	;2a7e			;
	inc	hl		;2a81			;
	push	hl		;2a82			;
	call	sub_2892h	;2a83			; word_a8ef = sub_2892h(word_a685-1, 8);
	pop	bc		;2a86			;
	pop	bc		;2a87			;
	jp	l2b16h		;2a88			; goto m10; /* goto m8;*/
l2a8bh:							; m4:
	ld	hl,(word_a685)	;2a8b			;
	push	hl		;2a8e			;
	ld	l,(ix-7)	;2a8f			;
	ld	h,(ix-6) ;l4	;2a92			;
	ld	c,(hl)		;2a95			;
	inc	hl		;2a96			;
	ld	b,(hl)		;2a97			;
	push	bc		;2a98			;
	call	strcmp		;2a99			;
	pop	bc		;2a9c			;
	pop	bc		;2a9d			;
	ld	a,l		;2a9e			;
	or	h		;2a9f			;
	ld	de,array_5cfa	;2aa0			;
	ld	l,(ix-7)	;2aa3			;
	ld	h,(ix-6) ;l4	;2aa6			;
	jr	nz,l2a2ch	;2aa9			; if(strcmp(*l4, word_a685) != 0) goto m2;

	or	a		;2aab			;
	sbc	hl,de		;2aac			;
	ld	de,2		;2aae			;
	call	adiv		;2ab1 			;
	add	hl,hl		;2ab4			;
	ld	de,array_5d0a	;2ab5			;
	add	hl,de		;2ab8			;
	ld	c,(hl)		;2ab9			;
	inc	hl		;2aba			;
	ld	b,(hl)		;2abb			;
	ld	(ix-5),c	;2abc			;
	ld	(ix-4),b ;l3	;2abf			; l3 = array_5d0a[l4-array_5cfa];
l2ac2h:							; m5:
	ld	a,(ix-1) ;l1	;2ac2 savc			;
	ld	hl,(word_9c9c)	;2ac5 word_9c9c			;
	ld	(hl),a		;2ac8			; *word_9c9c = l1;
	ld	(word_a685),hl	;2ac9
	ld	(word_a66b),hl	;2acc

	ld	l,(ix-5)	;2acf			;
	ld	h,(ix-4) ;l3	;2ad2			;
	jp	cret		;2ad5			; return l3;
l2ad8h:							; m6:
	ld	l,(ix-3)	;2ad8			;
	ld	h,(ix-2) ;l2	;2adb			;
	ld	a,(hl)		;2ade			;
	inc	hl		;2adf			;
	ld	(ix-3),l	;2ae0			;
	ld	(ix-2),h ;l2	;2ae3			; ++l2;

	ld	hl,(word_a685)	;2ae6			;
	cp	(hl)		;2ae9			;
	ld	l,(ix-3)	;2aea			;
	ld	h,(ix-2) ;l2	;2aed			;
	jp	nz,l2a42h	;2af0			; if(*word_a685 != 0) goto m3;

	dec	hl		;2af3			;
	ld	(ix-3),l	;2af4			;
	ld	(ix-2),h ;l2	;2af7			;
	ld	a,(hl)		;2afa			;
	ld	l,a		;2afb			;
	rla			;2afc			;
	sbc	a,a		;2afd			;
	ld	h,a		;2afe			;
	ld	(ix-5),l	;2aff			;
	ld	(ix-4),h ;l3	;2b02			; l3 = *(--l2);
	jr	l2ac2h		;2b05			; goto m5;
l2b07h:							; m7:
	ld	hl,00010h	;2b07			;
	push	hl		;2b0a			;
	ld	hl,(word_a685)	;2b0b			;
	inc	hl		;2b0e			;
	inc	hl		;2b0f			;
	push	hl		;2b10			;
	call	sub_2892h	;2b11			;
	pop	bc		;2b14			;
	pop	bc		;2b15			;
l2b16h:							; m8:
	ld	(word_a8ef),hl	;2b16			; word_a8ef = sub_2892h(++word_a685, 0x10);
	jr	l2b2bh		;2b19			; goto m10;
l2b1bh:							; m9:
	ld	hl,0000ah	;2b1b			;
	push	hl		;2b1e			;
	ld	hl,(word_a685)	;2b1f			;
	push	hl		;2b22			;
	call	sub_2892h	;2b23			;
	pop	bc		;2b26			;
	pop	bc		;2b27			;
	ld	(word_a8ef),hl	;2b28			; word_a8ef = sub_2892h(word_a685, 0xA);
l2b2bh:							; m10:
	ld	(ix-5),1	;2b2b
l2b2fh:							; m11:
	ld	(ix-4),1 ;l3	;2b2f			; l3 = 17;
	jr	l2ac2h		;2b33			; goto m5;
l2b35h:							; m12:
	ld	hl,(word_a685)	;2b35			;
	ld	a,(hl)		;2b38			;
l2b39h:							; m13:
	ld	e,a		;2b39			;
	rla			;2b3a			;
	sbc	a,a		;2b3b			;
	ld	d,a		;2b3c			;
	ld	hl,array_9d3e	;2b3d 			;
	add	hl,de		;2b40			;
	bit	0,(hl)		;2b41 			;
	jr	z,l2ba1h	;2b43			; if(bittst(array_9d3e[*word_a685],0) == 0) goto m17;
	
	ld	hl,l62f5h	;2b45			;
	push	hl		;2b48			;
	ld	hl,(word_a685)	;2b49			;
	push	hl		;2b4c			;
	call	strcmp		;2b4d			;
	pop	bc		;2b50			;
	pop	bc		;2b51			;
	ld	a,l		;2b52			;
	or	h		;2b53			;
	jr	nz,l2b69h	;2b54			; if(strcmp(word_a685, "defined") != 0) goto m14;

	ld	hl,1		;2b56			;
	ld	(word_5cf8),hl	;2b59			; word_5cf8 = 1;

	ld	hl,(word_9cae)	;2b5c			;
	inc	hl		;2b5f			;
	ld	(word_9cae),hl	;2b60			; ++word_9cae;

	ld	(ix-5),3 ;l3	;2b63			;  l3 = 17; /* ??? */
	jr	l2b2fh		;2b67			; goto m5; /* goto m11; */
l2b69h:							; m14:
	ld	hl,-1		;2b69			;
	push	hl		;2b6c			;
	ld	hl,(word_a685)	;2b6d			;
	push	hl		;2b70			;
	call	sub_1b97h	;2b71			;
	pop	bc		;2b74			;
	pop	bc		;2b75			;
	push	hl		;2b76			;
	pop	iy		;2b77			; st = sub_1b97h(word_a685, -1);
	ld	hl,(word_5cf8)	;2b79			;
	ld	a,l		;2b7c			;
	or	h		;2b7d			;
	jr	z,l2b8dh	;2b7e			; if(word_5cf8 == 0) goto m15;

	ld	hl,0		;2b80			;
	ld	(word_5cf8),hl	;2b83			; word_5cf8 = 0;
	ld	hl,(word_9cae)	;2b86			;
	dec	hl		;2b89			;
	ld	(word_9cae),hl	;2b8a			; word_9cae--;
l2b8dh:							; m15:
	ld	a,(iy+2)	;2b8d	ERROR		;
	or	(iy+3) ;l2	;2b90			;
	jr	z,l2b9bh	;2b93			; if(l2 == 0) goto m16;

	ld	hl,1		;2b95			; word_a8ef = 1;
	jp	l2b16h		;2b98			; goto m10; /* goto m8; */
l2b9bh:							; m16:
	ld	hl,0		;2b9b			; word_a8ef = 0;
	jp	l2b16h		;2b9e			; goto m10; /* goto m8; */
l2ba1h:							; m17:
	ld	hl,(word_a685)	;2ba1			;
	ld	a,(hl)		;2ba4			;
	cp	27h	; '\''	;2ba5			;
	jp	nz,l2c48h	;2ba7			; if(*word_a685 != '\'') goto m25;

	ld	(ix-5),1	;2baa			;
	ld	(ix-4),1 ;l3	;2bae			; l3 = 17;
	inc	hl		;2bb2			;
	ld	a,(hl)		;2bb3			;
	cp	05ch	; '\\'	;2bb4			;
	jp	nz,l2c42h	;2bb6			; if(*(word_a685+1) != '\\') goto m24;

	ld	hl,(word_9c9c)	;2bb9			;
	dec	hl		;2bbc			;
	ld	a,(hl)		;2bbd			;
	cp	27h	; '\''	;2bbe			;
	jr	nz,l2bc4h	;2bc0			; if(*(word_9c9c-1) != '\'') goto m18;

	ld	(hl),0		;2bc2			; *(word_9c9c-1) = 0;
l2bc4h:							; m18:
	ld	hl,(word_5d1a)	;2bc4			;
	ld	(ix-3),l	;2bc7			;
	ld	(ix-2),h ;l2	;2bca			; l2 = word_5d1a;
l2bcdh:							; m19:
	ld	l,(ix-3)	;2bcd			;
	ld	h,(ix-2) ;l2	;2bd0			;
	ld	a,(hl)		;2bd3			;
	or	a		;2bd4			;
	jr	nz,l2c15h	;2bd5			; if(*l2 != 0) goto m21;

	ld	hl,(word_a685)	;2bd7 inp			;
	inc	hl		;2bda			;
	inc	hl		;2bdb			;
	ld	a,(hl)		;2bdc			;
	ld	e,a		;2bdd			;
	rla			;2bde			;
	sbc	a,a		;2bdf			;
	ld	d,a		;2be0			;
	ld	hl,00039h	;2be1			;
	call	wrelop		;2be4			;
	jp	m,l2c3ah	;2be7			; if(0x39 < *word_a685) goto m22;

	ld	b,030h		;2bea			;
	ld	hl,(word_a685)	;2bec			;
	inc	hl		;2bef			;
	inc	hl		;2bf0			;
	ld	a,(hl)		;2bf1			;
	call	brelop		;2bf2			;
	jp	m,l2c3ah	;2bf5			; if(*(word_a685+2) < 0x30) goto m22;

	ld	hl,8		;2bf8			;
	push	hl		;2bfb			;
	ld	hl,(word_a685)	;2bfc			;
	inc	hl		;2bff			;
	inc	hl		;2c00			;
	push	hl		;2c01			;
	call	sub_2892h	;2c02			;
	pop	bc		;2c05			;
	pop	bc		;2c06			;
	ld	a,l		;2c07			;
	ld	(ix-8),a ;l5	;2c08			; l5 =  sub_2892h(word_a685+2, 8);
l2c0bh:							; m20:
	ld	l,a		;2c0b			;
	rla			;2c0c			;
	sbc	a,a		;2c0d			;
	ld	h,a		;2c0e			;
	ld	(word_a8ef),hl	;2c0f			; word_a8ef = l5;
	jp	l2ac2h		;2c12			; goto m5;
l2c15h:							; m21:
	ld	l,(ix-3)	;2c15			;
	ld	h,(ix-2) ;l2	;2c18			;
	ld	a,(hl)		;2c1b			;
	inc	hl		;2c1c			;
	ld	(ix-3),l	;2c1d			;
	ld	(ix-2),h ;l2	;2c20			;
	ld	hl,(word_a685)	;2c23			;
	inc	hl		;2c26			;
	inc	hl		;2c27 			;
	cp	(hl)		;2c28			;
	ld	l,(ix-3)	;2c29			;
	ld	h,(ix-2) ;l2	;2c2c			;
	jr	z,l2c3fh	;2c2f			; if(*(l2++) == *(word_a685+2)) goto m23;

	inc	hl		;2c31			;
	ld	(ix-3),l	;2c32			;
	ld	(ix-2),h ;l2	;2c35			; ++l2;
	jr	l2bcdh		;2c38			; goto m19;
l2c3ah:							; m22:
	ld	hl,(word_a685)	;2c3a			;
	inc	hl		;2c3d			;
	inc	hl		;2c3e			;
l2c3fh:							; m23:
	ld	a,(hl)		;2c3f			; word_a8ef = *(word_a685+2);
	jr	l2c0bh		;2c40			; goto m5; /* goto m20; */
l2c42h:							; m24:
	ld	hl,(word_a685)	;2c42
	inc	hl		;2c45			; word_a8ef = *(word_a685+1);
	jr	l2c3fh		;2c46			; goto m5; /* goto m23; */
l2c48h:							; m25:
	ld	hl,(word_a685)	;2c48			;
	push	hl		;2c4b			;
	ld	hl,l62fdh	;2c4c 			;
	push	hl		;2c4f			;
	call	strcmp		;2c50			;
	pop	bc		;2c53			;
	pop	bc		;2c54			;
	ld	a,l		;2c55			;
	or	h		;2c56			;
	ld	a,(ix-1) ;l1	;2c57			;
	ld	hl,(word_9c9c)	;2c5a			;
	ld	(hl),a		;2c5d			; *word_9c9c = l1;
	jp	z,l29fbh 	;2c5e			; if(strcmp("\\\n", word_a685) == 0) goto m0;

	ld	hl,(word_a685)	;2c61			;
	ld	a,(hl)		;2c64			;
	ld	l,a		;2c65			;
	rla			;2c66			;
	sbc	a,a		;2c67			;
	ld	h,a		;2c68			;
	push	hl		;2c69			;
	ld	hl,l6300h	;2c6a			;
	push	hl		;2c6d			;
	call	sub_1ad2h	;2c6e			; sub_1ad2h("Illegal character %c in preprocessor if", word_a685);
	pop	bc		;2c71			;
	pop	bc		;2c72			;
	jp	l29fbh		;2c73			; goto m0;

;	End sub_29f6h					; }

; =============== F U N C T I O N =======================================
;							; sub_2c76h() {
;		yyparse					; l1;
sub_2c76h:						; l2;
	call	ncsv		;2c76			; l3;
	defw	0fff4h	;-12	;2c79			; l4;
							; l5;
							; l6;
	ld	hl,0a7c1h	;2c7b			;
	ld	(word_a695),hl	;2c7e			; word_a695 = 0xA7C1;

	ld	hl,word_a695	;2c81			;
	ld	(word_a693),hl	;2c84			; word_a693 = word_a695;
	ld	hl,0		;2c87			;
	ld	(word_a8f1),hl	;2c8a			;
	ld	(word_a68f),hl	;2c8d			;
	ld	(word_a691),hl	;2c90			;
	ld	(word_a687),hl	;2c93			; word_a687 = word_a691 = word_a68f = word_a8f1 = 0;
	ld	hl,-1		;2c96			;
	ld	(word_a68d),hl	;2c99			; word_a68d = -1;
l2c9ch:						; m1:
	ld	hl,(word_a695)	;2c9c			;
	ld	(ix-2),l	;2c9f			;
	ld	(ix-1),h ;l1	;2ca2			; l1 = word_a695;
	ld	hl,(word_a693)	;2ca5			;
	ld	(ix-4),l	;2ca8			;
	ld	(ix-3),h ;l2	;2cab			; l2 = word_a693;
	ld	hl,(word_a8f1)	;2cae			;
	ld	(ix-6),l	;2cb1			;
	ld	(ix-5),h ;l3	;2cb4			; l3 = word_a8f1;
l2cb7h:						; m2:
	ld	de,0a7c3h	;2cb7			;
	ld	l,(ix-4)	;2cba			;
	ld	h,(ix-3) ;l2	;2cbd			;
	inc	hl		;2cc0			;
	inc	hl		;2cc1			;
	ld	(ix-4),l	;2cc2			;
	ld	(ix-3),h ;l2	;2cc5			;
	call	wrelop		;2cc8			;
	jr	c,l2cdbh	;2ccb			; if(++l2 < 0xA7C3) goto m4;

	ld	hl,l6328h	;2ccd			;
	push	hl		;2cd0			;
	call	sub_1b49h	;2cd1			; sub_1b49h("yacc stack overflow");
	pop	bc		;2cd4			;
l2cd5h:						; m3:
	ld	hl,1		;2cd5			;
	jp	cret		;2cd8			; return 1;

l2cdbh:						; m4:
	ld	e,(ix-6)	;2cdb			;
	ld	d,(ix-5) ;l3	;2cde			;
	ld	l,(ix-4)	;2ce1			;
	ld	h,(ix-3) ;l2	;2ce4			;
	ld	(hl),e		;2ce7			;
	inc	hl		;2ce8			;
	ld	(hl),d		;2ce9			; *l2 = l3;

	ld	de,(word_a68b)	;2cea			;
	ld	l,(ix-2)	;2cee			;
	ld	h,(ix-1) ;l1	;2cf1			;
	inc	hl		;2cf4			;
	inc	hl		;2cf5			;
	ld	(ix-2),l	;2cf6			;
	ld	(ix-1),h ;l1	;2cf9			;
	ld	(hl),e		;2cfc			;
	inc	hl		;2cfd			;
	ld	(hl),d		;2cfe			; *(++l1) = word_a68b;
l2cffh:						; m5:
	ld	de,array_607e	;2cff			;
	ld	l,(ix-6)	;2d02			;
	ld	h,(ix-5) ;l3	;2d05			;
	add	hl,hl		;2d08			;
	add	hl,de		;2d09			;
	ld	e,(hl)		;2d0a			;
	inc	hl		;2d0b			;
	ld	d,(hl)		;2d0c			;
	ld	(ix-8),e	;2d0d			;
	ld	(ix-7),d ;l4	;2d10			; l4 = array_607e[l3];
	ld	hl,0fc18h	;2d13			;
	call	wrelop		;2d16			;
	jp	p,l2da8h	;2d19			; if(0xFC18 >= l4) goto m7;

	ld	hl,(word_a68d)	;2d1c			;
	bit	7,h		;2d1f			;
	jr	z,l2d33h	;2d21			; if(((unsigned)word_a68d & 0x8000) == 0) goto m6;

	call	sub_29f6h	;2d23
	ld	(word_a68d),hl	;2d26
	bit	7,h		;2d29
	jr	z,l2d33h	;2d2b			; if(((unsigned)(word_a68d = sub_29f6h) & 0x8000) == 0) goto m6;

	ld	hl,0		;2d2d			;
	ld	(word_a68d),hl	;2d30			; word_a68d = 0;
l2d33h:						; m6:
	ld	de,(word_a68d)	;2d33			;
	ld	l,(ix-8)	;2d37			;
	ld	h,(ix-7) ;l4	;2d3a			;
	add	hl,de		;2d3d			;
	ld	(ix-8),l	;2d3e			;
	ld	(ix-7),h ;l4	;2d41			;
	bit	7,h		;2d44			;
	jp	nz,l2da8h	;2d46			; if(((unsigned)(l4 += word_a68d)& 0x8000) != 0) goto m7;

	ld	de,016bh	;2d49			;
	call	wrelop		;2d4c			;
	jp	p,l2da8h	;2d4f			; if(l4 >= 0x16B) goto m7;

	ld	de,array_5da8	;2d52			;
	ld	l,(ix-8)	;2d55			;
	ld	h,(ix-7) ;l4	;2d58			;
	add	hl,hl		;2d5b			;
	add	hl,de		;2d5c			;
	ld	a,(hl)		;2d5d			;
	inc	hl		;2d5e			;
	ld	h,(hl)		;2d5f			;
	ld	l,a		;2d60			;
	ld	(ix-8),l	;2d61			;
	ld	(ix-7),h ;l4	;2d64			; l4 = array_5da8[l4]
	add	hl,hl		;2d67			;
	ld	de,array_617a	;2d68			;
	add	hl,de		;2d6b			;
	ld	a,(hl)		;2d6c			;
	inc	hl		;2d6d			;
	ld	h,(hl)		;2d6e			;
	ld	l,a		;2d6f			;
	ld	de,(word_a68d)	;2d70			;
	or	a		;2d74			;
	sbc	hl,de		;2d75			;
	jr	nz,l2da8h	;2d77			; if(array_617a[l4] != word_a68d) goto m7;

	ld	hl,-1		;2d79			;
	ld	(word_a68d),hl	;2d7c			; word_a68d = -1;

	ld	hl,(word_a8ef)	;2d7f			;
	ld	(word_a68b),hl	;2d82			; word_a68b = word_a8ef;

	ld	l,(ix-8)	;2d85			;
	ld	h,(ix-7) ;l4	;2d88			;
	ld	(ix-6),l	;2d8b			;
	ld	(ix-5),h ;l3	;2d8e			; l3 = l4;

	ld	de,(word_a687)	;2d91			;
	ld	hl,0		;2d95			;
	call	wrelop		;2d98			;
	jp	p,l2cb7h	;2d9b			; if(0 >= word_a687) goto m2;

	ld	hl,(word_a687)	;2d9e			;
	dec	hl		;2da1			;
	ld	(word_a687),hl	;2da2			; --word_a687;
	jp	l2cb7h		;2da5			; goto m2;
l2da8h:						; m7:
	ld	de,array_61f6	;2da8			;
	ld	l,(ix-6)	;2dab			;
	ld	h,(ix-5) ;l3	;2dae			;
	add	hl,hl		;2db1			;
	add	hl,de		;2db2			;
	ld	a,(hl)		;2db3			;
	inc	hl		;2db4			;
	ld	h,(hl)		;2db5			;
	ld	l,a		;2db6			;
	ld	(ix-8),l	;2db7			;
	ld	(ix-7),h ;l4	;2dba			; l4 = array_61f6[l3];
	ld	de,0fffeh	;2dbd			;
	or	a		;2dc0			;
	sbc	hl,de		;2dc1			;
	jp	nz,l2e61h	;2dc3			; if(l4 != 0xFFFE) goto m13;
							; 
	ld	hl,(word_a68d)	;2dc6			;
	bit	7,h		;2dc9			;
	jr	z,l2dddh	;2dcb			; if(((unsigned)word_a68d & 0x8000) == 0) goto m8;

	call	sub_29f6h	;2dcd			; 
	ld	(word_a68d),hl	;2dd0			;
	bit	7,h		;2dd3			;
	jr	z,l2dddh	;2dd5			; if((((unsigned)(word_a68d = sub_29f6h()))& 0x8000) == 0) goto m8;

	ld	hl,0		;2dd7			;
	ld	(word_a68d),hl	;2dda			; word_a68d = 0;
l2dddh:						; m8:
	ld	hl,array_5d1c	;2ddd			;
	ld	(ix-10),l	;2de0			;
	ld	(ix-9),h ;l5	;2de3			; l5 = array_5d1c; 
	jr	l2df8h		;2de6			; goto m10;
l2de8h:						; m9:
	ld	l,(ix-10)	;2de8			;
	ld	h,(ix-9) ;l5	;2deb			;
	inc	hl		;2dee			;
	inc	hl		;2def			;
	inc	hl		;2df0			;
	inc	hl		;2df1			;
	ld	(ix-10),l	;2df2			;
	ld	(ix-9),h ;l5	;2df5			; l5 += 4;
l2df8h:						; m10:
	ld	de,-1		;2df8			;
	ld	l,(ix-10)	;2dfb			;
	ld	h,(ix-9) ;l5	;2dfe			;
	ld	a,(hl)		;2e01			;
	inc	hl		;2e02			;
	ld	h,(hl)		;2e03			;
	ld	l,a		;2e04			;
	or	a		;2e05			;
	sbc	hl,de		;2e06			;
	jr	nz,l2de8h	;2e08			; if(*l5 != -1) goto m9;

	ld	e,(ix-6)	;2e0a			;
	ld	d,(ix-5) ;l3	;2e0d			;
	ld	l,(ix-10)	;2e10			;
	ld	h,(ix-9) ;l5	;2e13			;
	inc	hl		;2e16			;
	inc	hl		;2e17			;
	ld	a,(hl)		;2e18			;
	inc	hl		;2e19			;
	ld	h,(hl)		;2e1a			;
	ld	l,a		;2e1b			;
	or	a		;2e1c			;
	sbc	hl,de		;2e1d			;
	jr	nz,l2de8h	;2e1f			; if(*(l5+2) != l3) goto m9;
l2e21h:						; m11:
	ld	l,(ix-10)	;2e21			;
	ld	h,(ix-9) ;l5	;2e24			;
	inc	hl		;2e27			;
	inc	hl		;2e28			;
	inc	hl		;2e29			;
	inc	hl		;2e2a			;
	ld	(ix-10),l	;2e2b			;
	ld	(ix-9),h ;l5	;2e2e			;
	ld	c,(hl)		;2e31			;
	inc	hl		;2e32			;
	ld	b,(hl)		;2e33			;
	bit	7,b		;2e34			;
	jr	nz,l2e46h	;2e36			; if((*(l5 +=4) & 0x8000) != 0) goto m12;

	ld	de,(word_a68d)	;2e38			;
	dec	hl		;2e3c			;
	ld	a,(hl)		;2e3d			;
	inc	hl		;2e3e			;
	ld	h,(hl)		;2e3f			;
	ld	l,a		;2e40			;
	or	a		;2e41			;
	sbc	hl,de		;2e42			;
	jr	nz,l2e21h	;2e44			; if(*(l5-1) != word_a68d) goto m11;
l2e46h:						; m12:
	ld	l,(ix-10)	;2e46			;
	ld	h,(ix-9) ;l5	;2e49			;
	inc	hl		;2e4c			;
	inc	hl		;2e4d			;
	ld	c,(hl)		;2e4e			;
	inc	hl		;2e4f			;
	ld	b,(hl)		;2e50			;
	ld	(ix-8),c	;2e51			;
	ld	(ix-7),b ;l4	;2e54			;
	bit	7,b		;2e57			;
	jr	z,l2e61h	;2e59			; if(((l4 = *(l5+2)) & 0x80) == 0) goto m13;

	ld	hl,0		;2e5b			;
	jp	cret		;2e5e			; return 0;
l2e61h:						; m13:
	ld	a,(ix-8)	;2e61			;
	or	(ix-7)   ;l4	;2e64			;
	jr	nz,l2e84h	;2e67			; if(l4 != 0) goto m14;

	ld	hl,(word_a687)	;2e69			;
	ld	a,h		;2e6c			;
	or	a		;2e6d			;
	jr	nz,l2e84h	;2e6e			; if(HI_CHAR(word_a687) != 0) goto m14;

	ld	a,l		;2e70			;
	or	a		;2e71			;
	jp	z,l2f77h	;2e72			; if(LO_CHAR(word_a687) == 0) goto m17;

	cp	1		;2e75			;
	jp	z,l2f7fh	;2e77			; if(LO_CHAR(word_a687) == 1) goto m18;

	cp	2		;2e7a			;
	jp	z,l2f7fh	;2e7c			; if(LO_CHAR(word_a687) == 2) goto m18;

	cp	3		;2e7f			;
	jp	z,l300dh	;2e81			; if(LO_CHAR(word_a687) == 3) goto m22;
l2e84h:						; m14:
	ld	l,(ix-8)	;2e84			;
	ld	h,(ix-7) ;l4	;2e87			;
	ld	(word_a68f),hl	;2e8a			; word_a68f = l4;

	ld	l,(ix-2)	;2e8d			;
	ld	h,(ix-1) ;l1	;2e90			;
	push	hl		;2e93			;
	pop	iy		;2e94			; st = l1;

	ld	de,array_613e	;2e96			;
	ld	l,(ix-8)	;2e99			;
	ld	h,(ix-7) ;l4	;2e9c			;
	add	hl,hl		;2e9f			;
	add	hl,de		;2ea0			;
	ld	c,(hl)		;2ea1			;
	inc	hl		;2ea2			;
	ld	b,(hl)		;2ea3			;
	ld	(ix-12),c	;2ea4			;
	ld	(ix-11),b ;l6	;2ea7			; l6 = array_613e[l4];
	
	bit	0,(ix-12) ; l6	;2eaa
	ld	b,1		;2eae
	push	ix		;2eb0
	pop	de		;2eb2
	ld	hl,0fff4h ;-12	;2eb3
	jp	nz,l301eh	;2eb6			; if(bittst(l6,0) != 0) goto m23;

	add	hl,de		;2eb9			;
	call	asar		;2eba hl=(uint)&l6>>1	;
	ld	l,(ix-12)	;2ebd			;
	ld	h,(ix-11) ;l6	;2ec0 			;
	add	hl,hl		;2ec3 hl=l6+(uint)&l6>>1;
	ex	de,hl		;2ec4 de=l6+(uint)&l6>>1;
	ld	l,(ix-2)	;2ec5			;
	ld	h,(ix-1) ;l1	;2ec8 hl = l1		;
	or	a		;2ecb			;
	sbc	hl,de		;2ecc l1-l6+(uint)&l6>>1;
	ld	(ix-2),l	;2ece			;
	ld	(ix-1),h ;l1	;2ed1			; l1 -= l6-(uint)&l6>>1;
	inc	hl		;2ed4			;
	inc	hl		;2ed5			;
	ld	c,(hl)		;2ed6			;
	inc	hl		;2ed7			;
	ld	b,(hl)		;2ed8			;
	ld	(word_a68b),bc	;2ed9			; word_a68b =  (l1+1)->p_1;

	ld	l,(ix-12)	;2edd			;
	ld	h,(ix-11) ;l6	;2ee0	hl=l6		;
	add	hl,hl		;2ee3			;
	ex	de,hl		;2ee4			;
	ld	h,(ix-3) ;l2	;2ee8			;
	or	a		;2eeb			;
	sbc	hl,de		;2eec			;
	ld	(ix-4),l	;2eee			;
	ld	(ix-3),h ;l2	;2ef1			; l2 = l2 - l6
	ld	c,(hl)		;2ef4			;
	inc	hl		;2ef5			;
	ld	b,(hl)		;2ef6 *l2		;

	ld	de,array_6102	;2ef7 de = array_6102	;
	ld	l,(ix-8)	;2efa			;
	ld	h,(ix-7) ;l4	;2efd			;
	add	hl,hl		;2f00			;
	add	hl,de		;2f01 hl=array_6102+l4	;
	ld	a,(hl)		;2f02			;
	inc	hl		;2f03			;
	ld	h,(hl)		;2f04			;
	ld	l,a		;2f05 			;
	ld	(ix-8),l	;2f06			;
	ld	(ix-7),h ;l4	;2f09			; l4 += array_6102;
	add	hl,hl		;2f0c			;
	ld	de,array_60fa	;2f0d			;
	add	hl,de		;2f10 			;
	ld	a,(hl)		;2f11			;
	inc	hl		;2f12			;
	ld	h,(hl)		;2f13			;
	ld	l,a		;2f14			;
	add	hl,bc		;2f15			;
	inc	hl		;2f16			;
	ld	(ix-6),l	;2f17			;
	ld	(ix-5),h ;l3	;2f1a			; l3 = array_60fa[l4] + *l2 + 1;
	ld	de,016bh	;2f1d
	call	wrelop		;2f20
	jp	p,l2f57h	;2f23			; if(l3 >= 0x16B) goto m15;

	ld	de,array_5da8	;2f26			;
	ld	l,(ix-6)	;2f29			;
	ld	h,(ix-5) ;l3	;2f2c			;
	add	hl,hl		;2f2f			;
	add	hl,de		;2f30			;
	ld	a,(hl)		;2f31			;
	inc	hl		;2f32			;
	ld	h,(hl)		;2f33			;
	ld	l,a		;2f34			;
	ld	(ix-6),l	;2f35			;
	ld	(ix-5),h ;l3	;2f38			; l3 = array_5da8[l3];
	add	hl,hl		;2f3b			;
	ld	de,array_617a	;2f3c			;
	add	hl,de		;2f3f			;
	ld	e,(hl)		;2f40			;
	inc	hl		;2f41			;
	ld	d,(hl)		;2f42 array_617a[l3]	;
	push	de		;2f43			;
	ld	e,(ix-8)	;2f44			;
	ld	d,(ix-7) ;l4	;2f47			;
	ld	hl,0		;2f4a			;
	or	a		;2f4d			;
	sbc	hl,de		;2f4e			;
	pop	de		;2f50			;
	or	a		;2f51			;
	sbc	hl,de		;2f52			;
	jp	z,l2cb7h	;2f54			; if(0 - l4 == array_617a[l3]) goto m2;
l2f57h:						; m15:
	ld	de,array_60fa	;2f57			;
	ld	l,(ix-8)	;2f5a			;
	ld	h,(ix-7) ;l4	;2f5d			;
	add	hl,hl		;2f60			;
	add	hl,de		;2f61			;
	ld	a,(hl)		;2f62			;
	inc	hl		;2f63			;
	ld	h,(hl)		;2f64			;
	ld	l,a		;2f65 array_60fa[l4]	;
	add	hl,hl		;2f66			;
	ld	de,array_5da8	;2f67			;
l2f6ah:						; m16:
	add	hl,de		;2f6a			;
	ld	c,(hl)		;2f6b			;
	inc	hl		;2f6c			;
	ld	b,(hl)		;2f6d			;
	ld	(ix-6),c	;2f6e			;
	ld	(ix-5),b ;l3	;2f71			; l3 = array_5da8[array_60fa[l4]];
	jp	l2cb7h		;2f74			; goto m2;
l2f77h:						; m17:
	ld	hl,l633ch	;2f77			;
	push	hl		;2f7a			;
	call	sub_1b49h	;2f7b			; sub_1b49h("syntax error");
	pop	bc		;2f7e
l2f7fh:						; m18:
	ld	hl,00003h	;2f7f			;
	ld	(word_a687),hl	;2f82			; word_a687 = 3;
	jp	l2ffbh		;2f85			; goto m21;
l2f88h:						; m19:
	ld	de,array_607e	;2f88			;
	ld	l,(ix-4)	;2f8b			;
	ld	h,(ix-3) ;l2	;2f8e			;
	ld	a,(hl)		;2f91			;
	inc	hl		;2f92			;
	ld	h,(hl)		;2f93			;
	ld	l,a		;2f94			;
	add	hl,hl		;2f95			;
	add	hl,de		;2f96			;
	ld	c,(hl)		;2f97			;
	inc	hl		;2f98			;
	ld	b,(hl)		;2f99 			;
	ld	hl,0100h  	;2f9a			;
	add	hl,bc		;2f9d			;
	ld	(ix-8),l	;2f9e			;
	ld	(ix-7),h ;l4	;2fa1			; l4 = array_607e[*l2] + 0x100;
	bit	7,(ix-7)	;2fa4			;
	jr	nz,l2fdfh	;2fa8			; if((l4 & 0x8000) != 0) goto m20;

	ld	de,016bh	;2faa			;
	call	wrelop		;2fad			;
	jp	p,l2fdfh	;2fb0			; if(l4 >= 0x16B) goto m20;
	
	ld	de,array_5da8	;2fb3			;
	ld	l,(ix-8)	;2fb6			;
	ld	h,(ix-7) ;l4	;2fb9			;
	add	hl,hl		;2fbc			;
	add	hl,de		;2fbd			;
	ld	a,(hl)		;2fbe			;
	inc	hl		;2fbf			;
	ld	h,(hl)		;2fc0			;
	ld	l,a		;2fc1 array_5da8[l4]	;
	add	hl,hl		;2fc2			;
	ld	de,array_617a	;2fc3			;
	add	hl,de		;2fc6			;
	ld	a,(hl)		;2fc7			;
	inc	hl		;2fc8			;
	ld	h,(hl)		;2fc9			;
	ld	l,a		;2fca 			;
	ld	de,0100h  	;2fcb			;
	or	a		;2fce			;
	sbc	hl,de		;2fcf			;
	jr	nz,l2fdfh	;2fd1			; if(array_617a[array_5da8[l4]] != 0x100) goto m20;

	ld	de,array_5da8	;2fd3			;
	ld	l,(ix-8)	;2fd6			;
	ld	h,(ix-7) ;l4	;2fd9			;
	add	hl,hl		;2fdc			; l3 = array_5da8[l4]
	jr	l2f6ah		;2fdd			; goto m2; /* goto m16; */
l2fdfh:						; m20:
	ld	l,(ix-4)	;2fdf			;
	ld	h,(ix-3) ;l2	;2fe2			;
	dec	hl		;2fe5			;
	dec	hl		;2fe6			;
	ld	(ix-4),l	;2fe7			;
	ld	(ix-3),h ;l2	;2fea			; -- l2;

	ld	l,(ix-2)	;2fed			;
	ld	h,(ix-1) ;l1	;2ff0			;
	dec	hl		;2ff3			;
	dec	hl		;2ff4			;
	ld	(ix-2),l	;2ff5			; --l1;
	ld	(ix-1),h ;l1	;2ff8
l2ffbh:						; m21:
	ld	de,0a697h	;2ffb ???		;
	ld	l,(ix-4)	;2ffe			;
	ld	h,(ix-3) ;l3	;3001			;
	call	wrelop		;3004			;
	jp	nc,l2f88h	;3007			; if(l3 >= 0xA697) goto m19;
	jp	l2cd5h		;300a			; goto m3;
l300dh:						; m22:
	ld	hl,(word_a68d)	;300d			;
	ld	a,l		;3010			;
	or	h		;3011			;
	jp	z,l2cd5h	;3012			; if(word_a68d == 0) goto m3;

	ld	hl,-1		;3015			;
	ld	(word_a68d),hl	;3018			; word_a68d = -1;
	jp	l2cffh		;301b			; goto m5;
l301eh:						; m23:
	add	hl,de		;301e l6		;
	call	asar		;301f			;
	ld	l,(ix-12)	;3022			;
	ld	h,(ix-11) ;l6	;3025			;
	add	hl,hl		;3028			;
	ex	de,hl		;3029			;
	ld	l,(ix-2)	;302a			;
	ld	h,(ix-1) ;l1	;302d			;
	or	a		;3030			;
	sbc	hl,de		;3031			;
	ld	(ix-2),l	;3033			;
	ld	(ix-1),h ;l1	;3036			; l1 = l1 -= l6 + l6>>1;
	inc	hl		;3039			;
	inc	hl		;303a			;
	ld	c,(hl)		;303b			;
	inc	hl		;303c			;
	ld	b,(hl)		;303d			;
	ld	(word_a68b),bc	;303e			; word_a68b =  *(++l1); 
	
	ld	l,(ix-12)	;3042			;
	ld	h,(ix-11) ;l6	;3045			;
	add	hl,hl		;3048			;
	ex	de,hl		;3049			;
	ld	l,(ix-4)	;304a			;
	ld	h,(ix-3) ;l2	;304d			;
	or	a		;3050			;
	sbc	hl,de		;3051			;
	ld	(ix-4),l	;3053			;
	ld	(ix-3),h ;l2	;3056			; l2 = l2 - l6
	ld	c,(hl)		;3059			;
	inc	hl		;305a			;
	ld	b,(hl)		;305b			;
	ld	de,array_6102	;305c			;
	ld	l,(ix-8)	;305f			;
	ld	h,(ix-7) ;l4	;3062			;
	add	hl,hl		;3065			;
	add	hl,de		;3066			;
	ld	a,(hl)		;3067			;
	inc	hl		;3068			;
	ld	h,(hl)		;3069			;
	ld	l,a		;306a			;
	ld	(ix-8),l	;306b			;
	ld	(ix-7),h ;l4	;306e			; l4 = array_6102[l4];
	add	hl,hl		;3071			;
	ld	de,array_60fa	;3072			;
	add	hl,de		;3075 			;
	ld	a,(hl)		;3076			;
	inc	hl		;3077			;
	ld	h,(hl)		;3078			;
	ld	l,a		;3079			;
	add	hl,bc		;307a			;
	inc	hl		;307b			;
	ld	(ix-6),l	;307c			;
	ld	(ix-5),h ;l3	;307f			; l3 = array_60fa[l4] + *l2 + 1;
	ld	de,0x16B	;3082 ???		;
	call	wrelop		;3085			;
	jp	p,l30bbh	;3088			; if(l3 >= 0x16B) goto m24;

	ld	de,array_5da8	;308b			;
	ld	l,(ix-6)	;308e			;
	ld	h,(ix-5) ;l3	;3091			;
	add	hl,hl		;3094			;
	add	hl,de		;3095			;
	ld	a,(hl)		;3096			;
	inc	hl		;3097			;
	ld	h,(hl)		;3098			;
	ld	l,a		;3099			;
	ld	(ix-6),l	;309a			;
	ld	(ix-5),h ;l3	;309d			; l3 = array_5da8[l3];
	add	hl,hl		;30a0			;
	ld	de,array_617a	;30a1			;
	add	hl,de		;30a4			;
	ld	e,(hl)		;30a5			;
	inc	hl		;30a6			;
	ld	d,(hl)		;30a7			;
	push	de		;30a8\			;
	ld	e,(ix-8)	;30a9			;
	ld	d,(ix-7) ;l4	;30ac			;
	ld	hl,0		;30af			;
	or	a		;30b2			;
	sbc	hl,de		;30b3			;
	pop	de		;30b5/			;
	or	a		;30b6			;
	sbc	hl,de		;30b7			;
	jr	z,l30d8h	;30b9			; if(0 - l4 == array_617a[l3]) goto m25;
l30bbh:						; m24:
	ld	de,array_60fa	;30bb			;
	ld	l,(ix-8)	;30be			;
	ld	h,(ix-7) ;l4	;30c1			;
	add	hl,hl		;30c4			;
	add	hl,de		;30c5			;
	ld	a,(hl)		;30c6			;
	inc	hl		;30c7			;
	ld	h,(hl)		;30c8			;
	ld	l,a		;30c9			;
	add	hl,hl		;30ca			;
	ld	de,array_5da8	;30cb			;
	add	hl,de		;30ce			;
	ld	c,(hl)		;30cf			;
	inc	hl		;30d0			;
	ld	b,(hl)		;30d1			;
	ld	(ix-6),c	;30d2			;
	ld	(ix-5),b ;l3	;30d5			; l3 = array_5da8[array_60fa[l4]];
l30d8h:						; m25:
	ld	l,(ix-6)	;30d8			;
	ld	h,(ix-5) ;l3	;30db			;
	ld	(word_a8f1),hl	;30de			; word_a8f1 = l3;
	ld	l,(ix-4)	;30e1			;
	ld	h,(ix-3) ;l2	;30e4			;
	ld	(word_a693),hl	;30e7			; word_a693 = l2;
	ld	l,(ix-2)	;30ea			;
	ld	h,(ix-1) ;l1	;30ed			;
	ld	(word_a695),hl	;30f0			; word_a695 = l1;
							;
	ld	hl,(word_a68f)	;30f3			; switch ((uchar)*word_a68f) {
	dec	hl		;30f6			;   case  0:    goto m27;
	xor	a		;30f7			;   case  1:    goto m28;
	cp	h		;30f8			;   case  2:    goto m30;
	jp	c,l2c9ch	;30f9 ; if( < ) goto m1;;   case  3:    goto m31;
	jr	nz,l3104h	;30fc ; if(!=) goto m26;;   case  4:    goto m32;
	ld	a,01ch		;30fe			;   case  5:    goto m33;
	cp	l		;3100			;   case  6:    goto m35;
	jp	c,l2c9ch	;3101 ; if( < ) goto m1;;   case  7:    goto m36;
l3104h:						; m26:  ;   case  8:    goto m37;
	add	hl,hl		;3104			;   case  9:    goto m39;
	ld	de,l6272h	;3105 branch table	;   case 10:    goto m41;
	add	hl,de		;3108			;   case 11:    goto m43;
	ld	a,(hl)		;3109			;   case 12:    goto m44;
	inc	hl		;310a			;   case 13:    goto m46;
	ld	h,(hl)		;310b			;   case 14:    goto m47;
	ld	l,a		;310c			;   case 15:    goto m49;
	jp	(hl)		;310d			;   case 16:    goto m50;
				;			;   case 17:    goto m51;
				;			;   case 18:    goto m54;
				;			;   case 20:    goto m55;
				;			;   case 21:    goto k57;
				;			;   case 22:    goto m62;
				;			;   case 23:    goto m58;
				;			;   case 24:    goto m59;
				;			;   case 25:    goto m60;
				;			;   case 26:    goto m61;
				;			;   case 27:    goto m61;
				;			;   case 28:    goto m62;
				;			;   case 29:    goto m62;
				;			; }
l310eh:							; m27:
	ld	l,(iy-2)	;310e case 0;		;
	ld	h,(iy-1) ;l1	;3111;			;
	jp	cret		;3114;			; return l1;
    
l3117h:							; m28:
	ld	e,(iy+0)	;3117 case 1		;
	ld	d,(iy+1)	;311a			;
	ld	l,(iy-4)	;311d			;
	ld	h,(iy-3) ;l2	;3120			; hl = l2*st->p_1;
	call	lmul		;3123
l3126h:							; m29:
	ld	(word_a68b),hl	;3126 yyval		; word_a68b = hl
	jp	l2c9ch		;3129			; goto m1;

l312ch:							; m30:
	ld	e,(iy+0)	;312c case 2		;
	ld	d,(iy+1)	;312f			;
	ld	l,(iy-4)	;3132			;
	ld	h,(iy-3) ;l2	;3135			;
	call	adiv		;3138			; hl = l2 / st->p_1;
	jr	l3126h		;313b			; goto m29;

l313dh:							; m31:
	ld	e,(iy+0)	;313d case 3		;
	ld	d,(iy+1)	;3140			;
	ld	l,(iy-4)	;3143			;
	ld	h,(iy-3) ;l2	;3146			;
	call	amod		;3149			; hl = l2 % st->p_1;
	jr	l3126h		;314c			; goto m29;

l314eh:							; m32:
	ld	e,(iy+0)	;314e case 4		;
	ld	d,(iy+1)	;3151			;
	ld	l,(iy-4)	;3154			;
	ld	h,(iy-3) ;l2	;3157			;
	add	hl,de		;315a			; hl = l2 + st->p_1;
	jr	l3126h		;315b			; goto m29;

l315dh:							; m33:
	ld	e,(iy+0)	;315d case 5		;
	ld	d,(iy+1)	;3160			; de = t->p_1
	ld	l,(iy-4)	;3163			;
	ld	h,(iy-3) ;l2	;3166			; hl = l2;
l3169h:							; m34:
	or	a		;3169
	sbc	hl,de		;316a			; hl = hl - de;
	jr	l3126h		;316c			; goto m29;

l316eh:							; m35:
	ld	b,(iy+0)	;316e case 6		;
	ld	l,(iy-4)	;3171			;
	ld	h,(iy-3) ;l2	;3174			;
	call	shll		;3177			; hl = l2<<st->p_1; /* hichar */
	jr	l3126h		;317a			; goto m29;

l317ch:							; m36:
	ld	b,(iy+0)	;317c case 7		;
	ld	l,(iy-4)	;317f			;
	ld	h,(iy-3) ;l2	;3182			;
	call	shar		;3185			; hl = l2>>st->p_1; /* hichar */
	jr	l3126h		;3188			; goto m29;

l318ah:							; m37:
	ld	e,(iy+0)	;318a case 8		;
	ld	d,(iy+1)	;318d			;
	ld	l,(iy-4)	;3190			;
	ld	h,(iy-3) ;l2	;3193			;
	call	wrelop		;3196			;
	ld	de,1		;3199			; de = 1;
	jp	m,l31a0h	;319c			; if(l2 < st->p_1) goto m38;
	dec	de		;319f			; de--;
l31a0h:							; m38:
	ld	(word_a68b),de	;31a0			; word_a68b = de;
	jp	l2c9ch		;31a4			; goto m1;

l31a7h:							; m39:
	ld	e,(iy-4)	;31a7 case 9		;
	ld	d,(iy-3) ;l2	;31aa			;
	ld	l,(iy+0)	;31ad			;
	ld	h,(iy+1)	;31b0			;
	call	wrelop		;31b3			;
	ld	de,1		;31b6			; de = 1;
	jp	m,l31a0h	;31b9			; if(l2 < st->p_1) goto m38;
l31bch:							; m40:
	dec	de		;31bc			; de--;
	jr	l31a0h		;31bd			; goto m38;

l31bfh:							; m41:
	ld	e,(iy-4)	;31bf case 10		;
	ld	d,(iy-3) ;l2	;31c2			; de = l2;
	ld	l,(iy+0)	;31c5			;
	ld	h,(iy+1)	;31c8			; hl = st->p_1;
l31cbh:							; m42:
	call	wrelop		;31cb
	ld	de,1		;31ce			; de = 1;
	jp	p,l31a0h	;31d1			; if(hl >= de) goto m38;
	jr	l31bch		;31d4			; goto m40;
							;

l31d6h:							; m43:
	ld	e,(iy+0)	;31d6 case 11		;
	ld	d,(iy+1)	;31d9			; de = st->p_1;
	ld	l,(iy-4)	;31dc			;
	ld	h,(iy-3) ;l2	;31df			; hl = l2;
	jr	l31cbh		;31e2			; goto m42;

l31e4h:						; m44:
	ld	e,(iy+0)	;31e4 case 12		;
	ld	d,(iy+1)	;31e7			;
	ld	l,(iy-4)	;31ea			;
	ld	h,(iy-3) ;l2	;31ed			;
	or	a		;31f0			;
	sbc	hl,de		;31f1			;
	ld	hl,1		;31f3			; hl = 1;
	jp	z,l3126h	;31f6			; if(l2 == st->p_1) goto m29;
l31f9h:						; m45:
	dec	hl		;31f9			; hl--;
	jp	l3126h		;31fa			; goto m29;

l31fdh:							; m46:
	ld	e,(iy+0)	;31fd case 13		;
	ld	d,(iy+1)	;3200			;
	ld	l,(iy-4)	;3203			;
	ld	h,(iy-3) ;l2	;3206			;
	or	a		;3209			;
	sbc	hl,de		;320a			;
	ld	hl,1		;320c			; hl = 1;
	jp	nz,l3126h	;320f			; if(l2 != st->p_1) goto m29;
	jr	l31f9h		;3212			; goto m45;

l3214h:							; m47:
	ld	a,(iy-4)	;3214 case 14		;
	and	(iy+0)		;3217			;
	ld	l,a		;321a			;
	ld	a,(iy-3) ;l2	;321b			;
	and	(iy+1)		;321e			; a = l4 & st->p_1;
l3221h:							; m48:
	ld	h,a		;3221			; h = a;
	jp	l3126h		;3222			; goto m29;

l3225h:							; m49:
	ld	a,(iy-4)	;3225 case 15		;
	xor	(iy+0)		;3228			;
	ld	l,a		;322b			;
	ld	a,(iy-3) ;l2	;322c			;
	xor	(iy+1)		;322f			; a = l4 ^ st->p_1;
	jr	l3221h		;3232			; goto m48;

l3234h:							; m50:
	ld	a,(iy-4)	;3234 case 16		;
	or	(iy+0)		;3237			;
	ld	l,a		;323a			;
	ld	a,(iy-3) ;l2	;323b			;
	or	(iy+1)		;323e			; a = l4 | st->p_1;
	jr	l3221h		;3241			; goto m48;

l3243h:							; m51:
	ld	a,(iy-4)	;3243 case 17		;
	or	(iy-3)   ;l2	;3246			;
	jr	z,l3259h	;3249			; if(l2 == 0) goto m53;

	ld	a,(iy+0)	;324b			;
	or	(iy+1)		;324e			;
	jr	z,l3259h	;3251			; if(st->p_1 == 0) goto m53;
l3253h:							; m52:
	ld	hl,1		;3253			; hl = 1;
	jp	l3126h		;3256			; goto m29;
l3259h:							; m53:
	ld	hl,0		;3259			; hl = 0
	jp	l3126h		;325c			; goto m29;

l325fh:							; m54:
	ld	a,(iy-4)	;325f case 18		;
	or	(iy-3)    ;l2	;3262			;
	jr	nz,l3253h	;3265			; if(l2 != 0) goto m52;
	ld	a,(iy+0)	;3267			;
	or	(iy+1)		;326a			;
	jr	z,l3259h	;326d			; if(st->p_1 == 0) goto m53;
	jr	l3253h		;326f			; goto m52;

l3271h:							; m55:
	ld	a,(iy-8)	;3271 case 19		;
	or	(iy-7)    ;l4	;3274			;
	jr	nz,l3282h	;3277			; if(l4 != -) goto m57;
l3279h:							; m56:
	ld	l,(iy+0)	;3279			;
	ld	h,(iy+1) 	;327c			; hl = st->p_1;
	jp	l3126h		;327f			; goto m29;
l3282h:							; m57:
	ld	l,(iy-4)	;3282
	ld	h,(iy-3) ;l2	;3285			; hl = l2;
	jp	l3126h		;3288			; goto m29;
l328bh:							; k57:
	jr	l3279h		;328b case 21		; goto m56;

l328dh:							; m58:
	ld	e,(iy+0)	;328d case 20		;
	ld	d,(iy+1)	;3290			; de = st->p_1;
	ld	hl,0		;3293			; hl = 0;
	jp	l3169h		;3296			; goto m34;

l3299h:							; m59:
	ld	a,(iy+0)	;3299 case 24
	or	(iy+1)		;329c
	ld	hl,1		;329f			; hl = 1;
	jp	z,l3126h	;32a2			; if(st->p_1 == =) goto m29;
	jp	l31f9h		;32a5			; goto m45;

l32a8h:							; m60:
	ld	e,(iy+0)	;32a8 case 25		;
	ld	d,(iy+1)	;32ab			; de = st->p_1;
	ld	hl,-1		;32ae			; hl = -1
	jp	l3169h		;32b1			; goto m34;

l32b4h:							; m61:
	ld	l,(iy-2)	;32b4 case 26		;
	ld	h,(iy-1) ;l1	;32b7 case 27		; hl = l1;
	jp	l3126h		;32ba			; goto m29;
l32bdh:				;			; m62:
				;     case 22		;
				;     case 28		;
	jr	l3279h		;32bd case 29		; goto m56;

;	End sub_2c76h


;========================================================================
; =============== F U N C T I O N =======================================
;	_getargs	From libary
;
__getargs:
	call	ncsv		;32bf
	defw	0fd54h	; ???	;32c2
	ld	hl,0		;32c4
	ld	(0a8fbh),hl	;32c7 _bp
	ld	a,l		;32ca
	ld	hl,0a8fah	;32cb _redone+2
	ld	(hl),a		;32ce
	ld	hl,0a8f9h	;32cf _redone+1
	ld	(hl),a		;32d2
	ld	(0a8f8h),a	;32d3 _redone
	ld	(ix-034h),a	;32d6
	ld	l,(ix+8)	;32d9
	ld	h,(ix+9)	;32dc
	ld	(0a8f6h),hl	;32df _name
	ld	l,(ix+6)	;32e2
	ld	h,(ix+7)	;32e5
	ld	(0a8f3h),hl	;32e8 _str
	ld	a,l		;32eb
	or	h		;32ec
	ld	hl,1		;32ed
	jr	z,l32f3h	;32f0
	dec	hl		;32f2
l32f3h:						; m1:
	ld	a,l		;32f3
	ld	(0a8f5h),a	;32f4 _interactive
	or	a		;32f7
	jr	z,l3300h	;32f8

	ld	hl,l6349h	;32fa 19f
	ld	(0a8f3h),hl	;32fd _str
l3300h:						; m2:
	push	ix		;3300
	pop	de		;3302
	ld	hl,0fe38h	;3303 -456
	add	hl,de		;3306
	ld	de,(0a8f6h)	;3307 _name
	ld	(hl),e		;330b
	inc	hl		;330c
	ld	(hl),d		;330d
	ld	(ix-032h),1	;330e
	ld	(ix-031h),0	;3312
	jp	l3695h		;3316
l3319h:						; m3:
	ld	de,000c8h	;3319 200
	ld	l,(ix-032h)	;331c
	ld	h,(ix-031h)	;331f
	or	a		;3322
	sbc	hl,de		;3323
	jr	nz,l3334h	;3325

	ld	hl,0		;3327
	push	hl		;332a
	ld	hl,l634bh	;332b	"too many arguments"
	push	hl		;332e
	call	_error	;332f error()
	pop	bc		;3332
	pop	bc		;3333
l3334h:						; m4:
	call	sub_3837h	;3334 _nxtch
	ld	a,l		;3337
	ld	(ix-033h),a	;3338
	ld	l,a		;333b
	rla			;333c
	sbc	a,a		;333d
	ld	h,a		;333e
	push	hl		;333f
	call	_isseparator	;3340 Test delimiter (' ', '\t' or '\n')
	pop	bc		;3343
	ld	a,l		;3344
	or	a		;3345
	jr	nz,l3334h	;3346

	ld	a,(ix-033h)	;3348
	or	a		;334b
	jp	z,l369dh	;334c

	push	ix		;334f
	pop	de		;3351
	ld	hl,0fd54h	;3352 -839
	add	hl,de		;3355
	push	hl		;3356
	pop	iy		;3357
	ld	l,a		;3359
	rla			;335a
	sbc	a,a		;335b
	ld	h,a		;335c
	push	hl		;335d
	call	_isspecial	;335e _isspecial   Test ('<' '>')
	pop	bc		;3361
	ld	a,l		;3362
	or	a		;3363
	ld	a,(ix-033h)	;3364
	jp	z,l33fbh	;3367

	ld	(iy+0),a	;336a
	inc	iy		;336d
	cp	03eh		;336f
	jp	nz,l3425h	;3371

	ld	hl,(0a8f3h)	;3374 _str
	ld	a,(hl)		;3377
	cp	03eh		;3378
	jp	nz,l3425h	;337a

	call	sub_3837h	;337d
	ld	e,l		;3380
	ld	(iy+0),e	;3381
	inc	iy		;3384
	jp	l3425h		;3386
l3389h:						; m5:
	push	ix		;3389
	pop	de		;338b
	ld	hl,0fdb8h	;338c -584
	add	hl,de		;338f
	push	iy		;3390
	pop	de		;3392
	or	a		;3393
	sbc	hl,de		;3394
	jr	nz,l33a5h	;3396

	ld	hl,0		;3398
	push	hl		;339b
	ld	hl,l635eh	;339c	    "argument too long"
	push	hl		;339f
	call	_error		;33a0 error()
	pop	bc		;33a3
	pop	bc		;33a4
l33a5h:						; m6:
	ld	a,(ix-033h)	;33a5
	cp	(ix-034h)	;33a8
	jr	nz,l33b3h	;33ab

	ld	(ix-034h),0	;33ad
	jr	l33dch		;33b1
l33b3h:						; m7:
	ld	a,(ix-034h)	;33b3
	or	a		;33b6
	jr	nz,l33c9h	;33b7

	ld	a,(ix-033h)	;33b9
	cp	027h		;33bc
	jr	z,l33c4h	;33be

	cp	022h		;33c0
	jr	nz,l33c9h	;33c2
l33c4h:						; m8:
	ld	(ix-034h),a	;33c4
	jr	l33dch		;33c7
l33c9h:						; m9:
	ld	a,(ix-034h)	;33c9
	or	a		;33cc
	ld	a,(ix-033h)	;33cd
	jr	z,l33d7h	;33d0

	or	080h		;33d2
	ld	(ix-033h),a	;33d4
l33d7h:						; m10:
	ld	(iy+0),a	;33d7
	inc	iy		;33da
l33dch:						; m11:
	ld	a,(ix-034h)	;33dc
	or	a		;33df
	jr	nz,l33f3h	;33e0

	ld	hl,(0a8f3h)	;33e2 _str
	ld	a,(hl)		;33e5
	ld	l,a		;33e6
	rla			;33e7
	sbc	a,a		;33e8
	ld	h,a		;33e9
	push	hl		;33ea
	call	_isspecial	;33eb _isspecial Test ('<' '>')
	pop	bc		;33ee
	ld	a,l		;33ef
	or	a		;33f0
	jr	nz,l3425h	;33f1
l33f3h:						; m12:
	call	sub_3837h	;33f3 _nxtch
	ld	e,l		;33f6
	ld	(ix-033h),e	;33f7
	ld	a,e		;33fa
l33fbh:						; m13:
	or	a		;33fb
	jr	z,l3425h	;33fc

	ld	a,(ix-034h)	;33fe
	or	a		;3401
	jr	nz,l3389h	;3402

	ld	a,(ix-033h)	;3404
	ld	l,a		;3407
	rla			;3408
	sbc	a,a		;3409
	ld	h,a		;340a
	push	hl		;340b
	call	_isspecial	;340c _isspecial Test ('<' '>')
	pop	bc		;340f
	ld	a,l		;3410
	or	a		;3411
	jr	nz,l3425h	;3412

	ld	a,(ix-033h)	;3414
	ld	l,a		;3417
	rla			;3418
	sbc	a,a		;3419
	ld	h,a		;341a
	push	hl		;341b
	call	_isseparator	;341c _isseparator Test delimiter (' ', '\t' or '\n')
	pop	bc		;341f
	ld	a,l		;3420
	or	a		;3421
	jp	z,l3389h	;3422
l3425h:						; m14:
	ld	(iy+0),0	;3425
	push	ix		;3429
	pop	de		;342b
	ld	hl,0fd54h	;342c -839
	add	hl,de		;342f
	push	hl		;3430
	call	_iswild		;3431 _iswild	; Test wildcard characters (* ?)
	pop	bc		;3434
	ld	a,l		;3435
	or	a		;3436
	push	ix		;3437
	pop	de		;3439
	ld	hl,0fd54h	;343a  -839
	jp	z,l3641h	;343d

	add	hl,de		;3440
	push	hl		;3441
	pop	iy		;3442
	jr	l3448h		;3444
l3446h:						; m15:
	inc	iy		;3446
l3448h:						; m16:
	ld	a,(iy+0)	;3448
	ld	e,a		;344b
	rla			;344c
	sbc	a,a		;344d
	ld	d,a		;344e
	ld	hl,__ctype_+1	;344f
	add	hl,de		;3452
	bit	2,(hl)		;3453
	jr	nz,l3446h	;3455

	ld	a,e		;3457
	cp	03ah		;3458
	jr	nz,l3470h	;345a

	push	ix		;345c
	pop	de		;345e
	ld	hl,0fd54h	;345f  -839
	add	hl,de		;3462
	push	iy		;3463
	pop	de		;3465
	or	a		;3466
	sbc	hl,de		;3467
	jr	z,l3470h	;3469

	ld	hl,1		;346b
	jr	l3473h		;346e
l3470h:						; m17:
	ld	hl,0		;3470
l3473h:						; m18:
	ld	(ix-034h),l	;3473
	push	ix		;3476
	pop	de		;3478
	ld	hl,0fd54h	;3479  -839
	add	hl,de		;347c
	push	hl		;347d
	push	ix		;347e
	pop	de		;3480
	ld	hl,0ffd4h	;3481 -44
	add	hl,de		;3484
	push	hl		;3485
	call	_setfcb		;3486
	pop	bc		;3489
	push	ix		;348a
	pop	de		;348c
	ld	hl,0fdb8h	;348d -584
	add	hl,de		;3490
	ex	(sp),hl		;3491
	ld	hl,1ah	;26	;3492
	push	hl		;3495
	call	bdos		;3496
	pop	bc		;3499
	pop	bc		;349a
	call	_getuid		;349b
	ld	(ix-033h),l	;349e
	ld	l,(ix-3)	;34a1
	ld	h,0		;34a4
	push	hl		;34a6
	call	_setuid		;34a7
	push	ix		;34aa
	pop	de		;34ac
	ld	hl,0ffd4h	;34ad
	add	hl,de		;34b0
	ex	(sp),hl		;34b1
	ld	hl,00011h ;17	;34b2
	push	hl		;34b5
	call	bdos		;34b6
	pop	bc		;34b9
	pop	bc		;34ba
	ld	h,0		;34bb
	ld	(ix-038h),l	;34bd
	ld	(ix-037h),h	;34c0
	ld	de,000ffh	;34c3
	or	a		;34c6
	sbc	hl,de		;34c7
	jp	z,l3612h	;34c9
l34cch:						; m19:
	push	ix		;34cc
	pop	de		;34ce
	ld	hl,0fd54h	;34cf -839
	add	hl,de		;34d2
	push	hl		;34d3
	pop	iy		;34d4
	ld	a,(ix-034h)	;34d6
	or	a		;34d9
	jr	z,l34f8h	;34da
	ld	l,(ix-3)	;34dc
	ld	h,0		;34df
	push	hl		;34e1
	ld	hl,l6370h	;34e2	"%u:"
	push	hl		;34e5
	push	iy		;34e6
	call	_sprintf	;34e8
	pop	bc		;34eb
	pop	bc		;34ec
	pop	bc		;34ed
	push	iy		;34ee
	call	strlen		;34f0
	pop	bc		;34f3
	ld	e,l		;34f4
	ld	d,h		;34f5
	add	iy,de		;34f6
l34f8h:						; m20:
	ld	a,(ix-02ch)	;34f8
	or	a		;34fb
	jr	z,l350eh	;34fc

	ld	l,a		;34fe
	ld	h,0		;34ff
	add	a,040h		;3501
	ld	(iy+0),a	;3503
	inc	iy		;3506
	ld	(iy+0),03ah ;58	;3508
	inc	iy		;350c
l350eh:						; m21:
	push	ix		;350e
	pop	de		;3510
	ld	b,5		;3511
	ld	l,(ix-038h)	;3513
	ld	h,(ix-037h)	;3516
	call	shal		;3519
	add	hl,de		;351c
	ld	de,0fdb8h	;351d -584
	add	hl,de		;3520
	ld	(ix-02eh),l	;3521
	ld	(ix-02dh),h	;3524
	inc	hl		;3527
	ld	(ix-030h),l	;3528
	ld	(ix-02fh),h	;352b
	jr	l3545h		;352e
l3530h:						; m22:
	ld	l,(ix-030h)	;3530
	ld	h,(ix-02fh)	;3533
	ld	a,(hl)		;3536
	inc	hl		;3537
	ld	(ix-030h),l	;3538
	ld	(ix-02fh),h	;353b
	and	07fh ;127	;353e
	ld	(iy+0),a	;3540
	inc	iy		;3543
l3545h:						; m23:
	ld	l,(ix-030h)	;3545
	ld	h,(ix-02fh)	;3548
	ld	a,(hl)		;354b
	cp	020h		;354c
	jr	z,l3566h	;354e
	ld	e,(ix-02eh)	;3550
	ld	d,(ix-02dh)	;3553
	ld	hl,00009h	;3556
	add	hl,de		;3559
	ex	de,hl		;355a
	ld	l,(ix-030h)	;355b
	ld	h,(ix-02fh)	;355e
	call	wrelop		;3561
	jr	c,l3530h	;3564
l3566h:						; m24:
	ld	(iy+0),02eh	;3566
	inc	iy		;356a
	ld	e,(ix-02eh)	;356c
	ld	d,(ix-02dh)	;356f
	ld	hl,9		;3572
	add	hl,de		;3575
	ld	(ix-030h),l	;3576
	ld	(ix-02fh),h	;3579
	jr	l3593h		;357c
l357eh:						; m25:
	ld	l,(ix-030h)	;357e
	ld	h,(ix-02fh)	;3581
	ld	a,(hl)		;3584
	inc	hl		;3585
	ld	(ix-030h),l	;3586
	ld	(ix-02fh),h	;3589
	and	07fh		;358c
	ld	(iy+0),a	;358e
	inc	iy		;3591
l3593h:						; m26:
	ld	l,(ix-030h)	;3593
	ld	h,(ix-02fh)	;3596
	ld	a,(hl)		;3599
	cp	020h		;359a
	jr	z,l35b4h	;359c
	ld	e,(ix-02eh)	;359e
	ld	d,(ix-02dh)	;35a1
	ld	hl,0000ch	;35a4
	add	hl,de		;35a7
	ex	de,hl		;35a8
	ld	l,(ix-030h)	;35a9
	ld	h,(ix-02fh)	;35ac
	call	wrelop		;35af
	jr	c,l357eh	;35b2
l35b4h:						; m27:
	ld	(iy+0),0	;35b4
	inc	iy		;35b8
	push	ix		;35ba
	pop	de		;35bc
	ld	hl,0fd54h	;35bd -839
	add	hl,de		;35c0
	push	hl		;35c1
	push	ix		;35c2
	pop	de		;35c4
	ld	hl,0fd54h	;35c5 -839
	add	hl,de		;35c8
	ex	de,hl		;35c9
	push	iy		;35ca
	pop	hl		;35cc
	or	a		;35cd
	sbc	hl,de		;35ce
	inc	hl		;35d0
	push	hl		;35d1
	call	_alloc	;35d2 _alloc
	pop	bc		;35d5
	push	hl		;35d6
	push	ix		;35d7
	pop	de		;35d9
	ld	l,(ix-032h)	;35da
	ld	h,(ix-031h)	;35dd
	inc	hl		;35e0
	ld	(ix-032h),l	;35e1
	ld	(ix-031h),h	;35e4
	dec	hl		;35e7
	add	hl,hl		;35e8
	add	hl,de		;35e9
	ld	de,0fe38h	;35ea -456
	add	hl,de		;35ed
	pop	de		;35ee
	ld	(hl),e		;35ef
	inc	hl		;35f0
	ld	(hl),d		;35f1
	push	de		;35f2
	call	strcpy		;35f3
	pop	bc		;35f6
	ld	hl,12h		;35f7
	ex	(sp),hl		;35fa
	call	bdos		;35fb
	pop	bc		;35fe
	ld	h,0		;35ff
	ld	(ix-038h),l	;3601
	ld	(ix-037h),h	;3604
	ld	de,000ffh	;3607
	or	a		;360a
	sbc	hl,de		;360b
	jp	nz,l34cch	;360d
	jr	l3633h		;3610
l3612h:						; m28:
	ld	a,(ix-033h)	;3612
	ld	l,a		;3615
	rla			;3616
	sbc	a,a		;3617
	ld	h,a		;3618
	push	hl		;3619
	call	_setuid		;361a
	ld	hl,0		;361d
	ex	(sp),hl		;3620
	ld	hl,l6374h	;3621	": no match"
	push	hl		;3624
	push	ix		;3625
	pop	de		;3627
	ld	hl,0fd54h	;3628
	add	hl,de		;362b
	push	hl		;362c
	call	_error	;362d error()
	pop	bc		;3630
	pop	bc		;3631
	pop	bc		;3632
l3633h:						; m29:
	ld	a,(ix-033h)	;3633
	ld	l,a		;3636
	rla			;3637
	sbc	a,a		;3638
	ld	h,a		;3639
	push	hl		;363a
	call	_setuid		;363b
	pop	bc		;363e
	jr	l3695h		;363f
l3641h:						; m30:
	add	hl,de		;3641
	ex	de,hl		;3642
	push	iy		;3643
	pop	hl		;3645
	or	a		;3646
	sbc	hl,de		;3647
	inc	hl		;3649
	push	hl		;364a
	call	_alloc	;364b _alloc
	pop	bc		;364e
	ex	de,hl		;364f
	push	de		;3650
	pop	iy		;3651
	push	de		;3653
	push	ix		;3654
	pop	de		;3656
	ld	l,(ix-032h)	;3657
	ld	h,(ix-031h)	;365a
	inc	hl		;365d
	ld	(ix-032h),l	;365e
	ld	(ix-031h),h	;3661
	dec	hl		;3664
	add	hl,hl		;3665
	add	hl,de		;3666
	ld	de,0fe38h	;3667 -456
	add	hl,de		;366a
	pop	de		;366b
	ld	(hl),e		;366c
	inc	hl		;366d
	ld	(hl),d		;366e
	push	ix		;366f
	pop	de		;3671
	ld	hl,0fd54h	;3672
	add	hl,de		;3675
	ld	(ix-030h),l	;3676
	ld	(ix-02fh),h	;3679
l367ch:						; m31:
	ld	l,(ix-030h)	;367c
	ld	h,(ix-02fh)	;367f
	ld	a,(hl)		;3682
	and	07fh		;3683
	ld	(iy+0),a	;3685
	inc	iy		;3688
	ld	a,(hl)		;368a
	inc	hl		;368b
	ld	(ix-030h),l	;368c
	ld	(ix-02fh),h	;368f
	or	a		;3692
	jr	nz,l367ch	;3693
l3695h:						; m32:
	ld	hl,(0a8f3h)	;3695
	ld	a,(hl)		;3698
	or	a		;3699
	jp	nz,l3319h	;369a
l369dh:						; m33:
	ld	hl,0		;369d
	ld	(ix-038h),l	;36a0
	ld	(ix-037h),h	;36a3
	ld	(ix-036h),l	;36a6
	ld	(ix-035h),h	;36a9
	jp	l37c8h		;36ac
l36afh:						; m34:
	push	ix		;36af
	pop	de		;36b1
	ld	l,(ix-038h)	;36b2
	ld	h,(ix-037h)	;36b5
	add	hl,hl		;36b8
	add	hl,de		;36b9
	ld	de,0fe38h	;36ba -456
	add	hl,de		;36bd
	ld	a,(hl)		;36be
	inc	hl		;36bf
	ld	h,(hl)		;36c0
	ld	l,a		;36c1
	ld	a,(hl)		;36c2
	ld	(ix-033h),a	;36c3
	ld	l,a		;36c6
	rla			;36c7
	sbc	a,a		;36c8
	ld	h,a		;36c9
	push	hl		;36ca
	call	_isspecial	;36cb _isspecial Test ('<' '>')
	pop	bc		;36ce
	ld	a,l		;36cf
	or	a		;36d0
	jp	z,l378fh	;36d1

	ld	e,(ix-038h)	;36d4
	ld	d,(ix-037h)	;36d7
	ld	l,(ix-032h)	;36da
	ld	h,(ix-031h)	;36dd
	dec	hl		;36e0
	or	a		;36e1
	sbc	hl,de		;36e2
	jr	nz,l3707h	;36e4

	ld	hl,0		;36e6
	push	hl		;36e9
	push	ix		;36ea
	pop	de		;36ec
	ld	l,(ix-038h)	;36ed
	ld	h,(ix-037h)	;36f0
	add	hl,hl		;36f3
	add	hl,de		;36f4
	ld	de,0fe38h	;36f5 -456
	add	hl,de		;36f8
	ld	c,(hl)		;36f9
	inc	hl		;36fa
	ld	b,(hl)		;36fb
	push	bc		;36fc
	ld	hl,l637fh	;36fd	"no name after "
	push	hl		;3700
	call	_error	;3701 error()
	pop	bc		;3704
	pop	bc		;3705
	pop	bc		;3706
l3707h:						; m35:
	ld	a,(ix-033h)	;3707
	cp	03ch	;60	;370a
	jr	nz,l3737h	;370c
	ld	hl,l63efh	;370e __iob
	push	hl		;3711
	ld	hl,l6394h	;3712	"r"
	push	hl		;3715
	push	ix		;3716
	pop	de		;3718
	ld	l,(ix-038h)	;3719
	ld	h,(ix-037h)	;371c
	inc	hl		;371f
	add	hl,hl		;3720
	add	hl,de		;3721
	ld	de,0fe38h	;3722 -456
	add	hl,de		;3725
	ld	c,(hl)		;3726
	inc	hl		;3727
	ld	b,(hl)		;3728
	push	bc		;3729
	ld	hl,l638eh	;372a "input"
	push	hl		;372d
	call	_redirect	;372e _redirect
	pop	bc		;3731
	pop	bc		;3732
	pop	bc		;3733
	pop	bc		;3734
	jr	l3780h		;3735
l3737h:						; m36:
	push	ix		;3737
	pop	de		;3739
	ld	l,(ix-038h)	;373a
	ld	h,(ix-037h)	;373d
	add	hl,hl		;3740
	add	hl,de		;3741
	ld	de,0fe38h	;3742 -456
	add	hl,de		;3745
	ld	a,(hl)		;3746
	inc	hl		;3747
	ld	h,(hl)		;3748
	ld	l,a		;3749
	inc	hl		;374a
	ld	a,(hl)		;374b
	cp	03eh	;62	;374c
	jr	z,l3755h	;374e

	ld	hl,l6398h	;3750 "w"
	jr	l3758h		;3753
l3755h:						; m37:
	ld	hl,l6396h	;3755 "a"
l3758h:						; m38:
	push	hl		;3758
	pop	iy		;3759
	ld	hl,l63f7h	;375b __iob+8
	push	hl		;375e
	push	iy		;375f
	push	ix		;3761
	pop	de		;3763
	ld	l,(ix-038h)	;3764
	ld	h,(ix-037h)	;3767
	inc	hl		;376a
	add	hl,hl		;376b
	add	hl,de		;376c
	ld	de,0fe38h	;376d -456
	add	hl,de		;3770
	ld	c,(hl)		;3771
	inc	hl		;3772
	ld	b,(hl)		;3773
	push	bc		;3774
	ld	hl,l639ah	;3775 "output"
	push	hl		;3778
	call	_redirect	;3779 _redirect
	pop	bc		;377c
	pop	bc		;377d
	pop	bc		;377e
	pop	bc		;377f
l3780h:						; m39:
	ld	l,(ix-038h)	;3780
	ld	h,(ix-037h)	;3783
	inc	hl		;3786
	ld	(ix-038h),l	;3787
	ld	(ix-037h),h	;378a
	jr	l37bbh		;378d
l378fh:						; m40:
	push	ix		;378f
	pop	de		;3791
	ld	l,(ix-038h)	;3792
	ld	h,(ix-037h)	;3795
	add	hl,hl		;3798
	add	hl,de		;3799
	ld	de,0fe38h	;379a -456
	add	hl,de		;379d
	ld	c,(hl)		;379e
	inc	hl		;379f
	ld	b,(hl)		;37a0
	push	ix		;37a1
	pop	de		;37a3
	ld	l,(ix-036h)	;37a4
	ld	h,(ix-035h)	;37a7
	inc	hl		;37aa
	ld	(ix-036h),l	;37ab
	ld	(ix-035h),h	;37ae
	dec	hl		;37b1
	add	hl,hl		;37b2
	add	hl,de		;37b3
	ld	de,0fe38h	;37b4 -456
	add	hl,de		;37b7
	ld	(hl),c		;37b8
	inc	hl		;37b9
	ld	(hl),b		;37ba
l37bbh:						; m41:
	ld	l,(ix-038h)	;37bb
	ld	h,(ix-037h)	;37be
	inc	hl		;37c1
	ld	(ix-038h),l	;37c2
	ld	(ix-037h),h	;37c5
l37c8h:						; m42:
	ld	e,(ix-032h)	;37c8
	ld	d,(ix-031h)	;37cb
	ld	l,(ix-038h)	;37ce
	ld	h,(ix-037h)	;37d1
	call	wrelop		;37d4
	jp	c,l36afh	;37d7

	ld	l,(ix-036h)	;37da
	ld	h,(ix-035h)	;37dd
	ld	(__argc_),hl	;37e0
	push	ix		;37e3
	pop	de		;37e5
	ld	l,(ix-036h)	;37e6
	ld	h,(ix-035h)	;37e9
	inc	hl		;37ec
	ld	(ix-036h),l	;37ed
	ld	(ix-035h),h	;37f0
	dec	hl		;37f3
	add	hl,hl		;37f4
	add	hl,de		;37f5
	ld	de,0fe38h	;37f6 -456
	add	hl,de		;37f9
	ld	de,0		;37fa
	ld	(hl),e		;37fd
	inc	hl		;37fe
	ld	(hl),d		;37ff
	ld	l,(ix-036h)	;3800
	ld	h,(ix-035h)	;3803
	add	hl,hl		;3806
	push	hl		;3807
	call	_alloc		;3808 _alloc
	ld	(ix-2),l	;380b
	ld	(ix-1),h	;380e
	ld	l,(ix-036h)	;3811
	ld	h,(ix-035h)	;3814
	add	hl,hl		;3817
	ex	(sp),hl		;3818
	ld	l,(ix-2)	;3819
	ld	h,(ix-1)	;381c
	push	hl		;381f
	push	ix		;3820
	pop	de		;3822
	ld	hl,0fe38h	;3823 -456
	add	hl,de		;3826
	push	hl		;3827
	call	movmem		;3828
	pop	bc		;382b
	pop	bc		;382c
	pop	bc		;382d
	ld	l,(ix-2)	;382e
	ld	h,(ix-1)	;3831
	jp	cret		;3834

; 	End __getargs

; =============== F U N C T I O N =======================================
;
;	nxtch		From libary
_nxtch:
sub_3837h:
	call	csv		;3837
	ld	a,(0a8f5h)	;383a _interactive
	or	a		;383d
	ld	hl,(0a8f3h)	;383e _str
	ld	a,(hl)		;3841
	jr	z,l3897h	;3842

	cp	05ch	;'\'	;3844
	jr	nz,l3893h	;3846

	ld	iy,(0a8f3h)	;3848 _str
	ld	a,(iy+1)	;384c
	or	a		;384f
	jr	nz,l3893h	;3850

	ld	hl,(0a8fbh)	;3852 _bp
	ld	a,l		;3855
	or	h		;3856
	jr	nz,l3864h	;3857

	ld	hl,256		;3859 256
	push	hl		;385c
	call	_alloc		;385d _alloc
	pop	bc		;3860
	ld	(0a8fbh),hl	;3861 _bp
l3864h:						; m1:
	ld	hl,l63f6h	;3864 __iob+7
	ld	l,(hl)		;3867
	ld	h,0		;3868
	push	hl		;386a
	call	_isatty		;386b _isatty
	pop	bc		;386e
	ld	a,l		;386f
	or	h		;3870
	jr	z,l3885h	;3871

	ld	hl,(0a8f6h)	;3873 _name
	push	hl		;3876
	ld	hl,l63a1h	;3877 "%s> "
	push	hl		;387a
	ld	hl,l63ffh	;387b __iob+16
	push	hl		;387e
	call	_fprintf	;387f
	pop	bc		;3882
	pop	bc		;3883
	pop	bc		;3884
l3885h:						; m2:
	ld	hl,(0a8fbh)	;3885 _bp
	push	hl		;3888
	call	sub_3e1ch	;3889 _gets
	pop	bc		;388c
	ld	hl,(0a8fbh)	;388d _bp
	ld	(0a8f3h),hl	;3890 _str
l3893h:						; m3:
	ld	hl,(0a8f3h)	;3893 _str
	ld	a,(hl)		;3896
l3897h:						; m4:
	or	a		;3897
	jr	z,l38a6h	;3898
	ld	hl,(0a8f3h)	;389a _str
	inc	hl		;389d
	ld	(0a8f3h),hl	;389e _str
	dec	hl		;38a1
	ld	l,(hl)		;38a2
	jp	cret		;38a3
l38a6h:						; m5:
	ld	l,0		;38a6
	jp	cret		;38a8

;	End sub_3837h:

; =============== F U N C T I O N =======================================
;
;	error		From libary
_error:
	call	csv		;38ab
	push	hl		;38ae
	push	ix		;38af
	pop	de		;38b1
	ld	hl,6		;38b2
	add	hl,de		;38b5
	ld	(ix-2),l	;38b6
	ld	(ix-1),h	;38b9
	jr	l38d3h		;38bc			goto m1;
l38beh:						; m1:
	ld	l,(ix-2)	;38be
	ld	h,(ix-1)	;38c1
	ld	c,(hl)		;38c4
	inc	hl		;38c5
	ld	b,(hl)		;38c6
	inc	hl		;38c7
	ld	(ix-2),l	;38c8
	ld	(ix-1),h	;38cb
	push	bc		;38ce
	call	sub_38efh	;38cf _sputs
	pop	bc		;38d2
l38d3h:						; m1:
	ld	l,(ix-2)	;38d3
	ld	h,(ix-1)	;38d6
	ld	a,(hl)		;38d9
	inc	hl		;38da
	or	(hl)		;38db
	jr	nz,l38beh	;38dc

	ld	hl,l63a6h	;38de "\n"
	push	hl		;38e1
	call	sub_38efh	;38e2 _sputs
	ld	hl,-1		;38e5
	ex	(sp),hl		;38e8
	call	exit		;38e9
	jp	cret		;38ec

;	End _error

; =============== F U N C T I O N =======================================
;
;	sputs		From libary
_sputs:
sub_38efh:						; void sub_38efh(register char * st) {
	call	csv		;38ef
	ld	l,(ix+6)	;38f2
	ld	h,(ix+7)	;38f5
	push	hl		;38f8
	pop	iy		;38f9
	jr	l3924h		;38fb	  		; while(*st != 0) {
l38fdh:						; m1:
	ld	a,(iy+0)	;38fd
	cp	0ah	;'\n'	;3900
	jr	nz,l3911h	;3902	    		;     if(*st == '\n') bdos(2, '\r');
	
	ld	hl,0dh	;'\r'	;3904
	push	hl		;3907
	ld	hl,2		;3908
	push	hl		;390b
	call	bdos		;390c	  
	pop	bc		;390f
	pop	bc		;3910
l3911h:						; m2:
	ld	a,(iy+0)	;3911
	inc	iy		;3914
	ld	l,a		;3916
	rla			;3917
	sbc	a,a		;3918
	ld	h,a		;3919
	push	hl		;391a
	ld	hl,2		;391b
	push	hl		;391e
	call	bdos		;391f	  		;      bdos(2, *(st++));
	pop	bc		;3922	  		; }
	pop	bc		;3923
l3924h:						; m3:
	ld	a,(iy+0)	;3924
	or	a		;3927
	jr	nz,l38fdh	;3928
	jp	cret		;392a	  return;

;	End sub_38efh

; =============== F U N C T I O N =======================================
;
; 	alloc	from library
_alloc:					  		; char * alloc(n) short n; {
	call	csv		;392d	  		;      char *	bp;
	push	hl		;3930
	ld	l,(ix+6)	;3931
	ld	h,(ix+7)	;3934
	push	hl		;3937
	call	sbrk		;3938
	pop	bc		;393b
	ld	(ix-2),l	;393c
	ld	(ix-1),h	;393f
	ld	de,-1		;3942
	or	a		;3945
	sbc	hl,de		;3946
	jr	nz,l3957h	;3948	  		;     if((bp = sbrk(n)) == (char *)-1)
	
	ld	hl,0		;394a
	push	hl		;394d
	ld	hl,l63a8h	;394e	
	push	hl		;3951
	call	_error		;3952	  		;         error("no room for arguments", 0);
	pop	bc		;3955
	pop	bc		;3956
l3957h:							;
	ld	l,(ix-2)	;3957
	ld	h,(ix-1)	;395a	  		;     return bp;
	jp	cret		;395d		  	; }

;	End _alloc

; =============== F U N C T I O N =======================================
;
;	redirect	from library
							; static void redirect(str_name, file_name, mode, stream)
							; char *	str_name, * file_name, * mode; FILE *	stream; {
_redirect:
	call	csv		;3960
	ld	de,l63efh	;3963 __iob
	ld	l,(ix+00ch)	;3966
	ld	h,(ix+00dh) ;p4 ;3969
	or	a		;396c
	sbc	hl,de		;396d
	ld	de,8		;396f
	call	adiv		;3972
	ld	de,0a8f8h	;3975 _redone
	add	hl,de		;3978
	ld	a,(hl)		;3979
	inc	(hl)		;397a
	or	a		;397b
	jr	z,l3998h	;397c
	
	ld	hl,0		;397e
	push	hl		;3981
	ld	hl,l63c9h	;3982 " redirection"
	push	hl		;3985
	ld	l,(ix+6)    ;p1 ;3986
	ld	h,(ix+7)	;3989
	push	hl		;398c
	ld	hl,l63beh	;398d "Ambiguous "
	push	hl		;3990
	call	_error		;3991			; error("Ambiguous ", p1, " redirection", 0);
	pop	bc		;3994
	pop	bc		;3995
	pop	bc		;3996
	pop	bc		;3997
l3998h:
	ld	l,(ix+00ch)	;3998
	ld	h,(ix+00dh) ;p4 ;399b
	push	hl		;399e
	ld	l,(ix+00ah)	;399f
	ld	h,(ix+00bh) ;p3 ;39a2
	push	hl		;39a5
	ld	l,(ix+8)	;39a6
	ld	h,(ix+9)    ;p2 ;39a9
	push	hl		;39ac
	call	_freopen	;39ad 
	pop	bc		;39b0
	pop	bc		;39b1
	pop	bc		;39b2
	ld	e,(ix+00ch)	;39b3
	ld	d,(ix+00dh) ;p4 ;39b6
	or	a		;39b9
	sbc	hl,de		;39ba
	jp	z,cret		;39bc		  	; if(freopen(p2, p3, p4) == p4) return;
	
	ld	hl,0		;39bf
	push	hl		;39c2
	ld	l,(ix+6)	;39c3
	ld	h,(ix+7)    ;p1 ;39c6
	push	hl		;39c9
	ld	hl,l63e2h	;39ca " for "
	push	hl		;39cd
	ld	l,(ix+8)	;39ce
	ld	h,(ix+9)    ;p2 ;39d1
	push	hl		;39d4
	ld	hl,l63d6h	;39d5 "Can't open "
	push	hl		;39d8
	call	_error		;39d9			; error("Can't open ", p2, " for ", p1, 0);
	jp	cret		;39dc		  	; return;

;	End _redirect

; =============== F U N C T I O N =======================================
;
;	Test wildcard characters ('*' '?')	from library
;
_iswild:						; int iswild(int par) {
	call	csv		;39df
	ld	hl,2ah	;'*'	;39e2
	push	hl		;39e5
	ld	l,(ix+6)	;39e6
	ld	h,(ix+7)	;39e9
	push	hl		;39ec
	call	_index		;39ed _strchr
	pop	bc		;39f0
	pop	bc		;39f1
	ld	a,l		;39f2
	or	h		;39f3
	jr	nz,l3a0ah	;39f4		  	; if(index(par, '*') != 0) return 1;

	ld	hl,3fh	;'?'	;39f6
	push	hl		;39f9
	ld	l,(ix+6)	;39fa
	ld	h,(ix+7)	;39fd
	push	hl		;3a00
	call	_index		;3a01 _strchr
	pop	bc		;3a04
	pop	bc		;3a05
	ld	a,l		;3a06
	or	h		;3a07
	jr	z,l3a10h	;3a08		  	; if(_index(par, '?') != 0) return 0;
l3a0ah:
	ld	hl,1		;3a0a		  	; }
	jp	cret		;3a0d
l3a10h:
	ld	hl,0		;3a10
	jp	cret		;3a13

;	End _iswild

; =============== F U N C T I O N =======================================
;
;	Test ('<' '>')		from library
;
_isspecial:						; int isspecial(char par) {
	call	csv		;3a16
	ld	a,(ix+6)	;3a19
	cp	'<'		;3a1c
	jr	z,l3a24h	;3a1e		  	; if(par == '<') return 1;
	
	cp	'>'		;3a20
	jr	nz,l3a2ah	;3a22		  	; if(par != '<') return 0;
l3a24h:
	ld	hl,1		;3a24		  	; }
	jp	cret		;3a27
l3a2ah:
	ld	hl,0		;3a2a
	jp	cret		;3a2d

;	End _isspecial

; =============== F U N C T I O N =======================================
;
;	Test delimiter (' ', '\t' or '\n')	from library
;
_isseparator:						; int isseparator(char par) {
	call	csv		;3a30
	ld	a,(ix+6)	;3a33
	cp	' '		;3a36
	jr	z,l3a42h	;3a38		  	; if((par == ' ') || (par != '\t')) return 1;
	cp	9	;'\t'	;3a3a
	jr	z,l3a42h	;3a3c
	cp	0ah	;'\n'	;3a3e
	jr	nz,l3a48h	;3a40		  	; if(par != '\n') return 0
l3a42h:
	ld	hl,1		;3a42		  	; return 1;
	jp	cret		;3a45		  	; }
l3a48h:
	ld	hl,0		;3a48
	jp	cret		;3a4b

;	End _isseparator

; =============== F U N C T I O N =======================================
;
;	fprintf		from library
_fprintf:					; void _fprintf(int p1, p2, p3) {
	call	csv		;3a4e
	push	ix		;3a51
	pop	de		;3a53
	ld	hl,0ah		;3a54
	add	hl,de		;3a57
	push	hl		;3a58
	ld	l,(ix+8)	;3a59
	ld	h,(ix+9)	;3a5c
	push	hl		;3a5f
	ld	l,(ix+6)	;3a60
	ld	h,(ix+7)	;3a63
	push	hl		;3a66
	call	__doprnt	;3a67		  	; __doprnt(p1, p2, &p3)
	pop	bc		;3a6a
	pop	bc		;3a6b
	pop	bc		;3a6c
	jp	cret		;3a6d		  	; }

; =============== F U N C T I O N =======================================
;
;	sprintf		From library
_sprintf:					; int _sprintf() {
	call	csv		;3a70
	ld	hl,07fffh	;3a73
	ld	(word_a8ff),hl	;3a76		  	; word_a8ff = 0x7fff;

	ld	l,(ix+6)	;3a79
	ld	h,(ix+7)	;3a7c
	ld	(word_a8fd),hl	;3a7f		  	; word_a8fd = p1;

	ld	hl,0a903h	;3a82
	ld	(hl),0c2h	;3a85		  	; *byte_a903 = 0xC2;
	push	ix		;3a87
	pop	de		;3a89
	ld	hl,0000ah	;3a8a
	add	hl,de		;3a8d
	push	hl		;3a8e
	ld	l,(ix+8)	;3a8f
	ld	h,(ix+9)	;3a92
	push	hl		;3a95
	ld	hl,word_a8fd	;3a96
	push	hl		;3a99
	call	__doprnt	;3a9a		  	; __doprnt(&word_a8fd, p2, &p3);
	pop	bc		;3a9d
	pop	bc		;3a9e
	pop	bc		;3a9f
	ld	hl,(word_a8fd)	;3aa0		  	; word_a8fd = 0;  
	ld	(hl),0		;3aa3

	ld	e,(ix+6)	;3aa5
	ld	d,(ix+7)	;3aa8
	or	a		;3aab
	sbc	hl,de		;3aac
	jp	cret		;3aae		  	; }

; =============== F U N C T I O N =======================================
;
;	pputc		From library
_pputc:							; void _pputc(char par) {
	call	csv		;3ab1
	ld	hl,(0a908h)	;3ab4
	push	hl		;3ab7
	ld	a,(ix+6)	;3ab8
	ld	l,a		;3abb
	rla			;3abc
	sbc	a,a		;3abd
	ld	h,a		;3abe
	push	hl		;3abf
	call	_fputc		;3ac0		  	; _fputc(p1, word_a908);
	jp	cret		;3ac3		  	; }

; =============== F U N C T I O N =======================================
;
;	icvt		From library
_icvt:						; char * _icvt(register char * par) {
	call	csv		;3ac6
	ld	l,(ix+6)	;3ac9
	ld	h,(ix+7)	;3acc
	push	hl		;3acf
	pop	iy		;3ad0
	
	push	hl		;3ad2
	call	atoi		;3ad3
	pop	bc		;3ad6
	ld	a,l		;3ad7
	ld	(0a905h),a	;3ad8			; word_a905h = atoi(*par);
	jr	l3adfh		;3adb			; goto m2;
l3addh:						; m1:
	inc	iy		;3add			; par++;
l3adfh:						; m2:
	ld	e,(iy+0)	;3adf
	ld	d,0		;3ae2
	ld	hl,__ctype_+1	;3ae4
	add	hl,de		;3ae7
	bit	2,(hl)		;3ae8			; if(isdigit(*par)) goto m1;
	jr	nz,l3addh	;3aea
	
	push	iy		;3aec
	pop	hl		;3aee			; return par;
	jp	cret		;3aef

; =============== F U N C T I O N =======================================
;
;	_doprnt		From library
__doprnt:
	call	ncsv	;-9	;3af2
	defw	0fff7h		;3af5
	ld	l,(ix+8)	;3af7
	ld	h,(ix+9)    ;p2 ;3afa
	push	hl		;3afd
	pop	iy		;3afe
	ld	l,(ix+6)	;3b00
	ld	h,(ix+7)    ;p1 ;3b03
	ld	(0a908h),hl	;3b06		  	; word_a908h = p1;
	jp	l3d95h		;3b09		  	; goto m38;
l3b0ch:						; m1:
	ld	a,(ix-1)	;3b0c
	cp	025h		;3b0f
	jr	z,l3b1fh	;3b11		  	; if( == 0x25) goto m2;

	ld	l,a		;3b13
	rla			;3b14
	sbc	a,a		;3b15
	ld	h,a		;3b16
	push	hl		;3b17
	call	_pputc		;3b18		  	; _pputc();
	pop	bc		;3b1b
	jp	l3d95h		;3b1c		  	; goto m38;
l3b1fh:						; m2:
	ld	(ix-5),00ah	;3b1f
	ld	(ix-6),0	;3b23
	ld	(ix-8),0	;3b27
	ld	(ix-3),0	;3b2b
	ld	(ix-9),001h	;3b2f
	ld	a,(iy+0)	;3b33
	cp	02dh		;3b36
	jr	nz,l3b3fh	;3b38

	inc	iy		;3b3a
	inc	(ix-3)		;3b3c
l3b3fh:						; m3:
	ld	a,(iy+0)	;3b3f
	cp	030h		;3b42
	ld	hl,1		;3b44
	jr	z,l3b4ah	;3b47
	dec	hl		;3b49
l3b4ah:						; m4:
	ld	(ix-2),l	;3b4a
	ld	e,(iy+0)	;3b4d
	ld	d,0		;3b50
	ld	hl,__ctype_+1	;3b52
	add	hl,de		;3b55
	bit	2,(hl)		;3b56
	jr	z,l3b6bh	;3b58

	push	iy		;3b5a
	call	_icvt	;3b5c
	pop	bc		;3b5f
	push	hl		;3b60
	pop	iy		;3b61
	ld	a,(0a905h)	;3b63
	ld	(ix-6),a	;3b66
	jr	l3b86h		;3b69		  	; goto m6;
l3b6bh:				;		; m5:
	ld	a,(iy+0)	;3b6b
	cp	02ah		;3b6e
	jr	nz,l3b86h	;3b70

	ld	l,(ix+00ah)	;3b72
	ld	h,(ix+00bh)	;3b75
	ld	a,(hl)		;3b78
	inc	hl		;3b79
	inc	hl		;3b7a
	ld	(ix+00ah),l	;3b7b
	ld	(ix+00bh),h	;3b7e
	ld	(ix-6),a	;3b81
	inc	iy		;3b84
l3b86h:						; m6:
	ld	a,(iy+0)	;3b86
	cp	02eh		;3b89
	jr	nz,l3bbdh	;3b8b

	inc	iy		;3b8d
	ld	a,(iy+0)	;3b8f
	cp	02ah		;3b92
	jr	nz,l3bach	;3b94
	ld	l,(ix+00ah)	;3b96
	ld	h,(ix+00bh)	;3b99
	ld	a,(hl)		;3b9c
	inc	hl		;3b9d
	inc	hl		;3b9e
	ld	(ix+00ah),l	;3b9f
	ld	(ix+00bh),h	;3ba2
	ld	(ix-7),a	;3ba5
	inc	iy		;3ba8
	jr	l3bd0h		;3baa
l3bach:						; m7:
	push	iy		;3bac
	call	_icvt		;3bae
	pop	bc		;3bb1
	push	hl		;3bb2
	pop	iy		;3bb3
	ld	a,(0a905h)	;3bb5
	ld	(ix-7),a	;3bb8
	jr	l3bd0h		;3bbb
l3bbdh:						; m8:
	ld	a,(ix-2)	;3bbd
	or	a		;3bc0
	jr	nz,l3bc8h	;3bc1

	ld	hl,0		;3bc3
	jr	l3bcdh		;3bc6
l3bc8h:						; m9:
	ld	l,(ix-6)	;3bc8
	ld	h,0		;3bcb
l3bcdh:						; m10:
	ld	(ix-7),l	;3bcd
l3bd0h:						; m11:
	ld	a,(iy+0)	;3bd0
	cp	06ch		;3bd3
	jr	nz,l3bddh	;3bd5

	inc	iy		;3bd7
	ld	(ix-9),002h	;3bd9
l3bddh:						; m12:
	ld	a,(iy+0)	;3bdd
	inc	iy		;3be0
	ld	(ix-1),a	;3be2
	or	a		;3be5
	jp	z,cret		;3be6

	cp	044h	;'D'	;3be9
	jp	z,l3c6ah	;3beb
	cp	04fh	;'O'	;3bee
	jr	z,l3c14h	;3bf0
	cp	058h	;'X;	;3bf2
	jp	z,l3c70h	;3bf4
	cp	063h	;'c'	;3bf7
	jp	z,l3d21h	;3bf9
	cp	064h	;'d'	;3bfc
	jr	z,l3c6ah	;3bfe
	cp	06fh	;'o'	;3c00
	jr	z,l3c14h	;3c02
	cp	073h	;'s'	;3c04
	jp	z,l3c76h	;3c06
	cp	075h	;'u'	;3c09
	jr	z,l3c18h	;3c0b
	cp	078h	;'x'	;3c0d
	jr	z,l3c70h	;3c0f
	jp	l3d33h		;3c11
l3c14h:						; m13:
	ld	(ix-5),8	;3c14
l3c18h:						; m14:
	ld	a,(ix-3)	;3c18
	or	a		;3c1b
	jr	z,l3c28h	;3c1c

	ld	a,(ix-6)	;3c1e
	ld	(ix-3),a	;3c21
	ld	(ix-6),0	;3c24
l3c28h:						; m15:
	ld	a,(ix-1)	;3c28
	ld	e,a		;3c2b
	rla			;3c2c
	sbc	a,a		;3c2d
	ld	d,a		;3c2e
	ld	hl,__ctype_+1	;3c2f
	add	hl,de		;3c32
	bit	0,(hl)		;3c33
	jr	z,l3c3bh	;3c35

	ld	(ix-9),2	;3c37
l3c3bh:						; m16:
	ld	hl,_pputc	;3c3b 
	push	hl		;3c3e
	ld	l,(ix-5)	;3c3f
	ld	h,0		;3c42
	push	hl		;3c44
	ld	l,(ix-8)	;3c45
	push	hl		;3c48
	ld	l,(ix-6)	;3c49
	push	hl		;3c4c
	ld	l,(ix-7)	;3c4d
	push	hl		;3c50
	ld	a,(ix-9)	;3c51
	cp	1		;3c54
	jp	z,l3d41h	;3c56

	ld	l,(ix+00ah)	;3c59
	ld	h,(ix+00bh)	;3c5c
	ld	e,(hl)		;3c5f
	inc	hl		;3c60
	ld	d,(hl)		;3c61
	inc	hl		;3c62
	ld	a,(hl)		;3c63
	inc	hl		;3c64
	ld	h,(hl)		;3c65
	ld	l,a		;3c66
	jp	l3d5ah		;3c67		  	; goto m35;
l3c6ah:						; m17:
	ld	(ix-8),1	;3c6a
	jr	l3c18h		;3c6e
l3c70h:						; m18:
	ld	(ix-5),010h	;3c70
	jr	l3c18h		;3c74
l3c76h:						; m19:
	ld	l,(ix+00ah)	;3c76
	ld	h,(ix+00bh)	;3c79
	ld	c,(hl)		;3c7c
	inc	hl		;3c7d
	ld	b,(hl)		;3c7e
	ld	(0a906h),bc	;3c7f
	inc	hl		;3c83
	ld	(ix+00ah),l	;3c84
	ld	(ix+00bh),h	;3c87
	ld	l,c		;3c8a
	ld	h,b		;3c8b
	ld	a,l		;3c8c
	or	h		;3c8d
	jr	nz,l3c96h	;3c8e

	ld	hl,l63e8h	;3c90
	ld	(0a906h),hl	;3c93
l3c96h:						; m20:
	ld	hl,(0a906h)	;3c96
	push	hl		;3c99
	call	strlen		;3c9a
	pop	bc		;3c9d
	ld	(ix-4),l	;3c9e
l3ca1h:						; m21:
	ld	a,(ix-7)	;3ca1
	or	a		;3ca4
	jr	z,l3cb5h	;3ca5		  	; if(	 == 0) goto m22;

	ld	b,(ix-4)	;3ca7
	call	brelop		;3caa
	jr	nc,l3cb5h	;3cad		  	; if(	  0) goto m22;

	ld	a,(ix-7)	;3caf
	ld	(ix-4),a	;3cb2
l3cb5h:						; m22:
	ld	b,(ix-6)	;3cb5
	ld	a,(ix-4)	;3cb8
	call	brelop		;3cbb
	jr	nc,l3ccbh	;3cbe		  	; if(	 ) goto m23;

	ld	a,(ix-6)	;3cc0
	sub	(ix-4)		;3cc3
	ld	(ix-6),a	;3cc6
	jr	l3ccfh		;3cc9		  	; goto m24;
l3ccbh:						; m23:
	ld	(ix-6),0	;3ccb
l3ccfh:						; m24:
	ld	a,(ix-3)	;3ccf
	or	a		;3cd2
	jr	nz,l3cfbh	;3cd3
	jr	l3cdfh		;3cd5
l3cd7h:						; m25:
	ld	hl,00020h	;3cd7
	push	hl		;3cda
	call	_pputc		;3cdb		  	; _pputc(' ');
	pop	bc		;3cde
l3cdfh:						; m26:
	ld	a,(ix-6)	;3cdf
	dec	(ix-6)		;3ce2
	or	a		;3ce5
	jr	nz,l3cd7h	;3ce6		  	; if() goto m25;
	jr	l3cfbh		;3ce8		  	; goto m28;
l3ceah:						; m27:
	ld	hl,(0a906h)	;3cea
	ld	a,(hl)		;3ced
	inc	hl		;3cee
	ld	(0a906h),hl	;3cef
	ld	l,a		;3cf2
	rla			;3cf3
	sbc	a,a		;3cf4
	ld	h,a		;3cf5
	push	hl		;3cf6
	call	_pputc		;3cf7
	pop	bc		;3cfa
l3cfbh:						; m28:
	ld	a,(ix-4)	;3cfb
	dec	(ix-4)		;3cfe
	or	a		;3d01
	jr	nz,l3ceah	;3d02		  	; if(	 != 0) goto m27;

	ld	a,(ix-3)	;3d04
	or	a		;3d07
	jp	z,l3d95h	;3d08		  	; if(	 == 0) goto m38;
	jr	l3d15h		;3d0b		  	; goto m30;
l3d0dh:						; m29:
	ld	hl,00020h	;3d0d
	push	hl		;3d10
	call	_pputc		;3d11		  	; _pputc(0x20);
	pop	bc		;3d14
l3d15h:						; m30:
	ld	a,(ix-6)	;3d15
	dec	(ix-6)		;3d18
	or	a		;3d1b
	jr	nz,l3d0dh	;3d1c		  	; if(	 != 0) goto m29;
	jp	l3d95h		;3d1e		  	; goto m38;
l3d21h:						; m31:
	ld	l,(ix+00ah)	;3d21
	ld	h,(ix+00bh)	;3d24
	ld	a,(hl)		;3d27
	inc	hl		;3d28
	inc	hl		;3d29
	ld	(ix+00ah),l	;3d2a
	ld	(ix+00bh),h	;3d2d
	ld	(ix-1),a	;3d30
l3d33h:						; m32:
	push	ix		;3d33
	pop	hl		;3d35
	dec	hl		;3d36
	ld	(0a906h),hl	;3d37
	ld	(ix-4),1	;3d3a
	jp	l3ca1h		;3d3e
l3d41h:						; m33:
	ld	a,(ix-8)	;3d41
	or	a		;3d44
	ld	l,(ix+00ah)	;3d45
	ld	h,(ix+00bh)	;3d48
	ld	e,(hl)		;3d4b
	inc	hl		;3d4c
	ld	d,(hl)		;3d4d
	jr	nz,l3d55h	;3d4e		  	; if(	 != 0) goto m34;

	ld	hl,0		;3d50
	jr	l3d5ah		;3d53		  	; goto m35;
l3d55h:						; m34:
	ld	a,d		;3d55
	rla			;3d56
	sbc	a,a		;3d57
	ld	l,a		;3d58
	ld	h,a		;3d59
l3d5ah:						; m35:
	push	hl		;3d5a
	push	de		;3d5b
	call	__pnum		;3d5c
	exx			;3d5f
	ld	hl,0000eh	;3d60
	add	hl,sp		;3d63
	ld	sp,hl		;3d64
	exx			;3d65
	ld	(ix-6),l	;3d66
	ld	l,(ix-9)	;3d69
	ld	h,0		;3d6c
	add	hl,hl		;3d6e
	ex	de,hl		;3d6f
	ld	l,(ix+00ah)	;3d70
	ld	h,(ix+00bh)	;3d73
	add	hl,de		;3d76
	ld	(ix+00ah),l	;3d77
	ld	(ix+00bh),h	;3d7a
	jr	l3d87h		;3d7d		  	; goto m37;
l3d7fh:						; m36:
	ld	hl,00020h	;3d7f
	push	hl		;3d82
	call	_pputc		;3d83		  	; _pputc(0x20);
	pop	bc		;3d86
l3d87h:						; m37:
	ld	b,(ix-3)	;3d87
	dec	(ix-3)		;3d8a
	ld	a,(ix-6)	;3d8d
	call	brelop		;3d90
	jr	c,l3d7fh	;3d93		  	; if() goto m36;
l3d95h:						; m38:
	ld	a,(iy+0)	;3d95
	inc	iy		;3d98
	ld	(ix-1),a	;3d9a
	or	a		;3d9d
	jp	nz,l3b0ch	;3d9e		  	; if( != 0) goto m1;
	jp	cret		;3da1		  	; return;

; =============== F U N C T I O N =======================================
;	
;
sub_3da4h:						; sub_3da4h(char * p1, char p2, register int * st) {
	call	csv		;3da4			; char * l1;
	push	hl		;3da7			; int    l2;
	push	hl		;3da8
	ld	l,(ix+00ah)	;3da9		  	;
	ld	h,(ix+00bh) ;p3	;3dac		  	;
	push	hl		;3daf		  	;
	pop	iy		;3db0		  	;

	ld	l,(ix+6)	;3db2		  	;
	ld	h,(ix+7) ;p1	;3db5		  	;
	ld	(ix-2),l	;3db8		  	;
	ld	(ix-1),h ;l1	;3dbb		  	; l1 = p1;
l3dbeh:							; m1:
	ld	l,(ix+8)	;3dbe		  	;
	ld	h,(ix+9) ;p2	;3dc1		  	;
	dec	hl		;3dc4		  	;
	ld	(ix+8),l	;3dc5		  	;
	ld	(ix+9),h ;p2	;3dc8		  	;
	inc	hl		;3dcb		  	;
	ld	a,l		;3dcc		  	;
	or	h		;3dcd		  	;
	jr	z,l3dfah	;3dce		  	; if(p2-- == 0) goto m2;

	push	iy		;3dd0		  	;
	call	sub_4437h	;3dd2		  	;
	pop	bc		;3dd5		  	;
	ld	(ix-4),l	;3dd6		  	;
	ld	(ix-3),h ;l2	;3dd9		  	; l2 = sub_4437h(st);

	ld	de,-1		;3ddc		  	;
	or	a		;3ddf		  	;
	sbc	hl,de		;3de0		  	;
	jr	z,l3dfah	;3de2		  	; if(l2 == -1) goto m2;

	ld	a,(ix-4) ;l2	;3de4		  	;
	ld	l,(ix+6)	;3de7		  	;
	ld	h,(ix+7) ;p1	;3dea		  	;
	inc	hl		;3ded		  	;
	ld	(ix+6),l	;3dee		  	;
	ld	(ix+7),h ;p1	;3df1		  	;
	dec	hl		;3df4		  	;
	ld	(hl),a		;3df5		  	;
	cp	0ah	;'\n'	;3df6		  	;
	jr	nz,l3dbeh	;3df8		  	; if((*(p1++) = l2) != '\n') goto m1;
l3dfah:							; m2:
	ld	l,(ix+6)	;3dfa		  	;
	ld	h,(ix+7) ;p1	;3dfd		  	;
	ld	(hl),0		;3e00		  	; *p1 = 0;

	ld	e,(ix-2)	;3e02		  	;
	ld	d,(ix-1) ;l1	;3e05		  	;
	or	a		;3e08		  	;
	sbc	hl,de		;3e09		  	;
	jr	nz,l3e13h	;3e0b		  	; if(p1 != l1) goto m3;

	ld	hl,0		;3e0d		  	;
	jp	cret		;3e10		  	; return 0;
l3e13h:							; m3:
	ld	l,(ix-2)	;3e13		  	;
	ld	h,(ix-1) ;l1	;3e16		  	;
	jp	cret		;3e19		  	; return l1;
							; }
; =============== F U N C T I O N =======================================
;	From library?
;
sub_3e1ch:						; char * sub_3e1ch(char * p1) {
	call	csv		;3e1c		  	;
	ld	hl,l63efh	;3e1f __iob		;
	push	hl		;3e22		  	;
	ld	hl,-1		;3e23		  	;
	push	hl		;3e26		  	;
	ld	l,(ix+6)	;3e27		  	;
	ld	h,(ix+7) ;p1	;3e2a		  	;
	push	hl		;3e2d		  	;
	call	sub_3da4h	;3e2e		  	;
	pop	bc		;3e31		  	;
	pop	bc		;3e32		  	;
	pop	bc		;3e33		  	;
	ld	(ix+6),l	;3e34		  	;
	ld	(ix+7),h ;p1	;3e37		  	; p1 = sub_3da4h(p1, -1, stdin);
	ld	a,l		;3e3a		  	;
	or	h		;3e3b		  	;
	jr	nz,l3e44h	;3e3c		  	; if(p1 != 0) goto m1;
	ld	hl,0		;3e3e		  	;
	jp	cret		;3e41		  	; return 0;
l3e44h:							; m1:
	ld	l,(ix+6)	;3e44		  	;
	ld	h,(ix+7) ;p1	;3e47		  	;
	push	hl		;3e4a		  	;
	call	strlen		;3e4b		  	;
	pop	bc		;3e4e		  	;
	ex	de,hl		;3e4f		  	;
	ld	hl,-1		;3e50		  	;
	add	hl,de		;3e53		  	;
	ld	e,(ix+6)	;3e54		  	;
	ld	d,(ix+7) ;p1	;3e57		  	;
	add	hl,de		;3e5a		  	;
	ld	(hl),0		;3e5b		  	; *(p1 + (-1 + strlen(p1))) = 0;
	ld	l,e		;3e5d		  	;
	ld	h,d		;3e5e		  	;
	jp	cret		;3e5f		  	; return p1;
							; }
; =============== F U N C T I O N =======================================
;
;	From library
_fputc:
	pop	de		;3e62
	pop	bc		;3e63
	ld	b,0		;3e64
	ex	(sp),iy		;3e66
	bit	1,(iy+6)	;3e68
	jr	z,l3eb5h	;3e6c
	bit	7,(iy+6)	;3e6e
	jr	nz,l3e88h	;3e72
	ld	a,c		;3e74
	cp	0ah ;'\n'	;3e75
	jr	nz,l3e88h	;3e77
	push	bc		;3e79
	push	de		;3e7a
	push	iy		;3e7b
	ld	hl,0000dh	;3e7d
	push	hl		;3e80
	call	_fputc		;3e81
	pop	hl		;3e84
	pop	bc		;3e85
	pop	de		;3e86
	pop	bc		;3e87
l3e88h:						; m1:
	ld	l,(iy+2)	;3e88
	ld	h,(iy+3)	;3e8b
	ld	a,l		;3e8e
	or	h		;3e8f
	jr	z,l3eaeh	;3e90

	dec	hl		;3e92
	ld	(iy+2),l	;3e93
	ld	(iy+3),h	;3e96
	ld	l,(iy+0)	;3e99
	ld	h,(iy+1)	;3e9c
	ld	(hl),c		;3e9f
	inc	hl		;3ea0
	ld	(iy+0),l	;3ea1
	ld	(iy+1),h	;3ea4
l3ea7h:						; m2:
	ex	(sp),iy		;3ea7
	push	bc		;3ea9
	push	de		;3eaa
	ld	l,c		;3eab
	ld	h,b		;3eac
	ret			;3ead
l3eaeh:						; m3:
	ex	(sp),iy		;3eae
	push	bc		;3eb0
	push	de		;3eb1
	jp	l3ebah		;3eb2
l3eb5h:						; m4:
	ld	bc,-1		;3eb5
	jr	l3ea7h		;3eb8

l3ebah:						; m5:
	call	csv		;3eba
	ld	l,(ix+8)	;3ebd
	ld	h,(ix+9)	;3ec0
	push	hl		;3ec3
	pop	iy		;3ec4
	bit	1,(iy+6)	;3ec6
	jp	z,l3f4dh	;3eca

	ld	a,(iy+4)	;3ecd
	or	(iy+5)		;3ed0
	jr	nz,l3f0fh	;3ed3

	ld	(iy+2),0	;3ed5
	ld	(iy+3),0	;3ed9
	ld	hl,1		;3edd
	push	hl		;3ee0
	push	ix		;3ee1
	pop	de		;3ee3
	ld	hl,6		;3ee4
	add	hl,de		;3ee7
	push	hl		;3ee8
	ld	l,(iy+7)	;3ee9
	ld	h,0		;3eec
	push	hl		;3eee
	call	_write		;3eef
	pop	bc		;3ef2
	pop	bc		;3ef3
	pop	bc		;3ef4
	ld	de,1		;3ef5
	or	a		;3ef8
	sbc	hl,de		;3ef9
	jr	nz,l3f05h	;3efb
l3efdh:						; m6:
	ld	l,(ix+6)	;3efd
	ld	h,0		;3f00
	jp	cret		;3f02
l3f05h:						; m7:
	set	5,(iy+6)	;3f05
l3f09h:						; m8:
	ld	hl,-1		;3f09
	jp	cret		;3f0c
l3f0fh:						; m9:
	ld	hl,0200h	;3f0f
	push	hl		;3f12
	ld	l,(iy+4)	;3f13
	ld	h,(iy+5)	;3f16
	push	hl		;3f19
	ld	l,(iy+7)	;3f1a
	ld	h,0		;3f1d
	push	hl		;3f1f
	call	_write		;3f20
	pop	bc		;3f23
	pop	bc		;3f24
	pop	bc		;3f25
	ld	de,0200h	;3f26
	or	a		;3f29
	sbc	hl,de		;3f2a
	jr	z,l3f32h	;3f2c
	set	5,(iy+6)	;3f2e
l3f32h:						; m10:
	ld	(iy+2),0ffh	;3f32
	ld	(iy+3),001h	;3f36
	ld	a,(ix+6)	;3f3a
	ld	l,(iy+4)	;3f3d
	ld	h,(iy+5)	;3f40
	ld	(hl),a		;3f43
	inc	hl		;3f44
	ld	(iy+0),l	;3f45
	ld	(iy+1),h	;3f48
	jr	l3f59h		;3f4b
l3f4dh:						; m11:
	set	5,(iy+6)	;3f4d
	ld	(iy+2),0	;3f51
	ld	(iy+3),0	;3f55
l3f59h:						; m12:
	bit	5,(iy+6)	;3f59
	jr	z,l3efdh	;3f5d
	jr	l3f09h		;3f5f

; =============== F U N C T I O N =======================================
;	Not from library
;
sub_3f61h:						; int sub_3f61h(char * name, char * mode) {
	call	csv		;3f61			; register FILE * stream;
	ld	iy,l63efh	;3f64 __iob		; stream = stdin;
	jr	l3f77h		;3f68			; goto m2;
l3f6ah:							; m1:
	ld	a,(iy+6) ;p1	;3f6a			;
	and	3		;3f6d			;
	or	a		;3f6f			;
	jr	z,l3f82h	;3f70			; if((stream->_flag & 3) == 0) goto m3;
	ld	de,8		;3f72		  	;
	add	iy,de		;3f75		  	; ++stream;
l3f77h:							; m2:
	ld	de,_dnames	;3f77		  	;
	push	iy		;3f7a		  	;
	pop	hl		;3f7c		  	;
	or	a		;3f7d		  	;
	sbc	hl,de		;3f7e		  	;
	jr	nz,l3f6ah	;3f80		  	; if(stream != dnames) goto m1;
l3f82h:							; m3:
	ld	de,_dnames	;3f82		  	;
	push	iy		;3f85		  	;
	pop	hl		;3f87		  	;
	or	a		;3f88		  	;
	sbc	hl,de		;3f89		  	;
	jr	nz,l3f93h	;3f8b		  	; if(stream != dnames) goto m4;
	ld	hl,0		;3f8d		  	;
	jp	cret		;3f90		  	; return 0;
l3f93h:							; m4:
	push	iy		;3f93		  	;
	ld	l,(ix+8)	;3f95		  	;
	ld	h,(ix+9) ; p2	;3f98		  	;
	push	hl		;3f9b		  	;
	ld	l,(ix+6)	;3f9c		  	;
	ld	h,(ix+7) ; p1	;3f9f		  	;
	push	hl		;3fa2		  	;
	call	_freopen	;3fa3		  	; freopen(name, mode, stream);
	pop	bc		;3fa6		  	;
	pop	bc		;3fa7		  	;
	pop	bc		;3fa8		  	;
	jp	cret		;3fa9		  	; return;
							; }
; =============== F U N C T I O N =======================================
;
;	freopen		from library
;
_freopen:
	call	csv		;3fac
	push	hl		;3faf
	ld	l,(ix+00ah)	;3fb0
	ld	h,(ix+00bh)	;3fb3
	push	hl		;3fb6
	pop	iy		;3fb7
	
	push	hl		;3fb9
	call	_fclose		;3fba
	pop	bc		;3fbd
	ld	(ix-1),0	;3fbe

	ld	a,(iy+6)	;3fc2
	and	4		;3fc5
	ld	(iy+6),a	;3fc7

	ld	l,(ix+8)	;3fca
	ld	h,(ix+9)	;3fcd
	ld	a,(hl)		;3fd0
	cp	61h	;'a'	;3fd1
	jr	z,l3fe0h	;3fd3
	cp	72h	;'r'	;3fd5
	jr	z,l3fe3h	;3fd7
	cp	77h	;'w'	;3fd9
	jr	nz,l3ff3h	;3fdb
	inc	(ix-1)		;3fdd
l3fe0h:						; m1:
	inc	(ix-1)		;3fe0
l3fe3h:						; m2:
	ld	l,(ix+8)	;3fe3
	ld	h,(ix+9)	;3fe6
	inc	hl		;3fe9
	ld	a,(hl)		;3fea
	cp	62h	;'b'	;3feb
	jr	nz,l3ff3h	;3fed

	ld	(iy+6),80h	;3fef -128
l3ff3h:						; m3:
	ld	a,(ix-1)	;3ff3
	or	a		;3ff6
	jr	z,l400eh	;3ff7

	cp	1		;3ff9
	jr	z,l4023h	;3ffb
	cp	2		;3ffd
	jr	z,l403bh	;3fff
l4001h:						; m4:
	ld	a,(iy+7)	;4001
	or	a		;4004
	jp	p,l404dh	;4005
l4008h:						; m5:
	ld	hl,0		;4008
	jp	cret		;400b
l400eh:						; m6:
	ld	hl,0		;400e
	push	hl		;4011
	ld	l,(ix+6)	;4012
	ld	h,(ix+7)	;4015
	push	hl		;4018
	call	_open		;4019
	pop	bc		;401c
	pop	bc		;401d
l401eh:						; m7:
	ld	(iy+7),l	;401e
	jr	l4001h		;4021			goto m4;
l4023h:						; m8:
	ld	hl,1		;4023
	push	hl		;4026
	ld	l,(ix+6)	;4027
	ld	h,(ix+7)	;402a
	push	hl		;402d
	call	_open		;402e
	pop	bc		;4031
	pop	bc		;4032
	ld	a,l		;4033
	ld	(iy+7),a	;4034
	or	a		;4037
	jp	p,l4001h	;4038			if() goto m4;
l403bh:						; m9:
	ld	hl,001b6h	;403b 438
	push	hl		;403e
	ld	l,(ix+6)	;403f
	ld	h,(ix+7)	;4042
	push	hl		;4045
	call	_creat		;4046
	pop	bc		;4049
	pop	bc		;404a
	jr	l401eh		;404b			goto m7;
l404dh:						; m10:
	ld	a,(iy+6)	;404d
	and	00ch		;4050
	or	a		;4052
	jr	nz,l405eh	;4053			if() goto m11;

	call	__bufallo	;4055
	ld	(iy+4),l	;4058
	ld	(iy+5),h	;405b
l405eh:						; m11:
	ld	de,-1		;405e
	ld	l,(iy+4)	;4061
	ld	h,(iy+5)	;4064
	or	a		;4067
	sbc	hl,de		;4068
	jr	nz,l4086h	;406a

	ld	(iy+4),0	;406c
	ld	(iy+5),0	;4070
	ld	a,(iy+7)	;4074
	ld	l,a		;4077
	rla			;4078
	sbc	a,a		;4079
	ld	h,a		;407a
	push	hl		;407b
	call	_close		;407c
	pop	bc		;407f
	ld	(iy+6),0	;4080
	jr	l4008h		;4084			goto m5;
l4086h:						; m12:
	ld	l,(iy+4)	;4086
	ld	h,(iy+5)	;4089
	ld	(iy+0),l	;408c
	ld	(iy+1),h	;408f
	ld	(iy+2),0	;4092
	ld	(iy+3),0	;4096
	ld	a,(ix-1)	;409a
	or	a		;409d
	jr	z,l40a6h	;409e

	set	1,(iy+6)	;40a0
	jr	l40aah		;40a4
l40a6h:						; m13:
	set	0,(iy+6)	;40a6
l40aah:						; m14:
	ld	a,(iy+4)	;40aa
	or	(iy+5)		;40ad
	ld	a,(ix-1)	;40b0
	jr	z,l40c3h	;40b3

	or	a		;40b5
	jr	z,l40c0h	;40b6

	ld	(iy+2),0	;40b8
	ld	(iy+3),2	;40bc
l40c0h:						; m15:
	ld	a,(ix-1)	;40c0
l40c3h:						; m16:
	cp	1		;40c3
	jr	nz,l40dbh	;40c5

	ld	hl,2		;40c7
	push	hl		;40ca
	ld	de,0		;40cb
	ld	l,e		;40ce
	ld	h,d		;40cf
	push	hl		;40d0
	push	de		;40d1
	push	iy		;40d2
	call	_fseek		;40d4
	pop	bc		;40d7
	pop	bc		;40d8
	pop	bc		;40d9
	pop	bc		;40da
l40dbh:						; m17:
	push	iy		;40db
	pop	hl		;40dd
	jp	cret		;40de

; =============== F U N C T I O N =======================================
;
;	_ssize	from library
;
__ssize:
	call	ncsv		;40e1
	defw	0ff78h	; ???	;40e4

	ld	l,(ix+6)	;40e6
	ld	h,(ix+7)	;40e9
	push	hl		;40ec
	pop	iy		;40ed
	
	bit	7,(iy+6)	;40ef
	jr	z,l4102h	;40f3

	ld	l,(iy+7)	;40f5
	ld	h,0		;40f8
	push	hl		;40fa
	call	__fsize		;40fb
	pop	bc		;40fe
	jp	cret		;40ff
l4102h:						; m1:
	ld	de,0002ah	;4102
	ld	l,(iy+7)	;4105
	ld	h,0		;4108
	call	lmul		;410a
	ld	de,__fcb	;410d
	add	hl,de		;4110
	ld	(ix-8),l	;4111
	ld	(ix-7),h	;4114
	ld	a,(iy+6)	;4117
	ld	(ix-2),a	;411a
	bit	1,a		;411d
	jr	z,l4127h	;411f

	push	iy		;4121
	call	_fflush	;4123
	pop	bc		;4126
l4127h:						; m2:
	ld	e,(ix-8)	;4127
	ld	d,(ix-7)	;412a
	ld	hl,00028h	;412d
	add	hl,de		;4130
	ld	l,(hl)		;4131
	ld	(ix-1),l	;4132
	ld	hl,00028h	;4135
	add	hl,de		;4138
	ld	(hl),1		;4139
	set	0,(iy+6)	;413b
	ld	a,(iy+6)	;413f
	and	0fdh		;4142
	ld	(iy+6),a	;4144

	ld	hl,2		;4147
	push	hl		;414a
	ld	de,0ff80h	;414b
	ld	hl,-1		;414e
	push	hl		;4151
	push	de		;4152
	ld	l,(iy+7)	;4153
	ld	h,0		;4156
	push	hl		;4158
	call	_lseek		;4159
	pop	bc		;415c
	pop	bc		;415d
	pop	bc		;415e
	pop	bc		;415f
	ld	(iy+2),0	;4160
	ld	(iy+3),0	;4164

	push	iy		;4168
	ld	hl,00080h	;416a
	push	hl		;416d
	ld	hl,1		;416e
	push	hl		;4171
	push	ix		;4172
	pop	de		;4174
	ld	hl,0ff78h	;4175
	add	hl,de		;4178
	push	hl		;4179
	call	sub_43a4h	;417a
	pop	bc		;417d
	pop	bc		;417e
	pop	bc		;417f
	pop	bc		;4180
	push	iy		;4181
	call	_ftell	;4183
	pop	bc		;4186
	ld	(ix-6),e	;4187
	ld	(ix-5),d	;418a
	ld	(ix-4),l	;418d
	ld	(ix-3),h	;4190

	ld	a,(ix-1)	;4193
	ld	e,(ix-8)	;4196
	ld	d,(ix-7)	;4199
	ld	hl,00028h	;419c
	add	hl,de		;419f
	ld	(hl),a		;41a0
	ld	a,(ix-2)	;41a1
	ld	(iy+6),a	;41a4
	bit	1,(iy+6)	;41a7
	jr	z,l41c1h	;41ab
	
	ld	(iy+2),0	;41ad
	ld	(iy+3),2	;41b1
	ld	l,(iy+4)	;41b5
	ld	h,(iy+5)	;41b8
	ld	(iy+0),l	;41bb
	ld	(iy+1),h	;41be
l41c1h:						; m3:
	ld	e,(ix-6)	;41c1
	ld	d,(ix-5)	;41c4
	ld	l,(ix-4)	;41c7
	ld	h,(ix-3)	;41ca
	jp	cret		;41cd

; =============== F U N C T I O N =======================================
;
;	fseek	from library
;
_fseek:
	call	csv		;41d0
	push	hl		;41d3
	push	hl		;41d4
	ld	l,(ix+6)	;41d5
	ld	h,(ix+7)	;41d8
	push	hl		;41db
	pop	iy		;41dc
	ld	a,(iy+6)	;41de
	and	0efh		;41e1 239
	ld	(iy+6),a	;41e3
	ld	a,(iy+4)	;41e6
	or	(iy+5)		;41e9
	jr	nz,l4222h	;41ec

	ld	de,-1		;41ee
	ld	l,e		;41f1
	ld	h,d		;41f2
	push	hl		;41f3
	push	de		;41f4
	ld	l,(ix+00ch)	;41f5
	ld	h,(ix+00dh)	;41f8
	push	hl		;41fb
	ld	e,(ix+8)	;41fc
	ld	d,(ix+9)	;41ff
	ld	l,(ix+00ah)	;4202
	ld	h,(ix+00bh)	;4205
	push	hl		;4208
	push	de		;4209
	ld	l,(iy+7)	;420a
	ld	h,0		;420d
	push	hl		;420f
	call	_lseek		;4210
	pop	bc		;4213
	pop	bc		;4214
	pop	bc		;4215
	pop	bc		;4216
	call	arelop		;4217
	jr	nz,l4281h	;421a
l421ch:						; m1:
	ld	hl,-1		;421c
	jp	cret		;421f
l4222h:						; m2:
	bit	1,(iy+6)	;4222
	jr	z,l422eh	;4226

	push	iy		;4228
	call	_fflush	;422a
	pop	bc		;422d
l422eh:						; m3:
	ld	l,(ix+00ch)	;422e
	ld	h,(ix+00dh)	;4231
	ld	a,h		;4234
	or	a		;4235
	jr	nz,l421ch	;4236

	ld	a,l		;4238
	or	a		;4239
	jr	z,l4258h	;423a

	cp	1		;423c
	jr	z,l4246h	;423e
	cp	2		;4240
	jr	z,l4287h	;4242
	jr	l421ch		;4244
l4246h:						; m4:
	push	iy		;4246
	call	_ftell		;4248
	pop	bc		;424b
	push	hl		;424c
	push	de		;424d
	push	ix		;424e
	pop	de		;4250
	ld	hl,8		;4251
	add	hl,de		;4254
	call	aslladd		;4255
l4258h:						; m5:
	push	iy																									;4258
	call	_ftell		;425a
	pop	bc		;425d
	push	hl		;425e
	push	de		;425f
	ld	e,(ix+8)	;4260
	ld	d,(ix+9)	;4263
	ld	l,(ix+00ah)	;4266
	ld	h,(ix+00bh)	;4269
	call	alsub		;426c
	ld	(ix-4),e	;426f
	ld	(ix-3),d	;4272
	ld	(ix-2),l	;4275
	ld	(ix-1),h	;4278
	ld	a,e		;427b
	or	d		;427c
	or	l		;427d
	or	h		;427e
	jr	nz,l429bh	;427f
l4281h:						; m6:
	ld	hl,0		;4281
	jp	cret		;4284
l4287h:						; m7:
	push	iy		;4287
	call	__ssize		;4289
	pop	bc		;428c
	push	hl		;428d
	push	de		;428e
	push	ix		;428f
	pop	de		;4291
	ld	hl,8		;4292
	add	hl,de		;4295
	call	aslladd		;4296
	jr	l4258h		;4299
l429bh:						; m8:
	bit	0,(iy+6)	;429b
	jr	z,l42f2h	;429f

	bit	7,(ix-1)	;42a1
	jr	nz,l42eah	;42a5

	ld	e,(ix-4)	;42a7
	ld	d,(ix-3)	;42aa
	ld	l,(ix-2)	;42ad
	ld	h,(ix-1)	;42b0
	push	hl		;42b3
	push	de		;42b4
	ld	e,(iy+2)	;42b5
	ld	d,(iy+3)	;42b8
	ld	a,d		;42bb
	rla			;42bc
	sbc	a,a		;42bd
	ld	l,a		;42be
	ld	h,a		;42bf
	call	arelop		;42c0
	jp	m,l42eah	;42c3

	ld	e,(ix-4)	;42c6
	ld	d,(ix-3)	;42c9
	ld	l,(iy+2)	;42cc
	ld	h,(iy+3)	;42cf
	or	a		;42d2
	sbc	hl,de		;42d3
	ld	(iy+2),l	;42d5
	ld	(iy+3),h	;42d8
	ld	l,(iy+0)	;42db
	ld	h,(iy+1)	;42de
	add	hl,de		;42e1
	ld	(iy+0),l	;42e2
	ld	(iy+1),h	;42e5
	jr	l4281h		;42e8
l42eah:						; m9:
	ld	(iy+2),0	;42ea
	ld	(iy+3),0	;42ee
l42f2h:						; m10:
	ld	de,-1		;42f2
	ld	l,e		;42f5
	ld	h,d		;42f6
	push	hl		;42f7
	push	de		;42f8
	ld	hl,0		;42f9
	push	hl		;42fc
	ld	e,(ix+8)	;42fd
	ld	d,(ix+9)	;4300
	ld	l,(ix+00ah)	;4303
	ld	h,(ix+00bh)	;4306
	push	hl		;4309
	push	de		;430a
	ld	a,(iy+7)	;430b
	ld	l,a		;430e
	rla			;430f
	sbc	a,a		;4310
	ld	h,a		;4311
	push	hl		;4312
	call	_lseek		;4313
	pop	bc		;4316
	pop	bc		;4317
	pop	bc		;4318
	pop	bc		;4319
	call	lrelop		;431a
	jp	nz,l4281h	;431d
	jp	l421ch		;4320

; =============== F U N C T I O N =======================================
;
;	ftell	from library
;
_ftell:
	call	csv		;4323
	push	hl		;4326
	push	hl		;4327
	ld	l,(ix+6)	;4328
	ld	h,(ix+7)	;432b
	push	hl		;432e
	pop	iy		;432f
	ld	hl,1		;4331
	push	hl		;4334
	ld	de,0		;4335
	ld	l,e		;4338
	ld	h,d		;4339
	push	hl		;433a
	push	de		;433b
	ld	a,(iy+7)	;433c
	ld	l,a		;433f
	rla			;4340
	sbc	a,a		;4341
	ld	h,a		;4342
	push	hl		;4343
	call	_lseek		;4344
	pop	bc		;4347
	pop	bc		;4348
	pop	bc		;4349
	pop	bc		;434a
	ld	(ix-4),e	;434b
	ld	(ix-3),d	;434e
	ld	(ix-2),l	;4351
	ld	(ix-1),h	;4354
	bit	7,(iy+3)	;4357
	jr	z,l4365h	;435b

	ld	(iy+2),0	;435d
	ld	(iy+3),0	;4361
l4365h:						; m1:
	ld	a,(iy+4)	;4365
	or	(iy+5)		;4368
	jr	z,l4385h	;436b

	bit	1,(iy+6)	;436d
	jr	z,l4385h	;4371

	ld	de,512		;4373
	ld	hl,0		;4376
	push	hl		;4379
	push	de		;437a
	push	ix		;437b
	pop	hl		;437d
	dec	hl		;437e
	dec	hl		;437f
	dec	hl		;4380
	dec	hl		;4381
	call	aslladd		;4382
l4385h:						; m2:
	ld	e,(iy+2)	;4385
	ld	d,(iy+3)	;4388
	ld	a,d		;438b
	rla			;438c
	sbc	a,a		;438d
	ld	l,a		;438e
	ld	h,a		;438f
	push	hl		;4390
	push	de		;4391
	ld	e,(ix-4)	;4392
	ld	d,(ix-3)	;4395
	ld	l,(ix-2)	;4398
	ld	h,(ix-1)	;439b
	call	llsub		;439e
	jp	cret		;43a1

; =============== F U N C T I O N =======================================
;	From library?
;		read1
;
sub_43a4h:						; sub_43a4h(char * buf, p2, count, register FILE * st) {
	call	ncsv		;43a4			; char * l1;
	defw	0fffah	;-6	;43a7			; int    l2;
	ld	l,(ix+00ch)	;43a9			; int    l3;
	ld	h,(ix+00dh) ;p4	;43ac	; st		;			
	push	hl		;43af			;
	pop	iy		;43b0			;

	ld	e,(ix+00ah)	;43b2			;
	ld	d,(ix+00bh) ;p3	;43b5	; count		;
	ld	l,(ix+8)	;43b8			;
	ld	h,(ix+9) ;p2	;43bb	; p2		;
	call	lmul		;43be			;
	ld	(ix-4),l	;43c1			;
	ld	(ix-3),h ;l2	;43c4	; l2		; l2 = p2*count;

	ld	l,(ix+6) ;p1	;43c7	; buf		;
	ld	h,(ix+7)	;43ca			;
	ld	(ix-2),l	;43cd			;
	ld	(ix-1),h ;l1	;43d0	; l1		; l1 = buf;
	jr	l4408h		;43d3			; goto m2;
l43d5h:							; m1:
	push	iy		;43d5			;
	call	sub_4437h	;43d7	; fgetc		;
	pop	bc		;43da			;
	ld	(ix-6),l	;43db			;
	ld	(ix-5),h ;l3	;43de	; l3		; l3 = sub_4437h(st);
	ld	de,-1		;43e1			;
	or	a		;43e4			;
	sbc	hl,de		;43e5			;
	jr	z,l4410h	;43e7			; if(l3 == -1) goto m3;

	ld	l,(ix-4)	;43e9			;
	ld	h,(ix-3) ;l2	;43ec	; l2		;
	add	hl,de		;43ef			;
	ld	(ix-4),l	;43f0			;
	ld	(ix-3),h ;l2	;43f3	; l2		; --l2;

	ld	a,(ix-6)	;43f6			;
	
	ld	l,(ix-2)	;43f9			;
	ld	h,(ix-1) ;l1	;43fc	; l1		;
	inc	hl		;43ff			;
	ld	(ix-2),l	;4400			;
	ld	(ix-1),h ;l1	;4403	; l1		;
	dec	hl		;4406			;
	ld	(hl),a		;4407			; *l1++ = *p1;
l4408h:							; m2:
	ld	a,(ix-4)	;4408
	or	(ix-3)	 ;l2	;440b	; l2		;
	jr	nz,l43d5h	;440e			; if(l2 != 0) goto m1;
l4410h:							; m3:
	ld	e,(ix+8)	;4410			;
	ld	d,(ix+9) ;p2	;4413	; p2		;
	ld	l,(ix-4)	;4416			;
	ld	h,(ix-3) ;l2	;4419	; l2		;
	add	hl,de		;441c			;
	ld	de,-1		;441d			;
	add	hl,de		;4420 hl = l2+p2 -1	;
	ld	e,(ix+8)	;4421			;
	ld	d,(ix+9) ;p2	;4424 de=p2		;
	call	ldiv		;4427 hl=(l2+p2 -1)/p2	;
	ex	de,hl		;442a de=(l2+p2 -1)/p2	;
	ld	l,(ix+00ah)	;442b			;
	ld	h,(ix+00bh) ;p3	;442e	; count		;
	or	a		;4431			;
	sbc	hl,de		;4432			;
	jp	cret		;4434			; return count - (l2+p2 -1)/p2;

; =============== F U N C T I O N =======================================
;
;	fgetc(f) From library
;
sub_4437h:
	pop	de		;4437
	ex	(sp),iy		;4438
	ld	a,(iy+6)	;443a
	bit	0,a		;443d
	jr	z,l449bh	;443f

	bit	4,a		;4441
	jr	nz,l449bh	;4443
l4445h:						; m1:
	ld	l,(iy+2)	;4445
	ld	h,(iy+3)	;4448
	ld	a,l		;444b
	or	h		;444c
	jr	z,l44a6h	;444d

	dec	hl		;444f
	ld	(iy+2),l	;4450
	ld	(iy+3),h	;4453
	ld	l,(iy+0)	;4456
	ld	h,(iy+1)	;4459
	ld	a,(hl)		;445c
	inc	hl		;445d
	ld	(iy+0),l	;445e
	ld	(iy+1),h	;4461
l4464h:						; m2:
	bit	7,(iy+6)	;4464
	jr	z,l4471h	;4468
l446ah:						; m3:
	ld	l,a		;446a
	ld	h,0		;446b
	ex	(sp),iy		;446d
	push	de		;446f
	ret			;4470
l4471h:						; m4:
	cp	00dh		;4471
	jr	z,l4445h	;4473

	cp	01ah		;4475
	jr	nz,l446ah	;4477

	ld	a,(iy+4)	;4479
	or	(iy+5)		;447c
	jr	z,l449bh	;447f

	ld	l,(iy+2)	;4481
	ld	h,(iy+3)	;4484
	inc	hl		;4487
	ld	(iy+2),l	;4488
	ld	(iy+3),h	;448b
	ld	l,(iy+0)	;448e
	ld	h,(iy+1)	;4491
	dec	hl		;4494
	ld	(iy+0),l	;4495
	ld	(iy+1),h	;4498
l449bh:						; m5:
	set	4,(iy+6)	;449b
	ld	hl,-1		;449f
	ex	(sp),iy		;44a2
	push	de		;44a4
	ret			;44a5
l44a6h:						; m6:
	bit	6,(iy+6)	;44a6
	jr	nz,l449bh	;44aa
	push	de		;44ac
	push	iy		;44ad
	call	sub_44bbh	;44af _filbuf
	ld	a,l		;44b2
	pop	bc		;44b3
	pop	de		;44b4
	bit	7,h		;44b5
	jr	nz,l449bh	;44b7
	jr	l4464h		;44b9

; =============== F U N C T I O N =======================================
;
;	_filbuf 	from library
;
sub_44bbh:
	call	csv		;44bb
	push	hl		;44be
	ld	l,(ix+6)	;44bf
	ld	h,(ix+7)	;44c2
	push	hl		;44c5
	pop	iy		;44c6

	ld	(iy+2),0	;44c8
	ld	(iy+3),0	;44cc
	bit	0,(iy+6)	;44d0
	jr	nz,l44dch	;44d4
l44d6h:						; m1:
	ld	hl,-1		;44d6
	jp	cret		;44d9
l44dch:						; m2:
	ld	a,(iy+4)	;44dc
	or	(iy+5)		;44df
	jr	nz,l4511h	;44e2

	ld	(iy+2),0	;44e4
	ld	(iy+3),0	;44e8
	ld	hl,1		;44ec
	push	hl		;44ef
	push	ix		;44f0
	pop	hl		;44f2
	dec	hl		;44f3
	push	hl		;44f4
	ld	l,(iy+7)	;44f5
	ld	h,0		;44f8
	push	hl		;44fa
	call	_read		;44fb
	pop	bc		;44fe
	pop	bc		;44ff
	pop	bc		;4500
	ld	de,1		;4501
	or	a		;4504
	sbc	hl,de		;4505
	jr	nz,l4540h	;4507
	ld	l,(ix-1)	;4509
l450ch:						; m3:
	ld	h,0		;450c
	jp	cret		;450e
l4511h:						; m4:
	ld	hl,0200h	;4511
	push	hl		;4514
	ld	l,(iy+4)	;4515
	ld	h,(iy+5)	;4518
	push	hl		;451b
	ld	l,(iy+7)	;451c
	ld	h,0		;451f
	push	hl		;4521
	call	_read		;4522
	pop	bc		;4525
	pop	bc		;4526
	pop	bc		;4527
	ex	de,hl		;4528
	ld	(iy+2),e	;4529
	ld	(iy+3),d	;452c
	ld	hl,0		;452f
	call	wrelop		;4532
	jp	m,l454ch	;4535
	
	ld	a,(iy+2)	;4538
	or	(iy+3)		;453b
	jr	nz,l4546h	;453e
l4540h:						; m5:
	set	4,(iy+6)	;4540
	jr	l44d6h		;4544
l4546h:						; m6:
	set	5,(iy+6)	;4546
	jr	l44d6h		;454a
l454ch:						; m7:
	ld	l,(iy+4)	;454c
	ld	h,(iy+5)	;454f
	ld	(iy+0),l	;4552
	ld	(iy+1),h	;4555
	ld	l,(iy+2)	;4558
	ld	h,(iy+3)	;455b
	dec	hl		;455e
	ld	(iy+2),l	;455f
	ld	(iy+3),h	;4562
	ld	l,(iy+0)	;4565
	ld	h,(iy+1)	;4568
	inc	hl		;456b
	ld	(iy+0),l	;456c
	ld	(iy+1),h	;456f
	dec	hl		;4572
	ld	l,(hl)		;4573
	jr	l450ch		;4574

; =============== F U N C T I O N =======================================
;	From library?
;							; void sub_4576h() {
cpm_clean:
sub_4576h:						;     char l1;
	call	csv		;4576			;     register FILE * st; 
	push	hl		;4579			;
	ld	(ix-1),8	;457a			;     l1 = 8;
	ld	iy,l63efh	;457e  __iob		;     st = stdin;
l4582h:						        ;     do { 
	push	iy		;4582			;
	call	_fclose		;4584			;         fclose(st)
	pop	bc		;4587			;
	ld	de,8		;4588			;
	add	iy,de		;458b			;         st += sizeof(stdin); /* 8 */
	ld	a,(ix-1)	;458d			;
	add	a,0ffh		;4590			;
	ld	(ix-1),a	;4592			;
	or	a		;4595			;
	jr	nz,l4582h	;4596			;     } while (--l1 != 0);
	jp	cret		;4598			;     return;
	
; End sub_4576h						; }

; =============== F U N C T I O N =======================================
;
;	fclose		From library
_fclose:
	call	csv		;459b
	ld	l,(ix+6)	;459e
	ld	h,(ix+7)	;45a1
	push	hl		;45a4
	pop	iy		;45a5
	ld	a,(iy+6)	;45a7
	and	3		;45aa
	or	a		;45ac
	jr	nz,l45b5h	;45ad
l45afh:						; m1:
	ld	hl,-1		;45af
	jp	cret		;45b2
l45b5h:						; m2:
	push	iy		;45b5
	call	_fflush		;45b7
	pop	bc		;45ba
	ld	a,(iy+6)	;45bb
	and	0f8h		;45be 248
	ld	(iy+6),a	;45c0
	ld	a,(iy+4)	;45c3
	or	(iy+5)		;45c6
	jr	z,l45e4h	;45c9

	bit	3,(iy+6)	;45cb
	jr	nz,l45e4h	;45cf
	ld	l,(iy+4)	;45d1
	ld	h,(iy+5)	;45d4
	push	hl		;45d7
	call	__buffree	;45d8
	pop	bc		;45db
	ld	(iy+4),0	;45dc
	ld	(iy+5),0	;45e0
l45e4h:						; m3:
	ld	l,(iy+7)	;45e4
	ld	h,0		;45e7
	push	hl		;45e9
	call	_close		;45ea
	pop	bc		;45ed
	ld	de,-1		;45ee
	or	a		;45f1
	sbc	hl,de		;45f2
	jr	z,l45afh	;45f4
	bit	5,(iy+6)	;45f6
	jr	nz,l45afh	;45fa

	ld	hl,0		;45fc
	jp	cret		;45ff

; =============== F U N C T I O N =======================================
;
;	fflush		From library
_fflush:
	call	csv		;4602
	push	hl		;4605
	ld	l,(ix+6)	;4606
	ld	h,(ix+7)	;4609
	push	hl		;460c
	pop	iy		;460d

	bit	1,(iy+6)	;460f
	jr	z,l4633h	;4613

	ld	a,(iy+4)	;4615
	or	(iy+5)		;4618
	jr	z,l4633h	;461b

	ld	e,(iy+2)	;461d
	ld	d,(iy+3)	;4620
	ld	hl,0200h	;4623
	or	a		;4626
	sbc	hl,de		;4627
	ld	(ix-2),l	;4629
	ld	(ix-1),h	;462c
	ld	a,l		;462f
	or	h		;4630
	jr	nz,l4639h	;4631
l4633h:						; m1:
	ld	hl,0		;4633
	jp	cret		;4636
l4639h:						; m2:
	ld	l,(ix-2)	;4639
	ld	h,(ix-1)	;463c
	push	hl		;463f
	ld	l,(iy+4)	;4640
	ld	h,(iy+5)	;4643
	push	hl		;4646
	ld	l,(iy+7)	;4647
	ld	h,0		;464a
	push	hl		;464c
	call	_write		;464d
	pop	bc		;4650
	pop	bc		;4651
	pop	bc		;4652
	ld	e,(ix-2)	;4653
	ld	d,(ix-1)	;4656
	or	a		;4659
	sbc	hl,de		;465a
	jr	z,l4662h	;465c

	set	5,(iy+6)	;465e
l4662h:						; m3:
	ld	(iy+2),0	;4662
	ld	(iy+3),2	;4666

	ld	l,(iy+4)	;466a
	ld	h,(iy+5)	;466d
	ld	(iy+0),l	;4670
	ld	(iy+1),h	;4673

	bit	5,(iy+6)	;4676
	jr	z,l4633h	;467a

	ld	hl,-1		;467c
	jp	cret		;467f

; =============== F U N C T I O N =======================================
;	From library?
;
__bufallo:
	call	csv		;4682
	ld	iy,(0ab0ah)	;4685
	push	iy		;4689
	pop	hl		;468b
	ld	a,l		;468c
	or	h		;468d
	jr	z,l469bh	;468e

	ld	l,(iy+0)	;4690
	ld	h,(iy+1)	;4693
	ld	(0ab0ah),hl	;4696
	jr	l46a6h		;4699
l469bh:						; m1:
	ld	hl,0200h	;469b
	push	hl		;469e
	call	sbrk		;469f
	pop	bc		;46a2
	push	hl		;46a3
	pop	iy		;46a4
l46a6h:						; m2:
	push	iy		;46a6
	pop	hl		;46a8
	jp	cret		;46a9

; =============== F U N C T I O N =======================================
;	From library?
;
__buffree:
	call	csv		;46ac
	ld	l,(ix+6)	;46af
	ld	h,(ix+7)	;46b2
	push	hl		;46b5
	pop	iy		;46b6

	ld	hl,(0ab0ah)	;46b8
	ld	(iy+0),l	;46bb
	ld	(iy+1),h	;46be
	ld	(0ab0ah),iy	;46c1
	jp	cret		;46c5

; =============== F U N C T I O N =======================================
;	From library?
;
exit:
	call	csv		;46c8
	call	sub_4576h	;46cb
	ld	l,(ix+6)	;46ce
	ld	h,(ix+7)	;46d1
	push	hl		;46d4
	call	__exit		;46d5
	jp	cret		;46d8

; =============== F U N C T I O N =======================================
;	From library
;
startup:
	jp	__getargs	;46db

; =============== F U N C T I O N =======================================
;	From library
;
_open:
	call	csv		;46de
	push	hl		;46e1
	ld	e,(ix+8)	;46e2
	ld	d,(ix+9)	;46e5
	inc	de		;46e8
	ld	(ix+8),e	;46e9
	ld	(ix+9),d	;46ec
	ld	hl,00003h	;46ef
	call	wrelop		;46f2
	jp	p,l4700h	;46f5

	ld	(ix+8),3	;46f8
	ld	(ix+9),0	;46fc
l4700h:						; m1:
	call	_getfcb		;4700
	push	hl		;4703
	pop	iy		;4704
	ld	a,l		;4706
	or	h		;4707
	jr	nz,l4710h	;4708
l470ah:						; m2:
	ld	hl,-1		;470a
	jp	cret		;470d
l4710h:						; m3:
	ld	l,(ix+6)	;4710
	ld	h,(ix+7)	;4713
	push	hl		;4716
	push	iy		;4717
	call	_setfcb		;4719
	pop	bc		;471c
	pop	bc		;471d
	ld	a,l		;471e
	or	a		;471f
	jr	nz,l478ah	;4720

	ld	de,1		;4722
	ld	l,(ix+8)	;4725
	ld	h,(ix+9)	;4728
	or	a		;472b
	sbc	hl,de		;472c
	jr	nz,l4749h	;472e

	ld	hl,0000ch	;4730
	push	hl		;4733
	call	bdos		;4734
	pop	bc		;4737
	ld	a,l		;4738
	ld	b,030h		;4739
	call	brelop		;473b
	jp	m,l4749h	;473e

	ld	a,(iy+6)	;4741
	or	080h		;4744
	ld	(iy+6),a	;4746
l4749h:						; m4:
	call	_getuid		;4749
	ld	(ix-1),l	;474c
	ld	l,(iy+029h)	;474f
	ld	h,0		;4752
	push	hl		;4754
	call	_setuid		;4755
	pop	bc		;4758
	push	iy		;4759
	ld	hl,0fh		;475b
	push	hl		;475e
	call	bdos		;475f
	pop	bc		;4762
	pop	bc		;4763
	ld	a,l		;4764
	cp	0ffh		;4765
	jr	nz,l477ah	;4767

	push	iy		;4769
	call	_putfcb		;476b
	ld	l,(ix-1)	;476e
	ld	h,0		;4771
	ex	(sp),hl		;4773
	call	_setuid		;4774
	pop	bc		;4777
	jr	l470ah		;4778
l477ah:						; m5:
	ld	l,(ix-1)	;477a
	ld	h,0		;477d
	push	hl		;477f
	call	_setuid		;4780
	pop	bc		;4783
	ld	a,(ix+8)	;4784
	ld	(iy+028h),a	;4787
l478ah:						; m6:
	ld	de,__fcb	;478a
	push	iy		;478d
	pop	hl		;478f
	or	a		;4790
	sbc	hl,de		;4791
	ld	de,0002ah	;4793
	call	adiv		;4796
	jp	cret		;4799

; =============== F U N C T I O N =======================================
;	From library
;
_read:
	call	ncsv		;479c
	defw	0ff79h	; ???	;479f

	ld	(ix-5),0	;47a1
	ld	(ix-4),0	;47a5
	ld	b,8		;47a9
	ld	a,(ix+6)	;47ab
	call	brelop		;47ae
	jr	c,l47b9h	;47b1
l47b3h:						; m1:
	ld	hl,-1		;47b3
	jp	cret		;47b6
l47b9h:						; m2:
	ld	de,0002ah	;47b9
	ld	l,(ix+6)	;47bc
	ld	h,0		;47bf
	call	lmul		;47c1
	ld	de,__fcb	;47c4
	add	hl,de		;47c7
	push	hl		;47c8
	pop	iy		;47c9
	ld	a,(iy+028h)	;47cb
	cp	1		;47ce
	jp	z,l48d4h	;47d0
	cp	3		;47d3
	jp	z,l48d4h	;47d5
	cp	4		;47d8
	jr	z,l4833h	;47da
	cp	5		;47dc
	jr	nz,l47b3h	;47de
	ld	l,(ix+00ah)	;47e0
	ld	h,(ix+00bh)	;47e3
	ld	(ix-5),l	;47e6
	ld	(ix-4),h	;47e9
l47ech:						; m3:
	ld	a,(ix+00ah)	;47ec
	or	(ix+00bh)	;47ef
	jr	nz,l4806h	;47f2
l47f4h:						; m4:
	ld	e,(ix+00ah)	;47f4
	ld	d,(ix+00bh)	;47f7
	ld	l,(ix-5)	;47fa
	ld	h,(ix-4)	;47fd
	or	a		;4800
	sbc	hl,de		;4801
	jp	cret		;4803
l4806h:						; m5:
	ld	l,(ix+00ah)	;4806
	ld	h,(ix+00bh)	;4809
	dec	hl		;480c
	ld	(ix+00ah),l	;480d
	ld	(ix+00bh),h	;4810
	ld	hl,3		;4813
	push	hl		;4816
	call	bdos		;4817
	pop	bc		;481a
	ld	a,l		;481b
	and	07fh		;481c
	ld	l,(ix+8)	;481e
	ld	h,(ix+9)	;4821
	inc	hl		;4824
	ld	(ix+8),l	;4825
	ld	(ix+9),h	;4828
	dec	hl		;482b
	ld	(hl),a		;482c
	cp	00ah		;482d
	jr	nz,l47ech	;482f
	jr	l47f4h		;4831
l4833h:						; m6:
	ld	e,(ix+00ah)	;4833
	ld	d,(ix+00bh)	;4836
	ld	hl,00080h	;4839
	call	wrelop		;483c
	jr	nc,l4849h	;483f

	ld	(ix+00ah),080h	;4841
	ld	(ix+00bh),0	;4845
l4849h:						; m71:
	ld	a,(ix+00ah)	;4849
	push	ix		;484c
	pop	de		;484e
	ld	hl,0ff79h	;484f
	add	hl,de		;4852
	ld	(hl),a		;4853
	push	ix		;4854
	pop	de		;4856
	ld	hl,0ff79h	;4857
	add	hl,de		;485a
	push	hl		;485b
	ld	hl,0000ah	;485c
	push	hl		;485f
	call	bdos		;4860
	pop	bc		;4863
	pop	bc		;4864
	push	ix		;4865
	pop	de		;4867
	ld	hl,0ff7ah	;4868
	add	hl,de		;486b
	ld	l,(hl)		;486c
	ld	h,0		;486d
	ld	(ix-5),l	;486f
	ld	(ix-4),h	;4872
	ld	e,(ix+00ah)	;4875
	ld	d,(ix+00bh)	;4878
	ld	h,(ix-4)	;487b
	call	wrelop		;487e
	jr	nc,l48afh	;4881

	ld	hl,0000ah	;4883
	push	hl		;4886
	ld	hl,00002h	;4887
	push	hl		;488a
	call	bdos		;488b
	pop	bc		;488e
	pop	bc		;488f
	push	ix		;4890
	pop	de		;4892
	ld	l,(ix-5)	;4893
	ld	h,(ix-4)	;4896
	inc	hl		;4899
	inc	hl		;489a
	add	hl,de		;489b
	ld	de,0ff79h	;489c
	add	hl,de		;489f
	ld	(hl),00ah	;48a0
	ld	l,(ix-5)	;48a2
	ld	h,(ix-4)	;48a5
	inc	hl		;48a8
	ld	(ix-5),l	;48a9
	ld	(ix-4),h	;48ac
l48afh:						; m8:
	ld	l,(ix-5)	;48af
	ld	h,(ix-4)	;48b2
	push	hl		;48b5
	ld	l,(ix+8)	;48b6
	ld	h,(ix+9)	;48b9
	push	hl		;48bc
	push	ix		;48bd
	pop	de		;48bf
	ld	hl,0ff7bh	;48c0
	add	hl,de		;48c3
	push	hl		;48c4
	call	movmem		;48c5
	pop	bc		;48c8
	pop	bc		;48c9
	pop	bc		;48ca
	ld	l,(ix-5)	;48cb
	ld	h,(ix-4)	;48ce
	jp	cret		;48d1
l48d4h:						; m9:
	call	_getuid		;48d4
	ld	e,l		;48d7
	ld	(ix-3),e	;48d8
	ld	l,(ix+00ah)	;48db
	ld	h,(ix+00bh)	;48de
	ld	(ix-5),l	;48e1
	ld	(ix-4),h	;48e4
	jp	l49eeh		;48e7
l48eah:						; m10:
	call	__sigchk	;48ea
	ld	l,(iy+029h)	;48ed
	ld	h,0		;48f0
	push	hl		;48f2
	call	_setuid		;48f3
	pop	bc		;48f6
	ld	a,(iy+024h)	;48f7
	and	07fh		;48fa
	ld	(ix-2),a	;48fc
	ld	e,a		;48ff
	ld	d,0		;4900
	ld	hl,00080h	;4902
	or	a		;4905
	sbc	hl,de		;4906
	ld	(ix-1),l	;4908
	ld	e,l		;490b
	ld	l,(ix+00ah)	;490c
	ld	h,(ix+00bh)	;490f
	call	wrelop		;4912
	jr	nc,l491dh	;4915
	ld	a,(ix+00ah)	;4917
	ld	(ix-1),a	;491a
l491dh:						; m11:
	ld	de,00080h	;491d
	ld	hl,0		;4920
	push	hl		;4923
	push	de		;4924
	ld	e,(iy+024h)	;4925
	ld	d,(iy+025h)	;4928
	ld	l,(iy+026h)	;492b
	ld	h,(iy+027h)	;492e
	call	aldiv		;4931
	push	hl		;4934
	push	de		;4935
	push	iy		;4936
	pop	de		;4938
	ld	hl,00021h	;4939
	add	hl,de		;493c
	push	hl		;493d
	call	__putrno	;493e
	pop	bc		;4941
	pop	bc		;4942
	pop	bc		;4943
	ld	a,(ix-1)	;4944
	cp	80h		;4947
	jr	nz,l496dh	;4949
	ld	l,(ix+8)	;494b
	ld	h,(ix+9)	;494e
	push	hl		;4951
	ld	hl,0001ah	;4952
	push	hl		;4955
	call	bdos		;4956
	pop	bc		;4959
	pop	bc		;495a
	push	iy		;495b
	ld	hl,00021h	;495d
	push	hl		;4961
	pop	bc		;4960
	call	bdos		;4964
	pop	bc		;4965
	ld	a,l		;4966
	or	a		;4967
	jr	z,l49aeh	;4968
	jp	l49f7h		;496a
l496dh:						; m12:
	push	ix		;496d
	pop	de		;496f
	ld	hl,0ff79h	;4970
	add	hl,de		;4973
	push	hl		;4974
	ld	hl,0001ah	;4975
	push	hl		;4978
	call	bdos		;4979
	pop	bc		;497c
	pop	bc		;497d
	push	iy		;497e
	ld	hl,00021h	;4980
	push	hl		;4983
	call	bdos		;4984
	pop	bc		;4987
	pop	bc		;4988
	ld	a,l		;4989
	or	a		;498a
	jr	nz,l49f7h	;498b
	ld	l,(ix-1)	;498d
	ld	h,0		;4990
	push	hl		;4992
	ld	l,(ix+8)	;4993
	ld	h,(ix+9)	;4996
	push	hl		;4999
	push	ix		;499a
	pop	de		;499c
	ld	l,(ix-2)	;499d
	ld	h,0		;49a0
	add	hl,de		;49a2
	ld	de,0ff79h	;49a3
	add	hl,de		;49a6
	push	hl		;49a7
	call	movmem		;49a8
	pop	bc		;49ab
	pop	bc		;49ac
	pop	bc		;49ad
l49aeh:						; m13:
	ld	e,(ix-1)	;49ae
	ld	d,0		;49b1
	ld	l,(ix+8)	;49b3
	ld	h,(ix+9)	;49b6
	add	hl,de		;49b9
	ld	(ix+8),l	;49ba
	ld	(ix+9),h	;49bd
	ld	a,e		;49c0
	ld	hl,0		;49c1
	ld	d,l		;49c4
	push	hl		;49c5
	push	de		;49c6
	push	iy		;49c7
	pop	de		;49c9
	ld	hl,00024h	;49ca
	add	hl,de		;49cd
	call	aslladd		;49ce
	ld	e,(ix-1)	;49d1
	ld	d,0		;49d4
	ld	l,(ix+00ah)	;49d6
	ld	h,(ix+00bh)	;49d9
	or	a		;49dc
	sbc	hl,de		;49dd
	ld	(ix+00ah),l	;49df
	ld	(ix+00bh),h	;49e2
	ld	l,(ix-3)	;49e5
	ld	h,d		;49e8
	push	hl		;49e9
	call	_setuid		;49ea
	pop	bc		;49ed
l49eeh:						; m14:
	ld	a,(ix+00ah)	;49ee
	or	(ix+00bh)	;49f1
	jp	nz,l48eah	;49f4
l49f7h:						; m15:
	ld	l,(ix-3)	;49f7
	ld	h,0		;49fa
	push	hl		;49fc
	call	_setuid		;49fd
	pop	bc		;4a00
	jp	l47f4h		;4a01

; =============== F U N C T I O N =======================================
;	From library
;
_write:
	call	ncsv		;4a04
	defw	0ff79h	; ???	;4a07
	ld	b,8		;4a09
	ld	a,(ix+6)	;4a0b
	call	brelop		;4a0e
	jr	c,l4a19h	;4a11
l4a13h:						; m1:
	ld	hl,-1		;4a13
	jp	cret		;4a16
l4a19h:						; m2:
	ld	de,0002ah	;4a19
	ld	l,(ix+6)	;4a1c
	ld	h,0		;4a1f
	call	lmul		;4a21
	ld	de,__fcb	;4a24
	add	hl,de		;4a27
	push	hl		;4a28
	pop	iy		;4a29
	ld	(ix-2),002h	;4a2b
	ld	l,(ix+00ah)	;4a2f
	ld	h,(ix+00bh)	;4a32
	ld	(ix-7),l	;4a35
	ld	(ix-6),h	;4a38
	ld	a,(iy+028h)	;4a3b
	cp	2		;4a3e
	jp	z,l4ad1h	;4a40
	cp	3		;4a43
	jp	z,l4ad1h	;4a45
	cp	4		;4a48
	jr	z,l4abdh	;4a4a
	cp	6		;4a4c
	jr	z,l4a75h	;4a4e
	cp	7		;4a50
	jr	z,l4a90h	;4a52
	jr	l4a13h		;4a54
l4a56h:						; m3:
	call	__sigchk	;4a56
	ld	l,(ix+8)	;4a59
	ld	h,(ix+9)	;4a5c
	ld	a,(hl)		;4a5f
	inc	hl		;4a60
	ld	(ix+8),l	;4a61
	ld	(ix+9),h	;4a64
	ld	l,a		;4a67
	rla			;4a68
	sbc	a,a		;4a69
	ld	h,a		;4a6a
	push	hl		;4a6b
	ld	hl,4		;4a6c
	push	hl		;4a6f
	call	bdos		;4a70
	pop	bc		;4a73
	pop	bc		;4a74
l4a75h:						; m4:
	ld	l,(ix+00ah)	;4a75
	ld	h,(ix+00bh)	;4a78
	dec	hl		;4a7b
	ld	(ix+00ah),l	;4a7c
	ld	(ix+00bh),h	;4a7f
	inc	hl		;4a82
	ld	a,l		;4a83
	or	h		;4a84
	jr	nz,l4a56h	;4a85
l4a87h:						; m5:
	ld	l,(ix-7)	;4a87
	ld	h,(ix-6)	;4a8a
	jp	cret		;4a8d
l4a90h:						; m6:
	ld	(ix-2),005h	;4a90
	jr	l4abdh		;4a94
l4a96h:						; m7:
	call	__sigchk	;4a96
	ld	l,(ix+8)	;4a99
	ld	h,(ix+9)	;4a9c
	ld	a,(hl)		;4a9f
	inc	hl		;4aa0
	ld	(ix+8),l	;4aa1
	ld	(ix+9),h	;4aa4
	ld	l,a		;4aa7
	rla			;4aa8
	sbc	a,a		;4aa9
	ld	h,a		;4aaa
	ld	(ix-5),l	;4aab
	ld	(ix-4),h	;4aae
	push	hl		;4ab1
	ld	l,(ix-2)	;4ab2
	ld	h,0		;4ab5
	push	hl		;4ab7
	call	bdos		;4ab8
	pop	bc		;4abb
	pop	bc		;4abc
l4abdh:						; m8:
	ld	l,(ix+00ah)	;4abd
	ld	h,(ix+00bh)	;4ac0
	dec	hl		;4ac3
	ld	(ix+00ah),l	;4ac4
	ld	(ix+00bh),h	;4ac7
	inc	hl		;4aca
	ld	a,l		;4acb
	or	h		;4acc
	jr	nz,l4a96h	;4acd
	jr	l4a87h		;4acf
l4ad1h:						; m9:
	call	_getuid		;4ad1
	ld	e,l		;4ad4
	ld	(ix-3),e	;4ad5
	jp	l4bfbh		;4ad8
l4adbh:						; m10:
	call	__sigchk	;4adb
	ld	l,(iy+029h)	;4ade
	ld	h,0		;4ae1
	push	hl		;4ae3
	call	_setuid		;4ae4
	pop	bc		;4ae7
	ld	a,(iy+024h)	;4ae8
	and	07fh		;4aeb
	ld	(ix-2),a	;4aed
	ld	e,a		;4af0
	ld	d,0		;4af1
	ld	hl,00080h	;4af3
	or	a		;4af6
	sbc	hl,de		;4af7
	ld	(ix-1),l	;4af9
	ld	e,l		;4afc
	ld	l,(ix+00ah)	;4afd
	ld	h,(ix+00bh)	;4b00
	call	wrelop		;4b03
	jr	nc,l4b0eh	;4b06
	ld	a,(ix+00ah)	;4b08
	ld	(ix-1),a	;4b0b
l4b0eh:						; m11:
	ld	de,00080h	;4b0e
	ld	hl,0		;4b11
	push	hl		;4b14
	push	de		;4b15
	ld	e,(iy+024h)	;4b16
	ld	d,(iy+025h)	;4b19
	ld	l,(iy+026h)	;4b1c
	ld	h,(iy+027h)	;4b1f
	call	aldiv		;4b22
	push	hl		;4b25
	push	de		;4b26
	push	iy		;4b27
	pop	de		;4b29
	ld	hl,00021h	;4b2a
	add	hl,de		;4b2d
	push	hl		;4b2e
	call	__putrno	;4b2f
	pop	bc		;4b32
	pop	bc		;4b33
	pop	bc		;4b34
	ld	a,(ix-1)	;4b35
	cp	080h		;4b38
	jr	nz,l4b4eh	;4b3a
	ld	l,(ix+8)	;4b3c
	ld	h,(ix+9)	;4b3f
	push	hl		;4b42
	ld	hl,0001ah	;4b43
	push	hl		;4b46
	call	bdos		;4b47
	pop	bc		;4b4a
	pop	bc		;4b4b
	jr	l4bach		;4b4c
l4b4eh:						; m12:
	push	ix		;4b4e
	pop	de		;4b50
	ld	hl,0ff79h	;4b51
	add	hl,de		;4b54
	push	hl		;4b55
	ld	hl,0001ah	;4b56
	push	hl		;4b59
	call	bdos		;4b5a
	pop	bc		;4b5d
	push	ix		;4b5e
	pop	de		;4b60
	ld	hl,0ff79h	;4b61
	add	hl,de		;4b64
	ld	(hl),01ah	;4b65
	ld	hl,0007fh	;4b67
	ex	(sp),hl		;4b6a
	push	ix		;4b6b
	pop	de		;4b6d
	ld	hl,0ff7ah	;4b6e
	add	hl,de		;4b71
	push	hl		;4b72
	push	ix		;4b73
	pop	de		;4b75
	ld	hl,0ff79h	;4b76
	add	hl,de		;4b79
	push	hl		;4b7a
	call	movmem		;4b7b
	pop	bc		;4b7e
	pop	bc		;4b7f
	pop	bc		;4b80
	push	iy		;4b81
	ld	hl,00021h	;4b83
	push	hl		;4b86
	call	bdos		;4b87
	pop	bc		;4b8a
	ld	l,(ix-1)	;4b8b
	ld	h,0		;4b8e
	ex	(sp),hl		;4b90
	push	ix		;4b91
	pop	de		;4b93
	ld	l,(ix-2)	;4b94
	ld	h,0		;4b97
	add	hl,de		;4b99
	ld	de,0ff79h	;4b9a
	add	hl,de		;4b9d
	push	 hl		;4b9e
	ld	l,(ix+8)	;4b9f
	ld	h,(ix+9)	;4ba2
	push	hl		;4ba5
	call	movmem		;4ba6
	pop	bc		;4ba9
	pop	bc		;4baa
	pop	bc		;4bab
l4bach:						; m13:
	push	iy		;4bac
	ld	hl,00022h	;4bae
	push	hl		;4bb1
	call	bdos		;4bb2
	pop	bc		;4bb5
	pop	bc		;4bb6
	ld	a,l		;4bb7
	or	a		;4bb8
	jr	nz,l4c04h	;4bb9
	ld	e,(ix-1)	;4bbb
	ld	d,0		;4bbe
	ld	l,(ix+8)	;4bc0
	ld	h,(ix+9)	;4bc3
	add	hl,de		;4bc6
	ld	(ix+8),l	;4bc7
	ld	(ix+9),h	;4bca
	ld	a,e		;4bcd
	ld	hl,0		;4bce
	ld	d,l		;4bd1
	push	hl		;4bd2
	push	de		;4bd3
	push	iy		;4bd4
	pop	de		;4bd6
	ld	hl,00024h	;4bd7
	add	hl,de		;4bda
	call	aslladd		;4bdb
	ld	e,(ix-1)	;4bde
	ld	d,0		;4be1
	ld	l,(ix+00ah)	;4be3
	ld	h,(ix+00bh)	;4be6
	or	a		;4be9
	sbc	hl,de		;4bea
	ld	(ix+00ah),l	;4bec
	ld	(ix+00bh),h	;4bef
	ld	l,(ix-3)	;4bf2
	ld	h,d		;4bf5
	push	hl		;4bf6
	call	_setuid		;4bf7
	pop	bc		;4bfa
l4bfbh:						; m14:
	ld	a,(ix+00ah)	;4bfb
	or	(ix+00bh)	;4bfe
	jp	nz,l4adbh	;4c01
l4c04h:						; m15:
	ld	l,(ix-3)	;4c04
	ld	h,0		;4c07
	push	hl		;4c09
	call	_setuid		;4c0a
	pop	bc		;4c0d
	ld	e,(ix+00ah)	;4c0e
	ld	d,(ix+00bh)	;4c11
	ld	l,(ix-7)	;4c14
	ld	h,(ix-6)	;4c17
	or	a		;4c1a
	sbc	hl,de		;4c1b
	jp	cret		;4c1d

; =============== F U N C T I O N =======================================
;	From library
;
__fsize:
	call	ncsv		;4c20
	defw	0fffbh	; -5	;4c23

	ld	b,8		;4c25
	ld	a,(ix+6)	;4c27
	call	brelop		;4c2a
	jr	c,l4c37h	;4c2d
	ld	de,-1		;4c2f
	ld	l,e		;4c32
	ld	h,d		;4c33
	jp	cret		;4c34
l4c37h:						; m1:
	ld	de,0002ah	;4c37
	ld	l,(ix+6)	;4c3a
	ld	h,0		;4c3d
	call	lmul		;4c3f
	ld	de,__fcb	;4c42
	add	hl,de		;4c45
	push	hl		;4c46
	pop	iy		;4c47
	call	_getuid		;4c49
	ld	(ix-5),l	;4c4c
	ld	l,(iy+029h)	;4c4f
	ld	h,0		;4c52
	push	hl		;4c54
	call	_setuid		;4c55
	pop	bc		;4c58
	push	iy		;4c59
	ld	hl,00023h	;4c5b
	push	hl		;4c5e
	call	bdos		;4c5f
	pop	bc		;4c62
	ld	l,(ix-5)	;4c63
	ld	h,0		;4c66
	ex	(sp),hl		;4c68
	call	_setuid		;4c69
	pop	bc		;4c6c
	ld	b,010h		;4c6d
	ld	a,(iy+023h)	;4c6f
	ld	hl,0		;4c72
	ld	d,l		;4c75
	ld	e,a		;4c76
	call	lllsh		;4c77
	push	hl		;4c7a
	push	de		;4c7b
	ld	b,8		;4c7c
	ld	a,(iy+022h)	;4c7e
	ld	hl,0		;4c81
	ld	d,l		;4c84
	ld	e,a		;4c85
	call	lllsh		;4c86
	push	hl		;4c89
	push	de		;4c8a
	ld	a,(iy+021h)	;4c8b
	ld	hl,0		;4c8e
	ld	d,l		;4c91
	ld	e,a		;4c92
	call	lladd		;4c93
	call	lladd		;4c96
	ld	(ix-4),e	;4c99
	ld	(ix-3),d	;4c9c
	ld	(ix-2),l	;4c9f
	ld	(ix-1),h	;4ca2
	ld	b,7		;4ca5
	push	ix		;4ca7
	pop	hl		;4ca9
	dec	hl		;4caa
	dec	hl		;4cab
	dec	hl		;4cac
	dec	hl		;4cad
	call	aslllsh		;4cae
	ld	e,(ix-4)	;4cb1
	ld	d,(ix-3)	;4cb4
	ld	l,(ix-2)	;4cb7
	ld	h,(ix-1)	;4cba
	push	hl		;4cbd
	push	de		;4cbe
	ld	e,(iy+024h)	;4cbf
	ld	d,(iy+025h)	;4cc2
	ld	l,(iy+026h)	;4cc5
	ld	h,(iy+027h)	;4cc8
	call	lrelop		;4ccb
	jp	p,l4ce0h	;4cce

	ld	e,(ix-4)	;4cd1
	ld	d,(ix-3)	;4cd4
	ld	l,(ix-2)	;4cd7
	ld	h,(ix-1)	;4cda
	jp	cret		;4cdd
l4ce0h:						; m2:
	ld	e,(iy+024h)	;4ce0
	ld	d,(iy+025h)	;4ce3
	ld	l,(iy+026h)	;4ce6
	ld	h,(iy+027h)	;4ce9
	jp	cret		;4cec

; =============== F U N C T I O N =======================================
;	From library
;
_lseek:
	call	csv		;4cef
	push	hl		;4cf2
	push	hl		;4cf3
	ld	b,8		;4cf4
	ld	a,(ix+6)	;4cf6
	call	brelop		;4cf9
	jr	c,l4d06h	;4cfc
l4cfeh:						; m1:
	ld	de,-1		;4cfe
	ld	l,e		;4d01
	ld	h,d		;4d02
	jp	cret		;4d03
l4d06h:						; m2:
	ld	de,0002ah	;4d06
	ld	l,(ix+6)	;4d09
	ld	h,0		;4d0c
	call	lmul		;4d0e
	ld	de,__fcb	;4d11
	add	hl,de		;4d14
	push	hl		;4d15
	pop	iy		;4d16
	ld	a,(ix+00ch)	;4d18
	cp	1		;4d1b
	jr	z,l4d68h	;4d1d
	cp	2		;4d1f
	ld	e,(ix+8)	;4d21
	ld	d,(ix+9)	;4d24
	ld	l,(ix+00ah)	;4d27
	ld	h,(ix+00bh)	;4d2a
	jr	z,l4d93h	;4d2d
	ld	(ix-4),e	;4d2f
	ld	(ix-3),d	;4d32
	ld	(ix-2),l	;4d35
	ld	(ix-1),h	;4d38
l4d3bh:						; m3:
	bit	7,(ix-1)	;4d3b
	jr	nz,l4cfeh	;4d3f
	ld	e,(ix-4)	;4d41
	ld	d,(ix-3)	;4d44
	ld	l,(ix-2)	;4d47
	ld	h,(ix-1)	;4d4a
	ld	(iy+024h),e	;4d4d
	ld	(iy+025h),d	;4d50
	ld	(iy+026h),l	;4d53
	ld	(iy+027h),h	;4d56
	ld	e,(iy+024h)	;4d59
	ld	d,(iy+025h)	;4d5c
	ld	l,(iy+026h)	;4d5f
	ld	h,(iy+027h)	;4d62
	jp	cret		;4d65
l4d68h:						; m4:
	ld	e,(ix+8)	;4d68
	ld	d,(ix+9)	;4d6b
	ld	l,(ix+00ah)	;4d6e
	ld	h,(ix+00bh)	;4d71
	push	hl		;4d74
	push	de		;4d75
	ld	e,(iy+024h)	;4d76
	ld	d,(iy+025h)	;4d79
	ld	l,(iy+026h)	;4d7c
	ld	h,(iy+027h)	;4d7f
l4d82h:						; m5:
	call	lladd		;4d82
	ld	(ix-4),e	;4d85
	ld	(ix-3),d	;4d88
	ld	(ix-2),l	;4d8b
	ld	(ix-1),h	;4d8e
	jr	l4d3bh		;4d91
l4d93h:						; m6:
	push	hl		;4d93
	push	de		;4d94
	ld	l,(ix+6)	;4d95
	ld	h,0		;4d98
	push	hl		;4d9a
	call	__fsize		;4d9b
	pop	bc		;4d9e
	jr	l4d82h		;4d9f

; =============== F U N C T I O N =======================================
;	From library
;
_creat:
	call	csv		;4da1
	push	hl		;4da4
	call	_getfcb		;4da5
	push	hl		;4da8
	pop	iy		;4da9
	ld	a,l		;4dab
	or	h		;4dac
	jr	nz,l4db5h	;4dad
l4dafh:						; m1:
	ld	hl,-1		;4daf
	jp	cret		;4db2
l4db5h:						; m2:
	call	_getuid		;4db5
	ld	(ix-1),l	;4db8
	ld	l,(ix+6)	;4dbb
	ld	h,(ix+7)	;4dbe
	push	hl		;4dc1
	push	iy		;4dc2
	call	_setfcb	;4dc4
	pop	bc		;4dc7
	pop	bc		;4dc8
	ld	a,l		;4dc9
	or	a		;4dca
	jr	nz,l4e09h	;4dcb

	ld	l,(ix+6)	;4dcd
	ld	h,(ix+7)	;4dd0
	push	hl		;4dd3
	call	_unlink		;4dd4
	ld	l,(iy+029h)	;4dd7
	ld	h,0		;4dda
	ex	(sp),hl		;4ddc
	call	_setuid		;4ddd
	pop	bc		;4de0
	push	iy		;4de1
	ld	hl,00016h	;4de3
	push	hl		;4de6
	call	bdos		;4de7
	pop	bc		;4dea
	pop	bc		;4deb
	ld	a,l		;4dec
	cp	0ffh		;4ded
	ld	l,(ix-1)	;4def
	ld	h,0		;4df2
	push	hl		;4df4
	jr	nz,l4e01h	;4df5

	call	_setuid		;4df7
	pop	bc		;4dfa
	ld	(iy+028h),0	;4dfb
	jr	l4dafh		;4dff
l4e01h:						; m3:
	call	_setuid		;4e01
	pop	bc		;4e04
	ld	(iy+028h),2	;4e05
l4e09h:						; m4:
	ld	de,__fcb	;4e09
	push	iy		;4e0c
	pop	hl		;4e0e
	or	a		;4e0f
	sbc	hl,de		;4e10
	ld	de,0002ah	;4e12
	call	adiv		;4e15
	jp	cret		;4e18

; =============== F U N C T I O N =======================================
;	From library?
;
_isatty:
	call	csv		;4e1b
	ld	de,0002ah	;4e1e
	ld	l,(ix+6)	;4e21
	ld	h,0		;4e24
	call	lmul		;4e26
	ld	de,array_6467	;4e29
	add	hl,de		;4e2c
	ld	a,(hl)		;4e2d
	cp	4		;4e2e
	jr	z,l4e3eh	;4e30
	cp	5		;4e32
	jr	z,l4e3eh	;4e34
	cp	6		;4e36
	jr	z,l4e3eh	;4e38
	cp	7		;4e3a
	jr	nz,l4e44h	;4e3c
l4e3eh:						; m1:
	ld	hl,1		;4e3e
	jp	cret		;4e41
l4e44h:						; m2:
	ld	hl,0		;4e44
	jp	cret		;4e47

; =============== F U N C T I O N =======================================
;	From library
;
_close:
	call	csv		;4e4a
	push	hl		;4e4d
	ld	b,8		;4e4e
	ld	a,(ix+6)	;4e50
	call	brelop		;4e53
	jr	c,l4e5eh	;4e56

	ld	hl,-1		;4e58
	jp	cret		;4e5b
l4e5eh:						; m1:
	ld	de,0002ah	;4e5e
	ld	l,(ix+6)	;4e61
	ld	h,0		;4e64
	call	lmul		;4e66
	ld	de,__fcb	;4e69
	add	hl,de		;4e6c
	push	hl		;4e6d
	pop	iy		;4e6e
	call	_getuid		;4e70
	ld	(ix-1),l	;4e73
	ld	l,(iy+029h)	;4e76
	ld	h,0		;4e79
	push	hl		;4e7b
	call	_setuid		;4e7c
	pop	bc		;4e7f
	ld	a,(iy+028h)	;4e80
	cp	2		;4e83
	jr	z,l4ea4h	;4e85
	cp	3		;4e87
	jr	z,l4ea4h	;4e89
	ld	hl,0000ch	;4e8b
	push	hl		;4e8e
	call	bdoshl		;4e8f
	pop	bc		;4e92
	xor	a		;4e93
	ld	l,a		;4e94
	ld	a,h		;4e95
	and	005h		;4e96
	ld	h,a		;4e98
	ld	a,l		;4e99
	or	h		;4e9a
	jr	z,l4eafh	;4e9b

	ld	a,(iy+028h)	;4e9d
	cp	1		;4ea0
	jr	nz,l4eafh	;4ea2
l4ea4h:						; m2:
	push	iy		;4ea4
	ld	hl,00010h	;4ea6
	push	hl		;4ea9
	call	bdos		;4eaa
	pop	bc		;4ead
	pop	bc		;4eae
l4eafh:						; m3:
	ld	(iy+028h),0	;4eaf
	ld	l,(ix-1)	;4eb3
	ld	h,0		;4eb6
	push	hl		;4eb8
	call	_setuid		;4eb9
	pop	bc		;4ebc
	ld	hl,0		;4ebd
	jp	cret		;4ec0

; =============== F U N C T I O N =======================================
;	From library
;
_unlink:
	call	ncsv		;4ec3
	defw	0ffd3h	;-45	;4ec6

	ld	l,(ix+6)	;4ec8
	ld	h,(ix+7)	;4ecb
	push	hl		;4ece
	push	ix		;4ecf

	pop	de		;4ed1
	ld	hl,0ffd6h	;4ed2
	add	hl,de		;4ed5
	push	hl		;4ed6
	call	_setfcb		;4ed7
	pop	bc		;4eda
	pop	bc		;4edb
	ld	a,l		;4edc
	or	a		;4edd
	jr	z,l4ee6h	;4ede

	ld	hl,0		;4ee0
	jp	cret		;4ee3
l4ee6h:						; m1:
	call	_getuid		;4ee6
	ld	(ix-02bh),l	;4ee9
	ld	l,(ix-1)	;4eec
	ld	h,0		;4eef
	push	hl		;4ef1
	call	_setuid		;4ef2
	push	ix		;4ef5
	pop	de		;4ef7
	ld	hl,0ffd6h	;4ef8
	add	hl,de		;4efb
	ex	(sp),hl		;4efc
	ld	hl,00013h	;4efd /* delete file */
	push	hl		;4f00
	call	bdos		;4f01
	pop	bc		;4f04
	ld	a,l		;4f05
	rla			;4f06
	sbc	a,a		;4f07
	ld	h,a		;4f08
	ld	(ix-02dh),l	;4f09
	ld	(ix-02ch),h	;4f0c

	ld	l,(ix-02bh)	;4f0f
	ld	h,0		;4f12
	ex	(sp),hl		;4f14
	call	_setuid		;4f15
	pop	bc		;4f18
	ld	l,(ix-02dh)	;4f19
	ld	h,(ix-02ch)	;4f1c
	jp	cret		;4f1f

; =============== F U N C T I O N =======================================
;	From library
;
_upcase:
	call	csv		;4f22
	ld	a,(ix+6)	;4f25
	ld	e,a		;4f28
	rla			;4f29
	sbc	a,a		;4f2a
	ld	d,a		;4f2b
	ld	hl,__ctype_+1	;4f2c
	add	hl,de		;4f2f
	bit	1,(hl)		;4f30
	jr	z,l4f3bh	;4f32

	ld	a,e		;4f34
	add	a,0e0h		;4f35
	ld	l,a		;4f37
	jp	cret		;4f38
l4f3bh:						; m1:
	ld	l,(ix+6)	;4f3b
	jp	cret		;4f3e

; =============== F U N C T I O N =======================================
;	From library
;
_getfcb:
	call	csv		;4f41
	ld	iy,__fcb	;4f44
	jr	l4f6fh		;4f48
l4f4ah:						; m1:
	ld	a,(iy+028h)	;4f4a
	or	a		;4f4d
	jr	nz,l4f6ah	;4f4e

	ld	(iy+028h),1	;4f50
	ld	(iy+024h),0	;4f54
	ld	(iy+025h),0	;4f58
	ld	(iy+026h),0	;4f5c
	ld	(iy+027h),0	;4f60
	push	iy		;4f64
	pop	hl		;4f66
	jp	cret		;4f67
l4f6ah:						; m2:
	ld	de,0002ah	;4f6a
	add	iy,de		;4f6d
l4f6fh:						; m3:
	ld	de,__ctype_	;4f6f
	push	iy		;4f72
	pop	hl		;4f74
	call	wrelop		;4f75
	jr	c,l4f4ah	;4f78

	ld	hl,0		;4f7a
	jp	cret		;4f7d

; =============== F U N C T I O N =======================================
;	From library
;
_putfcb:
	call	csv		;4f80
	ld	l,(ix+6)	;4f83
	ld	h,(ix+7)	;4f86
	push	hl		;4f89
	pop	iy		;4f8a
	ld	(iy+028h),0	;4f8c
	jp	cret		;4f90

; =============== F U N C T I O N =======================================
;	From library
;
_setfcb:
	call	csv		;4f93
	push	hl		;4f96
	ld	l,(ix+8)	;4f97
	ld	h,(ix+9)	;4f9a
	push	hl		;4f9d
	pop	iy		;4f9e
	jr	l4fa4h		;4fa0
l4fa2h:						; m1:
	inc	iy		;4fa2
l4fa4h:						; m2:
	ld	a,(iy+0)	;4fa4
	ld	e,a		;4fa7
	rla			;4fa8
	sbc	a,a		;4fa9
	ld	d,a		;4faa
	ld	hl,__ctype_+1	;4fab
	add	hl,de		;4fae
	bit	3,(hl)		;4faf
	jr	nz,l4fa2h	;4fb1

	ld	(ix-1),0	;4fb3
	jr	l4fe7h		;4fb7
l4fb9h:						; m3:
	ld	(ix-2),0	;4fb9
l4fbdh:						; m4:
	push	iy		;4fbd
	pop	de		;4fbf
	ld	l,(ix-2)	;4fc0
	ld	h,0		;4fc3
	add	hl,de		;4fc5
	ld	a,(hl)		;4fc6
	ld	l,a		;4fc7
	rla			;4fc8
	sbc	a,a		;4fc9
	ld	h,a		;4fca
	push	hl		;4fcb
	call	_upcase		;4fcc
	pop	bc		;4fcf
	ld	a,l		;4fd0
	ld	e,(ix-2)	;4fd1
	ld	d,0		;4fd4
	ld	l,(ix-1)	;4fd6
	ld	h,d		;4fd9
	add	hl,hl		;4fda
	add	hl,hl		;4fdb
	add	hl,de		;4fdc
	ld	de,_dnames	;4fdd
	add	hl,de		;4fe0
	cp	(hl)		;4fe1
	jr	z,l5004h	;4fe2

	inc	(ix-1)		;4fe4
l4fe7h:						; m5:
	ld	b,4		;4fe7
	ld	a,(ix-1)	;4fe9
	call	brelop		;4fec
	jr	c,l4fb9h	;4fef

	push	iy		;4ff1
	ld	l,(ix+6)	;4ff3
	ld	h,(ix+7)	;4ff6
	push	hl		;4ff9
	call	_fc_parse	;4ffa
	pop	bc		;4ffd
	pop	bc		;4ffe
	ld	l,0		;4fff
	jp	cret		;5001
l5004h:						; m6:
	inc	(ix-2)		;5004
	ld	a,(ix-2)	;5007
	cp	4		;500a
	jr	nz,l4fbdh	;500c

	ld	a,(ix-1)	;500e
	add	a,4		;5011
	ld	e,(ix+6)	;5013
	ld	d,(ix+7)	;5016
	ld	hl,00028h	;5019
	add	hl,de		;501c
	ld	(hl),a		;501d
	ld	l,1		;501e
	jp	cret		;5020

; =============== F U N C T I O N =======================================
;	From library
;
_fc_parse:
	call	csv		;5023
	push	hl		;5026
	push	hl		;5027
	ld	l,(ix+6)	;5028
	ld	h,(ix+7)	;502b
	push	hl		;502e
	pop	iy		;502f
	ld	(iy+0),0	;5031
	call	_getuid		;5035
	ld	(iy+029h),l	;5038
	ld	l,(ix+8)	;503b
	ld	h,(ix+9)	;503e
	ld	(ix-2),l	;5041
	ld	(ix-1),h	;5044
	jr	l5056h		;5047
l5049h:						; m1:
	ld	l,(ix-2)	;5049
	ld	h,(ix-1)	;504c
	inc	hl		;504f
	ld	(ix-2),l	;5050
	ld	(ix-1),h	;5053
l5056h:						; m2:
	ld	l,(ix-2)	;5056
	ld	h,(ix-1)	;5059
	ld	a,(hl)		;505c
	ld	e,a		;505d
	rla			;505e
	sbc	a,a		;505f
	ld	d,a		;5060
	ld	hl,__ctype_+1	;5061
	add	hl,de		;5064
	bit	2,(hl)		;5065
	jr	nz,l5049h	;5067

	ld	e,(ix-2)	;5069
	ld	d,(ix-1)	;506c
	ld	l,(ix+8)	;506f
	ld	h,(ix+9)	;5072
	or	a		;5075
	sbc	hl,de		;5076
	jr	z,l509ch	;5078

	ld	l,e		;507a
	ld	h,d		;507b
	ld	a,(hl)		;507c
	cp	03ah		;507d
	ld	l,(ix+8)	;507f
	ld	h,(ix+9)	;5082
	jr	nz,l50a2h	;5085

	push	hl		;5087
	call	atoi		;5088
	pop	bc		;508b
	ld	(iy+029h),l	;508c
	ld	l,(ix-2)	;508f
	ld	h,(ix-1)	;5092
	inc	hl		;5095
	ld	(ix+8),l	;5096
	ld	(ix+9),h	;5099
l509ch:						; m3:
	ld	l,(ix+8)	;509c
	ld	h,(ix+9)	;509f
l50a2h:						; m4:
	ld	a,(hl)		;50a2
	or	a		;50a3
	jr	z,l50d3h	;50a4

	ld	l,(ix+8)	;50a6
	ld	h,(ix+9)	;50a9
	inc	hl		;50ac
	ld	a,(hl)		;50ad
	cp	03ah		;50ae
	jr	nz,l50d3h	;50b0

	dec	hl		;50b2
	ld	a,(hl)		;50b3
	ld	l,a		;50b4
	rla	    ;50b5
	sbc	a,a		;50b6
	ld	h,a		;50b7
	push	hl		;50b8
	call	_upcase	;50b9
	pop	bc		;50bc
	ld	a,l		;50bd
	rla			;50be
	ld	a,l		;50bf
	add	a,0c0h		;50c0
	ld	(iy+0),a	;50c2
	ld	l,(ix+8)	;50c5
	ld	h,(ix+9)	;50c8
	inc	hl		;50cb
	inc	hl		;50cc
	ld	(ix+8),l	;50cd
	ld	(ix+9),h	;50d0
l50d3h:						; m5:
	push	iy		;50d3
	pop	hl		;50d5
	inc	hl		;50d6
	ld	(ix-2),l	;50d7
	ld	(ix-1),h	;50da
	jr	l5106h		;50dd
l50dfh:						; m6:
	ld	l,(ix+8)	;50df
	ld	h,(ix+9)	;50e2
	ld	a,(hl)		;50e5
	inc	hl		;50e6
	ld	(ix+8),l	;50e7
	ld	(ix+9),h	;50ea
	ld	l,a		;50ed
	rla			;50ee
	sbc	a,a		;50ef
	ld	h,a		;50f0
	push	hl		;50f1
	call	_upcase		;50f2
	pop	bc		;50f5
	ld	e,l		;50f6
	ld	l,(ix-2)	;50f7
	ld	h,(ix-1)	;50fa
	inc	hl		;50fd
	ld	(ix-2),l	;50fe
	ld	(ix-1),h	;5101
	dec	hl		;5104
	ld	(hl),e		;5105
l5106h:						; m7:
	ld	l,(ix+8)	;5106
	ld	h,(ix+9)	;5109
	ld	a,(hl)		;510c
	cp	02eh		;510d
	ld	a,(hl)		;510f
	jr	z,l513eh	;5110

	cp	02ah		;5112
	ld	a,(hl)		;5114
	jr	z,l513eh	;5115

	ld	e,a		;5117
	rla			;5118
	sbc	a,a		;5119
	ld	d,a		;511a
	ld	hl,00020h	;511b
	call	wrelop		;511e
	jp	p,l5137h	;5121

	push	iy		;5124
	pop	de		;5126
	ld	hl,9		;5127
	add	hl,de		;512a
	ex	de,hl		;512b
	ld	l,(ix-2)	;512c
	ld	h,(ix-1)	;512f
	call	wrelop		;5132
	jr	c,l50dfh	;5135
l5137h:						; m8:
	ld	l,(ix+8)	;5137
	ld	h,(ix+9)	;513a
	ld	a,(hl)		;513d
l513eh:						; m9:
	cp	02ah		;513e
	jr	nz,l5148h	;5140

	ld	(ix-3),03fh	;5142
	jr	l5160h		;5146
l5148h:						; m10:
	ld	(ix-3),020h	;5148
	jr	l5160h		;514c
l514eh:						; m11:
	ld	a,(ix-3)	;514e
	ld	l,(ix-2)	;5151
	ld	h,(ix-1)	;5154
	inc	hl		;5157
	ld	(ix-2),l	;5158
	ld	(ix-1),h	;515b
	dec	hl		;515e
	ld	(hl),a		;515f
l5160h:						; m12:
	push	iy		;5160
	pop	de		;5162
	ld	hl,00009h	;5163
	add	hl,de		;5166
	ex	de,hl		;5167
	ld	l,(ix-2)	;5168
	ld	h,(ix-1)	;516b
	call	wrelop		;516e
	jr	c,l514eh	;5171
l5173h:						; m13:
	ld	l,(ix+8)	;5173
	ld	h,(ix+9)	;5176
	ld	a,(hl)		;5179
	or	a		;517a
	ld	a,(hl)		;517b
	jr	z,l51b9h	;517c

	inc	hl		;517e
	ld	(ix+8),l	;517f
	ld	(ix+9),h	;5182
	cp	02eh		;5185
	jr	nz,l5173h	;5187

	jr	l51b2h		;5189
l518bh:						; m14:
	ld	l,(ix+8)	;518b
	ld	h,(ix+9)	;518e
	ld	a,(hl)		;5191
	inc	hl		;5192
	ld	(ix+8),l	;5193
	ld	(ix+9),h	;5196
	ld	l,a		;5199
	rla			;519a
	sbc	a,a		;519b
	ld	h,a		;519c
	push	hl		;519d
	call	_upcase		;519e
	pop	bc		;51a1
	ld	e,l		;51a2
	ld	l,(ix-2)	;51a3
	ld	h,(ix-1)	;51a6
	inc	hl		;51a9
	ld	(ix-2),l	;51aa
	ld	(ix-1),h	;51ad
	dec	hl		;51b0
	ld	(hl),e		;51b1
l51b2h:						; m15:
	ld	l,(ix+8)	;51b2
	ld	h,(ix+9)	;51b5
	ld	a,(hl)		;51b8
l51b9h:						; m16:
	ld	e,a		;51b9
	rla			;51ba
	sbc	a,a		;51bb
	ld	d,a		;51bc
	ld	hl,00020h	;51bd
	call	wrelop		;51c0
	ld	l,(ix+8)	;51c3
	ld	h,(ix+9)	;51c6
	ld	a,(hl)		;51c9
	jp	p,l51ebh	;51ca
	
	cp	02ah		;51cd
	jr	z,l51e4h	;51cf
	
	push	iy		;51d1
	pop	de		;51d3
	ld	hl,0000ch	;51d4
	add	hl,de		;51d7
	ex	de,hl		;51d8
	ld	l,(ix-2)	;51d9
	ld	h,(ix-1)	;51dc
	call	wrelop		;51df
	jr	c,l518bh	;51e2
l51e4h:						; m17:
	ld	l,(ix+8)	;51e4
	ld	h,(ix+9)	;51e7
	ld	a,(hl)		;51ea
l51ebh:						; m18:
	cp	02ah		;51eb
	jr	nz,l51f5h	;51ed

	ld	(ix-3),03fh	;51ef
	jr	l520dh		;51f3
l51f5h:						; m19:
	ld	(ix-3),020h	;51f5
	jr	l520dh		;51f9
l51fbh:						; m20:
	ld	a,(ix-3)	;51fb
	ld	l,(ix-2)	;51fe
	ld	h,(ix-1)	;5201
	inc	hl		;5204
	ld	(ix-2),l	;5205
	ld	(ix-1),h	;5208
	dec	hl		;520b
	ld	(hl),a		;520c
l520dh:						; m21:
	push	iy		;520d
	pop	de		;520f
	ld	hl,0000ch	;5210
	add	hl,de		;5213
	ex	de,hl		;5214
	ld	l,(ix-2)	;5215
	ld	h,(ix-1)	;5218
	call	wrelop		;521b
	jr	c,l51fbh	;521e

	xor	a		;5220
	ld	(iy+020h),a	;5221
	ld	(iy+00ch),a	;5224
	jp	cret		;5227


	call	csv		;522a
	push	hl		;522d
	ld	de,1		;522e
	ld	l,(ix+6)	;5231
	ld	h,(ix+7)	;5234
	or	a		;5237
	sbc	hl,de		;5238
	jr	z,l5242h	;523a

	ld	hl,-1		;523c
	jp	cret		;523f
l5242h:						; m22:
	ld	hl,(0ab0eh)	;5242
	ld	(ix-2),l	;5245
	ld	(ix-1),h	;5248
	ld	l,(ix+8)	;524b
	ld	h,(ix+9)	;524e
	ld	(0ab0eh),hl	;5251
	ld	l,(ix-2)	;5254
	ld	h,(ix-1)	;5257
	jp	cret		;525a

; =============== F U N C T I O N =======================================
;	From library
;
__sigchk:
	call	csv		;525d
	push	hl		;5260
	ld	de,1		;5261
	ld	hl,(0ab0eh)	;5264
	or	a		;5267
	sbc	hl,de		;5268
	jp	z,cret		;526a

	ld	hl,0000bh	;526d
	push	hl		;5270
	call	bdos		;5271
	pop	bc		;5274
	ld	a,l		;5275
	or	a		;5276
	jp	z,cret		;5277

	ld	hl,1		;527a
	push	hl		;527d
	call	bdos		;527e
	pop	bc		;5281
	ld	e,l		;5282
	ld	(ix-1),e	;5283
	ld	a,e		;5286
	cp	3		;5287
	jp	nz,cret		;5289

	ld	hl,(0ab0eh)	;528c
	ld	a,l		;528f
	or	h		;5290
	call	z,exit		;5291

	ld	hl,(0ab0eh)	;5294
	call	indir		;5297
	jp	cret		;529a

; =============== F U N C T I O N =======================================
;	From library
;
_getuid:
	call	csv		;529d
	ld	c,020h		;52a0
	ld	e,0FFh		;52a2
	push	ix		;52a4
	call	BDOS		;52a6
	pop	ix		;52a9
	ld	l,a		;52ab
	ld	h,0		;52ac
	jp	cret		;52ae

; =============== F U N C T I O N =======================================
;	From library
;
_setuid:
	call	csv		;52b1
	ld	e,(ix+6)	;52b4
	ld	c,020h		;52b7
	push	ix		;52b9
	call	BDOS		;52bb
	pop	ix		;52be
	jp	cret		;52c0

; =============== F U N C T I O N =======================================
;
;   char bdos(func, arg)
bdos:
	call	csv		;52c3
	ld	e,(ix+8)	;52c6
	ld	d,(ix+9)	;52c9
	ld	c,(ix+6)	;52cc
	push	ix		;52cf
	push	iy		;52d1
	call	BDOS		;52d3
	pop	iy		;52d6
	pop	ix		;52d8
	ld	l,a		;52da
	rla			;52db
	sbc	a,a		;52dc
	ld	h,a		;52dd
	jp	cret		;52de

; =============== F U N C T I O N =======================================
;	From library
;
bdoshl:
	call	csv		;52e1
	ld	e,(ix+8)	;52e4
	ld	d,(ix+9)	;52e7
	ld	c,(ix+6)	;52ea
	push	ix		;52ed
	call	BDOS		;52ef
	pop	ix		;52f2
	jp	cret		;52f4

; =============== F U N C T I O N =======================================

;	From library
;
__cpm_clean:
	call	csv		;52f7
	push	hl		;52fa
	ld	(ix-1),0	;52fb
l52ffh:
	ld	l,(ix-1)	;52ff
	ld	h,0		;5302
	push	hl		;5304
	call	_close		;5305
	pop	bc		;5308
	ld	b,8		;5309
	inc	(ix-1)		;530b
	ld	a,(ix-1)	;530e
	call	brelop		;5311
	jr	c,l52ffh	;5314

	jp	cret		;5316

; =============== F U N C T I O N =======================================
;	From library
;
__putrno:
	call	csv		;5319
	ld	a,(ix+8)	;531c
	ld	l,(ix+6)	;531f
	ld	h,(ix+7)	;5322
	ld	(hl),a		;5325
	ld	b,8		;5326
	ld	e,a		;5328
	ld	d,(ix+9)	;5329
	ld	l,(ix+00ah)	;532c
	ld	h,(ix+00bh)	;532f
	call	alrsh		;5332
	ld	l,(ix+6)	;5335
	ld	h,(ix+7)	;5338
	inc	hl		;533b
	ld	(hl),e		;533c
	ld	b,010h		;533d
	ld	e,(ix+8)	;533f
	ld	d,(ix+9)	;5342
	ld	l,(ix+00ah)	;5345
	ld	h,(ix+00bh)	;5348
	call	alrsh		;534b
	ld	l,(ix+6)	;534e
	ld	h,(ix+7)	;5351
	inc	hl		;5354
	inc	hl		;5355
	ld	(hl),e		;5356
	jp	cret		;5357

; =============== F U N C T I O N =======================================
;	From library
;
__exit:
	call	__cpm_clean	;535a
	pop	hl		;535d
	pop	hl		;535e
	ld	(80h),hl	;535f
	jp	0		;5362

; =============== F U N C T I O N =======================================
;
;
asallsh:
aslllsh:
	push	bc		;5365
	ld	e,(hl)		;5366
	inc	hl		;5367
	ld	d,(hl)		;5368
	inc	hl		;5369
	ld	c,(hl)		;536a
	inc	hl		;536b
	ld	b,(hl)		;536c
	ex	(sp),hl		;536d
	push	bc		;536e
	ex	(sp),hl		;536f
	pop	bc		;5370
	call	lllsh		;5371
	jp	iregstore	;5374

; =============== F U N C T I O N =======================================
;
;
allsh:
lllsh:
	ld	a,b		;5377
	or	a		;5378
	ret	z		;5379
	cp	021h		;537a
	jr	c,l5380h	;537c
	ld	b,020h		;537e
l5380h:
	ex	de,hl		;5380
	add	hl,hl		;5381
	ex	de,hl		;5382
	adc	hl,hl		;5383
	djnz	l5380h		;5385
	ret			;5387

; =============== F U N C T I O N =======================================
;
;
asar:
	ld	e,(hl)		;5388
	inc	hl		;5389
	ld	d,(hl)		;538a
	push	hl		;538b
	ex	de,hl		;538c
	call	shar		;538d
	ex	de,hl		;5390
	pop	hl		;5391
	ld	(hl),d		;5392
	dec	hl		;5393
	ld	(hl),e		;5394
	ex	de,hl		;5395
	ret			;5396

; =============== F U N C T I O N =======================================
;
;
asaladd:
aslladd:
	call	iregset		;5397
	call	lladd		;539a
	jp	iregstore	;539d

; =============== F U N C T I O N =======================================
;
;
asamod:
	ld	c,(hl)		;53a0
	inc	hl		;53a1
	ld	b,(hl)		;53a2
	push	bc		;53a3
	ex	(sp),hl		;53a4
	call	amod		;53a5
	ex	(sp),hl		;53a8
	pop	de		;53a9
	ld	(hl),d		;53aa
	dec	hl		;53ab
	ld	(hl),e		;53ac
	ex	de,hl		;53ad
	ret			;53ae
aslmod:
	ld	c,(hl)		;53af
	inc	hl		;53b0
	ld	b,(hl)		;53b1
	push	bc		;53b2
	ex	(sp),hl		;53b3
	call	lmod		;53b4
	ex	(sp),hl		;53b7
	pop	de		;53b8
	ld	(hl),d		;53b9
	dec	hl		;53ba
	ld	(hl),e		;53bb
	ex	de,hl		;53bc
	ret			;53bd

; =============== F U N C T I O N =======================================
;
;
digit:
	sub	030h		;53be
	ret	c		;53c0
	cp	0ah		;53c1
	ccf			;53c3
	ret			;53c4

; =============== F U N C T I O N =======================================
; atoi
;
atoi:
	pop	bc		;53c5
	pop	de		;53c6
	push	de		;53c7
	push	bc		;53c8
	ld	hl,0		;53c9
l53cch:
	ld	a,(de)		;53cc
	inc	de		;53cd
	cp	020h		;53ce
	jr	z,l53cch	;53d0
	cp	009h		;53d2
	jr	z,l53cch	;53d4
	dec	de		;53d6
	cp	02dh		;53d7
	jr	z,l53e0h	;53d9
	cp	02bh		;53db
	jr	nz,l53e1h	;53dd
	or	a		;53df
l53e0h:
	inc	de		;53e0
l53e1h:
	ex	af,af'		;53e1
l53e2h:
	ld	a,(de)		;53e2
	inc	de		;53e3
	call	digit		;53e4
	jr	c,l53f5h	;53e7
	add	hl,hl		;53e9
	ld	c,l		;53ea
	ld	b,h		;53eb
	add	hl,hl		;53ec
	add	hl,hl		;53ed
	add	hl,bc		;53ee
	ld	c,a		;53ef
	ld	b,0		;53f0
	add	hl,bc		;53f2
	jr	l53e2h		;53f3
l53f5h:
	ex	af,af'		;53f5
	ret	nz		;53f6
	ex	de,hl		;53f7
	ld	hl,0		;53f8
	sbc	hl,de		;53fb
	ret			;53fd

; =============== F U N C T I O N =======================================
;
;
_index:
	call	rcsv		;53fe
	jr	l5404h		;5401
l5403h:
	inc	hl		;5403
l5404h:
	ld	a,(hl)		;5404
	or	a		;5405
	jr	z,l540eh	;5406

	cp	e		;5408
	jr	nz,l5403h	;5409
l540bh:
	jp	cret		;540b
l540eh:
	ld	hl,0		;540e
	jr	l540bh		;5411

; =============== F U N C T I O N =======================================
; iregset
;
iregset:
	ld	e,(hl)		;5413
	inc	hl		;5414
	ld	d,(hl)		;5415
	inc	hl		;5416
	ld	c,(hl)		;5417
	inc	hl		;5418
	ld	b,(hl)		;5419
	ex	(sp),hl		;541a
	push	bc		;541b
	ex	(sp),hl		;541c
	pop	bc		;541d
	exx			;541e
	pop	hl		;541f
	pop	bc		;5420
	pop	de		;5421
	ex	(sp),hl		;5422
	push	bc		;5423
	ex	(sp),hl		;5424
	pop	bc		;5425
	ex	(sp),hl		;5426
	push	hl		;5427
	push	bc		;5428
	push	de		;5429
	exx			;542a
	push	bc		;542b
	ret			;542c

; =============== F U N C T I O N =======================================
; iregstore
;
iregstore:
	ex	(sp),hl		;542d
	pop	bc		;542e
	ld	(hl),b		;542f
	dec	hl		;5430
	ld	(hl),c		;5431
	dec	hl		;5432
	ld	(hl),d		;5433
	dec	hl		;5434
	ld	(hl),e		;5435
	push	bc		;5436
	pop	hl		;5437
	ret			;5438

; =============== F U N C T I O N =======================================
;
;
aladd:
lladd:
    exx		    ;5439
    pop hl	    ;543a
    exx		    ;543b
    pop bc	    ;543c
    ex de,hl	    ;543d
    add hl,bc	    ;543e
    ex de,hl	    ;543f
    pop bc	    ;5440
    adc hl,bc	    ;5441
    exx		    ;5443
    push hl	    ;5444
    exx		    ;5445
    ret		    ;5446

; =============== F U N C T I O N =======================================
; brelop
;
brelop:
    push de	    ;5447
    ld e,a	    ;5448
    xor b	    ;5449
    jp m,l5451h	    ;544a
    ld a,e	    ;544d
    sbc a,b	    ;544e
    pop de	    ;544f
    ret		    ;5450
l5451h:
    ld a,e	    ;5451
    and 080h	    ;5452
    ld d,a	    ;5454
    ld a,e	    ;5455
    sbc a,b	    ;5456
    ld a,d	    ;5457
    inc a	    ;5458
    pop de	    ;5459
    ret		    ;545a

; =============== F U N C T I O N =======================================
; wrelop
;
wrelop:
    ld a,h	    ;545b
    xor d	    ;545c
    jp m,l5463h	    ;545d
    sbc hl,de	    ;5460
    ret		    ;5462
l5463h:
    ld a,h	    ;5463
    and 080h	    ;5464
    sbc hl,de	    ;5466
    inc a	    ;5468
    ret		    ;5469

; =============== F U N C T I O N =======================================
;
;
arelop:
lrelop:
    exx		    ;546a
    pop hl	    ;546b
    exx		    ;546c
    pop bc	    ;546d
    ex de,hl	    ;546e
    ex (sp),hl	    ;546f
    ex de,hl	    ;5470
    ld a,h	    ;5471
    xor d	    ;5472
    jp p,l547ch	    ;5473
    ld a,h	    ;5476
    or 001h	    ;5477
    pop hl	    ;5479
    jr l548bh	    ;547a
l547ch:
    or a	    ;547c
    sbc hl,de	    ;547d
    pop hl	    ;547f
    jr nz,l548bh    ;5480
    sbc hl,bc	    ;5482
    jr z,l548bh	    ;5484
    ld a,002h	    ;5486
    rra		    ;5488
    or a	    ;5489
    rlca	    ;548a
l548bh:
    exx		    ;548b
    jp (hl)	    ;548c

; =============== F U N C T I O N =======================================
;
;
alsub
llsub:
    exx		    ;548d
    pop hl	    ;548e
    exx		    ;548f
    pop bc	    ;5490
    ex de,hl	    ;5491
    or a	    ;5492
    sbc hl,bc	    ;5493
    ex de,hl	    ;5495
    pop bc	    ;5496
    sbc hl,bc	    ;5497
    exx		    ;5499
    push hl	    ;549a
    exx		    ;549b
    ret		    ;549c

; =============== F U N C T I O N =======================================
;   16 bit divide and modulus routines
; called with dividend in hl and divisor in de
; returns with result in hl.
;
; adiv (amod) is signed divide (modulus), ldiv (lmod) is unsigned
;
amod:
    call adiv	    ;549d
    ex de,hl	    ;54a0
    ret		    ;54a1

;
;
lmod:
    call ldiv	    ;54a2
    ex de,hl	    ;54a5
    ret		    ;54a6

;
;
ldiv:
    xor a	    ;54a7
    ex af,af'	    ;54a8
    ex de,hl	    ;54a9
    jr l54b7h	    ;54aa

;
;
adiv:
    ld a,h	    ;54ac
    xor d	    ;54ad
    ld a,h	    ;54ae
    ex af,af'	    ;54af
    call l_negif    ;54b0
    ex de,hl	    ;54b3
    call l_negif    ;54b4
l54b7h:
    ld b,001h	    ;54b7
    ld a,h	    ;54b9
    or l	    ;54ba
    ret z	    ;54bb
l54bch:
    push hl	    ;54bc
    add hl,hl	    ;54bd
    jr c,l54ceh	    ;54be
    ld a,d	    ;54c0
    cp h	    ;54c1
    jr c,l54ceh	    ;54c2
    jr nz,l54cah    ;54c4
    ld a,e	    ;54c6
    cp l	    ;54c7
    jr c,l54ceh	    ;54c8
l54cah:
    pop af	    ;54ca
    inc b	    ;54cb
    jr l54bch	    ;54cc
l54ceh:
    pop hl	    ;54ce
    ex de,hl	    ;54cf
    push hl	    ;54d0
    ld hl,0	    ;54d1
    ex (sp),hl	    ;54d4
l54d5h:
    ld a,h	    ;54d5
    cp d	    ;54d6
    jr c,l54e1h	    ;54d7
    jr nz,l54dfh    ;54d9
    ld a,l	    ;54db
    cp e	    ;54dc
    jr c,l54e1h	    ;54dd
l54dfh:
    sbc hl,de	    ;54df
l54e1h:
    ex (sp),hl	    ;54e1
    ccf		    ;54e2
    adc hl,hl	    ;54e3
    srl d	    ;54e5
    rr e	    ;54e7
    ex (sp),hl	    ;54e9
    djnz l54d5h	    ;54ea
    pop de	    ;54ec
    ex de,hl	    ;54ed
    ex af,af'	    ;54ee
    call m,l_negat  ;54ef
    ex de,hl	    ;54f2
    or a	    ;54f3
    call m,l_negat  ;54f4
    ex de,hl	    ;54f7
    ret		    ;54f8

l_negif:
    bit 7,h	    ;54f9
    ret z	    ;54fb
l_negat:
    ld b,h	    ;54fc
    ld c,l	    ;54fd
    ld hl,0	    ;54fe
    or a	    ;5501
    sbc hl,bc	    ;5502
    ret		    ;5504

; =============== F U N C T I O N =======================================
;
;
__pnum:
	call	ncsv		;5505
	dw	0FFE1H	;-31	;5508
	ld	a,(ix+00ah)	;550a
	ld	e,a		;550d
	rla			;550e
	sbc	a,a		;550f
	ld	d,a		;5510
	ld	hl,0001eh	;5511
	call	wrelop		;5514
	jp	p,l551eh	;5517
    
	ld	(ix+00ah),01eh	;551a
l551eh:
	ld	a,(ix+00eh)	;551e
	or	a		;5521
	jr	z,l5554h	;5522
    
	bit	7,(ix+9)	;5524
	jr	z,l5554h	;5528

	ld	e,(ix+6)	;552a
	ld	d,(ix+7)	;552d
	ld	l,(ix+8)	;5530
	ld	h,(ix+9)	;5533
	push	hl		;5536
	push	de		;5537
	ld	hl,0		;5538
	pop	bc		;553b
	or	a		;553c
	sbc	hl,bc		;553d
	pop	bc		;553f
	ex	de,hl		;5540
	ld	hl,0		;5541
	sbc	hl,bc		;5544
	ld	(ix+6),e	;5546
	ld	(ix+7),d	;5549
	ld	(ix+8),l	;554c
	ld	(ix+9),h	;554f
	jr	l5558h		;5552
l5554h:
	ld	(ix+00eh),0	;5554
l5558h:
	ld	a,(ix+00ah)	;5558
	or	a		;555b
	jr	nz,l556fh	;555c

	ld	a,(ix+6)	;555e
	or	(ix+7)		;5561
	or	(ix+8)		;5564
	or	(ix+9)		;5567
	jr	nz,l556fh	;556a
	inc	(ix+00ah)	;556c
l556fh:
	push	ix		;556f
	pop	de		;5571
	ld	hl,-1		;5572
	add	hl,de		;5575
	push	hl		;5576
	pop	iy		;5577
	jr	l55b9h		;5579
l557bh:
	ld	a,(ix+010h)	;557b
	ld	hl,0		;557e
	ld	d,l		;5581
	ld	e,a		;5582
	push	hl		;5583
	push	de		;5584
	ld	e,(ix+6)	;5585
	ld	d,(ix+7)	;5588
	ld	l,(ix+8)	;558b
	ld	h,(ix+9)	;558e
	call	llmod		;5591
	ex	de,hl		;5594
	ld	de,l6610h	;5595
	add	hl,de		;5598
	ld	l,(hl)		;5599
	ld	de,-1		;559a
	add	iy,de		;559d
	ld	(iy+0),l	;559f
	ld	a,(ix+010h)	;55a2
	ld	hl,0		;55a5
	ld	d,l		;55a8
	ld	e,a		;55a9
	push	hl		;55aa
	push	de		;55ab
	push	ix		;55ac
	pop	de		;55ae
	ld	hl,6		;55af
	add	hl,de		;55b2
	call	aslldiv		;55b3
	dec	(ix+00ah)	;55b6
l55b9h:
	ld	a,(ix+6)	;55b9
	or	(ix+7)		;55bc
	or	(ix+8)		;55bf
	or	(ix+9)		;55c2
	jr	nz,l557bh	;55c5

	ld	a,(ix+00ah)	;55c7
	ld	e,a		;55ca
	rla			;55cb
	sbc	a,a		;55cc
	ld	d,a		;55cd
	ld	hl,0		;55ce
	call	wrelop		;55d1
	jp	m,l557bh	;55d4

	push	ix		;55d7
	pop	de		;55d9
	ld	hl,-1		;55da
	add	hl,de		;55dd
	push	iy		;55de
	pop	de		;55e0
	or	a		;55e1
	sbc	hl,de		;55e2
	ld	e,(ix+00eh)	;55e4
	ld	d,0		;55e7
	add	hl,de		;55e9
	ld	(ix+00ah),l	;55ea
	ld	(ix-1),l	;55ed
	ld	e,(ix+00ch)	;55f0
	ld	l,(ix-1)	;55f3
	ld	h,d		;55f6
	call	wrelop		;55f7
	jr	nc,l5612h	;55fa
	ld	a,(ix+00ch)	;55fc
	ld	(ix-1),a	;55ff
	jr	l5612h		;5602
l5604h:
	ld	hl,00020h	;5604
	push	hl		;5607
	ld	l,(ix+012h)	;5608
	ld	h,(ix+013h)	;560b
	call	indir		;560e
	pop	bc		;5611
l5612h:
	ld	b,(ix+00ch)	;5612
	dec	(ix+00ch)	;5615
	ld	a,(ix+00ah)	;5618
	call	brelop		;561b
	jp	m,l5604h	;561e

	ld	a,(ix+00eh)	;5621
	or	a		;5624
	jr	z,l564eh	;5625

	ld	hl,0002dh	;5627
	push	hl		;562a
	ld	l,(ix+012h)	;562b
	ld	h,(ix+013h)	;562e
	call	indir		;5631
	pop	bc		;5634
	dec	(ix+00ah)	;5635
	jr	l564eh		;5638
l563ah:
	ld	a,(iy+0)	;563a
	inc	iy		;563d
	ld	l,a		;563f
	rla			;5640
	sbc	a,a		;5641
	ld	h,a		;5642
	push	hl		;5643
	ld	l,(ix+012h)	;5644
	ld	h,(ix+013h)	;5647
	call	indir		;564a
	pop	bc		;564d
l564eh:
	ld	a,(ix+00ah)	;564e
	dec	(ix+00ah)	;5651
	or	a		;5654
	jr	nz,l563ah	;5655
    
	ld	l,(ix-1)	;5657
	ld	h,0		;565a
	jp	cret	    `	;565c

; =============== F U N C T I O N =======================================
;
lregset:
	pop	bc		;565f
	exx			;5660
	pop	bc		;5661
	pop	de		;5662
	exx			;5663
	ex	de,hl		;5664
	ex	(sp),hl		;5665
	ex	de,hl		;5666
	exx			;5667
	push	bc		;5668
	pop	hl		;5669
	ex	(sp),hl		;566a
	exx			;566b
	push bc			;566c
	ret			;566d
;
iregset:
	pop	de		;566e
	call	lregset		;566f
	push	hl		;5672
	ex	(sp),iy		;5673
	ld	h,(iy+3)	;5675
	ld	l,(iy+2)	;5678
	exx	    ;567b
	push	hl		;567c
	ld	h,(iy+1)	;567d
	ld	l,(iy+0)	;5680
	exx			;5683
	ret			;5684

; =============== F U N C T I O N =======================================
;
;
sgndiv:
	call	negif		;5685
	exx			;5688
	ex	de,hl		;5689
	exx			;568a
	ex	de,hl		;568b
	call	negif		;568c
	ex	de,hl		;568f
	exx			;5690
	ex	de,hl		;5691
	exx			;5692
	jp	divide		;5693
;
asaldiv:
	call	iregset		;5696
	call	dosdiv		;5699
;
store:
	ld	(iy+0),e	;569c
	ld	(iy+1),d	;569f
	ld	(iy+2),l	;56a2
	ld	(iy+3),h	;56a5
	pop	iy		;56a8
	ret			;56aa

; =============== F U N C T I O N =======================================
;
;
aldiv:
    call lregset    ;56ab
;
dosdiv:
    ld a,h	    ;56ae
    xor d	    ;56af
    ex af,af'	    ;56b0
    call sgndiv	    ;56b1
    ex af,af'	    ;56b4
    push bc	    ;56b5
    exx		    ;56b6
    pop hl	    ;56b7
    ld e,c	    ;56b8
    ld d,b	    ;56b9
    jp m,negat	    ;56ba
    ret		    ;56bd
lldiv:
    call lregset    ;56be
;
doudiv:
    call divide	    ;56c1
    push bc	    ;56c4
    exx		    ;56c5
    pop hl	    ;56c6
    ld e,c	    ;56c7
    ld d,b	    ;56c8
    ret		    ;56c9

; =============== F U N C T I O N =======================================
;
aslldiv:
    call iregset    ;56ca
    call doudiv	    ;56cd
    jr store	    ;56d0

    call lregset    ;56d2
;
dosrem:
    ld a,h	    ;56d5
    ex af,af'	    ;56d6
    call sgndiv	    ;56d7
    push hl	    ;56da
    exx		    ;56db
    pop de	    ;56dc
    ex de,hl	    ;56dd
    ex af,af'	    ;56de
    or a	    ;56df
    jp m,negat	    ;56e0
    ret		    ;56e3
; =============== F U N C T I O N =======================================
;
asalmod:    
    call iregset    ;56e4
    call dosrem	    ;56e7
    jr store	    ;56ea

; =============== F U N C T I O N =======================================
;
;
llmod:
    call lregset    ;56ec
;
dourem:
    call divide	    ;56ef
    push hl	    ;56f2
    exx		    ;56f3
    pop de	    ;56f4
    ex de,hl	    ;56f5
    ret		    ;56f6

; =============== F U N C T I O N =======================================
;
asllmod:
    call iregset    ;56f7
    call dourem	    ;56fa
    jr store	    ;56fd

; =============== F U N C T I O N =======================================
;
; Negate the long in HL/DE
;
negat:
    push hl	    ;56ff
    ld hl,0	    ;5700
    or a	    ;5703
    sbc hl,de	    ;5704
    ex de,hl	    ;5706
    pop bc	    ;5707
    ld hl,0	    ;5708
    sbc hl,bc	    ;570b
    ret		    ;570d

; =============== F U N C T I O N =======================================
;
; called with high word in HL, low word in HL'
; returns with positive value
;
negif:
    bit 7,h	    ;570e
    ret z	    ;5710
    exx		    ;5711
    ld c,l	    ;5712
    ld b,h	    ;5713
    ld hl,0	    ;5714
    or a	    ;5717
    sbc hl,bc	    ;5718
    exx		    ;571a
    ld c,l	    ;571b
    ld b,h	    ;571c
    ld hl,0	    ;571d
    sbc hl,bc	    ;5720
    ret		    ;5722

; =============== F U N C T I O N =======================================
; Called with dividend in HL/HL', divisor in DE/DE', high words in
; selected register set
; returns with quotient in BC/BC', remainder in HL/HL', high words
; selected
;
divide:
    ld bc,0	    ;5723
    ld a,e	    ;5726
    or d	    ;5727
    exx		    ;5728
    ld bc,0	    ;5729
    or e	    ;572c
    or d	    ;572d
    exx		    ;572e
    ret z	    ;572f
    ld a,001h	    ;5730
    jr l574dh	    ;5732
l5734h:
    push hl	    ;5734
    exx		    ;5735
    push hl	    ;5736
    or a	    ;5737
    sbc hl,de	    ;5738
    exx		    ;573a
    sbc hl,de	    ;573b
    exx		    ;573d
    pop hl	    ;573e
    exx		    ;573f
    pop hl	    ;5740
    jr c,l5751h	    ;5741
    exx		    ;5743
    inc a	    ;5744
    ex de,hl	    ;5745
    add hl,hl	    ;5746
    ex de,hl	    ;5747
    exx		    ;5748
    ex de,hl	    ;5749
    adc hl,hl	    ;574a
    ex de,hl	    ;574c
l574dh:
    bit 7,d	    ;574d
    jr z,l5734h	    ;574f
l5751h:
    push hl	    ;5751
    exx		    ;5752
    push hl	    ;5753
    or a	    ;5754
    sbc hl,de	    ;5755
    exx		    ;5757
    sbc hl,de	    ;5758
    exx		    ;575a
    jr nc,l5763h    ;575b
    pop hl	    ;575d
    exx		    ;575e
    pop hl	    ;575f
    exx		    ;5760
    jr l5767h	    ;5761
l5763h:
    inc sp	    ;5763
    inc sp	    ;5764
    inc sp	    ;5765
    inc sp	    ;5766
l5767h:
    ccf		    ;5767
    rl c	    ;5768
    rl b	    ;576a
    exx		    ;576c
    rl c	    ;576d
    rl b	    ;576f
    srl d	    ;5771
    rr e	    ;5773
    exx		    ;5775
    rr d	    ;5776
    rr e	    ;5778
    exx		    ;577a
    dec a	    ;577b
    jr nz,l5751h    ;577c
    ret		    ;577e

; =============== F U N C T I O N =======================================
;
; movmem
;
movmem:
bmove:
    pop hl	    ;577f
    exx		    ;5780
    pop hl	    ;5781
    pop de	    ;5782
    pop bc	    ;5783
    ld a,b	    ;5784
    or c	    ;5785
    jr z,l578ah	    ;5786
    ldir	    ;5788
l578ah:
    push bc	    ;578a
    push de	    ;578b
    push hl	    ;578c
    exx		    ;578d
    jp (hl)	    ;578e

; =============== F U N C T I O N =======================================
; 16 bit integer multiply	hl*de
; on entry, left operand is in hl, right operand in de
;
amul:
lmul:
    ld a,e	    ;578f
    ld c,d	    ;5790
    ex de,hl	    ;5791
    ld hl,0	    ;5792
    ld b,008h	    ;5795
    call mult8b	    ;5797
    ex de,hl	    ;579a
    jr l579eh	    ;579b
l579dh:
    add hl,hl	    ;579d
l579eh:
    djnz l579dh	    ;579e
    ex de,hl	    ;57a0
    ld a,c	    ;57a1

; =============== F U N C T I O N =======================================
;
; mult8b:
;
mult8b:
    srl a	    ;57a2
    jr nc,l57a7h    ;57a4
    add hl,de	    ;57a6
l57a7h:
    ex de,hl	    ;57a7
    add hl,hl	    ;57a8
    ex de,hl	    ;57a9
    ret z	    ;57aa
    djnz mult8b	    ;57ab
    ret		    ;57ad

; =============== F U N C T I O N =======================================
; arithmetic long right shift
; value in HLDE, count in B
;
alrsh:
    ld a,b	    ;57ae
    or a	    ;57af
    ret z	    ;57b0
    cp 021h	    ;57b1
    jr c,l57b7h	    ;57b3
    ld b,020h	    ;57b5
l57b7h:
    sra h	    ;57b7
    rr l	    ;57b9
    rr d	    ;57bb
    rr e	    ;57bd
    djnz l57b7h	    ;57bf
    ret		    ;57c1

; =============== F U N C T I O N =======================================
;
; NB This brk() does not check that the argument is reasonable.
;
brk:
    pop hl	    ;57c2
    pop de	    ;57c3
    ld (memtop),de  ;57c4
    push de	    ;57c8
    jp (hl)	    ;57c9

; =============== F U N C T I O N =======================================
;
; sbrk
;
sbrk:
    pop bc	    ;57ca
    pop de	    ;57cb
    push de	    ;57cc
    push bc	    ;57cd
    ld hl,(memtop)  ;57ce
    ld a,l	    ;57d1
    or h	    ;57d2
    jr nz,l57dbh    ;57d3
    ld hl,__Hbss    ;57d5
    ld (memtop),hl  ;57d8
l57dbh:
    add hl,de	    ;57db
    jr c,l57e8h	    ;57dc
    ld bc,400h	    ;57de
    add hl,bc	    ;57e1
    jr c,l57e8h	    ;57e2
    sbc hl,sp	    ;57e4
    jr c,l57ech	    ;57e6
l57e8h:
    ld hl,-1	    ;57e8
    ret		    ;57eb
l57ech:
    ld hl,(memtop)  ;57ec
    push hl	    ;57ef
    add hl,de	    ;57f0
    ld (memtop),hl  ;57f1
    pop hl	    ;57f4
    ret		    ;57f5

; =============== F U N C T I O N =======================================
;
; checksp
;
checksp:
    ld hl,(memtop)  ;57f6
    ld bc,80h	    ;57f9
    add hl,bc	    ;57fc
    sbc hl,sp	    ;57fd
    ld hl,1	    ;57ff
    ret c	    ;5802
    dec hl	    ;5803
    ret		    ;5804

; =============== F U N C T I O N =======================================
; shift arithmetic right
;
; Shift operations - the count is always in B,
; the quantity to be shifted is in HL, except for the assignment 
; type operations, when it is in the memory location pointed to by HL
shar:
    ld a,b	    ;5805
    or a	    ;5806
    ret z	    ;5807
    cp 010h	    ;5808
    jr c,loc_580e   ;580a
    ld b,010h	    ;580c
loc_580e:
    sra h	    ;580e
    rr l	    ;5810
    djnz loc_580e   ;5812
    ret		    ;5814

; =============== S U	B R O U T I N E =======================================
; shift left, arithmetic or logical <<
;
; Shift operations - the count is always in B,
; the quantity to be shifted is in HL, except for the assignment
; type operations, when it is in the memory location pointed to by HL
shal:
shll:
    ld a,b	    ;5815
    or a	    ;5816
    ret z	    ;5817
    cp 010h	    ;5818
    jr c,loc_581e   ;581a
    ld b,010h	    ;581c
loc_581e:
    add hl,hl	    ;581e
    djnz loc_581e   ;581f
    ret		    ;5821

; =============== F U N C T I O N =======================================
;
; strcat
;
strcat:
    pop bc	    ;5822
    pop de	    ;5823
    pop hl	    ;5824
    push hl	    ;5825
    push de	    ;5826
    push bc	    ;5827
    ld c,e	    ;5828
    ld b,d	    ;5829
loc_582a:
    ld a,(de)	    ;582a
    or a	    ;582b
    jr z,loc_5831   ;582c
    inc de	    ;582e
    jr loc_582a	    ;582f
loc_5831:
    ld a,(hl)	    ;5831
    ld (de),a	    ;5832
    or a	    ;5833
    jr z,loc_583a   ;5834
    inc de	    ;5836
    inc hl	    ;5837
    jr loc_5831	    ;5838
loc_583a:
    ld l,c	    ;583a
    ld h,b	    ;583b
    ret		    ;583c

; =============== F U N C T I O N =======================================
;
; strcmp
;
strcmp:
    pop bc	    ;583d
    pop de	    ;583e
    pop hl	    ;583f
    push hl	    ;5840
    push de	    ;5841
    push bc	    ;5842
loc_5843:
    ld a,(de)	    ;5843
    cp (hl)	    ;5844
    jr nz,loc_5850  ;5845
    inc de	    ;5847
    inc hl	    ;5848
    or a	    ;5849
    jr nz,loc_5843  ;584a
    ld hl,0	    ;584c
    ret		    ;584f
loc_5850:
    ld hl,1	    ;5850
    ret nc	    ;5853
    dec hl	    ;5854
    dec hl	    ;5855
    ret		    ;5856

; =============== F U N C T I O N =======================================
;
; strcpy
;
strcpy:
    pop bc	    ;5857
    pop de	    ;5858
    pop hl	    ;5859
    push hl	    ;585a
    push de	    ;585b
    push bc	    ;585c
    ld c,e	    ;585d
    ld b,d	    ;585e
loc_585f:
    ld a,(hl)	    ;585f
    ld (de),a	    ;5860
    inc de	    ;5861
    inc hl	    ;5862
    or a	    ;5863
    jr nz,loc_585f  ;5864
    ld l,c	    ;5866
    ld h,b	    ;5867
    ret		    ;5868

; =============== F U N C T I O N =======================================
;
; strlen
;
strlen:
    pop hl	    ;5869
    pop de	    ;586a
    push de	    ;586b
    push hl	    ;586c
    ld hl,0	    ;586d
loc_5870:
    ld a,(de)	    ;5870
    or a	    ;5871
    ret z	    ;5872
    inc hl	    ;5873
    inc de	    ;5874
    jr loc_5870	    ;5875

; =============== F U N C T I O N =======================================
;
; csv
;
csv:
    pop hl	    ;5877
    push iy	    ;5878
    push ix	    ;587a
    ld ix,0	    ;587c
    add ix,sp	    ;5880
    jp (hl)	    ;5882
; =============== F U N C T I O N =======================================
;
; cret
;
cret:
    ld sp,ix	    ;5883
    pop ix	    ;5885
    pop iy	    ;5887
    ret		    ;5889

; =============== F U N C T I O N =======================================
;
; indir
;
indir:
    jp (hl)	    ;588a

; =============== F U N C T I O N =======================================
; New csv: allocates space for stack based on word following
;	   call ncsv
;
ncsv:
    pop hl	    ;588b
    push iy	    ;588c
    push ix	    ;588e
    ld ix,0	    ;5890
    add ix,sp	    ;5894
    ld e,(hl)	    ;5896
    inc hl	    ;5897
    ld d,(hl)	    ;5898
    inc hl	    ;5899
    ex de,hl	    ;589a
    add hl,sp	    ;589b
    ld sp,hl	    ;589c
    ex de,hl	    ;589d
    jp (hl)	    ;589e

; =============== F U N C T I O N =======================================
; rcsv saves ix and iy and sets up ix to point to the local stack frame,
; then loads the first two words of the arguments into HL and DE respectively.
;
rcsv:
    ex (sp),iy	    ;589f
    push ix	    ;58a1
    ld ix,0	    ;58a3
    add ix,sp	    ;58a7
    ld l,(ix+6)	    ;58a9
    ld h,(ix+7)	    ;58ac
    ld e,(ix+8)	    ;58af
    ld d,(ix+9)	    ;58b2
    ld c,(ix+0ah)   ;58b5
    ld b,(ix+0bh)   ;58b8
    jp (iy)	    ;58bb

; =============== D A T A ===================================================
;
data:


data_58bd_start:
    defb 000h	    ;58bd

word_58be:
    defb 025h	    ;58be; '%'
    defb 067h	    ;58bf; 'g'

byte_58c0:
    defb 0feh	    ;58c0

word_58c1:
    defb 0efh	    ;58c1
    defb 063h	    ;58c2

word_58c3:
    defb 0f7h	    ;58c3
    defb 063h	    ;58c4

word_58c5:
    defb 001h	    ;58c5
    defb 000h	    ;58c6

word_58c7:
    defb 0beh	    ;58c7
    defb 09dh	    ;58c8

word_58c9:
    defb 0feh	    ;58c9
    defb 0a5h	    ;58ca

word_58cb:
    defb 000h	    ;58cb
    defb 000h	    ;58cc

l58cdh:			; branch table 124
    defw l0490h	    ;58cd ; 0	; NUL	; case	0:			goto l0490h;
    defw l04ddh	    ;58cf ; 1	; SOH	; case	1:   2:   3:   4:   5:   6:   7:   8:   9:  11:
    defw l04ddh	    ;58d1 ; 2	; STX	;      12:  13:  14:  15:  16:  17:  18:  19:  20:  21:
    defw l04ddh	    ;58d3 ; 3	; ETX	;      22:  23:  24:  25:  26:  27:  28:  29:  30:  31:
    defw l04ddh	    ;58d5 ; 4	; EOT	;      32:  35:  36:  37:  40:  41:  42:  43:  44:  45:
    defw l04ddh	    ;58d7 ; 5	; ENQ	;      46:  58:  59:  63:  64:  91:  93:  94:  96: 123:  goto l04ddh;
    defw l04ddh	    ;58d9 ; 6	; ACK	;
    defw l04ddh	    ;58db ; 7	; BEL	;
    defw l04ddh	    ;58dd ; 8	; BS	;
    defw l04ddh	    ;58df ; 9	; TAB	;
    defw l080ch	    ;58e1 ; 10	; LF	; case '\n':			goto l080ch;
    defw l04ddh	    ;58e3 ; 11	; VT	; case '!': '=':		goto l0511h;
    defw l04ddh	    ;58e5 ; 12	; FF	;
    defw l04ddh	    ;58e7 ; 13	; CR	; case '\"', '\'':		goto l0782h;
    defw l04ddh	    ;58e9 ; 14	; SO	;
    defw l04ddh	    ;58eb ; 15	; SI	; case '&', '|':		goto l04eah;
    defw l04ddh	    ;58ed ; 16	; DLE	;
    defw l04ddh	    ;58ef ; 17	; DC1	; case	'/':			goto l075fh;
    defw l04ddh	    ;58f1 ; 18	; DC2	;
    defw l04ddh	    ;58f3 ; 19	; DC3	; case	48-57:			goto l0852h;
    defw l04ddh	    ;58f5 ; 20	; DC4	;
    defw l04ddh	    ;58f7 ; 21	; NAK	; case	'<', '>':		goto l0536h;
    defw l04ddh	    ;58f9 ; 22	; SYN	;
    defw l04ddh	    ;58fb ; 23	; ETB	; case	65-90, '_', 97-122:	goto l0880h
    defw l04ddh	    ;58fd ; 24	; CAN	;
    defw l04ddh	    ;58ff ; 25	; EM	; case	'\\':			goto l057dh;
    defw l04ddh	    ;5901 ; 26	; SUB	;
    defw l04ddh	    ;5903 ; 27	; ESC   ;
    defw l04ddh	    ;5905 ; 28	; FS	;
    defw l04ddh	    ;5907 ; 29	; GS	;
    defw l04ddh	    ;5909 ; 30	; RS'	;
    defw l04ddh	    ;590b ; 31	; US	;
    defw l04ddh	    ;590d ; 32	; ' ' 	;
    defw l0511h	    ;590f ; 33	; '!'	;
    defw l0782h	    ;5911 ; 34	; '"'	;
    defw l04ddh	    ;5913 ; 35	; '#'	;
    defw l04ddh	    ;5915 ; 36	; '$'	;
    defw l04ddh	    ;5917 ; 37	; '%'	;
    defw l04eah	    ;5919 ; 38	; '&'	;
    defw l0782h	    ;591b ; 39	; '''	;
    defw l04ddh	    ;591d ; 40	; '('	;
    defw l04ddh	    ;591f ; 41	; ')'	;
    defw l04ddh	    ;5921 ; 42	; '*'	;
    defw l04ddh	    ;5923 ; 43	; '+'	;
    defw l04ddh	    ;5925 ; 44	; ','	;
    defw l04ddh	    ;5927 ; 45	; '-'	;
    defw l04ddh	    ;5929 ; 46	; '.'	;
    defw l075fh	    ;592b ; 47	; '/'	;
    defw l0852h	    ;592d ; 48	; '0'	;
    defw l0852h	    ;592f ; 49	; '1'	;
    defw l0852h	    ;5931 ; 50	; '2'	;
    defw l0852h	    ;5933 ; 51	; '3'	;
    defw l0852h	    ;5935 ; 52	; '4'	;
    defw l0852h	    ;5937 ; 53	; '5'	;
    defw l0852h	    ;5939 ; 54	; '6'	;
    defw l0852h	    ;593b ; 55	; '7'	;
    defw l0852h	    ;593d ; 56	; '8'	;
    defw l0852h	    ;593f ; 57	; '9'	;
    defw l04ddh	    ;5941 ; 58	; ':'	;
    defw l04ddh	    ;5943 ; 59	; ';'	;
    defw l0536h	    ;5945 ; 60	; '<'	;
    defw l0511h	    ;5947 ; 61	; '='	;
    defw l0536h	    ;5949 ; 62	; '>'	;
    defw l04ddh	    ;594b ; 63	; '?'	;
    defw l04ddh	    ;594d ; 64	; '@'	;
    defw l0880h	    ;594f ; 65	; 'A'	;
    defw l0880h	    ;5951 ; 66	; 'B'	;
    defw l0880h	    ;5953 ; 67	; 'C'	;
    defw l0880h	    ;5955 ; 68	; 'D'	;
    defw l0880h	    ;5957 ; 69	; 'E'	;
    defw l0880h	    ;5959 ; 70	; 'F'	;
    defw l0880h	    ;595b ; 71	; 'G'	;
    defw l0880h	    ;595d ; 72	; 'H'	;
    defw l0880h	    ;595f ; 73	; 'I'	;
    defw l0880h	    ;5961 ; 74	; 'J'	;
    defw l0880h	    ;5963 ; 75	; 'K'	;
    defw l0880h	    ;5965 ; 76	; 'L'	;
    defw l0880h	    ;5967 ; 77	; 'M'	;
    defw l0880h	    ;5969 ; 78	; 'N'	;
    defw l0880h	    ;596b ; 79	; 'O'	;
    defw l0880h	    ;596d ; 80	; 'P'	;
    defw l0880h	    ;596f ; 81	; 'Q'	;
    defw l0880h	    ;5971 ; 82	; 'R'	;
    defw l0880h	    ;5973 ; 83	; 'S'	;
    defw l0880h	    ;5975 ; 84	; 'T'	;
    defw l0880h	    ;5977 ; 85	; 'U'	;
    defw l0880h	    ;5979 ; 86	; 'V'	;
    defw l0880h	    ;597b ; 87	; 'W'	;
    defw l0880h	    ;597d ; 88	; 'X'	;
    defw l0880h	    ;597f ; 89	; 'Y'	;
    defw l0880h	    ;5981 ; 90	; 'Z'	;
    defw l04ddh	    ;5983 ; 91	; '['	;
    defw l057dh	    ;5985 ; 92	; '\'	;
    defw l04ddh	    ;5987 ; 93	; ']'	;
    defw l04ddh	    ;5989 ; 94	; '^'	;
    defw l0880h	    ;598b ; 95	; '_'	;
    defw l04ddh	    ;598d ; 96	; '`'	;
    defw l0880h	    ;598f ; 97	; 'a'	;
    defw l0880h	    ;5991 ; 98	; 'b'	;
    defw l0880h	    ;5993 ; 99	; 'c'	;
    defw l0880h	    ;5995 ; 100	; 'd'	;
    defw l0880h	    ;5997 ; 101	; 'e'	;
    defw l0880h	    ;5999 ; 102	; 'f'	;
    defw l0880h	    ;599b ; 103	; 'g'	;
    defw l0880h	    ;599d ; 104	; 'h'	;
    defw l0880h	    ;599f ; 105	; 'i'	;
    defw l0880h	    ;59a1 ; 106	; 'j'	;
    defw l0880h	    ;59a3 ; 107	; 'k'	;
    defw l0880h	    ;59a5 ; 108	; 'l'	;
    defw l0880h	    ;59a7 ; 109	; 'm'	;
    defw l0880h	    ;59a9 ; 110	; 'n'	;
    defw l0880h	    ;59ab ; 111	; 'o'	;
    defw l0880h	    ;59ad ; 112	; 'p'	;
    defw l0880h	    ;59af ; 113	; 'q'	;
    defw l0880h	    ;59b1 ; 114	; 'r'	;
    defw l0880h	    ;59b3 ; 115	; 's'	;
    defw l0880h	    ;59b5 ; 116	; 't'	;
    defw l0880h	    ;59b7 ; 117	; 'u'	;
    defw l0880h	    ;59b9 ; 118	; 'v'	;
    defw l0880h	    ;59bb ; 119	; 'w'	;
    defw l0880h	    ;59bd ; 120	; 'x'	;
    defw l0880h	    ;59bf ; 121	; 'y'	;
    defw l0880h	    ;59c1 ; 122	; 'z'	;
    defw l04ddh	    ;59c3 ; 123	; '{'	;
    defw l04eah	    ;59c5 ; 124 ; '|'	;

l59c7h: db  "%s: argument mismatch",0
l59ddh: db  "# %d \"%s\"\n", 0
l59e8h: db  "token too long",0
l59f7h: db  "%s: unterminated macro\tcall",0
l5a13h: db  "%s: too much pushback",0
l5a29h: db  "no space",0
l5a32h: db  "token too\tlong",0
l5a41h: db  "bad include syntax",0
l5a54h: db  "Unreasonable include nesting",0
l5a71h: db  "no/tspace",0
l5a7ah: db  "r",0
l5a7ch: db  "Can't find include file %s",0
l5a97h: db  "too much\tdefining",0
l5aa9h: db  "illegal\tmacro name",0
l5abch: db  "%s: missing )",0
l5acah: db  "bad formal: %s",0
l5ad9h: db  "too many formals: %s",0
l5aeeh: db  "%s redefined",0
l5afbh: db  "If-less endif",0
l5b09h: db  "If-less else",0
l5b16h: db  "undefined\tcontrol",0
l5b28h: db  " 1",0
l5b2bh: db  "%s: ",0
l5b30h: db  "%d: ",0
l5b35h: db  "\n",0
l5b37h: db  "too many defines",0
l5b48h: db  "%s: macro recursion",0
l5b5ch: db  "%d",0
l5b5fh: db  "\"%s\"",0
l5b64h: db  "%s: actuals too long",0
array_5b79: db  0
l5b7ah: db  "cpp",0
l5b7eh: db  "_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",0
l5bbeh: db  "0123456789.",0
l5bcah: db  "\n\"'/\",0
l5bd0h: db  "\n\"'\",0
l5bd5h: db  "*\n",0
l5bd8h: db  " \t\v\f\r",0
l5bdeh: db  "too many -D options, ignoring %s",0
l5bffh: db  "too many -U options, ignoring %s",0
l5c20h: db  "excessive -I\tfile (%s) ignored",0
l5c3fh: db  "unknown flag %s",0
l5c4fh: db  "r",0
l5c51h: db  "No source file\t%s",0
l5c63h: db  "w",0
l5c65h: db  "Can't create %s",0
l5c75h: db  "define",0
l5c7ch: db  "undef",0
l5c82h: db  "include",0
l5c8ah: db  "else",0
l5c8fh: db  "endif",0
l5c95h: db  "ifdef",0
l5c9bh: db  "ifndef",0
l5ca2h: db  "if",0
l5ca5h: db  "line",0
l5caah: db  "asm",0
l5caeh: db  "endasm",0
l5cb5h: db  "z80",0
l5cb9h: db  "__LINE__",0
l5cc2h: db  "__FILE__",0
l5ccbh: db  "command line",0
l5cd8h:	db  "CPP: Error closing output file\n",0

word_5cf8:	defw 0	    	;5cf8

array_5cfa:	defw l62beh	;5cfa	"||"
		defw l62c1h	;5cfc	"&&"
		defw l62c4h	;5cfe	">>"
		defw l62c7h	;5d00	"<<"
		defw l62cah	;5d02	">="
		defw l62cdh	;5d04	"<="
		defw l62d0h	;5d06 	"!="
		defw l62d3h	;5d08	"=="

array_5d0a:	defb 00bh	;5d0a
		defb 001h	;5d0b
		
		defb 00ah	;5d0c
		defb 001h	;5d0d
		
		defb 009h	;5d0e
		defb 001h	;5d0f
		
		defb 008h	;5d10
		defb 001h	;5d11
		
		defb 007h	;5d12
		defb 001h	;5d13
		
		defb 006h	;5d14
		defb 001h	;5d15
		
		defb 005h	;5d16
		defb 001h	;5d17
		
		defb 004h	;5d18
		defb 001h	;5d19

word_5d1a:	defw l62d6h	;5d1a

array_5d1c:
    defb 0ffh	    ;5d1c 0	-1,
    defb 0ffh	    ;5d1d
    
    defb 001h	    ;5d1e 1	1,
    defb 000h	    ;5d1f
    
    defb 000h	    ;5d20 2	0,
    defb 000h	    ;5d21
    
    defb 0ffh	    ;5d22 3	-1,
    defb 0ffh	    ;5d23
    
    defb 0feh	    ;5d24 4	0xfffe,
    defb 0ffh	    ;5d25
    
    defb 000h	    ;5d26 5	0,
    defb 000h	    ;5d27
    
    defb 0ffh	    ;5d28 6	-1,
    defb 0ffh	    ;5d29
    
    defb 02ch	    ;5d2a 7	0x2C,
    defb 000h	    ;5d2b
    
    defb 006h	    ;5d2c 8	0x106,
    defb 001h	    ;5d2d
    
    defb 000h	    ;5d2e 9	0,
    defb 000h	    ;5d2f
    
    defb 007h	    ;5d30 10	0x107,
    defb 001h	    ;5d31
    
    defb 000h	    ;5d32 11	0,
    defb 000h	    ;5d33
    
    defb 03ch	    ;5d34 12	0x3C,
    defb 000h	    ;5d35
    
    defb 000h	    ;5d36 13	0,
    defb 000h	    ;5d37
    
    defb 03eh	    ;5d38 14	0x3E,
    defb 000h	    ;5d39
    
    defb 000h	    ;5d3a 15	0,
    defb 000h	    ;5d3b
    
    defb 0feh	    ;5d3c 16	0xfffe,
    defb 0ffh	    ;5d3d
    
    defb 009h	    ;5d3e 17	9,
    defb 000h	    ;5d3f
    
    defb 0ffh	    ;5d40 18	-1,
    defb 0ffh	    ;5d41
    
    defb 02dh	    ;5d42 19	0x2D,
    defb 000h	    ;5d43
    
    defb 006h	    ;5d44 20	0x106,
    defb 001h	    ;5d45
    
    defb 000h	    ;5d46 21	0,
    defb 000h	    ;5d47
    
    defb 007h	    ;5d48 22	0x107,
    defb 001h	    ;5d49
    
    defb 000h	    ;5d4a 23	0,
    defb 000h	    ;5d4b
    
    defb 03ch	    ;5d4c 24	0x3C,
    defb 000h	    ;5d4d
    
    defb 000h	    ;5d4e 25	0,
    defb 000h	    ;5d4f
    
    defb 03eh	    ;5d50 26	0x3E,
    defb 000h	    ;5d51
    
    defb 000h	    ;5d52 27	0,
    defb 000h	    ;5d53
    
    defb 0feh	    ;5d54 28	0xfffe,
    defb 0ffh	    ;5d55
    
    defb 00ah	    ;5d56 29	10,
    defb 000h	    ;5d57
    
    defb 0ffh	    ;5d58 30	-1,
    defb 0ffh	    ;5d59
    
    defb 02eh	    ;5d5a 31	0x2E,
    defb 000h	    ;5d5b
    
    defb 006h	    ;5d5c 32	0x106,
    defb 001h	    ;5d5d
    
    defb 000h	    ;5d5e 33	0,
    defb 000h	    ;5d5f
    
    defb 007h	    ;5d60 34	0x107,
    defb 001h	    ;5d61
    
    defb 000h	    ;5d62 35	0,
    defb 000h	    ;5d63
    
    defb 03ch	    ;5d64 36	0x3C,
    defb 000h	    ;5d65
    
    defb 000h	    ;5d66 37	0,
    defb 000h	    ;5d67
    
    defb 03eh	    ;5d68 38	0x3E,
    defb 000h	    ;5d69
    
    defb 000h	    ;5d6a 39	0,
    defb 000h	    ;5d6b
    
    defb 0feh	    ;5d6c 40	0xfffe,
    defb 0ffh	    ;5d6d
    
    defb 00bh	    ;5d6e 41	11,
    defb 000h	    ;5d6f
    
    defb 0ffh	    ;5d70 42	-1,
    defb 0ffh	    ;5d71
    
    defb 02fh	    ;5d72 43	0x2F,
    defb 000h	    ;5d73
    
    defb 006h	    ;5d74 44	0x106,
    defb 001h	    ;5d75
    
    defb 000h	    ;5d76 45	0,
    defb 000h	    ;5d77
    
    defb 007h	    ;5d78 46	0x107,
    defb 001h	    ;5d79
    
    defb 000h	    ;5d7a 47	0,
    defb 000h	    ;5d7b
    
    defb 03ch	    ;5d7c 48	0x3C,
    defb 000h	    ;5d7d
    
    defb 000h	    ;5d7e 49	0,
    defb 000h	    ;5d7f
    
    defb 03eh	    ;5d80 50	0x3E,
    defb 000h	    ;5d81
    
    defb 000h	    ;5d82 51	0,
    defb 000h	    ;5d83
    
    defb 0feh	    ;5d84 52	0xfffe,
    defb 0ffh	    ;5d85
    
    defb 00ch	    ;5d86 53	0xC,
    defb 000h	    ;5d87
    
    defb 0ffh	    ;5d88 54	-1,
    defb 0ffh	    ;5d89
    
    defb 030h	    ;5d8a 55	0x30,
    defb 000h	    ;5d8b
    
    defb 004h	    ;5d8c 56	0x104,
    defb 001h	    ;5d8d
    
    defb 000h	    ;5d8e 57	0,
    defb 000h	    ;5d8f
    
    defb 005h	    ;5d90 58	0x105,
    defb 001h	    ;5d91
    
    defb 000h	    ;5d92 59	0,
    defb 000h	    ;5d93
    
    defb 0feh	    ;5d94 60	0xfffe,
    defb 0ffh	    ;5d95
    
    defb 00dh	    ;5d96 61	0xd,
    defb 000h	    ;5d97
    
    defb 0ffh	    ;5d98 62	-1,
    defb 0ffh	    ;5d99
    
    defb 031h	    ;5d9a 63	0x31,
    defb 000h	    ;5d9b
    
    defb 004h	    ;5d9c 64	0x104,
    defb 001h	    ;5d9d
    
    defb 000h	    ;5d9e 65	0,
    defb 000h	    ;5d9f
    
    defb 005h	    ;5da0 66	0x105,
    defb 001h	    ;5da1
    
    defb 000h	    ;5da2 67	0,
    defb 000h	    ;5da3
    
    defb 0feh	    ;5da4 68	0xfffe,
    defb 0ffh	    ;5da5
    
    defb 00eh	    ;5da6 69	0xE,
    defb 000h	    ;5da7




array_5da8:
    defb 00dh	    ;5da8	0xd,
    defb 000h	    ;5da9
    
    defb 018h	    ;5daa	0x18,
    defb 000h	    ;5dab
    
    defb 023h	    ;5dac	0x23,
    defb 000h	    ;5dad
    
    defb 03ah	    ;5dae	0x3a,
    defb 000h	    ;5daf
    
    defb 00dh	    ;5db0	0xd,
    defb 000h	    ;5db1
    
    defb 00bh	    ;5db2	0xb,
    defb 000h	    ;5db3
    
    defb 00eh	    ;5db4	0xe,
    defb 000h	    ;5db5
    
    defb 01eh	    ;5db6	0x1e,
    defb 000h	    ;5db7
    
    defb 00fh	    ;5db8	0xf,
    defb 000h	    ;5db9
    
    defb 00bh	    ;5dba	0xb,
    defb 000h	    ;5dbb
    
    defb 00ch	    ;5dbc	0xc,
    defb 000h	    ;5dbd
    
    defb 03ch	    ;5dbe	0x3c,
    defb 000h	    ;5dbf
    
    defb 00dh	    ;5dc0	0xd,
    defb 000h	    ;5dc1
    
    defb 018h	    ;5dc2	0x18,
    defb 000h	    ;5dc3
    
    defb 00ch	    ;5dc4	0xc,
    defb 000h	    ;5dc5
    
    defb 001h	    ;5dc6	1,
    defb 000h	    ;5dc7
    
    defb 039h	    ;5dc8	0x39,
    defb 000h	    ;5dc9
    
    defb 00bh	    ;5dca	0xb,
    defb 000h	    ;5dcb
    
    defb 00eh	    ;5dcc	0xe,
    defb 000h	    ;5dcd
    
    defb 01eh	    ;5dce	0x1e,
    defb 000h	    ;5dcf
    
    defb 00fh	    ;5dd0	0xf,
    defb 000h	    ;5dd1
    
    defb 03bh	    ;5dd2	0x3b,
    defb 000h	    ;5dd3
    
    defb 00ch	    ;5dd4	0xc,
    defb 000h	    ;5dd5
    
    defb 012h	    ;5dd6	0x12,
    defb 000h	    ;5dd7
    
    defb 00dh	    ;5dd8	0xd,
    defb 000h	    ;5dd9
    
    defb 013h	    ;5dda	0x13,
    defb 000h	    ;5ddb
    
    defb 01dh	    ;5ddc	0x1d,
    defb 000h	    ;5ddd
    
    defb 000h	    ;5dde	0,
    defb 000h	    ;5ddf
    
    defb 000h	    ;5de0	0,
    defb 000h	    ;5de1
    
    defb 00bh	    ;5de2	0xb,
    defb 000h	    ;5de3
    
    defb 00eh	    ;5de4	0xe,
    defb 000h	    ;5de5
    
    defb 000h	    ;5de6	0,
    defb 000h	    ;5de7
    
    defb 00fh	    ;5de8	0xf,
    defb 000h	    ;5de9
    
    defb 000h	    ;5dea	0,
    defb 000h	    ;5deb
    
    defb 00ch	    ;5dec	0xc,
    defb 000h	    ;5ded
    
    defb 012h	    ;5dee	0x12,
    defb 000h	    ;5def
    
    defb 003h	    ;5df0	3,
    defb 000h	    ;5df1
    
    defb 013h	    ;5df2	0x13,
    defb 000h	    ;5df3
    
    defb 01dh	    ;5df4	0x1d,
    defb 000h	    ;5df5
    
    defb 00dh	    ;5df6	0xd,
    defb 000h	    ;5df7
    
    defb 018h	    ;5df8	0x18,
    defb 000h	    ;5df9
    
    defb 01fh	    ;5dfa	0x1f,
    defb 000h	    ;5dfb
    
    defb 020h	    ;5dfc	0x20,
    defb 000h	    ;5dfd
    
    defb 021h	    ;5dfe	0x21,
    defb 000h	    ;5dff
    
    defb 00bh	    ;5e00	0xb,
    defb 000h	    ;5e01
    
    defb 00eh	    ;5e02	0xe,
    defb 000h	    ;5e03
    
    defb 01eh	    ;5e04	0x1e,
    defb 000h	    ;5e05
    
    defb 00fh	    ;5e06	0xf,
    defb 000h	    ;5e07
    
    defb 000h	    ;5e08	0,
    defb 000h	    ;5e09
    
    defb 00ch	    ;5e0a	0xc,
    defb 000h	    ;5e0b
    
    defb 00dh	    ;5e0c	0xd,
    defb 000h	    ;5e0d
    
    defb 018h	    ;5e0e	0x18,
    defb 000h	    ;5e0f
    
    defb 000h	    ;5e10	0,
    defb 000h	    ;5e11
    
    defb 000h	    ;5e12	0,
    defb 000h	    ;5e13
    
    defb 000h	    ;5e14	0,
    defb 000h	    ;5e15
    
    defb 00bh	    ;5e16	0xb,
    defb 000h	    ;5e17
    
    defb 00eh	    ;5e18	0xe,
    defb 000h	    ;5e19
    
    defb 019h	    ;5e1a	0x19,
    defb 000h	    ;5e1b
    
    defb 00fh	    ;5e1c	0xf,
    defb 000h	    ;5e1d
    
    defb 005h	    ;5e1e	5,
    defb 000h	    ;5e1f
    
    defb 00ch	    ;5e20	0xc,
    defb 000h	    ;5e21
    
    defb 000h	    ;5e22	0,
    defb 000h	    ;5e23
    
    defb 012h	    ;5e24	0x12,
    defb 000h	    ;5e25
    
    defb 000h	    ;5e26	0,
    defb 000h	    ;5e27
    
    defb 013h	    ;5e28	0x13,
    defb 000h	    ;5e29
    
    defb 01dh	    ;5e2a	0x1d,
    defb 000h	    ;5e2b
    
    defb 007h	    ;5e2c	7,
    defb 000h	    ;5e2d
    
    defb 000h	    ;5e2e	0,
    defb 000h	    ;5e2f
    
    defb 000h	    ;5e30	0,
    defb 000h	    ;5e31
    
    defb 019h	    ;5e32	0x19,
    defb 000h	    ;5e33
    
    defb 000h	    ;5e34	0,
    defb 000h	    ;5e35
    
    defb 004h	    ;5e36	4,
    defb 000h	    ;5e37
    
    defb 000h	    ;5e38	0,
    defb 000h	    ;5e39
    
    defb 012h	    ;5e3a	0x12,
    defb 000h	    ;5e3b
    
    defb 000h	    ;5e3c	0,
    defb 000h	    ;5e3d
    
    defb 013h	    ;5e3e	0x13,
    defb 000h	    ;5e3f
    
    defb 01dh	    ;5e40	0x1d,
    defb 000h	    ;5e41
    
    defb 000h	    ;5e42	0,
    defb 000h	    ;5e43
    
    defb 00dh	    ;5e44	0xd,
    defb 000h	    ;5e45
    
    defb 018h	    ;5e46	0x18,
    defb 000h	    ;5e47
    
    defb 000h	    ;5e48	0,
    defb 000h	    ;5e49
    
    defb 000h	    ;5e4a	0,
    defb 000h	    ;5e4b
    
    defb 000h	    ;5e4c	0,
    defb 000h	    ;5e4d
    
    defb 00bh	    ;5e4e	0xb,
    defb 000h	    ;5e4f
    
    defb 00eh	    ;5e50	0xe,
    defb 000h	    ;5e51
    
    defb 000h	    ;5e52	0,
    defb 000h	    ;5e53
    
    defb 00fh	    ;5e54	0xf,
    defb 000h	    ;5e55
    
    defb 01ah	    ;5e56	0x1a,
    defb 000h	    ;5e57
    
    defb 00ch	    ;5e58	0xc,
    defb 000h	    ;5e59
    
    defb 000h	    ;5e5a	0,
    defb 000h	    ;5e5b
    
    defb 000h	    ;5e5c	0,
    defb 000h	    ;5e5d
    
    defb 000h	    ;5e5e	0,
    defb 000h	    ;5e5f
    
    defb 00dh	    ;5e60	0xd,
    defb 000h	    ;5e61
    
    defb 018h	    ;5e62	0x18,
    defb 000h	    ;5e63
    
    defb 000h	    ;5e64	0,
    defb 000h	    ;5e65
    
    defb 000h	    ;5e66	0,
    defb 000h	    ;5e67
    
    defb 019h	    ;5e68	0x19,
    defb 000h	    ;5e69
    
    defb 00bh	    ;5e6a	0xb,
    defb 000h	    ;5e6b
    
    defb 00eh	    ;5e6c	0xe,
    defb 000h	    ;5e6d
    
    defb 01ah	    ;5e6e	0x1a,
    defb 000h	    ;5e6f
    
    defb 00fh	    ;5e70	0xf,
    defb 000h	    ;5e71
    
    defb 012h	    ;5e72	0x12,
    defb 000h	    ;5e73
    
    defb 00ch	    ;5e74	0xc,
    defb 000h	    ;5e75
    
    defb 013h	    ;5e76	0x13,
    defb 000h	    ;5e77
    
    defb 00dh	    ;5e78	0xd,
    defb 000h	    ;5e79
    
    defb 018h	    ;5e7a	0x18,
    defb 000h	    ;5e7b
    
    defb 000h	    ;5e7c	0,
    defb 000h	    ;5e7d
    
    defb 019h	    ;5e7e	0x19,
    defb 000h	    ;5e7f
    
    defb 000h	    ;5e80	0,
    defb 000h	    ;5e81
    
    defb 00bh	    ;5e82	0xb,
    defb 000h	    ;5e83
    
    defb 00eh	    ;5e84	0xe,
    defb 000h	    ;5e85
    
    defb 000h	    ;5e86	0,
    defb 000h	    ;5e87
    
    defb 00fh	    ;5e88	0xf,
    defb 000h	    ;5e89
    
    defb 00dh	    ;5e8a	0xd,
    defb 000h	    ;5e8b
    
    defb 00ch	    ;5e8c	0xc,
    defb 000h	    ;5e8d
    
    defb 012h	    ;5e8e	0x12,
    defb 000h	    ;5e8f
    
    defb 000h	    ;5e90	0,
    defb 000h	    ;5e91
    
    defb 013h	    ;5e92	0x13,
    defb 000h	    ;5e93
    
    defb 00bh	    ;5e94	0xb,
    defb 000h	    ;5e95
    
    defb 00eh	    ;5e96	0xe,
    defb 000h	    ;5e97
    
    defb 000h	    ;5e98	0,
    defb 000h	    ;5e99
    
    defb 00fh	    ;5e9a	0xf,
    defb 000h	    ;5e9b
    
    defb 000h	    ;5e9c	0,
    defb 000h	    ;5e9d
    
    defb 00ch	    ;5e9e	0xc,
    defb 000h	    ;5e9f
    
    defb 000h	    ;5ea0	0,
    defb 000h	    ;5ea1
    
    defb 000h	    ;5ea2	0,
    defb 000h	    ;5ea3
    
    defb 01ah	    ;5ea4	0x1a,
    defb 000h	    ;5ea5
    
    defb 012h	    ;5ea6	0x12,
    defb 000h	    ;5ea7
    
    defb 000h	    ;5ea8	0,
    defb 000h	    ;5ea9
    
    defb 013h	    ;5eaa	0x13,
    defb 000h	    ;5eab
    
    defb 000h	    ;5eac	0,
    defb 000h	    ;5ead
    
    defb 000h	    ;5eae	0,
    defb 000h	    ;5eaf
    
    defb 000h	    ;5eb0	0,
    defb 000h	    ;5eb1
    
    defb 000h	    ;5eb2	0,
    defb 000h	    ;5eb3
    
    defb 00dh	    ;5eb4	0xd,
    defb 000h	    ;5eb5
    
    defb 019h	    ;5eb6	0x19,
    defb 000h	    ;5eb7
    
    defb 012h	    ;5eb8	0x12,
    defb 000h	    ;5eb9
    
    defb 01ah	    ;5eba	0x1a,
    defb 000h	    ;5ebb
    
    defb 013h	    ;5ebc	0x13,
    defb 000h	    ;5ebd
    
    defb 00bh	    ;5ebe	0xb,
    defb 000h	    ;5ebf
    
    defb 00eh	    ;5ec0	0xe,
    defb 000h	    ;5ec1
    
    defb 000h	    ;5ec2	0,
    defb 000h	    ;5ec3
    
    defb 00fh	    ;5ec4	0xf,
    defb 000h	    ;5ec5
    
    defb 000h	    ;5ec6	0,
    defb 000h	    ;5ec7
    
    defb 00ch	    ;5ec8	0xc,
    defb 000h	    ;5ec9
    
    defb 00dh	    ;5eca	0xd,
    defb 000h	    ;5ecb
    
    defb 000h	    ;5ecc	0,
    defb 000h	    ;5ecd
    
    defb 000h	    ;5ece	0,
    defb 000h	    ;5ecf
    
    defb 000h	    ;5ed0	0,
    defb 000h	    ;5ed1
    
    defb 019h	    ;5ed2	0x19,
    defb 000h	    ;5ed3
    
    defb 00bh	    ;5ed4	0xb,
    defb 000h	    ;5ed5
    
    defb 00eh	    ;5ed6	0xe,
    defb 000h	    ;5ed7
    
    defb 006h	    ;5ed8	6,
    defb 000h	    ;5ed9
    
    defb 00fh	    ;5eda	0xf,
    defb 000h	    ;5edb
    
    defb 000h	    ;5edc	0,
    defb 000h	    ;5edd
    
    defb 00ch	    ;5ede	0xc,
    defb 000h	    ;5edf
    
    defb 000h	    ;5ee0	0,
    defb 000h	    ;5ee1
    
    defb 012h	    ;5ee2	0x12,
    defb 000h	    ;5ee3
    
    defb 000h	    ;5ee4	0,
    defb 000h	    ;5ee5
    
    defb 013h	    ;5ee6	0x13,
    defb 000h	    ;5ee7
    
    defb 000h	    ;5ee8	0,
    defb 000h	    ;5ee9
    
    defb 000h	    ;5eea	0,
    defb 000h	    ;5eeb
    
    defb 000h	    ;5eec	0,
    defb 000h	    ;5eed
    
    defb 000h	    ;5eee	0,
    defb 000h	    ;5eef
    
    defb 000h	    ;5ef0	0,
    defb 000h	    ;5ef1
    
    defb 01ah	    ;5ef2	0x1a,
    defb 000h	    ;5ef3
    
    defb 000h	    ;5ef4	0,
    defb 000h	    ;5ef5
    
    defb 000h	    ;5ef6	0,
    defb 000h	    ;5ef7
    
    defb 000h	    ;5ef8	0,
    defb 000h	    ;5ef9
    
    defb 000h	    ;5efa	0,
    defb 000h	    ;5efb
    
    defb 000h	    ;5efc	0,
    defb 000h	    ;5efd
    
    defb 000h	    ;5efe	0,
    defb 000h	    ;5eff
    
    defb 002h	    ;5f00	2,
    defb 000h	    ;5f01
    
    defb 000h	    ;5f02	0,
    defb 000h	    ;5f03
    
    defb 000h	    ;5f04	0,
    defb 000h	    ;5f05
    
    defb 000h	    ;5f06	0,
    defb 000h	    ;5f07
    
    defb 000h	    ;5f08	0,
    defb 000h	    ;5f09
    
    defb 000h	    ;5f0a	0,
    defb 000h	    ;5f0b
    
    defb 000h	    ;5f0c	0,
    defb 000h	    ;5f0d
    
    defb 01ah	    ;5f0e	0x1a,
    defb 000h	    ;5f0f
    
    defb 022h	    ;5f10	0x22,
    defb 000h	    ;5f11
    
    defb 000h	    ;5f12	0,
    defb 000h	    ;5f13
    
    defb 000h	    ;5f14	0,
    defb 000h	    ;5f15
    
    defb 000h	    ;5f16	0,
    defb 000h	    ;5f17
    
    defb 025h	    ;5f18	0x25,
    defb 000h	    ;5f19
    
    defb 026h	    ;5f1a	0x26,
    defb 000h	    ;5f1b
    
    defb 027h	    ;5f1c	0x27,
    defb 000h	    ;5f1d
    
    defb 028h	    ;5f1e	0x28,
    defb 000h	    ;5f1f
    
    defb 029h	    ;5f20	0x29,
    defb 000h	    ;5f21
    
    defb 02ah	    ;5f22	0x2a,
    defb 000h	    ;5f23
    
    defb 02bh	    ;5f24	0x2b,
    defb 000h	    ;5f25
    
    defb 02ch	    ;5f26	0x2c,
    defb 000h	    ;5f27
    
    defb 02dh	    ;5f28	0x2d,
    defb 000h	    ;5f29
    
    defb 02eh	    ;5f2a 	0x2e,
    defb 000h	    ;5f2b
    
    defb 02fh	    ;5f2c	0x2f,
    defb 000h	    ;5f2d
    
    defb 030h	    ;5f2e	0x30,
    defb 000h	    ;5f2f
    
    defb 031h	    ;5f30	0x31,
    defb 000h	    ;5f31
    
    defb 032h	    ;5f32 	0x32,
    defb 000h	    ;5f33
    
    defb 033h	    ;5f34	0x33,
    defb 000h	    ;5f35
    
    defb 034h	    ;5f36	0x34,
    defb 000h	    ;5f37
    
    defb 035h	    ;5f38	0x35,
    defb 000h	    ;5f39
    
    defb 036h	    ;5f3a	0x36,
    defb 000h	    ;5f3b
    
    defb 037h	    ;5f3c	0x37,
    defb 000h	    ;5f3d
    
    defb 038h	    ;5f3e	0x38,
    defb 000h	    ;5f3f
    
    defb 000h	    ;5f40	0,
    defb 000h	    ;5f41
    
    defb 000h	    ;5f42	0,
    defb 000h	    ;5f43
    
    defb 000h	    ;5f44	0,
    defb 000h	    ;5f45
    
    defb 000h	    ;5f46	0,
    defb 000h	    ;5f47
    
    defb 000h	    ;5f48	0,
    defb 000h	    ;5f49
    
    defb 000h	    ;5f4a	0,
    defb 000h	    ;5f4b
    
    defb 000h	    ;5f4c	0,
    defb 000h	    ;5f4d
    
    defb 000h	    ;5f4e	0,
    defb 000h	    ;5f4f
    
    defb 000h	    ;5f50	0,
    defb 000h	    ;5f51
    
    defb 000h	    ;5f52	0,
    defb 000h	    ;5f53
    
    defb 000h	    ;5f54	0,
    defb 000h	    ;5f55
    
    defb 000h	    ;5f56	0,
    defb 000h	    ;5f57
    
    defb 000h	    ;5f58	0,
    defb 000h	    ;5f59
    
    defb 000h	    ;5f5a	0,
    defb 000h	    ;5f5b
    
    defb 000h	    ;5f5c	0,
    defb 000h	    ;5f5d
    
    defb 024h	    ;5f5e 	0x24,
    defb 000h	    ;5f5f
    
    defb 000h	    ;5f60	0,
    defb 000h	    ;5f61
    
    defb 000h	    ;5f62	0,
    defb 000h	    ;5f63
    
    defb 000h	    ;5f64	0,
    defb 000h	    ;5f65
    
    defb 016h	    ;5f66 	0x16,
    defb 000h	    ;5f67
    
    defb 017h	    ;5f68 	0x17,
    defb 000h	    ;5f69
    
    defb 014h	    ;5f6a 	0x14,
    defb 000h	    ;5f6b
    
    defb 015h	    ;5f6c 	0x15,
    defb 000h	    ;5f6d
    
    defb 010h	    ;5f6e 	0x10,
    defb 000h	    ;5f6f
    
    defb 011h	    ;5f70 	0x11,
    defb 000h	    ;5f71
    
    defb 01bh	    ;5f72 	0x1b,
    defb 000h	    ;5f73
    
    defb 01ch	    ;5f74 	0x1c,
    defb 000h	    ;5f75
    
    defb 000h	    ;5f76 	0,
    defb 000h	    ;5f77
    
    defb 03dh	    ;5f78 	0x3d,
    defb 000h	    ;5f79
    
    defb 000h	    ;5f7a 	0,
    defb 000h	    ;5f7b
    
    defb 000h	    ;5f7c 	0,
    defb 000h	    ;5f7d
    
    defb 016h	    ;5f7e 	0x16,
    defb 000h	    ;5f7f
    
    defb 017h	    ;5f80 	0x17,
    defb 000h	    ;5f81
    
    defb 014h	    ;5f82 	0x14,
    defb 000h	    ;5f83
    
    defb 015h	    ;5f84 	0x15,
    defb 000h	    ;5f85
    
    defb 010h	    ;5f86 	0x10,
    defb 000h	    ;5f87
    
    defb 011h	    ;5f88 	0x11,
    defb 000h	    ;5f89
    
    defb 01bh	    ;5f8a 	0x1b,
    defb 000h	    ;5f8b
    
    defb 01ch	    ;5f8c 	0x1c,
    defb 000h	    ;5f8d
    
    defb 000h	    ;5f8e 	0,
    defb 000h	    ;5f8f
    
    defb 000h	    ;5f90 	0,
    defb 000h	    ;5f91
    
    defb 000h	    ;5f92 	0,
    defb 000h	    ;5f93
    
    defb 000h	    ;5f94 	0,
    defb 000h	    ;5f95
    
    defb 000h	    ;5f96 	0,
    defb 000h	    ;5f97
    
    defb 000h	    ;5f98 	0,
    defb 000h	    ;5f99
    
    defb 000h	    ;5f9a 	0,
    defb 000h	    ;5f9b
    
    defb 000h	    ;5f9c 	0,
    defb 000h	    ;5f9d
    
    defb 010h	    ;5f9e 	0x10,
    defb 000h	    ;5f9f
    
    defb 011h	    ;5fa0 	0x11,
    defb 000h	    ;5fa1
    
    defb 000h	    ;5fa2 	0,
    defb 000h	    ;5fa3
    
    defb 000h	    ;5fa4 	0,
    defb 000h	    ;5fa5
    
    defb 000h	    ;5fa6 	0,
    defb 000h	    ;5fa7
    
    defb 000h	    ;5fa8 	0,
    defb 000h	    ;5fa9
    
    defb 000h	    ;5faa 	0,
    defb 000h	    ;5fab
    
    defb 000h	    ;5fac 	0,
    defb 000h	    ;5fad
    
    defb 000h	    ;5fae 	0,
    defb 000h	    ;5faf
    
    defb 00ah	    ;5fb0 	0xa,
    defb 000h	    ;5fb1
    
    defb 000h	    ;5fb2 	0,
    defb 000h	    ;5fb3
    
    defb 016h	    ;5fb4 	0x16,
    defb 000h	    ;5fb5
    
    defb 017h	    ;5fb6 	0x17,
    defb 000h	    ;5fb7
    
    defb 014h	    ;5fb8 	0x14,
    defb 000h	    ;5fb9
    
    defb 015h	    ;5fba 	0x15,
    defb 000h	    ;5fbb
    
    defb 010h	    ;5fbc 	0x10,
    defb 000h	    ;5fbd
    
    defb 011h	    ;5fbe 	0x11,
    defb 000h	    ;5fbf
    
    defb 01bh	    ;5fc0 	0x1b,
    defb 000h	    ;5fc1
    
    defb 01ch	    ;5fc2 	0x1c,
    defb 000h	    ;5fc3
    
    defb 000h	    ;5fc4 	0,
    defb 000h	    ;5fc5
    
    defb 000h	    ;5fc6 	0,
    defb 000h	    ;5fc7
    
    defb 000h	    ;5fc8 	0,
    defb 000h	    ;5fc9
    
    defb 016h	    ;5fca 	0x16,
    defb 000h	    ;5fcb
    
    defb 017h	    ;5fcc 	0x17,
    defb 000h	    ;5fcd
    
    defb 014h	    ;5fce 	0x14,
    defb 000h	    ;5fcf
    
    defb 015h	    ;5fd0 	0x15,
    defb 000h	    ;5fd1
    
    defb 010h	    ;5fd2 	0x10,
    defb 000h	    ;5fd3
    
    defb 011h	    ;5fd4 	0x11,
    defb 000h	    ;5fd5
    
    defb 01bh	    ;5fd6 	0x1b,
    defb 000h	    ;5fd7
    
    defb 01ch	    ;5fd8 	0x1c,
    defb 000h	    ;5fd9
    
    defb 000h	    ;5fda 	0,
    defb 000h	    ;5fdb
    
    defb 000h	    ;5fdc 	0,
    defb 000h	    ;5fdd
    
    defb 009h	    ;5fde 	9,
    defb 000h	    ;5fdf
    
    defb 000h	    ;5fe0 	0,
    defb 000h	    ;5fe1
    
    defb 008h	    ;5fe2 	8,
    defb 000h	    ;5fe3
    
    defb 000h	    ;5fe4 	0,
    defb 000h	    ;5fe5
    
    defb 000h	    ;5fe6 	0,
    defb 000h	    ;5fe7
    
    defb 000h	    ;5fe8 	0,
    defb 000h	    ;5fe9
    
    defb 000h	    ;5fea 	0,
    defb 000h	    ;5feb
    
    defb 000h	    ;5fec 	0,
    defb 000h	    ;5fed
    
    defb 000h	    ;5fee 	0,
    defb 000h	    ;5fef
    
    defb 000h	    ;5ff0 	0,
    defb 000h	    ;5ff1
    
    defb 000h	    ;5ff2 	0,
    defb 000h	    ;5ff3
    
    defb 000h	    ;5ff4 	0,
    defb 000h	    ;5ff5
    
    defb 000h	    ;5ff6 	0,
    defb 000h	    ;5ff7
    
    defb 000h	    ;5ff8 	0,
    defb 000h	    ;5ff9
    
    defb 000h	    ;5ffa 	0,
    defb 000h	    ;5ffb
    
    defb 000h	    ;5ffc 	0,
    defb 000h	    ;5ffd
    
    defb 000h	    ;5ffe 	0,
    defb 000h	    ;5fff
    
    defb 000h	    ;6000 	0,
    defb 000h	    ;6001
    
    defb 016h	    ;6002 	0x16,
    defb 000h	    ;6003
    
    defb 017h	    ;6004 	0x17,
    defb 000h	    ;6005
    
    defb 014h	    ;6006 	0x14,
    defb 000h	    ;6007
    
    defb 015h	    ;6008 	0x15,
    defb 000h	    ;6009
    
    defb 010h	    ;600a 	0x10,
    defb 000h	    ;600b
    
    defb 011h	    ;600c 	0x11,
    defb 000h	    ;600d
    
    defb 01bh	    ;600e 	0x1b,
    defb 000h	    ;600f
    
    defb 000h	    ;6010 	0,
    defb 000h	    ;6011
    
    defb 000h	    ;6012 	0,
    defb 000h	    ;6013
    
    defb 000h	    ;6014 	0,
    defb 000h	    ;6015
    
    defb 000h	    ;6016 	0,
    defb 000h	    ;6017
    
    defb 000h	    ;6018 	0,
    defb 000h	    ;6019
    
    defb 000h	    ;601a 	0,
    defb 000h	    ;601b
    
    defb 000h	    ;601c 	0,
    defb 000h	    ;601d
    
    defb 016h	    ;601e 	0x16,
    defb 000h	    ;601f
    
    defb 017h	    ;6020 	0x17,
    defb 000h	    ;6021
    
    defb 014h	    ;6022 	0x14,
    defb 000h	    ;6023
    
    defb 015h	    ;6024 	0x15,
    defb 000h	    ;6025
    
    defb 010h	    ;6026 	0x10,
    defb 000h	    ;6027
    
    defb 011h	    ;6028 	0x11,
    defb 000h	    ;6029
    
    defb 000h	    ;602a 	0,
    defb 000h	    ;602b
    
    defb 000h	    ;602c 	0,
    defb 000h	    ;602d
    
    defb 000h	    ;602e 	0,
    defb 000h	    ;602f
    
    defb 000h	    ;6030 	0,
    defb 000h	    ;6031
    
    defb 000h	    ;6032 	0,
    defb 000h	    ;6033
    
    defb 000h	    ;6034 	0,
    defb 000h	    ;6035
    
    defb 016h	    ;6036 	0x16,
    defb 000h	    ;6037
    
    defb 017h	    ;6038 	0x17,
    defb 000h	    ;6039
    
    defb 014h	    ;603a 	0x14,
    defb 000h	    ;603b
    
    defb 015h	    ;603c 	0x15,
    defb 000h	    ;603d
    
    defb 010h	    ;603e 	0x10,
    defb 000h	    ;603f
    
    defb 011h	    ;6040 	0x11,
    defb 000h	    ;6041
    
    defb 000h	    ;6042 	0,
    defb 000h	    ;6043
    
    defb 000h	    ;6044 	0,
    defb 000h	    ;6045
    
    defb 000h	    ;6046 	0,
    defb 000h	    ;6047
    
    defb 016h	    ;6048 	0x16,
    defb 000h	    ;6049
    
    defb 017h	    ;604a 	0x17,
    defb 000h	    ;604b
    
    defb 014h	    ;604c 	0x14,
    defb 000h	    ;604d
    
    defb 015h	    ;604e 	0x15,
    defb 000h	    ;604f
    
    defb 010h	    ;6050 	0x10,
    defb 000h	    ;6051
    
    defb 011h	    ;6052 	0x11,
    defb 000h	    ;6053
    
    defb 000h	    ;6054 	0,
    defb 000h	    ;6055
    
    defb 000h	    ;6056 	0,
    defb 000h	    ;6057
    
    defb 000h	    ;6058 	0,
    defb 000h	    ;6059
    
    defb 000h	    ;605a 	0,
    defb 000h	    ;605b
    
    defb 000h	    ;605c 	0,
    defb 000h	    ;605d
    
    defb 000h	    ;605e 	0,
    defb 000h	    ;605f
    
    defb 000h	    ;6060	0,
    defb 000h	    ;6061
    
    defb 000h	    ;6062	0,
    defb 000h	    ;6063
    
    defb 000h	    ;6064	0,
    defb 000h	    ;6065
    
    defb 000h	    ;6066	0,
    defb 000h	    ;6067
    
    defb 000h	    ;6068	0,
    defb 000h	    ;6069
    
    defb 000h	    ;606a	0,
    defb 000h	    ;606b
    
    defb 000h	    ;606c	0,
    defb 000h	    ;606d
    
    defb 000h	    ;606e	0,
    defb 000h	    ;606f
    
    defb 000h	    ;6070	0,
    defb 000h	    ;6071
    
    defb 000h	    ;6072	0,
    defb 000h	    ;6073
    
    defb 000h	    ;6074	0,
    defb 000h	    ;6075
    
    defb 014h	    ;6076 	0x14,
    defb 000h	    ;6077
    
    defb 015h	    ;6078 	0x15,
    defb 000h	    ;6079
    
    defb 010h	    ;607a 	0x10,
    defb 000h	    ;607b
    
    defb 011h	    ;607c 	0x11
    defb 000h	    ;607d




array_607e:
    defb 01ah	    ;607e 0 	0x1a,
    defb 000h	    ;607f
    
    defb 018h	    ;6080 1 	0xfc18,
    defb 0fch	    ;6081
    
    defb 002h	    ;6082 2 	2,
    defb 000h	    ;6083
    
    defb 018h	    ;6084 3 	0xfc18,
    defb 0fch	    ;6085
    
    defb 01ah	    ;6086 4 	0x1a,
    defb 000h	    ;6087
    
    defb 01ah	    ;6088 5 	0x1a,
    defb 000h	    ;6089
    
    defb 01ah	    ;608a 6 	0x1a,
    defb 000h	    ;608b
    
    defb 01ah	    ;608c 7 	0x1a,
    defb 000h	    ;608d
    
    defb 0dah	    ;608e 8 	0xffda,
    defb 0ffh	    ;608f
    
    defb 018h	    ;6090 9 	0xfc18,
    defb 0fch	    ;6091
    
    defb 018h	    ;6092 10 	0xfc18,
    defb 0fch	    ;6093
    
    defb 01ah	    ;6094 11 	0x1a,
    defb 000h	    ;6095
    
    defb 01ah	    ;6096 12 	0x1a,
    defb 000h	    ;6097
    
    defb 01ah	    ;6098 13 	0x1a,
    defb 000h	    ;6099
    
    defb 01ah	    ;609a 14 	0x1a,
    defb 000h	    ;609b
    
    defb 01ah	    ;609c 15 	0x1a,
    defb 000h	    ;609d
    
    defb 01ah	    ;609e 16 	0x1a,
    defb 000h	    ;609f
    
    defb 01ah	    ;60a0 17 	0x1a,
    defb 000h	    ;60a1
    
    defb 01ah	    ;60a2 18 	0x1a,
    defb 000h	    ;60a3
    
    defb 01ah	    ;60a4 19 	0x1a,
    defb 000h	    ;60a5
    
    defb 01ah	    ;60a6 20 	0x1a,
    defb 000h	    ;60a7
    
    defb 01ah	    ;60a8 21 	0x1a,
    defb 000h	    ;60a9
    
    defb 01ah	    ;60aa 22 	0x1a,
    defb 000h	    ;60ab
    
    defb 01ah	    ;60ac 23 	0x1a,
    defb 000h	    ;60ad
    
    defb 01ah	    ;60ae 24 	0x1a,
    defb 000h	    ;60af
    
    defb 01ah	    ;60b0 25 	0x1a,
    defb 000h	    ;60b1
    
    defb 01ah	    ;60b2 26 	0x1a,
    defb 000h	    ;60b3
    
    defb 01ah	    ;60b4 27 	0x1a,
    defb 000h	    ;60b5
    
    defb 01ah	    ;60b6 28 	0x1a,
    defb 000h	    ;60b7
    
    defb 01ah	    ;60b8 29 	0x1a,
    defb 000h	    ;60b9
    
    defb 01ah	    ;60ba 30 	0x1a,
    defb 000h	    ;60bb
    
    defb 018h	    ;60bc 31 	0xfc18,
    defb 0fch	    ;60bd
    
    defb 018h	    ;60be 32 	0xfc18,
    defb 0fch	    ;60bf
    
    defb 018h	    ;60c0 33 	0xfc18,
    defb 0fch	    ;60c1
    
    defb 0e7h	    ;60c2 34 	0xffe7,
    defb 0ffh	    ;60c3
    
    defb 002h	    ;60c4 35 	0xff02,
    defb 0ffh	    ;60c5
    
    defb 018h	    ;60c6 36 	0xfc18,
    defb 0fch	    ;60c7
    
    defb 018h	    ;60c8 37 	0xfc18,
    defb 0fch	    ;60c9
    
    defb 018h	    ;60ca 38 	0xfc18,
    defb 0fch	    ;60cb
    
    defb 018h	    ;60cc 39 	0xfc18,
    defb 0fch	    ;60cd
    
    defb 0dfh	    ;60ce 40 	0xffdf,
    defb 0ffh	    ;60cf
    
    defb 0dfh	    ;60d0 41 	0xffdf,
    defb 0ffh	    ;60d1
    
    defb 06ch	    ;60d2 42 	0x6c,
    defb 000h	    ;60d3
    
    defb 06ch	    ;60d4 43 	0x6c,
    defb 000h	    ;60d5
    
    defb 0f3h	    ;60d6 44 	0xfff3,
    defb 0ffh	    ;60d7
    
    defb 0f3h	    ;60d8 45 	0xfff3,
    defb 0ffh	    ;60d9
    
    defb 0f3h	    ;60da 46 	0xfff3,
    defb 0ffh	    ;60db
    
    defb 0f3h	    ;60dc 47 	0xfff3,
    defb 0ffh	    ;60dd
    
    defb 061h	    ;60de 48 	0x61,
    defb 000h	    ;60df
    
    defb 061h	    ;60e0 49 	0x61,
    defb 000h	    ;60e1
    
    defb 04ch	    ;60e2 50 	0x4c,
    defb 000h	    ;60e3
    
    defb 043h	    ;60e4 51 	0x43,
    defb 000h	    ;60e5
    
    defb 043h	    ;60e6 52 	0x43,
    defb 000h	    ;60e7
    
    defb 037h	    ;60e8 53 	0x37,
    defb 000h	    ;60e9
    
    defb 029h	    ;60ea 54 	0x29,
    defb 000h	    ;60eb
    
    defb 0dbh	    ;60ec 55 	0xffdb,
    defb 0ffh	    ;60ed
    
    defb 00dh	    ;60ee 56 	0xd,
    defb 000h	    ;60ef
    
    defb 018h	    ;60f0 57 	0xfc18,
    defb 0fch	    ;60f1
    
    defb 0e2h	    ;60f2 58 	0xff02,
    defb 0ffh	    ;60f3
    
    defb 01ah	    ;60f4 59 	0x1a,
    defb 000h	    ;60f5
    
    defb 018h	    ;60f6 60 	0xfc18,
    defb 0fch	    ;60f7
    
    defb 00dh	    ;60f8 61 	0xd
    defb 000h	    ;60f9

array_60fa:
    defb 000h	    ;60fa	0,
    defb 000h	    ;60fb
    
    defb 00fh	    ;60fc	0xf,
    defb 000h	    ;60fd
    
    defb 0ach	    ;60fe	0xac,
    defb 000h	    ;60ff
    
    defb 024h	    ;6100	0x24
    defb 000h	    ;6101



array_6102:
    defb 000h	    ;6102	0,
    defb 000h	    ;6103
    
    defb 001h	    ;6104	1,
    defb 000h	    ;6105
    
    defb 002h	    ;6106	2,
    defb 000h	    ;6107
    
    defb 002h	    ;6108	2,
    defb 000h	    ;6109
    
    defb 002h	    ;610a	2,
    defb 000h	    ;610b
    
    defb 002h	    ;610c	2,
    defb 000h	    ;610d
    
    defb 002h	    ;610e	2,
    defb 000h	    ;610f
    
    defb 002h	    ;6110	2,
    defb 000h	    ;6111
    
    defb 002h	    ;6112	2,
    defb 000h	    ;6113
    
    defb 002h	    ;6114	2,
    defb 000h	    ;6115
    
    defb 002h	    ;6116	2,
    defb 000h	    ;6117
    
    defb 002h	    ;6118	2,
    defb 000h	    ;6119
    
    defb 002h	    ;611a	2,
    defb 000h	    ;611b
    
    defb 002h	    ;611c	2,
    defb 000h	    ;611d
    
    defb 002h	    ;611e	2,
    defb 000h	    ;611f
    
    defb 002h	    ;6120	2,
    defb 000h	    ;6121
    
    defb 002h	    ;6122	2,
    defb 000h	    ;6123
    
    defb 002h	    ;6124	2,
    defb 000h	    ;6125
    
    defb 002h	    ;6126	2,
    defb 000h	    ;6127
    
    defb 002h	    ;6128	2,
    defb 000h	    ;6129
    
    defb 002h	    ;612a	2,
    defb 000h	    ;612b
    
    defb 002h	    ;612c	2,
    defb 000h	    ;612d
    
    defb 002h	    ;612e	2,
    defb 000h	    ;612f
    
    defb 003h	    ;6130	3,
    defb 000h	    ;6131
    
    defb 003h	    ;6132	3,
    defb 000h	    ;6133
    
    defb 003h	    ;6134	3,
    defb 000h	    ;6135
    
    defb 003h	    ;6136	3,
    defb 000h	    ;6137
    
    defb 003h	    ;6138	3,
    defb 000h	    ;6139
    
    defb 003h	    ;613a	3,
    defb 000h	    ;613b
    
    defb 003h	    ;613c	3
    defb 000h	    ;613d

array_613e:
    defb 000h	    ;613e 0	0,
    defb 000h	    ;613f
    
    defb 005h	    ;6140 1	5,
    defb 000h	    ;6141
    
    defb 007h	    ;6142 2	7,
    defb 000h	    ;6143
    
    defb 007h	    ;6144 3	7,
    defb 000h	    ;6145
    
    defb 007h	    ;6146 4	7,
    defb 000h	    ;6147
    
    defb 007h	    ;6148 5	7,
    defb 000h	    ;6149
    
    defb 007h	    ;614a 6	7,
    defb 000h	    ;614b
    
    defb 007h	    ;614c 7	7,
    defb 000h	    ;614d
    
    defb 007h	    ;614e 8	7,
    defb 000h	    ;614f
    
    defb 007h	    ;6150 9	7,
    defb 000h	    ;6151
    
    defb 007h	    ;6152 10	7,
    defb 000h	    ;6153
    
    defb 007h	    ;6154 11	7,
    defb 000h	    ;6155
    
    defb 007h	    ;6156 12	7,
    defb 000h	    ;6157
    
    defb 007h	    ;6158 13	7,
    defb 000h	    ;6159
    
    defb 007h	    ;615a 14	7,
    defb 000h	    ;615b
    
    defb 007h	    ;615c 15	7,
    defb 000h	    ;615d
    
    defb 007h	    ;615e 16	7,
    defb 000h	    ;615f
    
    defb 007h	    ;6160 17	7,
    defb 000h	    ;6161
    
    defb 007h	    ;6162 18	7,
    defb 000h	    ;6163
    
    defb 007h	    ;6164 19	7,
    defb 000h	    ;6165
    
    defb 00bh	    ;6166 20	7,
    defb 000h	    ;6167
    
    defb 007h	    ;6168 21	7,
    defb 000h	    ;6169
    
    defb 003h	    ;616a 22	3,
    defb 000h	    ;616b
    
    defb 005h	    ;616c 23	5,
    defb 000h	    ;616d
    
    defb 005h	    ;616e 24	5,
    defb 000h	    ;616f
    
    defb 005h	    ;6170 25	5,
    defb 000h	    ;6171
    
    defb 007h	    ;6172 26	7,
    defb 000h	    ;6173
    
    defb 009h	    ;6174 27	9,
    defb 000h	    ;6175
    
    defb 005h	    ;6176 28	5,
    defb 000h	    ;6177
    
    defb 003h	    ;6178 29	3
    defb 000h	    ;6179




array_617a:
    defb 018h	    ;617a	0xfc18,
    defb 0fch	    ;617b
    
    defb 0ffh	    ;617c	-1,
    defb 0ffh	    ;617d
    
    defb 0feh	    ;617e	0xfffe,
    defb 0ffh	    ;617f
    
    defb 0fdh	    ;6180	0xfffd,
    defb 0ffh	    ;6181
    
    defb 02dh	    ;6182	0x2d,
    defb 000h	    ;6183
    
    defb 021h	    ;6184	0x21,
    defb 000h	    ;6185
    
    defb 07eh	    ;6186	0x7e,
    defb 000h	    ;6187
    
    defb 028h	    ;6188	0x28,
    defb 000h	    ;6189
    
    defb 003h	    ;618a	0x103,
    defb 001h	    ;618b
    
    defb 001h	    ;618c	0x101,
    defb 001h	    ;618d
    
    defb 002h	    ;618e	0x102,
    defb 001h	    ;618f
    
    defb 02ah	    ;6190	0x2a,
    defb 000h	    ;6191
    
    defb 02fh	    ;6192	0x2f,
    defb 000h	    ;6193
    
    defb 025h	    ;6194	0x25,
    defb 000h	    ;6195
    
    defb 02bh	    ;6196      	0x2b,
    defb 000h	    ;6197
    
    defb 02dh	    ;6198	0x2d,
    defb 000h	    ;6199
    
    defb 008h	    ;619a	0x108,
    defb 001h	    ;619b
    
    defb 009h	    ;619c	0x109,
    defb 001h	    ;619d
    
    defb 03ch	    ;619e	0x3c,
    defb 000h	    ;619f
    
    defb 03eh	    ;61a0	0x3e,
    defb 000h	    ;61a1
    
    defb 006h	    ;61a2	0x106,
    defb 001h	    ;61a3
    
    defb 007h	    ;61a4	0x107,
    defb 001h	    ;61a5
    
    defb 004h	    ;61a6	0x104,
    defb 001h	    ;61a7
    
    defb 005h	    ;61a8	0x105,
    defb 001h	    ;61a9
    
    defb 026h	    ;61aa	0x26,
    defb 000h	    ;61ab
    
    defb 05eh	    ;61ac	0x5e,
    defb 000h	    ;61ad
    
    defb 07ch	    ;61ae	0x7c,
    defb 000h	    ;61af
    
    defb 00ah	    ;61b0	0x10a,
    defb 001h	    ;61b1
    
    defb 00bh	    ;61b2	0x10b,
    defb 001h	    ;61b3
    
    defb 03fh	    ;61b4 	0x3f,
    defb 000h	    ;61b5
    
    defb 02ch	    ;61b6 	0x2c,
    defb 000h	    ;61b7
    
    defb 0fdh	    ;61b8	0xfffd,
    defb 0ffh	    ;61b9
    
    defb 0fdh	    ;61ba	0xfffd,
    defb 0ffh	    ;61bb
    
    defb 0fdh	    ;61bc	0xfffd,
    defb 0ffh	    ;61bd
    
    defb 0feh	    ;61be	0xfffe,
    defb 0ffh	    ;61bf
    
    defb 028h	    ;61c0	0x28,
    defb 000h	    ;61c1
    
    defb 001h	    ;61c2	0x101,
    defb 001h	    ;61c3
    
    defb 0feh	    ;61c4	0xfffe,
    defb 0ffh	    ;61c5
    
    defb 0feh	    ;61c6	0xfffe,
    defb 0ffh	    ;61c7
    
    defb 0feh	    ;61c8	0xfffe,
    defb 0ffh	    ;61c9
    
    defb 0feh	    ;61ca	0xfffe,
    defb 0ffh	    ;61cb
    
    defb 0feh	    ;61cc	0xfffe,
    defb 0ffh	    ;61cd
    
    defb 0feh	    ;61ce	0xfffe,
    defb 0ffh	    ;61cf
    
    defb 0feh	    ;61d0	0xfffe,
    defb 0ffh	    ;61d1
    
    defb 0feh	    ;61d2	0xfffe,
    defb 0ffh	    ;61d3
    
    defb 0feh	    ;61d4	0xfffe,
    defb 0ffh	    ;61d5
    
    defb 0feh	    ;61d6	0xfffe,
    defb 0ffh	    ;61d7
    
    defb 0feh	    ;61d8	0xfffe,
    defb 0ffh	    ;61d9
    
    defb 0feh	    ;61da	0xfffe,
    defb 0ffh	    ;61db
    
    defb 0feh	    ;61dc	0xfffe,
    defb 0ffh	    ;61dd
    
    defb 0feh	    ;61de	0xfffe,
    defb 0ffh	    ;61df
    
    defb 0feh	    ;61e0	0xfffe,
    defb 0ffh	    ;61e1
    
    defb 0feh	    ;61e2	0xfffe,
    defb 0ffh	    ;61e3
    
    defb 0feh	    ;61e4	0xfffe,
    defb 0ffh	    ;61e5
    
    defb 0feh	    ;61e6	0xfffe,
    defb 0ffh	    ;61e7
    
    defb 0feh	    ;61e8	0xfffe,
    defb 0ffh	    ;61e9
    
    defb 0feh	    ;61ea	0xfffe,
    defb 0ffh	    ;61eb
    
    defb 029h	    ;61ec	0x29,
    defb 000h	    ;61ed
    
    defb 001h	    ;61ee	0x101
    
    defb 03ah	    ;61f0	0x3a,
    defb 000h	    ;61f1
    
    defb 029h	    ;61f2	0x29,
    defb 000h	    ;61f3
    
    defb 0feh	    ;61f4	0xfffe
    defb 0ffh	    ;61f5



array_61f6:
    defb 000h	    ;61f6	0,
    defb 000h	    ;61f7
    
    defb 0feh	    ;61f8	0xfffe,
    defb 0ffh	    ;61f9
    
    defb 000h	    ;61fa	0,
    defb 000h	    ;61fb
    
    defb 016h	    ;61fc	0x16,
    defb 000h	    ;61fd
    
    defb 000h	    ;61fe	0,
    defb 000h	    ;61ff
    
    defb 000h	    ;6200	0,
    defb 000h	    ;6201
    
    defb 000h	    ;6202	0,
    defb 000h	    ;6203
    
    defb 000h	    ;6204	0,
    defb 000h	    ;6205
    
    defb 000h	    ;6206	0,
    defb 000h	    ;6207
    
    defb 01dh	    ;6208	0x1d,
    defb 000h	    ;6209
    
    defb 001h	    ;620a	1,
    defb 000h	    ;620b
    
    defb 000h	    ;620c	0,
    defb 000h	    ;620d
    
    defb 000h	    ;620e	0,
    defb 000h	    ;620f
    
    defb 000h	    ;6210	0,
    defb 000h	    ;6211
    
    defb 000h	    ;6212	0,
    defb 000h	    ;6213
    
    defb 000h	    ;6214	0,
    defb 000h	    ;6215
    
    defb 000h	    ;6216	0,
    defb 000h	    ;6217
    
    defb 000h	    ;6218	0,
    defb 000h	    ;6219
    
    defb 000h	    ;621a	0,
    defb 000h	    ;621b
    
    defb 000h	    ;621c	0,
    defb 000h	    ;621d
    
    defb 000h	    ;621e	0,
    defb 000h	    ;621f
    
    defb 000h	    ;6220	0,
    defb 000h	    ;6221
    
    defb 000h	    ;6222	0,
    defb 000h	    ;6223
    
    defb 000h	    ;6224	0,
    defb 000h	    ;6225
    
    defb 000h	    ;6226	0,
    defb 000h	    ;6227
    
    defb 000h	    ;6228	0,
    defb 000h	    ;6229
    
    defb 000h	    ;622a	0,
    defb 000h	    ;622b
    
    defb 000h	    ;622c	0,
    defb 000h	    ;622d
    
    defb 000h	    ;622e	0,
    defb 000h	    ;622f
    
    defb 000h	    ;6230	0,
    defb 000h	    ;6231
    
    defb 000h	    ;6232	0,
    defb 000h	    ;6233
    
    defb 017h	    ;6234	0x17,
    defb 000h	    ;6235
    
    defb 018h	    ;6236	0x18,
    defb 000h	    ;6237
    
    defb 019h	    ;6238	0x19,
    defb 000h	    ;6239
    
    defb 000h	    ;623a	0,
    defb 000h	    ;623b
    
    defb 000h	    ;623c	0,
    defb 000h	    ;623d
    
    defb 01ch	    ;623e	0x1c,
    defb 000h	    ;623f
    
    defb 002h	    ;6240	2,
    defb 000h	    ;6241
    
    defb 003h	    ;6242	3,
    defb 000h	    ;6243
    
    defb 004h	    ;6244	4,
    defb 000h	    ;6245
    
    defb 005h	    ;6246	5,
    defb 000h	    ;6247
    
    defb 006h	    ;6248	6,
    defb 000h	    ;6249
    
    defb 007h	    ;624a	7,
    defb 000h	    ;624b
    
    defb 008h	    ;624c	8,
    defb 000h	    ;624d
    
    defb 0feh	    ;624e	0xfffe,
    defb 0ffh	    ;624f
    
    defb 0feh	    ;6250	0xfffe,
    defb 0ffh	    ;6251
    
    defb 0feh	    ;6252	0xfffe,
    defb 0ffh	    ;6253
    
    defb 0feh	    ;6254	0xfffe,
    defb 0ffh	    ;6255
    
    defb 0feh	    ;6256	0xfffe,
    defb 0ffh	    ;6257
    
    defb 0feh	    ;6258	0xfffe,
    defb 0ffh	    ;6259
    
    defb 00fh	    ;625a	0xf,
    defb 000h	    ;625b
    
    defb 010h	    ;625c	0x10,
    defb 000h	    ;625d
    
    defb 011h	    ;625e	0x11,
    defb 000h	    ;625f
    
    defb 012h	    ;6260	0x12,
    defb 000h	    ;6261
    
    defb 013h	    ;6262	0x13,
    defb 000h	    ;6263
    
    defb 000h	    ;6264	0,
    defb 000h	    ;6265
    
    defb 015h	    ;6266	0x15,
    defb 000h	    ;6267
    
    defb 01ah	    ;6268	0x1a,
    defb 000h	    ;6269
    
    defb 000h	    ;626a	0,
    defb 000h	    ;626b
    
    defb 000h	    ;626c	0,
    defb 000h	    ;626d
    
    defb 01bh	    ;626e	0x1b,
    defb 000h	    ;626f
    
    defb 014h	    ;6270	0x14
    defb 000h	    ;6271

l6272h:			; branch table from sub_2c76h
    defw l310eh	    ;6272 0
    defw l3117h	    ;6274 1
    defw l312ch	    ;6276 2
    defw l313dh	    ;6278 3
    defw l314eh	    ;627a 4
    defw l315dh	    ;627c 5
    defw l316eh	    ;627e 6
    defw l317ch	    ;6280 7
    defw l318ah	    ;6282 8
    defw l31a7h	    ;6284 9
    defw l31bfh	    ;6286 10
    defw l31d6h	    ;6288 11
    defw l31e4h	    ;628a 12
    defw l31fdh	    ;628c 13
    defw l3214h	    ;628e 14
    defw l3225h	    ;6290 15
    defw l3234h	    ;6292 16
    defw l3243h	    ;6294 17
    defw l325fh	    ;6296 18
    defw l3271h	    ;6298 20
    defw l328bh	    ;629a 21
    defw l32bdh	    ;629c 22
    defw l328dh	    ;629e 23
    defw l3299h	    ;62a0 24
    defw l32a8h	    ;62a2 25
    defw l32b4h	    ;62a4 26
    defw l32b4h	    ;62a6 27
    defw l32bdh	    ;62a8 28
    defw l32bdh	    ;62aa 29

l62ach: defb "Illegal number\t%s",0

l62beh:	defb "||",0	    ;62be
l62c1h:	defb "&&",0	    ;62c1
l62c4h:	defb ">>",0	    ;62c4   
l62c7h:	defb "<<",0	    ;62c7
l62cah:	defb ">=",0	    ;62ca
l62cdh:	defb "<=",0	    ;62cd
l62d0h:	defb "!=",0	    ;62d0
l62d3h:	defb "==",0	    ;62d3

esc_seq: 
l62d6h:	db	'b'	    ;62d6
	db	8	    ;62d7
	db	't'	    ;62d8
	db	9	    ;62d9
	db	'n'	    ;62da
	db	0ah	    ;62db
	db	'f'	    ;62dc
	db	0ch	    ;62dd
	db	'r'	    ;62de
	db	0dh	    ;62df
    
    db '\\','\\',0	    ;62e0

l62e3h: db "+-*/%<>&^|?:!~(),",0    ;62e3

l62f5h: db "defined",0	    ;62f5

l62fdh:
    db 05ch	    ;62fd '\'
    db 0ah	    ;62fe
    db 0	    ;62ff

l6300h: db "Illegal character %c in preprocessor if",0	    ;6300
l6328h: db "yacc stack overflow",0	;6328
l633ch: db "syntax error",0		;633c

l6349h: db "\\", 0			;6349

l634bh: db "too many arguments",0	;634b	
l635eh: db "argument too long",0	;635e
l6370h: db "%u:",0			;6370
l6374h: db ": no match",0		;6374
l637fh: db "no name after ",0		;637f
l638eh: db "input",0			;638e
l6394h: db "r",0			;6394
l6396h: db "a",0			;6396
l6398h: db "w",0			;6398
l639ah: db "output",0			;639a
l63a1h: db "%s> ",0			;63a1
l63a6h: db "\n",0			;63a6
l63a8h: db "no room for arguments",0	;63a8
l63beh: db "Ambiguous ",0		;63be
l63c9h: db " redirection",0		;63c9
l63d6h: db "Can't open ",0		;63d6
l63e2h: db " for ",0			;63e2
l63e8h: db "(null)",0			;63e8

__iob:
l63efh:
    defb 00ah	    ;63ef ; 0 0
    defb 0a9h	    ;63f0 ; 1
    defb 000h	    ;63f1 ; 2
    defb 000h	    ;63f2 ; 3
    defb 00ah	    ;63f3 ; 4
    defb 0a9h	    ;63f4 ; 5
    defb 009h	    ;63f5 ; 6
l63f6h:		    ;    
    defb 000h	    ;63f6 ; 7

__iob+8:
l63f7h:
    defb 000h	    ;63f7 ; 0 1
    defb 000h	    ;63f8 ; 1
    defb 000h	    ;63f9 ; 2
    defb 000h	    ;63fa ; 3
    defb 000h	    ;63fb ; 4
    defb 000h	    ;63fc ; 5
    defb 006h	    ;63fd ; 6
    defb 001h	    ;63fe ; 7

 __iob+16
l63ffh:
    defb 000h	    ;63ff ; 0 2
    defb 000h	    ;6400 ; 1
    defb 000h	    ;6401 ; 2
    defb 000h	    ;6402 ; 3
    defb 000h	    ;6403 ; 4
    defb 000h	    ;6404 ; 5
    defb 006h	    ;6405 ; 6
    defb 002h	    ;6406 ; 7
    
    defb 000h	    ;6407 ; 0 3
    defb 000h	    ;6408 ; 1
    defb 000h	    ;6409 ; 2
    defb 000h	    ;640a ; 3
    defb 000h	    ;640b ; 4
    defb 000h	    ;640c ; 5
    defb 000h	    ;640d ; 6
    defb 000h	    ;640e ; 7

    defb 000h	    ;640f ; 0 4
    defb 000h	    ;6410 ; 1
    defb 000h	    ;6411 ; 2
    defb 000h	    ;6412 ; 3
    defb 000h	    ;6413 ; 4
    defb 000h	    ;6414 ; 5
    defb 000h	    ;6415 ; 6
    defb 000h	    ;6416 ; 7

    defb 000h	    ;6417 ; 0 5
    defb 000h	    ;6418 ; 1
    defb 000h	    ;6419 ; 2
    defb 000h	    ;641a ; 3
    defb 000h	    ;641b ; 4
    defb 000h	    ;641c ; 5
    defb 000h	    ;641d ; 6
    defb 000h	    ;641e ; 7

    defb 000h	    ;641f ; 0 6
    defb 000h	    ;6420 ; 1
    defb 000h	    ;6421 ; 2
    defb 000h	    ;6422 ; 3
    defb 000h	    ;6423 ; 4
    defb 000h	    ;6424 ; 5
    defb 000h	    ;6425 ; 6
    defb 000h	    ;6426 ; 7

    defb 000h	    ;6427 ; 0 7
    defb 000h	    ;6428 ; 1
    defb 000h	    ;6429 ; 2
    defb 000h	    ;642a ; 3
    defb 000h	    ;642b ; 4
    defb 000h	    ;642c ; 5
    defb 000h	    ;642d ; 6
    defb 000h	    ;642e ; 7

_dnames:	defb "CON:RDR:PUN:LST:"

__fcb:		defb 000h	;643f	; 0 +0 drive code	fcb[0]
		defb ' '	;6440	; 1 +1 file name
		defb ' '	;6441	; 2
		defb ' '	;6442	; 3
		defb ' '	;6443	; 4
		defb ' '	;6444	; 5
		defb ' '	;6445	; 6
		defb ' '	;6446	; 7
		defb ' '	;6447	; 8
		defb ' '	;6448	; 9 +9 file type
		defb ' '	;6449	;10
		defb ' '	;644a	;11
		defb 000h	;644b	;12 +12 file extent
		defb 000h	;644c	;13 +13 not used
		defb 000h	;644d	;14
		defb 000h	;644e	;15 +15 number of records in present extent
		defb 000h	;644f	;16 +16 CP/M disk map
		defb 000h	;6450	;17
		defb 000h	;6451	;18
		defb 000h	;6452	;19
		defb 000h	;6453	;20
		defb 000h	;6454	;21
		defb 000h	;6455	;22
		defb 000h	;6456	;23
		defb 000h	;6457	;24
		defb 000h	;6458	;25
		defb 000h	;6459	;26
		defb 000h	;645a	;27
		defb 000h	;645b	;28
		defb 000h	;645c	;20
		defb 000h	;645d	;30
		defb 000h	;645e	;31
		defb 000h	;645f	;32 +32 next record to read or write
		defb 000h	;6460	;33 +33 random record number (24 bit no. )
		defb 000h	;6461	;34
		defb 000h	;6462	;35
		defb 000h	;6463	;36 +36 read/write pointer in bytes
		defb 000h	;6464	;37
		defb 000h	;6465	;38
		defb 000h	;6466	;39 
array_6467:	defb 004h	;6467	;40 +40 use flag
		defb 000h	;6468	;41 +41 user id belonging to this file

		defb 000h	;6469	; 0 +0 drive code	fcb[1]
		defb ' '	;646a	; 1 +1 file name
		defb ' '	;646b	; 2
		defb ' '	;646c	; 3
		defb ' '	;646d	; 4
		defb ' '	;646e	; 5
		defb ' '	;646f	; 6
		defb ' '	;6470	; 7
		defb ' '	;6471	; 8
		defb ' '	;6472	; 9 +9 file type
		defb ' '	;6473	;10
		defb ' '	;6474	;11
		defb 000h	;6475	;12 +12 file extent
		defb 000h	;6476	;13 +13 not used
		defb 000h	;6477	;14
		defb 000h	;6478	;15 +15 number of records in present extent
		defb 000h	;6479	;16 +16 CP/M disk map
		defb 000h	;647a	;17
		defb 000h	;647b	;18
		defb 000h	;647c	;19
		defb 000h	;647d	;20
		defb 000h	;647e	;21
		defb 000h	;647f	;22
		defb 000h	;6480	;23
		defb 000h	;6481	;24
		defb 000h	;6482	;25
		defb 000h	;6483	;26
		defb 000h	;6484	;27
		defb 000h	;6485	;28
		defb 000h	;6486	;20
		defb 000h	;6487	;30
		defb 000h	;6488	;31
		defb 000h	;6489	;32 +32 next record to read or write
		defb 000h	;648a	;33 +33 random record number (24 bit no. )
		defb 000h	;648b	;34
		defb 000h	;648c	;35 
		defb 000h	;648d	;36 +36 read/write pointer in bytes .
		defb 000h	;648e	;37 
		defb 000h	;648f	;38 
		defb 000h	;6490	;39 
		defb 004h	;6491	;40 +40 use flag
		defb 000h	;6492	;41 +41 user id belonging to this file

		defb 000h	;6493	; 0 +0 drive code	fcb[2]
		defb ' '	;6494	; 1 +1 file name
		defb ' '	;6495	; 2
		defb ' '	;6496	; 3
		defb ' '	;6497	; 4
		defb ' '	;6498	; 5
		defb ' '	;6499	; 6
		defb ' '	;649a	; 7
		defb ' '	;649b	; 8
		defb ' '	;649c	; 9 +9 file type
		defb ' '	;649d	;10
		defb ' '	;649e	;11
		defb 000h	;649f	;12 +12 file extent
		defb 000h	;64a0	;13 +13 not used
		defb 000h	;64a1	;14
		defb 000h	;64a2	;15 +15 number of records in present extent
		defb 000h	;64a3	;16 +16 CP/M disk map
		defb 000h	;64a4	;17
		defb 000h	;64a5	;18
		defb 000h	;64a6	;19
		defb 000h	;64a7	;20
		defb 000h	;64a8	;21
		defb 000h	;64a9	;22
		defb 000h	;64aa	;23
		defb 000h	;64ab	;24
		defb 000h	;64ac	;25
		defb 000h	;64ad	;26
		defb 000h	;64ae	;27
		defb 000h	;64af	;28
		defb 000h	;64b0	;20
		defb 000h	;64b1	;30
		defb 000h	;64b2	;31
		defb 000h	;64b3	;32 +32 next record to read or write
		defb 000h	;64b4	;33 +33 random record number (24 bit no. )
		defb 000h	;64b5	;34
		defb 000h	;64b6	;35 
		defb 000h	;64b7	;36 +36 read/write pointer in bytes .
		defb 000h	;64b8	;37 
		defb 000h	;64b9	;38 
		defb 000h	;64ba	;39 
		defb 004h	;64bb	;40 +40 use flag
		defb 000h	;64bc	;41 +41 user id belonging to this file

		defb 000h	;64bd	; 0 +0 drive code	fcb[3]
		defb 000h	;64be	; 1 +1 file name
		defb 000h	;64bf	; 2
		defb 000h	;64c0	; 3
		defb 000h	;64c1	; 4
		defb 000h	;64c2	; 5
		defb 000h	;64c3	; 6
		defb 000h	;64c4	; 7
		defb 000h	;64c5	; 8
		defb 000h	;64c6	; 9 +9 file type
		defb 000h	;64c7	;10
		defb 000h	;64c8	;11
		defb 000h	;64c9	;12 +12 file extent
		defb 000h	;64ca	;13 +13 not used
		defb 000h	;64cb	;14
		defb 000h	;64cc	;15 +15 number of records in present extent
		defb 000h	;64cd	;16 +16 CP/M disk map
		defb 000h	;64ce	;17
		defb 000h	;64cf	;18
		defb 000h	;64d0	;19
		defb 000h	;64d1	;20
		defb 000h	;64d2	;21
		defb 000h	;64d3	;22
		defb 000h	;64d4	;23
		defb 000h	;64d5	;24
		defb 000h	;64d6	;25
		defb 000h	;64d7	;26
		defb 000h	;64d8	;27
		defb 000h	;64d9	;28
		defb 000h	;64da	;20
		defb 000h	;64db	;30
		defb 000h	;64dc	;31
		defb 000h	;64dd	;32 +32 next record to read or write
		defb 000h	;64de	;33 +33 random record number (24 bit no. )
		defb 000h	;64df	;34
		defb 000h	;64e0	;35 
		defb 000h	;64e1	;36 +36 read/write pointer in bytes .
		defb 000h	;64e2	;37 
		defb 000h	;64e3	;38 
		defb 000h	;64e4	;39 
		defb 000h	;64e5	;40 +40 use flag
		defb 000h	;64e6	;41 +41 user id belonging to this file

		defb 000h	;64e7	; 0 +0 drive code	fcb[4]
		defb 000h	;64e8	; 1 +1 file name
		defb 000h	;64e9	; 2
		defb 000h	;64ea	; 3
		defb 000h	;64eb	; 4
		defb 000h	;64ec	; 5
		defb 000h	;64ed	; 6
		defb 000h	;64ee	; 7
		defb 000h	;64ef	; 8
		defb 000h	;64f0	; 9 +9 file type
		defb 000h	;64f1	;10
		defb 000h	;64f2	;11
		defb 000h	;64f3	;12 +12 file extent
		defb 000h	;64f4	;13 +13 not used
		defb 000h	;64f5	;14
		defb 000h	;64f6	;15 +15 number of records in present extent
		defb 000h	;64f7	;16 +16 CP/M disk map
		defb 000h	;64f8	;17
		defb 000h	;64f9	;18
		defb 000h	;64fa	;19
		defb 000h	;64fb	;20
		defb 000h	;64fc	;21
		defb 000h	;64fd	;22
		defb 000h	;64fe	;23
		defb 000h	;64ff	;24
		defb 000h	;6500	;25
		defb 000h	;6501	;26
		defb 000h	;6502	;27
		defb 000h	;6503	;28
		defb 000h	;6504	;20
		defb 000h	;6505	;30
		defb 000h	;6506	;31
		defb 000h	;6507	;32 +32 next record to read or write
		defb 000h	;6508	;33 +33 random record number (24 bit no. )
		defb 000h	;6509	;34
		defb 000h	;650a	;35 
		defb 000h	;650b	;36 +36 read/write pointer in bytes .
		defb 000h	;650c	;37 
		defb 000h	;650d	;38 
		defb 000h	;650e	;39 
		defb 000h	;650f	;40 +40 use flag
		defb 000h	;6510	;41 +41 user id belonging to this file

		defb 000h	;6511	; 0 +0 drive code	fcb[5]
		defb 000h	;6512	; 1 +1 file name
		defb 000h	;6513	; 2
		defb 000h	;6514	; 3
		defb 000h	;6515	; 4
		defb 000h	;6516	; 5
		defb 000h	;6517	; 6
		defb 000h	;6518	; 7
		defb 000h	;6519	; 8
		defb 000h	;651a	; 9 +9 file type
		defb 000h	;651b	;10
		defb 000h	;651c	;11
		defb 000h	;651d	;12 +12 file extent
		defb 000h	;651e	;13 +13 not used
		defb 000h	;651f	;14
		defb 000h	;6520	;15 +15 number of records in present extent
		defb 000h	;6521	;16 +16 CP/M disk map
		defb 000h	;6522	;17
		defb 000h	;6523	;18
		defb 000h	;6524	;19
		defb 000h	;6525	;20
		defb 000h	;6526	;21
		defb 000h	;6527	;22
		defb 000h	;6528	;23
		defb 000h	;6529	;24
		defb 000h	;652a	;25
		defb 000h	;652b	;26
		defb 000h	;652c	;27
		defb 000h	;652d	;28
		defb 000h	;652e	;20
		defb 000h	;652f	;30
		defb 000h	;6530	;31
		defb 000h	;6531	;32 +32 next record to read or write
		defb 000h	;6532	;33 +33 random record number (24 bit no. )
		defb 000h	;6533	;34
		defb 000h	;6534	;35 
		defb 000h	;6535	;36 +36 read/write pointer in bytes .
		defb 000h	;6536	;37 
		defb 000h	;6537	;38 
		defb 000h	;6538	;39 
		defb 000h	;6539	;40 +40 use flag
		defb 000h	;653a	;41 +41 user id belonging to this file

		defb 000h	;653b	; 0 +0 drive code	fcb[6]
		defb 000h	;653c	; 1 +1 file name
		defb 000h	;653d	; 2
		defb 000h	;653e	; 3
		defb 000h	;653f	; 4
		defb 000h	;6540	; 5
		defb 000h	;6541	; 6
		defb 000h	;6542	; 7
		defb 000h	;6543	; 8
		defb 000h	;6544	; 9 +9 file type
		defb 000h	;6545	;10
		defb 000h	;6546	;11
		defb 000h	;6547	;12 +12 file extent
		defb 000h	;6548	;13 +13 not used
		defb 000h	;6549	;14
		defb 000h	;654a	;15 +15 number of records in present extent
		defb 000h	;654b	;16 +16 CP/M disk map
		defb 000h	;654c	;17
		defb 000h	;654d	;18
		defb 000h	;654e	;19
		defb 000h	;654f	;20
		defb 000h	;6550	;21
		defb 000h	;6551	;22
		defb 000h	;6552	;23
		defb 000h	;6553	;24
		defb 000h	;6554	;25
		defb 000h	;6555	;26
		defb 000h	;6556	;27
		defb 000h	;6557	;28
		defb 000h	;6558	;20
		defb 000h	;6559	;30
		defb 000h	;655a	;31
		defb 000h	;655b	;32 +32 next record to read or write
		defb 000h	;655c	;33 +33 random record number (24 bit no. )
		defb 000h	;655d	;34
		defb 000h	;655e	;35 
		defb 000h	;655f	;36 +36 read/write pointer in bytes .
		defb 000h	;6560	;37 
		defb 000h	;6561	;38 
		defb 000h	;6562	;39 
		defb 000h	;6563	;40 +40 use flag
		defb 000h	;6564	;41 +41 user id belonging to this file

		defb 000h	;6565	; 0 +0 drive code	fcb[7]
		defb 000h	;6566	; 1 +1 file name
		defb 000h	;6567	; 2
		defb 000h	;6568	; 3
		defb 000h	;6569	; 4
		defb 000h	;656a	; 5
		defb 000h	;656b	; 6
		defb 000h	;656c	; 7
		defb 000h	;656d	; 8
		defb 000h	;656e	; 9 +9 file type
		defb 000h	;656f	;10
		defb 000h	;6570	;11
		defb 000h	;6571	;12 +12 file extent
		defb 000h	;6572	;13 +13 not used
		defb 000h	;6573	;14
		defb 000h	;6574	;15 +15 number of records in present extent
		defb 000h	;6575	;16 +16 CP/M disk map
		defb 000h	;6576	;17
		defb 000h	;6577	;18
		defb 000h	;6578	;19
		defb 000h	;6579	;20
		defb 000h	;657a	;21
		defb 000h	;657b	;22
		defb 000h	;657c	;23
		defb 000h	;657d	;24
		defb 000h	;657e	;25
		defb 000h	;657f	;26
		defb 000h	;6580	;27
		defb 000h	;6581	;28
		defb 000h	;6582	;20
		defb 000h	;6583	;30
		defb 000h	;6584	;31
		defb 000h	;6585	;32 +32 next record to read or write
		defb 000h	;6586	;33 +33 random record number (24 bit no. )
		defb 000h	;6587	;34
		defb 000h	;6588	;35 
		defb 000h	;6589	;36 +36 read/write pointer in bytes .
		defb 000h	;658a	;37 
		defb 000h	;658b	;38 
		defb 000h	;658c	;39 
		defb 000h	;658d	;40 +40 use flag
		defb 000h	;658e	;41 +41 user id belonging to this file

__ctype_:
    defb 000h	    ;658f
    defb 020h	    ;6590
    defb 020h	    ;6591
    defb 020h	    ;6592
    defb 020h	    ;6593
    defb 020h	    ;6594
    defb 020h	    ;6595
    defb 020h	    ;6596
    defb 020h	    ;6597
    defb 020h	    ;6598
    defb 008h	    ;6599
    defb 008h	    ;659a
    defb 008h	    ;659b
    defb 008h	    ;659c
    defb 008h	    ;659d
    defb 020h	    ;659e
    defb 020h	    ;659f
    defb 020h	    ;65a0
    defb 020h	    ;65a1
    defb 020h	    ;65a2
    defb 020h	    ;65a3
    defb 020h	    ;65a4
    defb 020h	    ;65a5
    defb 020h	    ;65a6
    defb 020h	    ;65a7
    defb 020h	    ;65a8
    defb 020h	    ;65a9
    defb 020h	    ;65aa
    defb 020h	    ;65ab
    defb 020h	    ;65ac
    defb 020h	    ;65ad
    defb 020h	    ;65ae
    defb 020h	    ;65af
    defb 008h	    ;65b0
    defb 010h	    ;65b1
    defb 010h	    ;65b2
    defb 010h	    ;65b3
    defb 010h	    ;65b4
    defb 010h	    ;65b5
    defb 010h	    ;65b6
    defb 010h	    ;65b7
    defb 010h	    ;65b8
    defb 010h	    ;65b9
    defb 010h	    ;65ba
    defb 010h	    ;65bb
    defb 010h	    ;65bc
    defb 010h	    ;65bd
    defb 010h	    ;65be
    defb 010h	    ;65bf
    defb 004h	    ;65c0
    defb 004h	    ;65c1
    defb 004h	    ;65c2
    defb 004h	    ;65c3
    defb 004h	    ;65c4
    defb 004h	    ;65c5
    defb 004h	    ;65c6
    defb 004h	    ;65c7
    defb 004h	    ;65c8
    defb 004h	    ;65c9
    defb 010h	    ;65ca
    defb 010h	    ;65cb
    defb 010h	    ;65cc
    defb 010h	    ;65cd
    defb 010h	    ;65ce
    defb 010h	    ;65cf
    defb 010h	    ;65d0
    defb 041h	    ;65d1
    defb 041h	    ;65d2
    defb 041h	    ;65d3
    defb 041h	    ;65d4
    defb 041h	    ;65d5
    defb 041h	    ;65d6
    defb 001h	    ;65d7
    defb 001h	    ;65d8
    defb 001h	    ;65d9
    defb 001h	    ;65da
    defb 001h	    ;65db
    defb 001h	    ;65dc
    defb 001h	    ;65dd
    defb 001h	    ;65de
    defb 001h	    ;65df
    defb 001h	    ;65e0
    defb 001h	    ;65e1
    defb 001h	    ;65e2
    defb 001h	    ;65e3
    defb 001h	    ;65e4
    defb 001h	    ;65e5
    defb 001h	    ;65e6
    defb 001h	    ;65e7
    defb 001h	    ;65e8
    defb 001h	    ;65e9
    defb 001h	    ;65ea
    defb 010h	    ;65eb
    defb 010h	    ;65ec
    defb 010h	    ;65ed
    defb 010h	    ;65ee
    defb 010h	    ;65ef
    defb 010h	    ;65f0
    defb 042h	    ;65f1
    defb 042h	    ;65f2
    defb 042h	    ;65f3
    defb 042h	    ;65f4
    defb 042h	    ;65f5
    defb 042h	    ;65f6
    defb 002h	    ;65f7
    defb 002h	    ;65f8
    defb 002h	    ;65f9
    defb 002h	    ;65fa
    defb 002h	    ;65fb
    defb 002h	    ;65fc
    defb 002h	    ;65fd
    defb 002h	    ;65fe
    defb 002h	    ;65ff
    defb 002h	    ;6600
    defb 002h	    ;6601
    defb 002h	    ;6602
    defb 002h	    ;6603
    defb 002h	    ;6604
    defb 002h	    ;6605
    defb 002h	    ;6606
    defb 002h	    ;6607
    defb 002h	    ;6608
    defb 002h	    ;6609
    defb 002h	    ;660a
    defb 010h	    ;660b
    defb 010h	    ;660c
    defb 010h	    ;660d
    defb 010h	    ;660e
    defb 020h	    ;660f
l6610h:				; from pnum
    defb 030h	    ;6610
    defb 031h	    ;6611
    defb 032h	    ;6612
    defb 033h	    ;6613
    defb 034h	    ;6614
    defb 035h	    ;6615
    defb 036h	    ;6616
    defb 037h	    ;6617
    defb 038h	    ;6618
    defb 039h	    ;6619
    defb 041h	    ;661a
    defb 042h	    ;661b
    defb 043h	    ;661c
    defb 044h	    ;661d
    defb 045h	    ;661e
    defb 046h	    ;661f
    defb 000h	    ;6620

__Lbss:					; BSS section start (static variable)
word_6621:
    defb 000h	    ;6621
    defb 000h	    ;6622
word_6623:
    defb 000h	    ;6623
    defb 000h	    ;6624
array_6625:
    defb 000h	    ;6625  0
    defb 000h	    ;6626  1
    defb 000h	    ;6627  2
    defb 000h	    ;6628  3
    defb 000h	    ;6629  4
    defb 000h	    ;662a  5
    defb 000h	    ;662b  6
    defb 000h	    ;662c  7
    defb 000h	    ;662d  8
    defb 000h	    ;662e  9
    defb 000h	    ;662f 10
    defb 000h	    ;6630 11
    defb 000h	    ;6631 12
    defb 000h	    ;6632 13
    defb 000h	    ;6633 14
    defb 000h	    ;6634 15
    defb 000h	    ;6635 16
    defb 000h	    ;6636 17
    defb 000h	    ;6637 18
    defb 000h	    ;6638 19
    defb 000h	    ;6639 20
    defb 000h	    ;663a 21
    defb 000h	    ;663b 22
    defb 000h	    ;663c 23
    defb 000h	    ;663d 24
    defb 000h	    ;663e 25
    defb 000h	    ;663f 26
    defb 000h	    ;6640 27
    defb 000h	    ;6641 28
    defb 000h	    ;6642 29
    defb 000h	    ;6643 30
    defb 000h	    ;6644 31
    defb 000h	    ;6645 32
    defb 000h	    ;6646 33
    defb 000h	    ;6647 34
    defb 000h	    ;6648 35
    defb 000h	    ;6649 36
    defb 000h	    ;664a 37
    defb 000h	    ;664b 38
    defb 000h	    ;664c 39
    defb 000h	    ;664d 40
    defb 000h	    ;664e 41
    defb 000h	    ;664f 42
    defb 000h	    ;6650 43
    defb 000h	    ;6651 44
    defb 000h	    ;6652 45
    defb 000h	    ;6653 46
    defb 000h	    ;6654 47
    defb 000h	    ;6655 48
    defb 000h	    ;6656 49
    defb 000h	    ;6657 50
    defb 000h	    ;6658 51
    defb 000h	    ;6659 52
    defb 000h	    ;665a 53
    defb 000h	    ;665b 54
    defb 000h	    ;665c 55
    defb 000h	    ;665d 56
    defb 000h	    ;665e 57
    defb 000h	    ;665f 58
    defb 000h	    ;6660 59
    defb 000h	    ;6661 60
    defb 000h	    ;6662 61
    defb 000h	    ;6663 62
    defb 000h	    ;6664 63
    defb 000h	    ;6665 64
    defb 000h	    ;6666 65
    defb 000h	    ;6667 66
    defb 000h	    ;6668 67
    defb 000h	    ;6669 68
    defb 000h	    ;666a 69
    defb 000h	    ;666b 70
    defb 000h	    ;666c 71
    defb 000h	    ;666d 72
    defb 000h	    ;666e 73
    defb 000h	    ;666f 74
    defb 000h	    ;6670 75
    defb 000h	    ;6671 76
    defb 000h	    ;6672 77
    defb 000h	    ;6673 78
    defb 000h	    ;6674 79
    defb 000h	    ;6675 80
    defb 000h	    ;6676 81
    defb 000h	    ;6677 82
    defb 000h	    ;6678 83
    defb 000h	    ;6679 84
    defb 000h	    ;667a 85
    defb 000h	    ;667b 86
    defb 000h	    ;667c 87
    defb 000h	    ;667d 88
    defb 000h	    ;667e 89
    defb 000h	    ;667f 90


word_9c98:  ds 2    ;9c98
word_a8fd:  ds 2    ;a8fd
word_a8ff:  ds 2    ;a8ff
