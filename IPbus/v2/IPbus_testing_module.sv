// Interface declaration


interface IPb_intf( input logic ipb_in,
                    output logic ipb_out);

/***** TO DO -> Virtual interface error ( EXCEPTION_ACCESS_VIOLATION ) *****/  
/*                              
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
*/                         
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
    
  end
  
endmodule: IPbus_testing_module