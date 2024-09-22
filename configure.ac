AC_INIT([OMEN kernel], [0.1], [youremail@example.com])
AM_INIT_AUTOMAKE([foreign])

AC_CONFIG_SRCDIR([src/kernel.c])  
AC_CONFIG_HEADERS([src/conf/generic/build_config.h])
AC_CONFIG_FILES([Makefile])

#m4_include([ax_check_compile_flag.m4])


AC_ARG_WITH([cross-compiler],
    [AS_HELP_STRING([--with-cross-compiler=COMPILER], [Specify the C cross-compiler to use])],
    [CC=$withval],
    [CC=gcc])

AC_ARG_WITH([linker],
    [AS_HELP_STRING([--with-linker=LINKER], [Specify the linker to use])],
    [LD=$withval],
    [LD=ld])

AC_ARG_WITH([assembler],
    [AS_HELP_STRING([--with-assembler=ASSEMBLER], [Specify the assembler to use])],
    [ASMC=$withval],
    [ASMC=nasm])

AC_ARG_WITH([c_flags],
    [AS_HELP_STRING([--with-c_flags=CFLAGS], [Specify extra C compiler flags])],
    [CFLAGS=$withval],
    [CFLAGS="-O2 -g -Wall -Wextra -pipe -std=c11 -ffreestanding -fno-pie -fno-pic -m64 -march=x86-64 -mabi=sysv -mno-80387 -mno-red-zone -mcmodel=kernel -MMD"])

AC_ARG_WITH([ld_flags],
    [AS_HELP_STRING([--with-ld_flags=LDFLAGS], [Specify extra linker flags])],
    [LDFLAGS=$withval],
    [LDFLAGS="-nostdlib -static -z max-page-size=0x1000"])
    

AC_ARG_WITH([asm_flags],
    [AS_HELP_STRING([--with-asm_flags=ASMFLAGS], [Specify extra assembler flags])],
    [NASMFLAGS=$withval],
    [NASMFLAGS="-f elf64"])

AC_ARG_WITH([gdb],
    [AS_HELP_STRING([--with-debugger=GDB], [Specify the path to GDB])],
    [GDB=$withval],
    [GDB=gdb])  # Default to 'gdb'

AC_CHECK_PROG([HAVE_GIT], [git], [git], [no])
AC_CHECK_PROG([HAVE_MAKE], [make], [make], [no])
AC_CHECK_PROG([HAVE_MTOOLS], [mtools], [mcopy], [no])


AC_CHECK_PROG([ASMC], [$ASMC], [$ASMC], [AC_MSG_ERROR([Assembler $ASMC not found. Please install it or specify a valid assembler.])])
AC_CHECK_PROG([CC], [$CC], [$CC], [AC_MSG_ERROR([C compiler $CC not found. Please install it or specify a valid compiler.])])
AC_CHECK_PROG([LD], [$LD], [$LD], [AC_MSG_ERROR([Linker $LD not found. Please install it or specify a valid linker.])])
AC_CHECK_PROG([GDB_FOUND], [$GDB], [$GDB], [no])
if test "x$GDB_FOUND" = "xno"; then
    AC_MSG_ERROR([GDB is required for debugging. Please install gdb or specify a valid debugger with --with-gdb.])
fi

AC_MSG_CHECKING([whether the compiler supports required flags])
AX_CHECK_COMPILE_FLAG([-ffreestanding], [CFLAGS="$CFLAGS -ffreestanding"])
AX_CHECK_COMPILE_FLAG([-fno-stack-protector], [CFLAGS="$CFLAGS -fno-stack-protector"])
AX_CHECK_COMPILE_FLAG([-m64], [CFLAGS="$CFLAGS -m64"])


AC_MSG_RESULT([Using C compiler: $CC])
AC_MSG_RESULT([Using linker: $LD])
AC_MSG_RESULT([Using assembler: $ASMC])
AC_MSG_RESULT([CFLAGS: $CFLAGS])
AC_MSG_RESULT([LDFLAGS: $LDFLAGS])
AC_MSG_RESULT([NASMFLAGS: $NASMFLAGS])

AC_MSG_RESULT([CONFIGURING PATHS])


AC_OUTPUT
