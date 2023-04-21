#!/bin/bash

for TYPE in hacker pvt; do
	for SIDE in front back; do
		for CASE in "bare" "case"; do
			convert -resize 100x137 hw-$TYPE-$SIDE-$CASE.jpg hw-$TYPE-$SIDE-$CASE-small.jpg
		done
	done
done
