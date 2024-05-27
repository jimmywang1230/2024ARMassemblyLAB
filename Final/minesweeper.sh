

# 變數
score=0
mine_count=10  # 設定地雷數量
inpuut_count=0
declare -a board   # 宣告一個陣列來存放遊戲板
declare -a revealed # 宣告一個陣列來標記已揭露的單元格
declare -a mines # 宣告一個陣列來存放地雷的位置

game_rule()
{
cat <<_EOF_
😀 M11207509 王佑強 😀
----------------------------------------
  這是一個踩地雷💣的小遊戲.
  1. 遊戲目標：
    清除所有不含地雷的方格，避免點擊到地雷。
  * 在10*10的矩陣中藏有「10顆地雷」。

  2. 操作方式:
    填寫📌座標，以reveal該位置的方格。
    ex: 輸入 a0 以reveal左上角的方格。
----------------------------------------

_EOF_
}

# 初始化地雷位置
initialize_mines() {
  local count=0
  # 當前地雷數量小於預設數量時，繼續生成地雷
  while [ $count -lt $mine_count ]; do
    index=$(shuf -i 0-99 -n 1)  # 隨機生成0到99之間的index
    if [[ "${board[$index]}" != "💣" ]]; then  # 如果該位置沒有地雷，才放地雷
      board[$index]="💣"
      mines+=($index)   # 記錄地雷位置
      ((count++))
    fi
  done
}

# 打印地雷場
plough() {
  printf "\e[2J\e[H"    # 清除螢幕並把游標移動到top
  printf '%s' "     a   b   c   d   e   f   g   h   i   j"
  printf '\n   %s\n' "══════════════════════════════════════════"
  for row in $(seq 0 9); do
    printf '%d  ' "$row" 
    for col in $(seq 0 9); do
      index=$((row * 10 + col))
      if [[ "${revealed[$index]}" == "1" ]]; then   # 如果該單元格已被打開，則印出他的值
        printf '%s' "║ ${board[$index]} "
      else  # 如果未被打開過，印出問號
        printf '%s' "║ ? "
      fi
    done
    printf '%s\n' "║"
    printf '   %s\n' "══════════════════════════════════════════"
  done
  printf '\n\n'
}

# 顯示所有地雷
show_all_mines() {
  for mine in "${mines[@]}"; do
    revealed[$mine]=1
  done
}

# 計算相鄰地雷數量
count_nearby_mines() {
  local index=$1
  local row=$((index / 10))
  local col=$((index % 10))
  local count=0
  for r in $(seq -1 1); do
    for c in $(seq -1 1); do
      if [[ $((row + r)) -ge 0 && $((row + r)) -le 9 && $((col + c)) -ge 0 && $((col + c)) -le 9 ]]; then
        adj_index=$(((row + r) * 10 + (col + c)))
        if [[ "${board[$adj_index]}" == "💣" ]]; then    # 如果相鄰單元格是地雷，計數加一
          ((count++))
        fi
      fi
    done
  done
  echo $count
}

# 揭露相鄰cell
reveal_adjacent_cells() {
  local index=$1
  local row=$((index / 10))
  local col=$((index % 10))
  for r in $(seq -1 1); do
    for c in $(seq -1 1); do
      if [[ $((row + r)) -ge 0 && $((row + r)) -le 9 && $((col + c)) -ge 0 && $((col + c)) -le 9 ]]; then    # 檢查是否在邊界內
        adj_index=$(((row + r) * 10 + (col + c)))
        if [[ "${revealed[$adj_index]}" != "1" ]]; then
          reveal_cell $adj_index
        fi
      fi
    done
  done
}

# 打開cell
reveal_cell() {
  local index=$1
  if [[ "${board[$index]}" == "💣" ]]; then  # 如果開到地雷，遊戲結束
    show_all_mines  # 顯示所有地雷
    plough  # 重新印地雷場
    printf "\n\n\t%s\n\n" "GAME OVER: 😂你踩到地雷了笑死!😂 總共花 $inpuut_count 次打開了: $score 個cells"
    exit 0  # 結束遊戲
  else
    adj_mines=$(count_nearby_mines $index)  # 計算相鄰地雷數量
    board[$index]=$adj_mines    # 將相鄰地雷數量存入當前cell
    revealed[$index]=1          # 標記該cell為revealed
    score=$((score + 1))
    if [[ $adj_mines -eq 0 ]]; then # 如果相鄰地雷數量為0，打開相鄰cells
      reveal_adjacent_cells $index
    fi
  fi
}

# 處理用戶輸入
get_coordinates() {
  colm=${opt:0:1}
  ro=${opt:1:1}
  case $colm in # 將輸入的列轉換為數字
    a ) o=0;;
    b ) o=1;;
    c ) o=2;;
    d ) o=3;;
    e ) o=4;;
    f ) o=5;;
    g ) o=6;;
    h ) o=7;;
    i ) o=8;;
    j ) o=9;;
  esac
  i=$(((ro * 10) + o))  # 計算單元格索引
  inpuut_count=$((inpuut_count + 1))
  reveal_cell $i
  plough
  if [[ $score -eq $((100 - mine_count)) ]]; then   # 如果所有非地雷cell都被打開，玩家勝利
    printf "\n\t%s\n\n" "恭喜你贏了!!! \t 總共花 $inpuut_count 次打開了: $score 個cells"
    
    exit 0
  fi
}

# 主程序
trap "printf '\n\n%s\n\n' 'QAQ!!! 你退出遊戲了!!'; exit 1" INT
printf "\e[2J\e[H"
game_rule
read -p "點擊 Enter 開始遊戲吧!!"
initialize_mines
plough
while true; do
  printf "小提醒: 操作方式選擇輸入行列座標 col- a, row- 6 -> a6 \n\n"
  read -p "請輸入要打開的座標:  " opt
  get_coordinates
done
