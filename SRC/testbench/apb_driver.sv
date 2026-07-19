`include "defines.svh"

class apb_driver;
    virtual apb_if.DRV vif;
    mailbox #(apb_transaction) mbx_gd;
    mailbox #(apb_transaction) mbx_dr;
    apb_transaction drv_trans;

    covergroup drv_cg;
        PRESETn_cp : coverpoint vif.drv_cb.PRESETn
        {
            bins reset_deasserted = {1};
        }
        PSEL_cp : coverpoint vif.drv_cb.PSEL
        {
            bins psel_asserted = {1};
        }
        PENABLE_cp : coverpoint vif.drv_cb.PENABLE;
        PADDR_cp : coverpoint vif.drv_cb.PADDR
        {
            bins addr_0 = {0};
            bins addr_mid = {[1:126]};
            bins addr_127 = {127};
            bins addr_invalid = {[128:255]};
        }
        PWDATA_cp : coverpoint vif.drv_cb.PWDATA;
        PWRITE_cp : coverpoint vif.drv_cb.PWRITE
        {
            bins read  = {0};
            bins write = {1};
        }
        PSTRB_cp : coverpoint vif.drv_cb.PSTRB
        {
            bins read_strb = {4'b0000};
            bins write_strb[] = {[1:15]};
        }
        PSEL_PENABLE : cross PSEL_cp, PENABLE_cp;
        PWRITE_PADDR : cross PWRITE_cp, PADDR_cp;
        
    endgroup

    function new(virtual apb_if.DRV vif, mailbox #(apb_transaction) mbx_gd, mailbox #(apb_transaction) mbx_dr);
        this.vif = vif;
        this.mbx_gd = mbx_gd;
        this.mbx_dr = mbx_dr;
        drv_cg = new();
    endfunction

    task start();
        while (!vif.drv_cb.PRESETn)
            @(vif.drv_cb);

        forever
        begin
            mbx_gd.get(drv_trans);

            //setup
            @(vif.drv_cb);
            vif.drv_cb.PSEL <= 1;
            vif.drv_cb.PENABLE <= 0;
            vif.drv_cb.PWRITE <= drv_trans.PWRITE;
            vif.drv_cb.PADDR <= drv_trans.PADDR;
            vif.drv_cb.PWDATA <= drv_trans.PWDATA;
            vif.drv_cb.PSTRB <= drv_trans.PSTRB;
            drv_cg.sample();

            //access
            @(vif.drv_cb);
            vif.drv_cb.PENABLE <= 1;
            drv_cg.sample();

            mbx_dr.put(drv_trans.copy());

            @(vif.drv_cb);
            vif.drv_cb.PSEL <= 0;
            vif.drv_cb.PENABLE <= 0;
            vif.drv_cb.PWRITE <= 0;
            vif.drv_cb.PADDR <='0;
            vif.drv_cb.PWDATA <= '0;
            vif.drv_cb.PSTRB <= '0;
        end
    endtask
endclass
