`include "defines.svh"

class apb_generator;

    apb_transaction blueprint;
    mailbox #(apb_transaction) mbx_gd;

    function new(mailbox #(apb_transaction) mbx_gd);
        this.mbx_gd = mbx_gd;
        blueprint = new();
    endfunction

    task start();

        for (int i = 0; i < `NUM_TRANSACTIONS; i++) begin

            // Random Test
            assert(blueprint.randomize());

            // Write Test
            //assert(blueprint.randomize() with { PWRITE == 1; });

            // Read Test
            //assert(blueprint.randomize() with { PWRITE == 0; });

            // Invalid Address Test
            //assert(blueprint.randomize() with { PADDR >= `DATA_DEPTH; });

            // No Strobe Test
            //assert(blueprint.randomize() with {
            //    PWRITE == 1;
            //    PSTRB  == 4'b0000;
            //});

            // Back-to-Back Test
            //assert(blueprint.randomize() with {
            //    PADDR inside {[0:`DATA_DEPTH-1]};
            //});

            mbx_gd.put(blueprint.copy());

        end

    endtask

endclass
