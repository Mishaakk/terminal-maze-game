#!/bin/bash

map_data=()
player_x=0
player_y=0
current_tile=" "

load_map() {
  local file=$1
  map_data=()
  while IFS= read -r line; do
    map_data+=("$line")
  done < "$file"
}

draw_map() {
  for y in "${!map_data[@]}"; do
    line="${map_data[$y]}"
    for x in $(seq 0 $((${#line} - 1))); do
      if [[ $x -eq $player_x && $y -eq $player_y ]]; then
        echo -n "@"
      else
        echo -n "${line:$x:1}"
      fi
    done
    echo
  done
}

find_player_position() {
  for y in "${!map_data[@]}"; do
    line="${map_data[$y]}"
    for x in $(seq 0 $((${#line} - 1))); do
      if [[ "${line:$x:1}" == "S" ]]; then
        player_x=$x
        player_y=$y
        return
      fi
    done
  done
}

move_player() {
  local key=$1
  local new_x=$player_x
  local new_y=$player_y

  case "$key" in
    w) ((new_y--)) ;;
    s) ((new_y++)) ;;
    a) ((new_x--)) ;;
    d) ((new_x++)) ;;
    *) return ;;
  esac

  local line="${map_data[$new_y]}"
  local tile="${line:$new_x:1}"

  if [[ "$tile" != "#" ]]; then
    player_x=$new_x
    player_y=$new_y
    current_tile="$tile"
  fi
}


show_help() {
  clear
  echo "🆘 Помощь:"
  echo
  echo "🎮 Цель: дойти от точки 'S' до 'E', избегая стен '#'."
  echo
  echo "🔼 W — вверх"
  echo "🔽 S — вниз"
  echo "◀️  A — влево"
  echo "▶️  D — вправо"
  echo
  echo "ℹ️  H — показать эту справку"
  echo "❌ Ctrl+C — выйти из игры"
  echo
}


if [[ "$key" == "h" ]]; then
  show_help
fi
