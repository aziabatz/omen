# Makefile.am
builddir = $(top_builddir)/build/bin
srcdir = .

SRCDIR = $(srcdir)/src
INCLUDE_DIR = $(SRCDIR)/include
CONFIG_DIR = $(SRCDIR)/conf
DRIVER_DIR = $(SRCDIR)/drivers
BUILDHOME = $(srcdir)/build
BUILDDIR = $(BUILDHOME)/bin
OBJDIR = $(BUILDHOME)/lib
ISOBUILDDIR = $(BUILDHOME)/iso_root
ISODIR = $(BUILDHOME)/image
LMNDIR = $(srcdir)/buildenv/limine
OVMFDIR = $(srcdir)/buildenv/OVMFbin

KERNEL = kernel.elf
ISO = limine-cd.iso
IMG = limine-cd.img
VDI = limine-cd.vdi
IMG_RAW = raw.img
LIMINECFG = limine.conf
LINKER_SCRIPT = buildenv/linker.ld

# SRCS = $(shell find $(SRCDIR) -type f \( -name '*.c' -o -name '*.S' -o -name '*.asm' \))

SRCS_C = $(shell find $(SRCDIR) -type f -name '*.c')
SRCS_S = $(shell find $(SRCDIR) -type f -name '*.S')
SRCS_NASM = $(shell find $(SRCDIR) -type f -name '*.asm')

SRCS = $(SRCS_C) $(SRCS_S) $(SRCS_NASM)

OBJS = $(patsubst %.c, $(builddir)/%.o, $(SRCS_C))
OBJS += $(patsubst %.S, $(builddir)/%_S.o, $(SRCS_S))
OBJS += $(patsubst %.asm, $(builddir)/%_asm.o, $(SRCS_NASM))


bin_PROGRAMS = omen
omen_SOURCES = $(SRCS)

# Compiler flags
AM_CPPFLAGS = -I$(srcdir)/include
#CFLAGS := -std=gnu11 -g -Wall -Wextra -Wmissing-declarations 
CFLAGS += -I$(INCLUDE_DIR)
CFLAGS += -I$(CONFIG_DIR)
CFLAGS += -I$(DRIVER_DIR)

LDFLAGS += -T $(LINKER_SCRIPT)


all:
	@echo "Building kernel..."
	@echo "OBJS: $(OBJS)"
	@make omen
	@echo "Building ISO..."
	@make iso
	@echo "Running QEMU..."
	@make run
	@echo "Done!"

omen: $(OBJS) link

# Rules for compiling object files
$(builddir)/%.o: %.c
	@echo !==== COMPILING $^
	mkdir -p $$(dirname $@)
	$(CC) $(CFLAGS) -c $< -o $@
$(builddir)/%_asm.o: %.asm
	@echo !==== COMPILING $^
	mkdir -p $(@D)
	$(ASMC) $^ -felf64 -o $@
$(builddir)/%_S.o: %.S
	@echo !==== COMPILING $^
	mkdir -p $(@D)
	$(ASMC) $(NASMFLAGS) $^ -f elf64 -o $@

# Rules for linking the object files
link: $(OBJS)
	@echo !==== LINKING binaries
	@$(LD) $(LDFLAGS) -o $(BUILDDIR)/$(KERNEL) $(OBJS)

# Rules for building the ISO
iso: omen
	@echo "Building ISO..."
	cp $(ISODIR)/$(IMG_RAW) $(ISODIR)/$(IMG)

	truncate -s 100M $(ISODIR)/$(IMG)
	rm -rf .mtoolsrc
	echo "drive i: file=\"$(ISODIR)/$(IMG)\"" >> .mtoolsrc
	mformat -F -i $(ISODIR)/$(IMG) ::
	mdir -i $(ISODIR)/$(IMG)

	mmd -i $(ISODIR)/$(IMG) ::/efi
	mmd -i $(ISODIR)/$(IMG) ::/efi/boot

	mcopy -i $(ISODIR)/$(IMG) $(BOOTEFI) ::/efi/boot
	mcopy -i $(ISODIR)/$(IMG) ./startup.nsh ::
	mcopy -i $(ISODIR)/$(IMG) $(BUILDDIR)/$(KERNEL) ::
	mcopy -i $(ISODIR)/$(IMG) ./limine.conf ::

	echo "Disk mounted, creating system files"


# Clean rules
clean-local:
	@for objfile in $(OBJS); do \
		echo "Removing $$objfile"; \
		rm -f "$$objfile"; \
	done

debug:
	@echo "builddir: $(builddir)"
	@echo "srcdir: $(srcdir)"
	@echo "SRCS: $(SRCS)"
	@echo "OBJS: $(OBJS)"

.PHONY: omen clean clean-local iso all link
