# 112-2 Design of Embedded Microprocessor Systems

M11207509 王佑強

### 題目: 掃雷先生 (踩地雷)

### 簡介

Bash 是 Linux 和 Unix 系統上的一種常用命令行解釋器，使用 Bash 語言編寫的腳本文件，用於自動化執行命令、管理系統任務和處理文本。支援 Unix 命令、變數、條件語句、迴圈和函數。Bash 腳本它在系統管理中非常有用，可自動化備份、監控、安裝等任務，也常用於文本處理和資料分析。

《踩地雷》（Minesweeper）是一款經典的益智遊戲，在考驗玩家的邏輯推理能力。遊戲開始時，玩家面前是一個矩形網格，地雷隨機被放置在裡面。玩家的目標是打開所有不含地雷的方格，同時避免點擊到地雷。如果打開的方格沒有地雷，會顯示一個數字，這個數字代表相鄰的八個方格中有多少個地雷。可以根據這些數字進行推論找出所有安全的方格；如果玩家點擊到地雷，遊戲則會立即結束。

為了增加遊戲挑戰性，會在遊戲成功或失敗時，印出玩家揭露次數與打開的方格，讓玩家思考如何用最少的輸入開啟最多的方格。

### 遊戲實現

- **程式語言:** Bash Shell Script
- **遊戲目標:**
    - 在10*10的矩陣中藏有「10顆地雷💣」。
    - 清除所有不含地雷的座標，避免點擊到地雷。
- **操作方式:**
    - 填寫📌座標，以reveal該位置的方格。
    ex: col=a, row=0 則輸入a0
    - 閱讀完遊戲規則點擊Enter 開始遊戲
- 系統流程圖:
  
    ![alt text](https://github.com/jimmywang1230/2024ARMassemblyLAB/blob/main/Final/Flow1.png)
    ![alt text](https://github.com/jimmywang1230/2024ARMassemblyLAB/blob/main/Final/Flow2.png)
    
- 程式碼解說:
    - 主程序
        1. 如果^C顯示遊戲退出訊息:
            
             `trap "printf '\n\n%s\n\n' 'QAQ!!! 你退出遊戲了!!'; exit 1" INT`
            
        2. 把畫面清空
            
             `printf "\e[2J\e[H”`
            
        3.  印出遊戲規則 `game_rule`
        4.  read 使用者輸入如果 點擊Enter 開始遊戲
            
            `read -p "點擊 Enter 開始遊戲吧!!”`
            
        5.  初始化地雷位置 `initialize_mines`
        6. 印出地雷場  `plough`
        7. 印出遊戲提醒，並`get_coordinates`取得玩家輸入座標
        
        ```
        while true; do
          printf "小提醒: 操作方式選擇輸入行列座標 col- a, row- 6 -> a6 \n\n"
          read -p "請輸入要打開的座標:  " opt
          get_coordinates
        done
        ```
        
    - 變數
        
        `score`: 被揭露的方格
        
        `mine_count`: 地雷數量
        
        `input_count`: 玩家輸入次數
        
        `board`: 存放遊戲的陣列
        
        `revealed`: 存放打開過的方格的陣列
        
        `mines`: 存放地雷位置陣列
        
    - 函式
        
        game_rule(): 遊戲規則
        
        initialize_mines(): 初始化地雷位置
        
        plough(): 印出地雷場
        
        get_coordinates(): 處理用戶輸入
        
        show_all_mines(): 顯示所有地雷
        
        reveal_cell(): 打開cell
        
        count_nearby_mines(): 計算相鄰地雷數量
        
        reveal_adjacent_cells(): 如果打開的為0揭露相鄰cell
