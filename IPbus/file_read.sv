module file_read;
  int 	 fd; 			// file descriptor
  string line; 			// String value read from the file

  initial begin

    // 1. Write "w"
    fd = $fopen ("D:/Vivado/project_3/plik.txt", "w");

        for (int i = 0; i < 10; i++) begin
           $fdisplay (fd, "Linia = %0d", i);
        end

    $fclose(fd);


    // 2. Read "r"
    fd = $fopen ("D:/Vivado/project_3/plik.txt", "r");

    // fgets -> save string in "line" variable
    $fgets(line, fd);
    $display ("Przeczytano : %s", line);

    // Next line
    $fgets(line, fd);
    $display ("Przeczytano : %s", line);

    $fclose(fd);
  end
endmodule