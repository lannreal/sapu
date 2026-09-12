#!/usr/bin/env bash
# ============================================================
#  Server Welcome Script
#  Dibuat oleh: Lann
#  Style: Minimalist / Modern / Professional (ala Claude Code CLI)
# ============================================================

RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
WHITE='\033[38;5;255m'
GRAY='\033[38;5;245m'
ORANGE='\033[38;5;209m'
GREEN='\033[38;5;114m'
YELLOW='\033[38;5;221m'
RED='\033[38;5;203m'

WIDTH=49

repeat() { printf "%${2}s" | tr ' ' "$1"; }

kv() {
  printf "  ${GRAY}%-13s${RESET} %s\n" "$1" "$2"
}

bar() {
  local pct=$1 width=20
  [ -z "$pct" ] && pct=0
  local filled=$(( pct * width / 100 ))
  local empty=$(( width - filled ))
  local color="$GREEN"
  [ "$pct" -ge 70 ] && color="$YELLOW"
  [ "$pct" -ge 90 ] && color="$RED"
  printf "${color}$(repeat '█' $filled)${GRAY}$(repeat '░' $empty)${RESET}"
}

# ---------------- Gather info ----------------
OS_NAME=$( [ -f /etc/os-release ] && . /etc/os-release && echo "$PRETTY_NAME" || uname -s )
KERNEL=$(uname -r)
ARCH=$(uname -m)
HOST=$(hostname)
UPTIME=$(uptime -p 2>/dev/null | sed 's/^up //')
[ -z "$UPTIME" ] && UPTIME="N/A"

CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo 2>/dev/null | cut -d: -f2 | sed 's/^ //')
[ -z "$CPU_MODEL" ] && CPU_MODEL="Unknown"
CPU_CORES=$(nproc 2>/dev/null || echo "?")

if command -v free >/dev/null 2>&1; then
  MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
  MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
  MEM_PCT=$(( MEM_TOTAL > 0 ? MEM_USED * 100 / MEM_TOTAL : 0 ))
else
  MEM_TOTAL=0; MEM_USED=0; MEM_PCT=0
fi

DISK_LINE=$(df -h / 2>/dev/null | tail -1)
DISK_USED=$(echo "$DISK_LINE" | awk '{print $3}')
DISK_TOTAL=$(echo "$DISK_LINE" | awk '{print $2}')
DISK_PCT=$(echo "$DISK_LINE" | awk '{print $5}' | tr -d '%')
[ -z "$DISK_PCT" ] && DISK_PCT=0

IP_ADDR=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$IP_ADDR" ] && IP_ADDR="N/A"

PROJECT=${RAILWAY_PROJECT_NAME:-"-"}
ENVNAME=${RAILWAY_ENVIRONMENT_NAME:-"-"}
SERVICE=${RAILWAY_SERVICE_NAME:-"-"}
REGION=${RAILWAY_REPLICA_REGION:-"-"}

DATE_NOW=$(date "+%A, %d %B %Y - %H:%M:%S")

# ---------------- Render ----------------
clear
echo
printf "  ${BOLD}${ORANGE}✳${RESET}  ${BOLD}${WHITE}%s${RESET}\n" "$HOST"
printf "     ${DIM}${GRAY}Server dashboard · dibuat oleh Lann${RESET}\n"
echo
printf "${GRAY}$(repeat '─' $WIDTH)${RESET}\n"
echo
printf "  ${BOLD}${ORANGE}SYSTEM${RESET}\n"
kv "OS"       "$OS_NAME"
kv "Kernel"   "$KERNEL"
kv "Arch"     "$ARCH"
kv "Uptime"   "$UPTIME"
kv "Waktu"    "$DATE_NOW"
echo
printf "  ${BOLD}${ORANGE}HARDWARE${RESET}\n"
kv "CPU"    "$CPU_MODEL"
kv "Cores"  "$CPU_CORES"
printf "  ${GRAY}%-13s${RESET} %s ${GRAY}%s%%${RESET}  (%sMB/%sMB)\n" "RAM" "$(bar "$MEM_PCT")" "$MEM_PCT" "$MEM_USED" "$MEM_TOTAL"
printf "  ${GRAY}%-13s${RESET} %s ${GRAY}%s%%${RESET}  (%s/%s)\n" "Disk" "$(bar "$DISK_PCT")" "$DISK_PCT" "$DISK_USED" "$DISK_TOTAL"
echo
printf "  ${BOLD}${ORANGE}NETWORK${RESET}\n"
kv "Internal IP" "$IP_ADDR"
echo
printf "  ${BOLD}${ORANGE}RAILWAY${RESET}\n"
kv "Project"     "$PROJECT"
kv "Environment" "$ENVNAME"
kv "Service"     "$SERVICE"
kv "Region"      "$REGION"
echo
printf "${GRAY}$(repeat '─' $WIDTH)${RESET}\n"
echo
printf "  ${DIM}${GRAY}Tip: ketik${RESET} ${WHITE}htop${RESET} ${DIM}${GRAY}atau${RESET} ${WHITE}neofetch${RESET} ${DIM}${GRAY}untuk detail lebih lanjut${RESET}\n"
printf "  ${DIM}${GRAY}Crafted with care by${RESET} ${BOLD}${WHITE}Lann${RESET}\n"
echo
