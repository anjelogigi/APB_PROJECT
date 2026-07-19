`include "defines.svh"
class apb_generator;
    apb_transaction blueprint;
    apb_transaction trans;
    mailbox #(apb_transaction) mbx_gd;

    function new(mailbox #(apb_transaction) mbx_gd);
        this.mbx_gd = mbx_gd;
        blueprint = new();
    endfunction

    task start();
        for (int i = 0; i < `NUM_TRANSACTIONS; i++)
        begin
            trans = blueprint.copy();
            assert(trans.randomize())
            mbx_gd.put(trans.copy());
        end
    endtask

endclass
