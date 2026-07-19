`include "defines.svh"

class apb_transaction;

    rand bit [`ADDR_WIDTH-1:0] PADDR;
    rand bit PWRITE;
    rand bit [`DATA_WIDTH-1:0] PWDATA;
    rand bit [`STRB_WIDTH-1:0] PSTRB;
    bit PREADY;
    bit [`DATA_WIDTH-1:0] PRDATA;
    bit PSLVERR;

    constraint c1{
        if(!PWRITE)
            PSTRB == '0;
        if(PWRITE)
            PSTRB inside {['0:{`STRB_WIDTH{1'b1}}]};}
    constraint c2{ PWRITE dist {0:=30, 1:=70};}
    constraint c3 {PADDR dist { [0:255] := 90,[256:511] := 10};}
    constraint c4 { PSTRB dist {[4'b0000 : 4'b1111] :/16 };}

    function apb_transaction copy();
        apb_transaction trans;
        trans = new();
        trans.PADDR = this.PADDR;
        trans.PWRITE = this.PWRITE;
        trans.PWDATA = this.PWDATA;
        trans.PSTRB = this.PSTRB;
        trans.PREADY = this.PREADY;
        trans.PRDATA = this.PRDATA;
        trans.PSLVERR = this.PSLVERR;
        return trans;
    endfunction

endclass

// WRITE TRANSACTION
class apb_write_transaction extends apb_transaction;
    constraint c5 { PWRITE == 1;}
endclass

// READ TRANSACTION
class apb_read_transaction extends apb_transaction;
    constraint c6{ PWRITE == 0; }
endclass

// INVALID ADDRESS TRANSACTION
class apb_invalid_addr_transaction extends apb_transaction;
    constraint c7{ PADDR >= `DATA_DEPTH;}
endclass

// NO STROBE TRANSACTION
class apb_no_strobe_transaction extends apb_transaction;
    constraint c8{
        PWRITE == 1;
        PSTRB  == 4'b0000;}
endclass

// BACK-TO-BACK TRANSACTION
class apb_back_to_back_transaction extends apb_transaction;
    constraint c9{
        PADDR inside {[0:`DATA_DEPTH-1]};}
endclass
