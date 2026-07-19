`include "defines.svh"

interface apb_if(input logic PCLK, input logic PRESETn);

logic [`ADDR_WIDTH-1:0] PADDR;
logic PSEL;
logic PENABLE;
logic PWRITE;
logic [`DATA_WIDTH-1:0] PWDATA;
logic [`STRB_WIDTH-1:0] PSTRB;
logic [`DATA_WIDTH-1:0] PRDATA;
logic PREADY;
logic PSLVERR;

clocking drv_cb @(posedge PCLK);
    default input #0 output #0;
    output PADDR;
    output PSEL;
    output PENABLE;
    output PWRITE;
    output PWDATA;
    output PSTRB;
    input PRESETn;
endclocking

clocking mon_cb @(posedge PCLK);
    default input #0 output #0;
    input PRESETn;
    input PADDR;
    input PSEL;
    input PENABLE;
    input PWRITE;
    input PWDATA;
    input PSTRB;
    input PRDATA;
    input PREADY;
    input PSLVERR;
endclocking

modport DRV(clocking drv_cb);
modport MON(clocking mon_cb);

endinterface
