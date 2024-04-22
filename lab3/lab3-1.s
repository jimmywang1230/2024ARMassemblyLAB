    AREA SquareRootFinder, CODE, READONLY
    ENTRY
start
    MOV R0, #1        ; R0 is the counter for odd numbers (1, 3, 5, 7, 9, ...)
    MOV R1, #0        ; R1 will keep the root
    MOV R2, #0        ; R2 will keep the sum of odd numbers

find_square
    ADD R2, R2, R0    ; Add the next odd number to the sum
    CMP R2, #30       ; Compare the sum with 30
    BGT finish        ; If the sum is greater than 30, stop the loop
    ADD R1, R1, #1    ; Increment the root
    ADD R0, R0, #2    ; Increment to the next odd number
    B find_square     ; Repeat the process

finish
    ; R1 now contains the root of the largest perfect square less than 30
    MOV R0, R1        ; Optionally move result to R0, or leave in R1 as per requirement

stop
    B stop            ; Infinite loop to halt further execution

    AREA data, DATA, READWRITE
    END ; Mark end of file