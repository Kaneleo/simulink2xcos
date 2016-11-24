//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) - 2016 – German Aerospace Center – Nils Leimbach
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//

//parses every subsystem in a supersystem, calls the next level of the function and implements the systems in the superblock

function [scs_m] = subsysParsing(scs_m, layer, srcBlockLine, srcBlockDiagInd)
    
    global nextFree;
    global syspath;
    
    layer = layer+1;  //recieved layer is advanced by one, becuase the current simulation layer is one deeper
    
    for i = 1:length(subsyspath(layer-1)) //every subsystem on the cuurent layer; layer-1 because subsyspath begins at 1 although it technically  starts on the second layer
        
        if subsyspath(layer-1)(i)(3) == srcBlockLine //diagram is only made if the supersystem of the subsystem is the same as the one which was edited in the function calling this one; short: system is only created if it belongs in the block above
            
            nextFree = 1;
            diagram = scicos_diagram();
            syspath = subsyspath(layer-1)(i)(2);
            diagram = parsing(diagram, layer, i); //layer and index of the system are passsed down to complete xcosIDList
            
            if length(subsyspath)>layer-1 //this ensures that as long as there are more layers of subsystems, the function recalls itself to process down to the deepest subsystem
                diagram = subsysParsing(diagram, layer, subsyspath(layer-1)(i)(2).line, i); //see function parameters for purpose
            end
            
//just like in subsysParsingPrep the source Superblock xcosID is identified to make insertion of diagram possible
            
            for j = 1:length(xcosIDList(layer-1)(srcBlockDiagInd))
                if xcosIDList(layer-1)(srcBlockDiagInd)(j) == subsyspath(layer-1)(i)(1).attributes(3)
                    n = j;
                    break;
                end
            end
            
            scs_m.objs(n).model.rpar.objs = diagram.objs;
        
        end
    end
endfunction
