`ifndef RKV_WATCHDOG_LOADCOUNT_SV
`define RKV_WATCHDOG_LOADCOUNT_SV
  
class rkv_watchdog_loadcount extends rkv_watchdog_base_element_sequence;
  `uvm_object_utils(rkv_watchdog_loadcount)
  rand int load_val;

  constraint cstr{
    soft load_val inside{['h1:'hffffff]};
  };
  function new (string name = "rkv_watchdog_loadcount");
    super.new(name);
  endfunction

  virtual task body();
    int rd_val;

    super.body();
    rgm.WDOGLOAD.mirror(status);
    @(posedge vif.wdg_clk);
    rgm.WDOGLOAD.write(status, load_val); 
    rgm.WDOGLOAD.read(status, rd_val); 
    void'(this.diff_value( rd_val , load_val));
   //此seq对WDOGLOAD寄存器进行了写入，其中传递值load_val可以由外部约束
  endtask
endclass
`endif
