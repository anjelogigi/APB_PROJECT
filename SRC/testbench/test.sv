
`include "defines.svh"

class apb_test;

    virtual apb_if.DRV drv_if;
    virtual apb_if.MON mon_if;
    apb_environment env;

    function new(virtual apb_if.DRV drv_if, virtual apb_if.MON mon_if);
        this.drv_if = drv_if;
        this.mon_if = mon_if;
    endfunction

    task run();
        env = new(drv_if, mon_if);
        env.build();
        env.start();
    endtask

endclass
