/*Declaration of top module*/
module top;
   
    parameter HOW_MANY_BITS = 4; //case '3' counter counts to 7; case '4' to 15 etc... 

    counter_interface #(.HOW_MANY_BITS(HOW_MANY_BITS)) counterInterface(); //Create interface named "counterInterface"
    
    /*Create design and tb instances and ?connect? them by giving the same interfece and params???*/ 
    first_counter #(.HOW_MANY_BITS(HOW_MANY_BITS)) counter_design (counterInterface);
    first_counter_tb #(.HOW_MANY_BITS(HOW_MANY_BITS)) counter_tb (counterInterface);

endmodule : top   


/*Declaration of interface between main module and TB*/
interface counter_interface #(HOW_MANY_BITS);       //taking param from "top" module  
    logic [HOW_MANY_BITS-1:0] IN, OUT;        //IN - value I want to load, OUT - output register
    logic UP_or_DOWN;                         //Select counting direction
    logic LOAD;                               //Load enable (if high, counter loads value from IN register)
    logic START_or_STOP;                      //Start or stop counting
    logic CLK, RST;                           //Declaration of reset and clock signals               
endinterface 

/*Main module*/
module first_counter #(HOW_MANY_BITS) (counter_interface counterInterface);

    initial begin : initialization                     
        counterInterface.UP_or_DOWN = 1'b0;     //Counting UP
        counterInterface.START_or_STOP = 1'b1;  //Start counting at the begining
        counterInterface.IN <= 0;
        counterInterface.LOAD <= 0;             //Load disable at the beginning
        counterInterface.OUT <= 0;
        counterInterface.RST <= 0;
    end : initialization   
    
    /*always_ff ->flip-flop logic*/
    /*the process is triggered on every positive edge of the clock declared in interface*/
    always_ff @(posedge counterInterface.CLK)
        
        if (counterInterface.RST == 1'b1)    //First of all I am checking if reset is high 
                counterInterface.OUT <= 0;    //If so, OUTPUT equals zero
        else if (counterInterface.START_or_STOP == 1'b0)        //Check if counting is stopped
                counterInterface.OUT <= counterInterface.OUT;   //Stop counting
        else if (counterInterface.LOAD == 1'b1)                 //Check if load is enable
                counterInterface.OUT <= counterInterface.IN;    //load value from "IN" register to counter
        else
        //There is no need to use "case statement" - it is used only to practise syntax
                case (counterInterface.UP_or_DOWN)               //TO DO --> usage of "enum"
                    1'b0: counterInterface.OUT <= counterInterface.OUT + 1;     //Counting UP                          
                    1'b1: counterInterface.OUT <= counterInterface.OUT - 1;     //Counting DOWN                          
                    default: counterInterface.OUT <= counterInterface.OUT + 1;  //Counting UP by default                     
                endcase
endmodule
