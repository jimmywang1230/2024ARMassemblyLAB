AREA Data, DATA, READWRITE
signedsum   DCD 0                         ; 初始化 sum 為 0
sumunsign   DCD 0                         ; 初始化無號數和 sumunsign 為 0
n           DCD 6                         ; 陣列長度 (n = 6)
ptr         DCD ArrayA                     ; 指向數組的指標 (int *ptr = ArrayA)
ArrayA     DCD -10, 11, 20, 50, -20, -3  ; 陣列: {-10, 11, 20, 50, -20, -3}

    AREA Array, CODE, READONLY
    ENTRY

start
    BL sumSigned
    BL sumUnsigned   
stop

sumSigned
    LDR R1, n                           ; 將 n 加載到 R1
    LDR R2, =ptr                        ; 將 ptr 的地址加載到 R2
    LDR R2, [R2]                        
    MOV R7, #0                          ; 初始化有號數總和 (R7) 為 0
loop
    LDR R3, [R2], #4                    ; 加載 *R2（將 R2 增加 4，即 int 的大小）到 R3
    ADD R7, R7, R3                      ; 更新有號數和：R7 = R7 + R3
    MOVVS R5, #1                        ; 如果無號數和溢位，則在 R5 存儲溢位資料
    SUBS R1, R1, #1                     ; 減少 n：R1 = R1 - 1；如果（R1 > 0）
    BGT loop                            ; 如果條件滿足，則跳轉到 loop
    STR R7, signedsum                   ; 將有號數和儲在signedsum
    MOV PC, LR                          ; 從函數返回

sumUnsigned
    LDR R1, n                           ; 將 n 加載到 R1
    LDR R2, =ptr                        ; 將 ptr 的地址加載到 R2
    LDR R2, [R2]                        
    MOV R8, #0                          ; 初始化無號數和 (R8) 為 0
loop_unsigned
    LDR R3, [R2], #4                    ; 加載 *R2（將 R2 增加 4，即 int 的大小）到 R3
    ADDS R8, R8, R3                     ; 更新無號數和：R8 = R8 + R3
    SUBS R1, R1, #1                     ; 減少 n：R1 = R1 - 1；如果（R1 > 0）
    BGT loop_unsigned                   ; 如果條件滿足，則跳轉到 loop_unsigned
    MOVCS R6, #1                        ; 如果無號數和溢位，則在 R6 存儲溢位資料
    STR R8, sumunsign
    b loop                              ; BREAKPOINT!!!設在這裡
    
    END