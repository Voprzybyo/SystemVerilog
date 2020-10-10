
//IPbus structures from "IPbus_package.vhd" written in SV
	typedef struct packed{
			logic [31:0] ipb_addr;
			logic [31:0] ipb_wdata;
			logic ipb_strobe;
			logic ipb_write;
	}ipb_wbus;


	typedef struct packed{
			logic [31:0] ipb_rdata;
			logic ipb_ack;
			logic ipb_err;
    }ipb_rbus;


// Interface declaration
interface IPb_intf(  input ipb_rbus ipb_in,
                     output ipb_wbus ipb_out 
				   );                           
    initial begin
    
    //ipb_in structure initialization
    ipb_in.ipb_rdata = 32'hcccccccc;    //32 bit input
    ipb_in.ipb_ack = 1'b1;
    ipb_in.ipb_err = 1'b1;
 
    //ipb_out structure initialization
    ipb_out.ipb_wdata = 32'heeeeeeee;   //32 bit output
    ipb_out.ipb_addr = 32'b0;  		    //32 bit output
    ipb_out.ipb_write = 1'b1;
    ipb_out.ipb_strobe = 1'b1;
	
    end  
                         
endinterface: IPb_intf


/********************IPbus class***********************/

class IPbus_testing_class;

    
    virtual IPb_intf intf;      //Virtual interface inside class
    
	//Assign interface method
    function assign_interface( virtual IPb_intf intf );
        this.intf = intf;
    endfunction
    
	
 
	//Read word method
	task read_word();
	
		$display ( "Read value: %h", intf.ipb_in.ipb_rdata );   
		
	endtask:read_word
  
   
   
	//Write word method   
	task write_word( input [31:0] word_to_write );  
	
		intf.ipb_out.ipb_wdata = word_to_write;
		$display ( "Value %h was succesfully assigned", word_to_write );   
		
	endtask:write_word
	
	
	
    //Read IPbus values current status and write to file
    task read_intf_to_file();
       
       int fd;
       
       fd = $fopen ( "D:/Vivado/alice-fit-fpga/firmware/FT0/TCM/register_status.txt", "w" );
            
       //IN
       $fdisplay( fd, "ipb_rdata: %h",  intf.ipb_in.ipb_rdata );
       $fdisplay( fd, "ipb_ack: %d",    intf.ipb_in.ipb_ack );
       $fdisplay( fd, "ipb_err: %d",    intf.ipb_in.ipb_err );
       
       //OUT
       $fdisplay( fd, "ipb_wdata: %h",  intf.ipb_out.ipb_wdata );
       $fdisplay( fd, "ipb_addr: %h",   intf.ipb_out.ipb_addr );
       $fdisplay( fd, "ipb_write: %d",  intf.ipb_out.ipb_write );
       $fdisplay( fd, "ipb_strobe: %d", intf.ipb_out.ipb_strobe );
       
       $fclose(fd);
       
    endtask: read_intf_to_file


  
    //Read from file 32-bit words and put them to IPbus structure
    task read_file();
    
		int fd; 
		int register_addr;
		int value;
    
		fd = $fopen ( "D:/Vivado/alice-fit-fpga/firmware/FT0/TCM/register.txt", "r" );

        while (!$feof(fd)) begin 
            $fscanf( fd, "%h %h", register_addr, value ); //Reading line
            
			$display ( "ZAPIS na adres: %h 32-bitowego slowa: %h ", register_addr, value );
			intf.ipb_out.ipb_addr = register_addr;
			intf.ipb_out.ipb_wdata = value;			
        end

		$fclose(fd);
 
    endtask: read_file
  
 
 
	//Assign 32-bit word from file to IPbus
    task assign_word_from_file();
		int fd; 

		fd = $fopen ( "D:/Vivado/alice-fit-fpga/firmware/FT0/TCM/IPbus_init.txt", "r" );

		while (!$feof(fd)) begin 
			$fscanf( fd, "%h ", intf.ipb_in.ipb_rdata ); //Reading IN values from file
		end
			
        $display ( "Zapisane wartosci: %h ", intf.ipb_in.ipb_rdata );

		$fclose(fd);
          
    endtask: assign_word_from_file
    
  
  
	//Additional method for debugging purposes
	task read_word2();
  
		$display ( "Read value: %h", intf.ipb_out.ipb_wdata );
    
	endtask:read_word2

endclass: IPbus_testing_class
 
