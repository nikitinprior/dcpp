# dcpp
New C Preprocessor for Hi-Tech C Compiler v3.09

# Introduction

When I started decompiling the preprocessor from the Hi-Tech C compiler package v3.09, I found that the error messages are completely identical to the messages of the program written by John F. Reiser. So I assumed that the Hi-Tech C preprocessor is based on this program. This assumption turned out to be correct.

# Decompilation results

The C preprocessor, which is part of the Hi-Tech C compiler v3.09, uses the cpp.c program code written by John F. Raiser in July/August 1987. The Hi-Tech C preprocessor uses almost all the functions and variables of the source program.
The source program has been adapted to process the C language source codes in CP/M encoding, in which each line ends with the characters CR and LF.  Hi-Tech has made the following changes:
In the cotoken function, a case is added to the switch statement for characters with codes 1-9, 11-32, 35-37, 40-46, 58, 59, 63, 64, 91, 93, 94, 96 and 123. Code has been added to the main function for to handle the #asm and #endasm directives, and directives CPM and z80 are predefined.

Unfortunately, the preprocessor version is Hi-Tech C, just like the original John F program. Reiser, do not support C++ - style comments.

Creating a new preprocessor

Fortunately, other programmers also made changes to the source code of the program, adding additional features to it.
A new implementation of the preprocessor, based on the 1978 UNIX 32V release with permission from Caldera Inc., was written by J. Schilling. Its preprocessor version can handle C++ comments and adds some features.

Based on the fact that his version of the program is also based on the code of John F. I decided  use the code of J. Schilling and adapt it to work under the CP/M operating system. Part of the code from the restored original version of the preprocessor was added to the program text, turning it almost into a Hi-Tech C version, and part of the code with functions not needed in the CP/M version was excluded.

Deleted options:

	-version 	Displaying the version of the program;
	-xsc and -xuc 	Specifying char type by default signed or unsigned;
	-M		Generate make dependencies;
	-p 		Suppress "extra tokens warn" warnings.

Left command line options:

	-noinclude
	-undef 		Remove predefined macros;
	-T 		Compatibility with V7, specifying the name length equal to 8;
	-H		Print names of include files.

In addition, the new version of the preprocessor supports the conditional compilation directive #elif.

In the new version of the preprocessor, the error and warning message routines have been modified to support a variable number of parameters.
In addition, the new preprocessor supports all the command-line options available in the Hi-Tech C version.

	-C		Retain comments in output;
	-Dname		Define name as "1";
	-Dname=def	Define name as def;
	-0
	-E		Ignored;
	-Idirectory	Add directory to search list for #include files;
	-P		Don't insert lines "# 12 \"foo.c\""
			into output;
	-R		Allow recursive macros;
	-Uname		Undefine name.

As a result, the Hi-Tech C compiler v3. 09 for CP/M now has an alternative preprocessor that supports C++ - style comments, compatible with the original preprocessor of the compiler itself.

# For those who are interested

The code of the new preprocessor is presented based on the version of the program by J. Schilling in the file cpp_new. c. Executable file - cpp_new.com.
The cpp_old.c file contains the restored code of the Hi-Tech C v3.09 preprocessor. It is compiled partially, and is not linked to the executable program. The recovered code contains C++ comments and compiles successfully using the new preprocessor. The cpp_old.asm file is the restored assembly code.

As a result of the work done, I have received all the information I need and I do not want to waste time completely restoring the original source code of the Hi-Tech C v3.09 preprocessor.

Unfortunately, modern analogues of the yacc program generate other tables and code in the C language. To convert the file " cpy.y" I had to use the yacc program code from the old UNIX distribution, adapting it for CP/M.
The text of the program "cpy. c" was obtained using the yacc program using the code

	yacc cpy.y

the resulting file is renamed to "cpy. c".

The pperror, yyerror, and ppwarn functions have been changed, and they require the "vfprintf.c" function.

# Compiling the program

To compile a new preprocessor, you need to run the command

	zxc -o cpp_new.c spy.c vprintf.c

or you can run the make command. In this case, in addition to the executable, a symbol file and a file with a program memory card will be created.

The size of the executable program became 29 KB instead of 26 KB in the Hi-Tech C v3.09 compiler.

# Copyright

The Hi-Tech C compiler V3.09 is provided free of charge for any use, private or commercial, strictly as-is. No warranty or product support is offered or implied including merchantability, fitness for a particular purpose, or non-infringement. In no event will Hi-Tech Software or its corporate affiliates be liable for any direct or indirect damages.

You may use this software for whatever you like, providing you ACKNOWLEDGE that the copyright to this software remains with Hi-Tech Software and its corporate affiliates.

All copyrights to the algorithms used, binary code, trademarks, etc. belong to the legal owner - Microchip Technology Inc. and its subsidiaries. Commercial use and distribution of recreated source codes without permission from the copyright holderis strictly FORBIDDEN.

# Changes in the program

The source code of the preprocessor program contains code for processing the "#error message " directive. However, to activate it at the beginning of the program, you need to add the #define EXIT_ON_ERROR directive and change the storage class of the char ebuf[BUFFERSIZ] character array to static char ebuf[BUFFERSIZ]. After recompiling the program, the "#error message " directive will be activated. The necessary changes have been made to the source code of the program. Thanks to FredW for the comments made.
26.06.2021

# Appreciation

John F. Reiser for writing the preprocessor program.

J. Schilling for adding new features to the original preprocessor text. 

Hi-Tech Software for writing a compiler and providing it for free use.

To all authors who are not indifferent to CP/M and have written
wonderful emulators: cpm (Keiji Murakami), iz-cpm (Iván Izaguirre),
zxcc (John Elliott), aliados (Julián Albo), cpm for osx (Thomas Harte),
tnylpo (Georg Brein), and etc.),

Tony Nicholson for the support of the information about the compiler.

Andrey Nikitin (nikitinprior@gmail.com)
