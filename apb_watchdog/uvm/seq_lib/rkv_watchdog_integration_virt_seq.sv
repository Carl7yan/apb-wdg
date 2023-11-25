`ifndef RKV_WATCHDOG_INTEGRATION_VIRT_SEQ_SV
`define RKV_WATCHDOG_INTEGRATION_VIRT_SEQ_SV

class rkv_watchdog_integration_virt_seq extends rkv_watchdog_base_virtual_sequence;
  `uvm_object_utils(rkv_watchdog_integration_virt_seq)
  function new (string name = "rkv_watchdog_integration_virt_seq");
    super.new(name);
  endfunction

  task body();
    super.body();
    `uvm_info("body", "Entered...", UVM_LOW)
    `uvm_info("SEQSTART", "virtual sequence body started!!", UVM_LOW)
  
    void'(this.diff_value( vif.wdogint, 'b0));
    void'(this.diff_value( vif.wdogres, 'b0));

    wt_val = 'h1;
    rgm.WDOGITCR.write(status, wt_val);
    rgm.WDOGITCR.read(status, rd_val);
    void'(this.diff_value( rd_val, wt_val));   //先配置WDOGITCR寄存器，使watchdog进入集成测试模式
    



    wt_val = 'b11;
    rgm.WDOGITOP.write(status, wt_val);
    void'(this.diff_value( vif.wdogint, 'b1));
    void'(this.diff_value( vif.wdogres, 'b1));

    wt_val = 'b01;
    rgm.WDOGITOP.WDOGINT.set('b1);
    rgm.WDOGITOP.WDOGRES.set('b0);
    rgm.WDOGITOP.update(status);
    void'(this.diff_value( vif.wdogint, 'b1));
    void'(this.diff_value( vif.wdogres, 'b0));
    
    wt_val = 'b10;
    rgm.WDOGITOP.WDOGINT.set('b0);
    rgm.WDOGITOP.WDOGRES.set('b1);
    rgm.WDOGITOP.update(status);
    void'(this.diff_value( vif.wdogint, 'b0));
    void'(this.diff_value( vif.wdogres, 'b1));
                                                //   随后对wdogitop中wdogint和wdogres两个域进行0 1 赋值，检验输出的值是否与赋值相同并随着变化       



    wt_val = 'h0;                            //配置WDOGITCR寄存器，不让watchdog进入集成测试模式  
    rgm.WDOGITCR.write(status, wt_val);
    rgm.WDOGITCR.read(status, rd_val);
    void'(this.diff_value( rd_val, wt_val));
    
    wt_val = 'b11;
    rgm.WDOGITOP.WDOGINT.set('b1);
    rgm.WDOGITOP.WDOGRES.set('b1);
    rgm.WDOGITOP.update(status);
    void'(this.diff_value( vif.wdogint, 'b0));
    void'(this.diff_value( vif.wdogres, 'b0));
    

    // 这里WDOGITCR是读写寄存器，故可以对其进行读写操作，而WDOGITOP为只读寄存器，只能对其进行写操作。
    //而功能验证则通过检查返回的信号是否与赋值相同实现即可。
    //只读”的意思是在其工作时只能读出，不能写入。然而其中存储的原始效据，必须在它工作以前与入。
    //只读存储器由寸工作可靠，保密性强，在计算机系统中得到广泛的应用
    
    #1us;
    `uvm_info("body", "Exiting...", UVM_LOW)
  endtask
endclass

`endif 
