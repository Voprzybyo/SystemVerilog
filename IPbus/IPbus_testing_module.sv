
`include "IPbus_testing_class.svh"

module IPbus_testing_module();

    IPb_intf intf_in_module(
                          .ipb_in( ipb_in ),
                          .ipb_out( ipb_out )
                          ); 

    IPbus_testing_class temp;

    initial begin
		temp = new();
		temp.assign_interface( intf_in_module );
	end
  
  
    logic CLK;
    always begin : clock_init //Clock period:20ns
		CLK <= 0; #10;
		CLK <= 1; #10;
    end : clock_init
  
	initial begin
   
    $display( "\n\n\n" );


    #50 //Run "read word" method  
    $display( "\nReading value of IPbus -> rbus data" );
    temp.read_word();
	
	
    #50 //Run "write word" method  
    $display( "\nWriting value to IPbus -> wbus data" );
    #50 temp.write_word( 32'hffffffff );
	#50 temp.write_word( 32'hcccccccc );
	#50 temp.write_word( 32'hecececec );
	#50 temp.write_word( 32'haaaaaaaa );


	#50 //Test write and read word methods
		#50 temp.write_word( 32'hffffffff );
			temp.read_word2();
		
		#50 temp.write_word( 32'hecececec );
			temp.read_word2();
		
		#50 temp.write_word( 32'h11111111 );
			temp.read_word2();
		
		#50 temp.write_word( 32'h55555555 );
			temp.read_word2();
  
    #50 //Run method assigning VALUES and ADDRESSES from file to IPbus structures members
    $display( "\nAssign 32-word from file" );
    temp.assign_word_from_file();
    
    
	#50 //Run method reading values of IPbus structures and writing them to file
    $display( "\nRead structure members values and write to file" );
    temp.read_intf_to_file();
	
	
	#50 //Run writing to file method  
    $display( "\nRead address and value from file and assign them to IPbus structure members" );
    temp.read_file();
	
	
    $display( "\n\n\n" );
    
    #50 $finish;
  end
  
endmodule: IPbus_testing_module