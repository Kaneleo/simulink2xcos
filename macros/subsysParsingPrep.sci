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

//function calls the subparsing function, starting with the first layer, then proceeding with the next layer, but in a recursive way instead of every layer at a time

function [scs_m] = subsysParsingPrep(scs_m)
    
    global nextFree;
    global syspath; //test
    
    for i = 1:length(subsyspath(1)) //every subsystem of the first sublayer is processed
        
        nextFree = 1;
        diagram = scicos_diagram();
        syspath = subsyspath(1)(i)(2); //syspath is the system in the corresponding Superblock
        diagram = parsing(diagram, 2, i); //layer is set to 2, because it will be the first layer after the main layer; i is an identifier for the systems on the same layer, it is also corresponding to position of a subsystem in subsyspath
        
        for j = 1:length(xcosIDList(1)(1)) //in the list of blocks on the main layer
            if xcosIDList(1)(1)(j) == string(subsyspath(1)(i)(1).attributes(3)) //the current superblock is looked up
                n = j; //and saved (the xcosID), so that the diagram created can later be inserted into said superblock
                break;
            end
        end
        
        srcBlockLine = subsyspath(1)(i)(2).line; //line of the system is saved
        
        if length(subsyspath)>1 //more than one layer of subsystems?
        
            diagram = subsysParsing(diagram, 2, srcBlockLine, i); //work on the next layer
        
        end
        
        scs_m.objs(n).model.rpar.objs = diagram.objs; //insert the system into the superblock previously identified
        
    end
    
endfunction
