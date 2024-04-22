AREA Det, CODE, READONLY
    ENTRY

start
    ; Load matrix elements into registers
    LDR r1, =M         ; Point r1 to the start of the matrix data
    LDMIA r1!, {r2-r10} ; Load matrix values into registers r2 to r10

    ; Compute determinant using the formula:
    ; det = a11a22a33 + a12a23a31 + a13a21a32 - a31a22a13 - a32a23a11 - a33a21a12
    MUL r11, r2, r6    ; r11 = a11 * a22
    MUL r12, r11, r10  ; r12 = a11 * a22 * a33
    MUL r11, r3, r7    ; r11 = a12 * a23
    MUL r13, r11, r8   ; r13 = a12 * a23 * a31
    MUL r11, r4, r5    ; r11 = a13 * a21
    MUL r14, r11, r9   ; r14 = a13 * a21 * a32

    MUL r11, r8, r6    ; r11 = a31 * a22
    MUL r6, r11, r4    ; r3 = a31 * a22 * a13, reuse r3 after its original value is no longer needed
    MUL r11, r9, r7    ; r11 = a32 * a23
    MUL r4, r11, r2    ; r4 = a32 * a23 * a11, reuse r4
    MUL r11, r10, r5   ; r11 = a33 * a21
    MUL r5, r11, r3    ; r5 = a33 * a21 * a12, reuse r5

    ; Add and subtract the results to find determinant
    ADD r0, r12, r13   ; r0 = part1 + part2
    ADD r0, r0, r14    ; r0 = current + part3
    SUB r0, r0, r6     ; r0 = current - part4
    SUB r0, r0, r4     ; r0 = current - part5
    SUB r0, r0, r5     ; r0 = final determinant result

    ; Store the result back to the det variable
    LDR r1, =det
    STR r0, [r1]

stop
    AREA Data, DATA, READWRITE

    ALIGN
M   DCD -1, 3, 8
    DCD 7, 12, -3
    DCD 3, 2, 3
det DCD 0

    END