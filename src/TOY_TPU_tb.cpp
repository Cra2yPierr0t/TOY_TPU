#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VTOY_TPU.h"

unsigned int main_time = 0;

int main(int argc, char **argv){
    Verilated::commandArgs(argc, argv);
    VTOY_TPU *top = new VTOY_TPU();

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("wave.vcd");

    top->clk = 0;
    top->activate_plz = 0;
    
    while(!Verilated::gotFinish()){
        if((main_time % 2) == 0)
            top->clk = !top->clk;

        top->eval();
        tfp->dump(main_time);

        if(main_time == 10)
            top->activate_plz = 1;

        if(main_time > 10000)
            break;
        
        main_time++;
    }

    tfp->close();
    top->final();
}
