`include "defines.svh"

class apb_monitor;

    virtual apb_if.MON vif;
    mailbox #(apb_transaction) mbx_ms;
    apb_transaction mon_trans;

    function new(virtual apb_if.MON vif, mailbox #(apb_transaction) mbx_ms);
        this.vif = vif;
        this.mbx_ms = mbx_ms;
    endfunction


    task start();
        forever
        begin
            @(vif.mon_cb);

            if(vif.mon_cb.PSEL && vif.mon_cb.PENABLE)
            begin
                mon_trans = new();
                mon_trans.PADDR = vif.mon_cb.PADDR;
                mon_trans.PWRITE = vif.mon_cb.PWRITE;
                mon_trans.PWDATA = vif.mon_cb.PWDATA;
                mon_trans.PSTRB = vif.mon_cb.PSTRB;
                mon_trans.PRDATA = vif.mon_cb.PRDATA;
                mon_trans.PSLVERR = vif.mon_cb.PSLVERR;
                mon_trans.PREADY = vif.mon_cb.PREADY;

                mbx_ms.put(mon_trans.copy());
             end
        end
    endtask
endclass
