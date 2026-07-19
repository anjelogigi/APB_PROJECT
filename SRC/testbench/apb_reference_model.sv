`include "defines.svh"

class apb_reference_model;

    mailbox #(apb_transaction) mbx_dr;
    mailbox #(apb_transaction) mbx_rs;
    apb_transaction drv_trans;
    apb_transaction ref_trans;

    bit [`DATA_WIDTH-1:0] mem[`DATA_DEPTH-1:0];

    function new(mailbox #(apb_transaction) mbx_dr,mailbox #(apb_transaction) mbx_rs);
        this.mbx_dr = mbx_dr;
        this.mbx_rs = mbx_rs;
    endfunction


    task start();

        forever
        begin

            mbx_dr.get(drv_trans);

            ref_trans = drv_trans.copy();
            ref_trans.PREADY = 1;
            ref_trans.PRDATA = '0;
            ref_trans.PSLVERR = 0;

            if(drv_trans.PADDR >= `DATA_DEPTH)
            begin
                ref_trans.PSLVERR = 1;
                if(!drv_trans.PWRITE)
                    ref_trans.PRDATA = {`DATA_WIDTH{1'b1}};
            end
            else
            begin
                if(drv_trans.PWRITE)
                begin
                    for(int i=0; i<`STRB_WIDTH; i++)
                    begin
                        if(drv_trans.PSTRB[i])
                            mem[drv_trans.PADDR][8*i +: 8] = drv_trans.PWDATA[8*i +: 8];
                    end
                end
                else
                begin
                    ref_trans.PRDATA = mem[drv_trans.PADDR];
                end
            end

            mbx_rs.put(ref_trans.copy());
       end

    endtask

endclass
