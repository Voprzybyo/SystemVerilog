//.svh file with class
`include "IPbus_testing_class.svh"

// Test file write/read
program write_read_file_test(input IPbus_testing_class tmp);
initial
begin : main_testing_block

for (int i = 0; i < 5; i++)
begin  
        $display (":)");
        tmp.test_file_read_write(54); 
end
end: main_testing_block
endprogram
