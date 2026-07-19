`include "defines.svh"

class apb_environment;

    apb_generator gen;
    apb_driver drv;
    apb_monitor mon;
    apb_reference_model ref_model;
    apb_scoreboard scb;
    mailbox #(apb_transaction) mbx_gd;
    mailbox #(apb_transaction) mbx_dr;
    mailbox #(apb_transaction) mbx_ms;
    mailbox #(apb_transaction) mbx_rs;
    virtual apb_if.DRV drv_if;
    virtual apb_if.MON mon_if;

    function new(virtual apb_if.DRV drv_if, virtual apb_if.MON mon_if);
        this.drv_if = drv_if;
        this.mon_if = mon_if;
    endfunction

    function void build();
        mbx_gd = new();
        mbx_dr = new();
        mbx_ms = new();
        mbx_rs = new();
        gen = new(mbx_gd);
        drv = new(drv_if, mbx_gd, mbx_dr);
        mon = new(mon_if, mbx_ms);
        ref_model = new(mbx_dr, mbx_rs);
        scb = new(mbx_rs, mbx_ms);
    endfunction

    task start();
        fork
            gen.start();
            drv.start();
            mon.start();
            ref_model.start();
            scb.start();
        join_none
    endtask
endclass
