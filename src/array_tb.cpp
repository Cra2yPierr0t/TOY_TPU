#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Varray_top.h"

unsigned int main_time = 0;

int main(int argc, char **argv){
    Verilated::commandArgs(argc, argv);
    Varray_top *top = new Varray_top();

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("wave.vcd");

    top->clk = 0;
    
    while(!Verilated::gotFinish()){
        if((main_time % 2) == 0)
            top->clk = !top->clk;

        top->eval();
        tfp->dump(main_time);

        if(main_time > 10000)
            break;
        
        main_time++;
    }

    tfp->close();
    top->final();
}
