#!/bin/bash

source ./utils.sh

choose_level() {
  echo "📜 Выбери уровень:"
  echo "1. Уровень 1"
  echo "2. Уровень 2"
  echo "3. Уровень 3"
  echo

  read -p "👉 Введите номер уровня (1-3): " level

  case "$level" in
    1) map_file="maps/level1.map" ;;
    2) map_file="maps/level2.map" ;;
    3) map_file="maps/level3.map" ;;
    *) echo "❌ Неверный выбор."; exit 1 ;;
  esac
}

choose_level
load_map "$map_file"
find_player_position
clear
draw_map

while true; do
  read -s -n 1 key

  case "$key" in
    h)
      show_help
      read -n 1 -s -p "Нажми любую клавишу, чтобы вернуться..."
      clear
      draw_map
      ;;
    *)
      move_player "$key"
      clear
      draw_map
      ;;
  esac

  if [[ "$current_tile" == "E" ]]; then
    echo "🎉 Победа! Ты прошёл уровень!"
    break
  fi
done
