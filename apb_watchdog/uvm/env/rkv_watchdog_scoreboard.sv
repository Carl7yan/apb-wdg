
`ifndef RKV_WATCHDOG_SCOREBOARD_SV
`define RKV_WATCHDOG_SCOREBOARD_SV

class rkv_watchdog_scoreboard extends rkv_watchdog_subscriber;
    int cur_load;                           //load value from load reg
    int cur_count;                          //count value which will decrease when counting  
    bit inten_status = 0;                   //value of inten in reg
    bit load_set = 0;                       //value of load in watchdog 
    bit inrt_asserted = 0;                  //means watchdog int has asserted
    bit res_asserted = 0;                   //means watchdog res has asserted
    bit res_able_check = 0;                 //reset check enable
  `uvm_component_utils(rkv_watchdog_scoreboard)

  function new (string name = "rkv_watchdog_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
 
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    do_countdown_check();
  endtask
  

  //同时不停地进行不同事件的触发等待以及do_localcount计数等待工作，不同的事件会将计数状态改变，
  //比如中断清除事件会将inrt_asserted = 0;使得中断状态处于未触发状态，并重新开始计数检查。
  //每一个forever begin中就包含了一次会对计数造成影响的寄存器访问行为。
   
  virtual task do_countdown_check();
    fork
        forever begin: wait_inten
          wdg_inten_e.wait_trigger();
          inten_status = 1;
          disable load_count_check;
        end
        forever begin: wait_resen
          wdg_resen_e.wait_trigger();
          res_able_check = 1;
        end
        forever begin: wait_int_disable
          wdg_intdis_e.wait_trigger();
          inten_status = 0;
          disable load_count_check;
        end
        forever begin: wait_load_count_val
          wdg_load_e.wait_trigger();
          load_set = 1;
          disable load_count_check;
        end
        forever begin: wait_int_clr
          wdg_int_clr_e.wait_trigger();
          inrt_asserted = 0;
          disable load_count_check;
        end
        forever begin 
          begin: load_count_check
            do_localcount();
          end
        end
    join_none
  endtask




  virtual function bit do_count_able_check();
    if( inten_status && load_set && cfg.enable_scb ) return 1;
    //满足检查条件（检查器打开，inten为高，watchdog完成计数值加载）时会进行计数检查
    else return 0;
  endfunction

  virtual task do_localcount();
        bit count_check;
        count_check = do_count_able_check(); //满足检查条件（检查器打开，inten为高，watchdog完成计数值加载）时会进行计数检查
        @(posedge vif.wdg_clk iff count_check );
        cur_load = rgm.WDOGLOAD.LOADVAL.get();
        cur_count = cur_load;
        do begin
          @(posedge vif.wdg_clk);
          cur_count--;       //在每个wdg_clk时钟计数减1
        end while( cur_count != 0 );
        repeat(2) @(negedge vif.wdg_clk); //in load and clear check need one more clock to reload
        res_able_check = rgm.WDOGCONTROL.RESEN.get(); 
        if( !inrt_asserted && !res_asserted ) begin     //中断信号和复位信号未触发，进行中断触发检查
          wdg_assert_inrt_e.trigger();
          if( vif.wdogint !=1 ) begin    
            cfg.scb_error_count++;
            `uvm_error("CNTDWN", "wdogint is not asserted!!")
          end
          inrt_asserted = 1;
          cfg.scb_check_count++;
        end
        else if( inrt_asserted && !res_asserted && res_able_check ) begin //中断信号触发和复位信号未触发，进行复位触发检查
          if( !vif.wdogres) begin
            cfg.scb_error_count++;
            `uvm_error("CNTDWN","wdogres is not asserted!!!")
          end
            wdg_assert_res_e.trigger();
            res_asserted = 1;
            cfg.scb_check_count++;
        end
  endtask
endclass



`endif //
