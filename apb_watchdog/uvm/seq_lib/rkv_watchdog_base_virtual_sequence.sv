`ifndef RKV_WATCHDOG_BASE_VIRTUAL_SEQUENCE_SV
`define RKV_WATCHDOG_BASE_VIRTUAL_SEQUENCE_SV

// typedef class rkv_watchdog_inrt_wait_clear;
// typedef class rkv_watchdog_loadcount;
// typedef class rkv_watchdog_reg_enable_inrt;

class rkv_watchdog_base_virtual_sequence extends uvm_sequence;
  `uvm_object_utils(rkv_watchdog_base_virtual_sequence)
  `uvm_declare_p_sequencer(rkv_watchdog_virtual_sequencer) 

    //m_sequencer是定义在sequence的最底层类uvm_sequence_item里的，意味着任何sequence都会自带一个m_sequencer，
  //当我们无论是通过`uvm_do_on宏还是seq.start(xxx_sequencer)的方式，UVM都会将用户传入的sequencer绑定到该sequence的m_sequencer。
  
  //m_sequencer是watchdog_base_virtual_sequence内部的一个成员变量，指向其所挂载的sequencer（watchdog_base_virtual_sequencer),但是m_sequencer是
   //父类uvm_base_sequencer类型，无法通过它调用子类watchdog_virtual_sequencer的成员变量，而p_sqr则做了两步，定义了一个virtual_sqr，并且$cast转化，
  //m_sqr转为p_sqr，这样就可以通过p_sqr来调用rkv_watchdog_virtal_sequencer内部的apb_mst_sqr句柄。


  //创建一个sequence的时候，往往要在这个sequence中声明它所对应的sequencer类型，也就是`uvm_declare_p_sequencer(xxx_sequencer)。
  //注意的是，这里xxx_sequencer指的是类型，而不是某个具体的sequencer实例。

  rkv_watchdog_inrt_wait_clear int_wait_clr_seq;
  rkv_watchdog_loadcount loadcount_seq;
  rkv_watchdog_reg_enable_inrt enable_inrt_seq;
  rkv_watchdog_reg_enable_rst enable_rst_seq;
  rkv_watchdog_reg_disable_rst disable_rst_seq;
  rkv_watchdog_reg_disable_inrt disable_inrt_seq;        //把watchdog的base_element_sequence放到base_virtual_sequence中来


  //base element sequence几乎是base virtual sequence的翻版，但是为什么不直接使其继承于base virtual seq中呢？
  //因为需要在各个virtual sequence中调用element seq，
  //因此要在base virtual seq中完成对element seq的声明，故将其单独拿出是合适的。





  apb_master_single_write_sequence apb_wr_seq;
  apb_master_single_read_sequence apb_rd_seq;
  apb_master_write_read_sequence apb_wr_rd_seq;
  //vip中的sequence也集成到base virtual seq中来
  
  
  rkv_watchdog_config cfg;
  rkv_watchdog_rgm rgm;  
  i
  
  nt rd_val,wt_val;
  uvm_status_e status = UVM_IS_OK;
  virtual rkv_watchdog_if vif;
  function new (string name = "rkv_watchdog_base_virtual_sequence");
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
  virtual task wait_int_rise();
    @(posedge vif.wdogint);
  endtask

  virtual task wait_int_down();
    @(negedge vif.wdogint);
  endtask

  virtual task wait_res_rise();
    @(posedge vif.wdogres);
  endtask

  virtual task wait_res_down();
    @(negedge vif.wdogres);
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
