/********Declaration of top module*********/
module top;

    FSM_interface FSMInterface(); //Create interface named "FSMInterface"
    
    /*Create design and tb instances and ?connect? them by giving the same interface*/ 
    FSM  fsm_design (FSMInterface);
    FSM_tb  fsm_tb (FSMInterface);

endmodule : top  

/*Declaration of interface between main module and TB*/

interface FSM_interface;       
     logic CLK, RST;
     logic DATA;
     logic [1:0] OUT;    
endinterface 

/***************MAIN MODULE***************/

/*FSM - serial detector  of "00" or "11" sequention*/
//if  none of above -> output is "00" 
//if  "00" -> output is "01" 
//if  "11" -> output is "10" 
module FSM(FSM_interface FSMInterface);

/*Enumerated types*/
    typedef enum logic [2:0] {NONE, ONE_FIRST, ONE_SECOND, ZERO_FIRST, ZERO_SECOND} State;
    State currentState, nextState;

/***********INITIALIZATION***************/

    initial 
    begin : initialization                     
        FSMInterface.DATA <= 0;
        FSMInterface.CLK <= 0;
        FSMInterface.RST <= 0;
        FSMInterface.OUT = 2'b00;
       // currentState <= NONE;
    end : initialization   

/***********MAIN BEHAVIOUR***************/

    always_ff @(edge FSMInterface.CLK ) 
    begin: main_bahaviour
        if(FSMInterface.RST) currentState <= NONE;  
        else currentState <= nextState;       
    end: main_bahaviour

/***********STATES SWITCH***************/

    always_comb 
    begin: switch_states
     case(currentState)
    
     NONE: if (FSMInterface.DATA) nextState = ONE_FIRST;
     else nextState = ZERO_FIRST;
    
     /*Got first '1'*/
     ONE_FIRST:   if (FSMInterface.DATA) nextState = ONE_SECOND;
                  else nextState = ZERO_FIRST;
                  
     /*Got first '0'*/
     ZERO_FIRST:  if (FSMInterface.DATA) nextState = ONE_FIRST;
                  else nextState = ZERO_SECOND;
                  
    /*Got '11'*/
     ONE_SECOND:  if (FSMInterface.DATA) nextState = ONE_SECOND;
                  else nextState = ZERO_FIRST;
    
    /*Got '00'*/
     ZERO_SECOND: if (FSMInterface.DATA) nextState = ONE_FIRST;
                  else nextState = ZERO_SECOND;
    
     endcase

    end: switch_states
    
 /**********OUTPUT BEHAVIOUR************/   
 
 always_ff @(posedge FSMInterface.CLK)
 
 case (currentState)
 
    /*OUTPUT: "00"*/
    NONE: FSMInterface.OUT = 2'b00;
    ZERO_FIRST: FSMInterface.OUT = 2'b00;
    ONE_FIRST: FSMInterface.OUT = 2'b00;
    
    /*OUTPUT: "01"*/
    ZERO_SECOND: FSMInterface.OUT = 2'b01;
    
    /*OUTPUT: "10"*/
    ONE_SECOND: FSMInterface.OUT = 2'b10;

 endcase

endmodule


