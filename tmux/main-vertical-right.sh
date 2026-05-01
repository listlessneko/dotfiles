#!/usr/bin/env bash
# Inverse of tmux's `main-vertical` layout: the main pane sits on the
# right at full height; remaining panes are stacked on the left.
#
# Usage: main-vertical-right.sh [main_width] [top_percent]
#   main_width  — cells (e.g. 80) or percent of window width (e.g. 50%).
#                 Falls back to tmux option `main-pane-width`.
#   top_percent — 1..99, height share of the topmost stack pane.
#                 Falls back to tmux option `@stack-top-percent`.
#
# Builds a layout string sized to the current window and applies it via
# `tmux select-layout`. Re-run after a window resize to refit.

set -euo pipefail

ARG_MAIN_W="${1:-}"
ARG_TOP_PCT="${2:-}"

W=$(tmux display -p '#{window_width}')
H=$(tmux display -p '#{window_height}')
N=$(tmux display -p '#{window_panes}')

if [ "$N" -lt 2 ]; then
    exit 0
fi

if [ -n "$ARG_MAIN_W" ]; then
    if [[ "$ARG_MAIN_W" =~ ^([0-9]+)%$ ]]; then
        MAIN_W=$(( W * ${BASH_REMATCH[1]} / 100 ))
    else
        MAIN_W=$ARG_MAIN_W
    fi
else
    MAIN_W=$(tmux show-options -gv main-pane-width 2>/dev/null || echo 120)
fi
MIN_STACK_W=20

STACK_W=$((W - MAIN_W - 1))
if [ "$STACK_W" -lt "$MIN_STACK_W" ]; then
    STACK_W=$MIN_STACK_W
    MAIN_W=$((W - STACK_W - 1))
fi

MAIN_X=$((STACK_W + 1))

if [ "$N" -eq 2 ]; then
    BODY="${W}x${H},0,0{${STACK_W}x${H},0,0,1,${MAIN_W}x${H},${MAIN_X},0,0}"
else
    STACK_PANES=$((N - 1))
    SEPARATORS=$((STACK_PANES - 1))
    AVAIL_H=$((H - SEPARATORS))

    if [ -n "$ARG_TOP_PCT" ]; then
        STACK_TOP_PCT="$ARG_TOP_PCT"
    else
        STACK_TOP_PCT=$(tmux show-options -gv @stack-top-percent 2>/dev/null || echo "")
    fi
    STACK_TOP_H=""
    if [[ "$STACK_TOP_PCT" =~ ^[0-9]+$ ]] && [ "$STACK_TOP_PCT" -ge 1 ] && [ "$STACK_TOP_PCT" -le 99 ]; then
        STACK_TOP_H=$((AVAIL_H * STACK_TOP_PCT / 100))
        MIN_OTHER_H=5
        MAX_TOP_H=$((AVAIL_H - MIN_OTHER_H * (STACK_PANES - 1)))
        if [ "$STACK_TOP_H" -lt 1 ]; then
            STACK_TOP_H=1
        elif [ "$STACK_TOP_H" -gt "$MAX_TOP_H" ]; then
            STACK_TOP_H=$MAX_TOP_H
        fi
    fi

    if [ -n "$STACK_TOP_H" ]; then
        TOP_H=$STACK_TOP_H
        REMAINING_H=$((AVAIL_H - TOP_H))
        REMAINING_PANES=$((STACK_PANES - 1))
        BASE_H=$((REMAINING_H / REMAINING_PANES))
        EXTRA=$((REMAINING_H - BASE_H * REMAINING_PANES))
    else
        BASE_H=$((AVAIL_H / STACK_PANES))
        EXTRA=$((AVAIL_H - BASE_H * STACK_PANES))
    fi

    LEFT_BODY=""
    Y=0
    for i in $(seq 1 "$STACK_PANES"); do
        if [ -n "$STACK_TOP_H" ] && [ "$i" -eq 1 ]; then
            PANE_H=$TOP_H
        else
            PANE_H=$BASE_H
            extra_idx=$i
            [ -n "$STACK_TOP_H" ] && extra_idx=$((i - 1))
            if [ "$extra_idx" -le "$EXTRA" ]; then
                PANE_H=$((PANE_H + 1))
            fi
        fi
        if [ -n "$LEFT_BODY" ]; then
            LEFT_BODY="${LEFT_BODY},"
        fi
        LEFT_BODY="${LEFT_BODY}${STACK_W}x${PANE_H},0,${Y},${i}"
        Y=$((Y + PANE_H + 1))
    done

    BODY="${W}x${H},0,0{${STACK_W}x${H},0,0[${LEFT_BODY}],${MAIN_W}x${H},${MAIN_X},0,0}"
fi

# tmux's layout checksum (see layout-custom.c:layout_checksum).
csum=0
for (( i=0; i<${#BODY}; i++ )); do
    c=$(printf '%d' "'${BODY:$i:1}")
    csum=$(( ((csum >> 1) | ((csum & 1) << 15)) & 0xFFFF ))
    csum=$(( (csum + c) & 0xFFFF ))
done
CSUM=$(printf '%04x' "$csum")

tmux select-layout "${CSUM},${BODY}"
