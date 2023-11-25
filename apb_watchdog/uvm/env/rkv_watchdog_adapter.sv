`ifndef RKV_WATCHDOG_ADAPTER_SV
`define RKV_WATCHDOG_ADAPTER_SV


class rkv_watchdog_adapter extends uvm_reg_adapter;
    `uvm_object_utils(rkv_watchdog_adapter)
    function new(string name = "rkv_watchdog_adapter");
      super.new(name);
      provides_responses = 1;
    endfunction
    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);        //uvm_reg_bus_op是一个类，类的成员包括6个域，成员有addr(地址，默认64位) data（数据，默认64位） 
                                                                            //kind（UVM_READ WRITE)  n_bits(传输比特位）)byte_en（byte 操作使能） status（UVM_IS_OK  IS_X NOT_OK)
    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);       
                           //如果用户在寄存器级别做了操作，那么寄存器级别的操作信息会被uvm_reg_bus_op记录，同时调用reg_2_bus操作，在完成uvm_reg_bus_op的信息映射到madf_bus_trans之后，
                           //函数将madf_bus_trans的句柄返回（这里是apb_transfer)
      apb_transfer t = apb_transfer::type_id::create("t");
      t.trans_kind = (rw.kind == UVM_WRITE) ? WRITE : READ;
      t.addr = rw.addr;
      t.data = rw.data;
      t.idle_cycles = 1;
      return t;
    endfunction
    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      apb_transfer t;
      if (!$cast(t, bus_item)) begin
        `uvm_fatal("CASTFAIL","Provided bus_item is not of the correct type")
        return;
      end
      rw.kind = (t.trans_kind == WRITE) ? UVM_WRITE : UVM_READ;
      rw.addr = t.addr;
      rw.data = t.data;
      rw.status = UVM_IS_OK;
    endfunction
  endclass
`endif
