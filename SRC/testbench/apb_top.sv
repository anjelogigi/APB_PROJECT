`timescale 1ns/1ps

`include "defines.svh"

module top;

    import apb_package::*;

    bit PCLK;
    bit PRESETn;

    apb_if intf(PCLK, PRESETn);

    apb_test test;

    initial
    begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

    initial
    begin
        PRESETn = 0;
        #10;
        PRESETn = 1;
        #10;
        PRESETn = 0;
        #10;
        PRESETn = 1;
    end

    apb_slave #(.ADDR_WIDTH(`ADDR_WIDTH),.DATA_WIDTH(`DATA_WIDTH),.MEM_DEPTH(`DATA_DEPTH)) 
         dut(
        .PCLK (PCLK),
        .PRESETn (PRESETn),
        .PADDR (intf.PADDR),
        .PSEL (intf.PSEL),
        .PENABLE (intf.PENABLE),
        .PWRITE (intf.PWRITE),
        .PWDATA (intf.PWDATA),
        .PSTRB (intf.PSTRB),
        .PRDATA (intf.PRDATA),
        .PREADY (intf.PREADY),
        .PSLVERR (intf.PSLVERR));

    initial
    begin
        test = new(intf.DRV, intf.MON);
        test.run();
    end

    initial
    begin
        #100000;
        $finish;
    end

endmodule
