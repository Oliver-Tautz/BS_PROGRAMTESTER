#!/usr/bin/env lua

require("csv_reader")

options = {program_path = "~/Documents/BS21/subs/C/todrees/todrees_schaltjahr", vector_csv = "test_vec.csv" ,
           vector_name = "schaltjahr", epsilon_token = "epsilon", use_stdin = false, delimiter=';'}


out_delim_str = "-------------------------------------------------------------------------------"

-- fieldnames: 
--
-- vector_name: which program does this line belong to?
-- vector_x   : input for program
-- vector_y   : expected outpur opf program


local csv_options = {filename = options.vector_csv, delimiter=options.delimiter,header=true}
local vector_lines = csv_file(csv_options)

for index,line in pairs(vector_lines) do
    if  line.vector_name == options.vector_name then
        
        --print line 
        print(out_delim_str)        
        -- print input 
        print("input\t=","`" .. line.vector_x .. "`")
        
        local input_args = line.vector_x

        -- replace epsilon by ""
        if input_args == options.epsilon_token then
            input_args = ""  
        end

        -- run program and get output. redirect stderr to stdout
        local program_out_file = io.popen(options.program_path .. " " .. input_args .. " 2>&1")
        local out              = program_out_file:read('a')
        program_out_file:close()

        
        print("output\t=\n",out)

        print("expected output\t=\n",line.vector_y)





    end    
end

