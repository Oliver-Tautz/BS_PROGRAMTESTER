-- made by Oliver Tautz 12.01.2021
-- very simple csv parser. Does not handle empty fields (yet ...)




-- warning! Does not support Empty fields!
function split(str,seperator)
    local len = 0
    local seperated = {}
    for match in string.gmatch(str,"[^"..seperator.."]+") do
        table.insert(seperated,match)
        len = len+1
    end
    --seperated["n"]=len
    return seperated
end


function csv_file(csv_options)
    if not csv_options then
        csv_options={filename="test_vec.csv",delimiter=";",header=true}
    end 

    io.input(csv_options.filename)
    
    local lines = {}
    local header 
    -- split first line to get col names and stor in header
    if csv_options.header then
        line = io.read("l")
        header = split(line,csv_options.delimiter)
        lines.header=header
    end

    local line_number = 0
    local line =io.read("l")

    while line do
        line = split(line,csv_options.delimiter)
        if csv_options.header then
            linetab = {}
            for k, v in pairs(header) do
                linetab[v]=line[k]
            end

            line=linetab    
        end
        
        lines[line_number]=line
        line_number=line_number+1
        line=io.read("l")
    end
        
    return lines    
end
