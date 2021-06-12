#!/usr/bin/env lua

--made by Oliver Tautz 12.06.2021


local argparse = require "argparse"

local parser = argparse("test_program", "Test a program on multiple inputs with epected outputs!")
parser:argument("program", "path of program to test. Can be absolute or relative.")
parser:argument("vector_name", "name of the vector_name field.")
parser:argument("vector_file", "file with test vector(s). Should be csv with \nvector_name, vector_x and vector_y fieldnames in header", "test_vec.csv")
parser:option("--epsilon","set epsilon token to a different string.", "epsilon")
parser:option("--delimiter","use differenmt delimiter for your csv", ";")
parser:flag("--use-stdin", "pipe input to stdin for program to use instead of argv")


local args = parser:parse()




require("csv_reader")



local options = {program_path = args.program, vector_csv = args.vector_file ,
           vector_name = args.vector_name, epsilon_token = args.epsilon, use_stdin = args.use_stdin, delimiter=args.delimiter}


local out_delim_str = "-------------------------------------------------------------------------------"

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

        
        print("output\t=\n\n" .. out)

        print("\nexpected output\t=\n")


        -- this is pretty dirty. How to do it in lua?!
        os.execute("echo -e " .."\"".. line.vector_y .. "\"")




    end    
end

