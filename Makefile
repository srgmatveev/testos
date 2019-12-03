OPTIMIZATION = 0
GPP_PARAMS = -m32 -O$(OPTIMIZATION) -std=c++14 -fno-use-cxa-atexit -fno-builtin -fno-rtti -fno-leading-underscore -Wall -Wextra -pedantic-errors
AS_PARAMS = --32
LD_PARAMS = -m elf_i386

objects = obj/loader.o \
	      obj/constructors.o \
		  obj/kernel.o

obj/%.o: src/%.cpp
	g++ $(GPP_PARAMS) -o $@ -c $<
obj/%.o: src/%.s
	as $(AS_PARAMS) -o $@  $<

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
	echo 'menuentry "TestOS" {'          >> iso/boot/grub/grub.cfg
	echo '  multiboot /boot/testos.bin'  >> iso/boot/grub/grub.cfg
	echo '  boot'                       >> iso/boot/grub/grub.cfg
	echo '}'                            >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso

run: testos.iso
	VirtualBoxVM --startvm Test_OS &

install: testos.bin
	sudo cp $< /boot/testos.bin

