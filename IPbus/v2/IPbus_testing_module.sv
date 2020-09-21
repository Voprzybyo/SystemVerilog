//IPbus structures from "IPbus_package.vhd" written in SV
	typedef struct{
			logic [31:0] ipb_addr;
			logic [31:0] ipb_wdata;
			logic ipb_strobe;
			logic ipb_write;
	}ipb_wbus;


	typedef struct{
			logic [31:0] ipb_rdata;
			logic ipb_ack;
			logic ipb_err;
    }ipb_rbus;

// Interface declaration
interface IPb_intf( input ipb_rbus ipb_in,
                    output ipb_wbus ipb_out
					//input logic clk ?
					); 
					                            
    initial
    begin
    //ipb_in structure initialization
    //ipb_in.data = 1'b1;        //unnecessary? there is no such a member in ipb_wbus structure
    ipb_in.ipb_rdata = 32'b0;    //32 bit input
    ipb_in.ipb_ack = 1'b1;
    ipb_in.ipb_err = 1'b1;
 
    //ipb_out structure initialization
    ipb_out.ipb_wdata = 32'b0;  //32 bit output
    ipb_out.ipb_addr = 32'b1;   //32 bit output
    ipb_out.ipb_write = 1'b1;
    ipb_out.ipb_strobe = 1'b1;
    end  
                         
endinterface: IPb_intf

class IPbus_testing_class;


    //Virtual interface inside class
    local virtual IPb_intf intf;
 
    //Assigning interface method
    task assign_interface( virtual IPb_intf intf);
        this.intf = intf;       //interface named locally as "intf"
    endtask: assign_interface

    //Read virtual interface method
    task read_intf(virtual IPb_intf intf); //Interface given as a parameter
       //TO DO
    endtask: read_intf


    //variables for setters and getters
    local int x; //local value using to test set/get methods
 
    //Set method
    task set(int i);
        x = i;
    endtask
 
     //Get method
    function int get();
        return x;
    endfunction
  
    task test();
        $display("Test");
    endtask;
  
    //Write/read file testing method
    task test_file_read_write(int data_in);
        
    int fd; 			// file descriptor
    string line; 		// String value read from the file
    
    // 1. Write 
    fd = $fopen ("D:/Vivado/alice-fit-fpga/firmware/FT0/TCM/plik.txt", "w");
        for (int i = 0; i < 10; i++) begin
           $fdisplay (fd, "Linia = %0d, %0d", i+10, data_in);
        end
    $fclose(fd);

    // 2. Read 
    fd = $fopen ("D:/Vivado/alice-fit-fpga/firmware/FT0/TCM/plik.txt", "r");
    // fgets -> save string in "line" variable
    $fgets(line, fd);
    $display ("Przeczytano : %s", line);
    
    // Next line
    $fgets(line, fd);
    $display ("Przeczytano : %s", line);
    $fclose(fd);
 
    endtask: test_file_read_write
  
    //Read from file values for memory adresses
    task read_file();
    
    int fd; 
    int read_or_write;
    int register_addr;
    int value;
    
    fd = $fopen ("D:/Vivado/alice-fit-fpga/firmware/FT0/TCM/register.txt", "r");

        while (!$feof(fd)) begin 
            $fscanf(fd, "%d %d %d ", read_or_write, register_addr, value); //Reading line
            if(read_or_write == 1) begin
            $display ("ZAPIS na adres: %08d wartoœci: %0d ", register_addr, value);
            //TO DO
            //Put parsed memory adresses and corresponding values to IPbus      
            
            //intf.ipbus.data = value;
                 
            end
        end

    $fclose(fd);
 
    endtask: read_file
  
  
    //Write to file values from IPbus input signals
    task write_file();
    
    int fd; 
    int register_addr;
    int value;
    
    // 1. Write register status to file 
    fd = $fopen ("D:/Vivado/alice-fit-fpga/firmware/FT0/TCM/register_status.txt", "w");
        $fdisplay (fd, "TEST");
        for (int i = 0; i < 10; i++) begin
           //$display (fd, "IPbus data: %d", intf.ipb_in.ipb_rdata);
          // $fdisplay (fd, "IPbus data: %d", intf.ipb_in); // intf.ipb_in.data ??? <- error         
        end
    $fclose(fd);
 
    endtask: write_file
  
  
  
endclass: IPbus_testing_class
 

module IPbus_testing_module;

  initial begin
  
    IPbus_testing_class temp = new(); //Creating handle and object

    //Setters and getters test
    $display("Setting value -> 20");
    temp.set(20);
    $display("Getter called. Got -> %0d",temp.get());
    
    //Void test method from class
    $display("Call void test method from class");
    temp.test();
    
    //Run writing/reading to file method
    $display("Call testing write/read file function");
    temp.test_file_read_write(32);
    
    //Run reading from file method
    $display("Reading registers from file");
    temp.read_file();
    
    //Run writing to file method
    $display("Writing to file");
    temp.write_file();
    
    
  end
  
endmodule: IPbus_testing_module