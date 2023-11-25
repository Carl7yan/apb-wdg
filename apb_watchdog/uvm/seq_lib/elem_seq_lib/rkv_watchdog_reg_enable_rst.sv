`ifndef RKV_WATCHDOG_REG_ENABLE_RST_SV
`define RKV_WATCHDOG_REG_ENABLE_RST_SV
  
class rkv_watchdog_reg_enable_rst extends rkv_watchdog_base_element_sequence;
  `uvm_object_utils(rkv_watchdog_reg_enable_rst)

  function new (string name = "rkv_watchdog_reg_enable_rst");
    super.new(name);
  endfunction

  virtual task body();
    int rd_val;
    super.body();
    rgm.WDOGCONTROL.RESEN.set('b1);  //set resen value = 1   spec中WDOGCONTROL寄存器第一位（RESEN)置1为使能复位RESEN
    rgm.WDOGCONTROL.update(status);
  endtask


  //这里简单介绍set+update与直接write的差别。首先前者可以进行寄存器域的访问，其次就是前者不一定会完成一次写操作，
  //只有set之后的rgm值与实际硬件值不同时，才会进行一次写操作。
endclass


`endif
