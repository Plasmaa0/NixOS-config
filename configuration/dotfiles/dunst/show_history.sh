#!/bin/bash
for i in $(seq 1 $(dunstctl count history))
do
  dunstctl history-pop
done
