#!/bin/bash

[ -z "$MCMP7" ] && MCMP7="mcompare7"
[ -z "LITMUS_LOG" ] && LITMUS_LOG=../../litmus.log

model_result=model-results/herd.logs

$MCMP7 -nohash $LITMUS_LOG $model_result
