	AREA Matrix, CODE, READONLY
	ENTRY
start
    LDR R0, =MatrixA    ; Address of MATRIXA (2x3)
    LDR R1, =MatrixB    ; Address of MATRIXB (3x2)
    LDR R2, =MatrixC    ; Address for results MATRIXC (2x2)

    ; First element of MATRIXC (C[0][0] = A[0][0]*B[0][0] + A[0][1]*B[1][0] + A[0][2]*B[2][0])
    LDR R3, [R0], #4    ; R3 = A[0][0]
    LDR R4, [R1], #4    ; R4 = B[0][0]
    MUL R9, R3, R4      ; R9 = A[0][0]*B[0][0]
    LDR R3, [R0], #4    ; R3 = A[0][1]
    LDR R4, [R1, #4]    ; R4 = B[1][0]
    MLA R9, R3, R4, R9  ; R9 += A[0][1]*B[1][0]
    LDR R3, [R0], #4    ; R3 = A[0][2]
    LDR R4, [R1, #12]    ; R4 = B[2][0]
    MLA R9, R3, R4, R9  ; R9 += A[0][2]*B[2][0]
    STR R9, [R2]        ; Store result in MATRIXC[0][0]

    ; Second element of MATRIXC (C[0][1] = A[0][0]*B[0][1] + A[0][1]*B[1][1] + A[0][2]*B[2][1])
    LDR R0, =MatrixA    ; Reset R0 to the start of MATRIXA
    LDR R3, [R0], #4    ; R3 = A[0][0]
    LDR R4, [R1]   ; R4 = B[0][1]
    MUL R10, R3, R4     ; R10 = A[0][0]*B[0][1]
    LDR R3, [R0], #4    ; R3 = A[0][1]
    LDR R4, [R1, #8]   ; R4 = B[1][1]
    MLA R10, R3, R4, R10; R10 += A[0][1]*B[1][1]
    LDR R3, [R0], #4    ; R3 = A[0][2]
    LDR R4, [R1, #16]   ; R4 = B[2][1]
    MLA R10, R3, R4, R10; R10 += A[0][2]*B[2][1]
    STR R10, [R2, #4]   ; Store result in MATRIXC[0][1]

    ; Third element of MATRIXC (C[1][0] = A[1][0]*B[0][0] + A[1][1]*B[1][0] + A[1][2]*B[2][0])
    LDR R0, =MatrixA+12 ; Point R0 to the second row of MATRIXA
    LDR R3, [R0], #4    ; R3 = A[1][0]
    LDR R1, =MatrixB    ; Reset R1 to the start of MATRIXB
    LDR R4, [R1]        ; R4 = B[0][0]
    MUL R11, R3, R4     ; R11 = A[1][0]*B[0][0]
    LDR R3, [R0], #4    ; R3 = A[1][1]
    LDR R4, [R1, #8]    ; R4 = B[1][0]
    MLA R11, R3, R4, R11; R11 += A[1][1]*B[1][0]
    LDR R3, [R0], #4    ; R3 = A[1][2]
    LDR R4, [R1, #16]    ; R4 = B[2][0]
    MLA R11, R3, R4, R11; R11 += A[1][2]*B[2][0]
    STR R11, [R2, #8]   ; Store result in MATRIXC[1][0]

    ; Fourth element of MATRIXC (C[1][1] = A[1][0]*B[0][1] + A[1][1]*B[1][1] + A[1][2]*B[2][1])
    LDR R0, =MatrixA+12 ; Point R0 to the second row of MATRIXA
    LDR R3, [R0], #4    ; R3 = A[1][0]
    LDR R1, =MatrixB    ; Reset R0 to the start of MATRIX
    LDR R4, [R1, #4]   ; R4 = B[0][1]
    MUL R12, R3, R4     ; R12 = A[1][0]*B[0][1]
    LDR R3, [R0], #4    ; R3 = A[1][1]
    LDR R4, [R1, #12]   ; R4 = B[1][1]
    MLA R12, R3, R4, R12; R12 += A[1][1]*B[1][1]
    LDR R3, [R0], #4    ; R3 = A[1][2]
    LDR R4, [R1, #20]   ; R4 = B[2][1]
    MLA R12, R3, R4, R12; R12 += A[1][2]*B[2][1]
    STR R12, [R2, #12]  ; Store result in MATRIXC[1][1]

stop
    B stop              ; Infinite loop to stop the program

	AREA Data, DATA, READWRITE
MatrixA dcd 1, 2, 3, 4, 5, 6
MatrixB dcd 7, 8, 9, 10, 11, 12
MatrixC dcd 0, 0, 0, 0
	END ; Mark end of file
