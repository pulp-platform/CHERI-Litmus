PLATFORM="cva6"

CC="/usr/pack/riscv-1.0-kgf/riscv64-gcc-8.5.0/bin/riscv64-unknown-elf-gcc"
AS="/usr/pack/riscv-1.0-kgf/riscv64-gcc-8.5.0/bin/riscv64-unknown-elf-as"
LD="/usr/pack/riscv-1.0-kgf/riscv64-gcc-8.5.0/bin/riscv64-unknown-elf-ld"
OBJCOPY="/usr/pack/riscv-1.0-kgf/riscv64-gcc-8.5.0/bin/riscv64-unknown-elf-objcopy"
OBJDUMP="/usr/pack/riscv-1.0-kgf/riscv64-gcc-8.5.0/bin/riscv64-unknown-elf-objdump"

OPT="-O -fno-builtin"          #optimize even more and avoid to use standard c functions
CFLAGS="$OPT -I. -I$PLATFORM -mcmodel=medany -g"  #include actuar directory to search directories
LDFLAGS="-G 0 -T $PLATFORM/$PLATFORM.ld"

CFILES="main io log hash rand riscv/arch cva6/platform cva6/uart test"
OFILES=""
for F in $CFILES
do
  OFILES="$OFILES `basename $F.o`"
  $CC $CFLAGS -std=gnu99 -Wall -c -o `basename $F.o` $F.c  #-std define the standard used
done

$AS -o entry.o cva6/entry.s
$LD $LDFLAGS -o main.elf entry.o $OFILES
$OBJDUMP -S main.elf > main.dump
#elf2hex 16 65536 main.elf >
