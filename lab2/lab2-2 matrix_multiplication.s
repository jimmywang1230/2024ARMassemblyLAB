    AREA Matrix, CODE, READONLY ; mark first instruction
    ENTRY
start
    LDR R1, =MatrixA      ; Load address of MATRIXA
    LDR R2, =MatrixB      ; Load address of MATRIXB
    LDR R3, =MatrixC      ; Load address of MATRIXC

    ; Initialize loop indices
    MOV R6, #0            ; i index for outer loop (MATRIXA rows)
outer_loop
    MOV R7, #0            ; j index for inner loop (MATRIXB columns)
inner_loop
    MOV R8, #0            ; k index for sum (MATRIXA columns/MATRIXB rows)
    MOV R9, #0            ; Sum register for MATRIXC[R6, R7]

sum_loop
    ; Compute effective addresses for A[i, k] and B[k, j]
    ADD R4, R1, R6, LSL #3    ; Offset for ith row of MatrixA (i * 4 * 2)
    ADD R4, R4, R8, LSL #2    ; Offset for kth column of MatrixA (k * 4)
    ADD R5, R2, R8, LSL #3    ; Offset for kth row of MatrixB (k * 4 * 2)
    ADD R5, R5, R7, LSL #2    ; Offset for jth column of MatrixB (j * 4)

    ; Load values and multiply
    LDR R10, [R4]         ; Load A[i, k]
    LDR R11, [R5]         ; Load B[k, j]
    MUL R12, R10, R11     ; Multiply A[i, k] * B[k, j]
    ADD R9, R9, R12       ; Accumulate result in R9

    ; Increment k and check if done with this sum
    ADD R8, R8, #1
    CMP R8, #3            ; Compare k with 3
    BLT sum_loop          ; If k < 3, continue sum_loop

    ; Store result in MATRIXC[i, j]
    ADD R4, R3, R6, LSL #3    ; Offset for ith row of MatrixC (i * 4 * 2)
    ADD R4, R4, R7, LSL #2    ; Offset for jth column of MatrixC (j * 4)
    STR R9, [R4]          ; Store the computed sum

    ; Increment j and check if done with this row
    ADD R7, R7, #1
    CMP R7, #2            ; Compare j with 2
    BLT inner_loop        ; If j < 2, continue inner_loop

    ; Increment i and check if done with all rows
    ADD R6, R6, #1
    CMP R6, #2            ; Compare i with 2
    BLT outer_loop        ; If i < 2, continue outer_loop

stop
    B stop               ; Infinite loop to stop the program

    AREA Data, DATA, READWRITE
MatrixA dcd 1,2,3
        dcd 4,5,6
MatrixB dcd 1,4
        dcd 2,5
        dcd 3,6
MatrixC dcd 0,0
        dcd 0,0
    END ; Mark end of file