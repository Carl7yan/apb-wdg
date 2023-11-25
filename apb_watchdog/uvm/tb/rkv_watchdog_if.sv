
interface rkv_watchdog_if;

  logic [3:0] ecorevnum = 4'b1011;      //注册修订号，赋值即可。
  logic       wdogint;
  logic       wdogres;
  logic apb_clk;
  logic apb_rstn;
  logic wdg_clk;
  logic wdg_rstn;
endinterface 
