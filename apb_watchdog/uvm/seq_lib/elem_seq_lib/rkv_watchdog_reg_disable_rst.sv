`ifndef RKV_WATCHDOG_REG_DISABLE_RST_SV
`define RKV_WATCHDOG_REG_DISABLE_RST_SV
  
class rkv_watchdog_reg_disable_rst extends rkv_watchdog_base_element_sequence;
  `uvm_object_utils(rkv_watchdog_reg_disable_rst)

  function new (string name = "rkv_watchdog_reg_disable_rst");
    super.new(name);
  endfunction

  virtual task body();
    int rd_val;
    
    super.body();
    rgm.WDOGCONTROL.RESEN.set('b0);     //spec中WDOGCONTROL寄存器第一位（RESEN)置0为不使能复位RESEN
    rgm.WDOGCONTROL.update(status);
  
  endtask



endclass


`endif
