`ifndef RKV_WATCHDOG_BASE_ELEMENT_SEQUENCE_SV
`define RKV_WATCHDOG_BASE_ELEMENT_SEQUENCE_SV
//为了测试一个功能可能需要发送一系列的激励，将这些激励打包为element sequence能够便于在其他测试点复用我们的激励。
//就好像之前的apb write read一样，element sequence能够方便后面的激励测试。
class rkv_watchdog_base_element_sequence extends uvm_sequence;

//base element sequence几乎是base virtual sequence的翻版，但是为什么不直接使其继承与base virtual seq中呢？
//因为需要在各个virtual sequence中调用element seq，因此要在base virtual seq中完成对element seq的声明，故将其单独拿出是合适的。
  `uvm_object_utils(rkv_watchdog_base_element_sequence)
  `uvm_declare_p_sequencer(rkv_watchdog_virtual_sequencer)      //element_sequence里面也有p_sequencer,也是watchdog_virtual_sequencer 
  
  rkv_watchdog_config cfg;
  rkv_watchdog_rgm rgm;  
 
  int rd_val,wt_val;
  uvm_status_e status = UVM_IS_OK;
  virtual rkv_watchdog_if vif;
  function new (string name = "rkv_watchdog_base_element_sequence");
    super.new(name);
    //cfg = rkv_watchdog_config::type_id::create("cfg");
  endfunction
  virtual task body();
    // get cfg from p_sequencer
    cfg = p_sequencer.cfg;
    // get rgm from p_sequencer
    rgm = cfg.rgm;
    vif = cfg.vif;
    `uvm_info("body", "Entered...", UVM_LOW)
    // TODO in sub-class
    `uvm_info("body", "Exiting...", UVM_LOW)
  endtask
virtual function bit diff_value(int val1, int val2, string id = "value_compare");
      cfg.seq_check_count++;
      if(val1 != val2) begin
        cfg.seq_error_count++;
        `uvm_error("[CMPERR]", $sformatf("ERROR! %s val1 %8x != val2 %8x", id, val1, val2)) 
        return 0;
      end
      else begin
        `uvm_info("[CMPSUC]", $sformatf("SUCCESS! %s val1 %8x == val2 %8x", id, val1, val2), UVM_LOW)
        return 1;
      end
    endfunction
endclass

`endif  
