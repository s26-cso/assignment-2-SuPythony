.data

fname: .string "input.txt"
mode: .string "r"
yes: .string "Yes\n"
no: .string "No\n"

.text
.globl main

read_forw:
#fp in a0
addi sp, sp, -16
sd ra, 0(sp)
call fgetc
ld ra, 0(sp)
addi sp, sp, 16
ret

read_rev:
#fp in a0
addi sp, sp, -32
sd ra, 0(sp)
sd s0, 8(sp)
sd s1, 16(sp)

mv s0, a0
li a1, -1
li a2, 1 #SEEK_CUR
call fseek

mv a0, s0
call fgetc
mv s1, a0

mv a0, s0
li a1, -1
li a2, 1
call fseek

mv a0, s1

ld s1, 16(sp)
ld s0, 8(sp)
ld ra, 0(sp)
addi sp, sp, 32
ret

is_done:
#forw fp in a0
#rev fp in a1
addi sp, sp, -32
sd ra, 0(sp)
sd s0, 8(sp)
sd s1, 16(sp)

mv s0, a1
call ftell
mv s1, a0
mv a0, s0
call ftell
mv s0, a0
addi s1, s1, 1
li a0, 1
blt s0, s1, is_done_end
li a0, 0

is_done_end:
ld s1, 16(sp)
ld s0, 8(sp)
ld ra, 0(sp)
addi sp, sp, 32
ret

main:
addi sp, sp, -48
sd ra, 0(sp)
sd s0, 8(sp)
sd s1, 16(sp)
sd s2, 24(sp)
sd s3, 32(sp)

la a0, fname
la a1, mode
call fopen
mv s0, a0 #front file pointer
la a0, fname
la a1, mode
call fopen
mv s1, a0 #reverse file pointer
mv a0, s1
li a1, -1 #assuming \n at end
li a2, 2 #SEEK_END
call fseek #go to end

loop:
mv a0, s0
mv a1, s1
call is_done
beq a0, zero, not_done
jal zero, print_yes
not_done:
mv a0, s0
call read_forw
mv s2, a0
mv a0, s1
call read_rev
mv s3, a0
beq s2, s3, loop
jal zero, print_no

print_yes:
la a0, yes
call printf
jal zero, main_end

print_no:
la a0, no
call printf

main_end:
mv a0, s0
call fclose
mv a0, s1
call fclose
ld s3, 32(sp)
ld s2, 24(sp)
ld s1, 16(sp)
ld s0, 8(sp)
ld ra, 0(sp)
addi sp, sp, 48
ret
