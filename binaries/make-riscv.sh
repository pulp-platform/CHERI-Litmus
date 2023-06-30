#!/bin/bash

if [ "$1" = "" ]; then
  echo "Usage: make-riscv.sh <path-to-litmus-files> [cores]"
  exit
fi

#sed "25 s/  uint32_t seed = [0-9];/  uint32_t seed = $RANDOM;/" ../main.copy > ../backend/main.c
rm -rf backend-tmp
n_tests=0
n_compiled_tests=0
n_parsing_errors=0
n_compiling_errors=0
#refers to the lw.aq and sw.rl that are still not 
#defined by riscv spec
n_no_opcode=0
#filter number of cores
CORES=$2
n_many_cores=0
i=0

#ATOMICS/CO and HAND litmus tests can't actually be compiled
for FILE in $(find $1 -name "*.litmus" | grep -v "ATOMICS/CO\|HAND")
 do
  echo "Processing file $FILE"
  if grep -q sw.rl $FILE || grep -q lw.aq $FILE;then
    n_no_opcode=$((n_no_opcode+1))
  elif [ "$CORES" != "" ] && grep -q P$CORES $FILE ; then
    n_many_cores=$((n_many_cores+1))
  else
    cp -r ../backend/ backend-tmp
      if ../frontend/litmus $FILE backend-tmp/testcase.c backend-tmp/testcase.h $2; then
           cd backend-tmp
           ./make-riscv.sh
           cd ..
           OUTFILE=`basename $FILE .litmus`.elf
           if cp backend-tmp/main.elf $OUTFILE; then
               OUTFILE=`basename $FILE .litmus`.dump
               cp backend-tmp/main.dump $OUTFILE
               n_compiled_tests=$((n_compiled_tests+1))
           else
              n_compiling_errors=$((n_compiled_errors+1))
           fi
      else
        n_parsing_errors=$((n_parsing_errors+1))
      fi
  fi
  rm -rf backend-tmp
  n_tests=$((n_tests+1))
 done 
 echo "#tests               = $n_tests"
 echo "#tests well compiled = $n_compiled_tests"
 echo "#parsing errors      = $n_parsing_errors"
 echo "#compiling errors    = $n_compiling_errors"
 echo "#lw.aq or sw.rl      = $n_no_opcode"
 echo "#too many cores      = $n_many_cores"
