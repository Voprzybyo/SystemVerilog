`timescale 1ns / 1ps

/*********Testbench declaration***********/
module FSM_tb( FSM_interface FSMInterface);

/*Clock parameters init*/
    always begin : clock_init //Clock period:20ns
      FSMInterface.CLK <= 0; #10;
      FSMInterface.CLK <= 1; #10;
    end : clock_init

/*Spread sequention in time (clock period)*/
    task test_seq(input [10:0] sequence_of_bits);
        for(int i = 0; i<10; i++)
        begin
            #20 FSMInterface.DATA = sequence_of_bits[i]; //putting particulary each bit of sequence
        end              
    endtask

/*Toggle RESET*/
    task toggle_reset();
        FSMInterface.RST = ~FSMInterface.RST;
    endtask   

/**************Simulation****************/
initial 
begin : sim

    #30 toggle_reset();
    #30 toggle_reset();
    #30 toggle_reset();
    #30 toggle_reset();
    
    #60 test_seq(10'b0100011100);
    #60 test_seq(10'b1110001010);
    #60 test_seq(10'b0101010101);
    #30 toggle_reset();
    #60 test_seq(10'b1010000111);
    #30 toggle_reset();
    #60 test_seq(10'b0101010101);
    #60 test_seq(10'b1111111111);
    #60 test_seq(10'b0000000000);

     
    #500 $finish;
end : sim

endmodule
