########################################################################
#
#  Use this Makefile to build the CPP for HiTech C v3.09 under Linux
#  using John Elliott's zxcc emulator.
#
########################################################################

VERSION = 3.0

CSRCS =	cpp_new.c \
	cpy.c \
	vprintf.c

COBJS = $(CSRCS:.c=.obj)

OBJS = $(COBJS)

all:	$(COBJS) cpp_new.com 

.SUFFIXES:		# delete the default suffixes
.SUFFIXES: .c .obj .asm

$(COBJS): %.obj: %.c
	zxc -c -o  $<

cpp_new.com: $(OBJS)
	zxcc link -"<" +lkcpp
	sort cpp_new.sym | uniq > cpp_new.sym.sorted

clean:
	rm -f $(OBJS) cpp_new.com *.\$$\$$\$$ cpp_new.map cpp_new.sym cpp_new.sym.sorted

compress:
	enhuff -a cpp_new.HUF cpp_new.c spy.c vprintf.c makefile lkcpp

