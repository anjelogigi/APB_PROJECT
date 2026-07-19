
`include "defines.svh"

class apb_scoreboard;

    mailbox #(apb_transaction) mbx_rs;
    mailbox #(apb_transaction) mbx_ms;
    apb_transaction ref_trans;
    apb_transaction mon_trans;

    int MATCH =0;
    int MISMATCH=0;

    function new(mailbox #(apb_transaction) mbx_rs, mailbox #(apb_transaction) mbx_ms);
        this.mbx_rs = mbx_rs;
        this.mbx_ms = mbx_ms;
     endfunction


    task start();
        forever
        begin
            mbx_rs.get(ref_trans);
            mbx_ms.get(mon_trans);

            if((ref_trans.PRDATA   === mon_trans.PRDATA) && (ref_trans.PSLVERR  === mon_trans.PSLVERR))
            begin
                MATCH++;
                $display("----------------------------------------");
                $display("SCOREBOARD : MATCH");
                $display("PRDATA = %0h", mon_trans.PRDATA);
                $display("PSLVERR = %0b", mon_trans.PSLVERR);
                $display("----------------------------------------");
            end
            else
            begin
                MISMATCH++;

                $display("----------------------------------------");
                $display("SCOREBOARD : MISMATCH");
                $display("EXPECTED PRDATA = %0h | ACTUAL PRDATA   = %0h", ref_trans.PRDATA, mon_trans.PRDATA);
                $display("EXPECTED PSLVERR = %0b | ACTUAL PSLVERR  = %0b", ref_trans.PSLVERR, mon_trans.PSLVERR);
                $display("----------------------------------------");
            end

            $display("TOTAL MATCH = %0d", MATCH);
            $display("TOTAL MISMATCH = %0d", MISMATCH);
            $display("");

        end

    endtask

endclass
