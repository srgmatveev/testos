OPTIMIZATION = 2
GPP_PARAMS = -m32 -O$(OPTIMIZATION) -std=c++14 -fno-use-cxa-atexit -fno-builtin -fno-leading-underscore -ffreestanding -O2 -fno-exceptions -fno-rtti -Wall -Wextra -pedantic-errors
NASM_PARAMS = -felf32
LD_PARAMS = -m elf_i386
MKDIR_P = mkdir -p
OBJ_DIR = obj

objects = obj/loader.o \
	      obj/constructors.o \
		  obj/kernel.o


$(OBJ_DIR)/%.o: src/%.cpp
	@$(MKDIR_P) $(@D)
	i686-elf-g++ $(GPP_PARAMS) -o $@ -c $<
$(OBJ_DIR)/%.o: src/%.s
	@$(MKDIR_P) $(@D)
	nasm $(NASM_PARAMS) -o $@  $<

testos.bin: linker.ld $(objects)
	ld $(LD_PARAMS) -T $< -o $@ $(objects)


testos.iso: testos.bin
	mkdir -p iso
	mkdir -p iso/boot
	mkdir -p iso/boot/grub
	cp $< iso/boot/testos.bin
	echo 'set timeout=0'                 > iso/boot/grub/grub.cfg
	echo 'set default=0'                >> iso/boot/grub/grub.cfg
	echo ''                             >> iso/boot/grub/grub.cfg
	echo 'menuentry "testos" {'          >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/testos.bin'  >> iso/boot/grub/grub.cfg
	echo '  boot'                       >> iso/boot/grub/grub.cfg
	echo '}'                            >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso

run: testos.iso
	VirtualBoxVM --startvm Test_OS &

install: testos.bin
	sudo cp $< /boot/testos.bin

title:
	shell(echo ${OBJ_DIR_P})

