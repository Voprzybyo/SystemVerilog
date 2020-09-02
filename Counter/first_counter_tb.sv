`timescale 1ns / 1ps

/*Testbench declaration*/
module first_counter_tb #(HOW_MANY_BITS)(counter_interface counterInterface);
    
/*Clock parameters init*/
    always begin : clock_init //Clock period:20ns
      counterInterface.CLK <= 0; #10;
      counterInterface.CLK <= 1; #10;
    end : clock_init
    
/****************SINGLE TASKS*******************/

/*Toggle RESET signal*/
    task toggle_reset();
        counterInterface.RST = ~counterInterface.RST;
    endtask   
    
/*Toggle counting direction*/
    task set_direction( input integer a );
        counterInterface.UP_or_DOWN = a;
    endtask
    
/*Start/Stop counting*/
    task start_stop_counting( input integer a );
        counterInterface.START_or_STOP = a;
    endtask
    
/*Load value*/ 
    task load_value( input integer a );
        counterInterface.LOAD = 1;  //Load enable    
        counterInterface.IN = a;    //Load value
        #20                         //waiting for clock positive edge (trigger)
        counterInterface.LOAD = 0;  //Load disable
    endtask

/****************************************/
/*************TESTING BLOCKS*************/

task test_RESET();
    #100 toggle_reset();
    #70  toggle_reset();
    #150 toggle_reset();
    #150 toggle_reset();
endtask

task test_DIRECTION();
    #100 set_direction(0);
    #70  set_direction(1);
    #150 set_direction(0);
    #40 set_direction(1);
    #40 set_direction(0);
endtask

task test_START_STOP();
    #100 start_stop_counting(0);
    #70  start_stop_counting(1);
    #150 start_stop_counting(0);
    #70  start_stop_counting(1);
endtask  

task test_LOAD();
    #100 load_value(4);
    #70  load_value(1);
    #150 load_value(7);
    #150 load_value(3);
endtask  

task test_MIX();
    #100 toggle_reset();
    #70  load_value(7);
    #70  set_direction(1);
    #20 toggle_reset();
    #150 load_value(5);
    #80 start_stop_counting(0);
    #70  toggle_reset();
    #30 load_value(5);
    #30  set_direction(0);
    #70  toggle_reset();
    #80 start_stop_counting(1);
endtask  
    
/****************************************/
/**************Simulation****************/
    initial 
    begin : sim
    
    #200
    test_RESET();
  
    #200
    test_DIRECTION();
    
    #200
    test_START_STOP();
    
    #200
    test_LOAD();
    
    #200
    test_MIX();
     
    #500 $finish;
    end : sim
    
/****************************************/   
endmodule
