#!/bin/env bash

GHC_BIN="${GHC:-ghc}"

"$GHC_BIN" -O2 --make Litmus.lhs -o litmus
"$GHC_BIN" -O2 --make Translate -o litmus-translate
