/* Automatically generated by litmus */

void test_body(int pid) {
  switch(pid) {
    case 0: {
      var_t out0;
      arch_barrier_up();
      delay(test.delays[0]*12);
      
      asm volatile (
        " lw %0,0(%1) \n"
        " ori x7,x0,1 \n"
        " sw x7,0(%2) \n"
      : /* output operands */
        "=&r"(out0)
      : /* input operands */
        "r"(test.vars[0]),"r"(test.vars[1])
      );
      test.outcome[0] = out0;
      arch_barrier_down();
      break;
    }
    case 1: {
      var_t out0;
      arch_barrier_up();
      delay(test.delays[1]*12);
      
      asm volatile (
        " lw %0,0(%1) \n"
        " ori x7,x0,1 \n"
        " sw x7,0(%2) \n"
      : /* output operands */
        "=&r"(out0)
      : /* input operands */
        "r"(test.vars[1]),"r"(test.vars[0])
      );
      test.outcome[1] = out0;
      arch_barrier_down();
      break;
    }
  }
}
