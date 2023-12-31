`ifndef RKV_WATCHDOG_REGACC_VIRT_SEQ_SV
`define RKV_WATCHDOG_REGACC_VIRT_SEQ_SV
  
class rkv_watchdog_regacc_virt_seq extends rkv_watchdog_base_virtual_sequence;
  `uvm_object_utils(rkv_watchdog_regacc_virt_seq)

  function new (string name = "rkv_watchdog_regacc_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    int rd_val;
    uvm_status_e status = UVM_IS_OK;
    super.body(); 

    `uvm_info("body", "Entered...", UVM_LOW)
    // TODO in sub-class
    rgm.WDOGPERIPHID0.read(status, rd_val);  //rgm访问的方式将硬件寄存器通过软件方式进行封装，不再需要查询每个寄存器的地址来进行配置，同时也可以针对
                                            //某个寄存器域进行配置，增加了配置的灵活程度
    void'(this.diff_value( rd_val , 'h24));
    
    rgm.WDOGPERIPHID1.read(status, rd_val); 
    void'(this.diff_value( rd_val , 'hb8));
    
    rgm.WDOGPERIPHID2.read(status, rd_val); 
    void'(this.diff_value( rd_val , 'h1b));
    rgm.WDOGPERIPHID3.read(status, rd_val); 
    void'(this.diff_value( rd_val , 'hb0));
    `uvm_info("body", "Exiting...", UVM_LOW)
  endtask



endclass


`endif
