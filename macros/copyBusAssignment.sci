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

function [diagram] = copyBusAssignment(blockNo, diagram)
    
    global nextFree;
    
    busassignment = SUPER_f('define');
    busassignment.model.uid = syspath.children(blockNo).attributes(3);
    busassignment.graphics.id = syspath.children(blockNo).attributes(2);
    
    [orig, sz] = convertPosSize(blockNo);
    
    busassignment.graphics.orig = orig;
    busassignment.graphics.sz = sz;
    
    [w, ind] = xmlAttributeExist('Ports'); //input and output ports
    ports = syspath.children(blockNo).children(ind).content;
    
    ports = part(ports, 2:length(ports)); //string manipulation
    cpos = strindex(ports, ', ');
    inPorts = strtod(part(ports, 1:cpos-1));
    outPorts = strtod(part(ports, cpos+1:length(ports)));
    
    in = []; //inport defining attributes are written
    in2 = [];
    intyp = [];
    for i = 1:inPorts
        in = [in; -1];
        in2 = [in2; -2];
        intyp = [intyp; -1];
    end
    
    busassignment.model.in = in;
    busassignment.model.in2 = in2;
    busassignment.model.intyp = intyp;
    
    out = []; //same for outports
    out2 = [];
    outtyp = [];
    for i = 1:outPorts
        out = [out; -1];
        out2 = [out2; -2];
        outtyp = [outtyp; -1];
    end
    
    busassignment.model.out = out;
    busassignment.model.out2 = out2;
    busassignment.model.outtyp = outtyp;
    
    [busassignment.model.rpar, vectSize] = busAssignment(busassignment.model.uid); //w => busassignment.model.out
//    busassignment.model.in(1) = 1;
    
    busassignment.model.in(1) = vectSize;
    busassignment.model.out = vectSize;
    
    diagram.objs(nextFree) = busassignment;
    endoffunction(busassignment.model.uid);
    
endfunction
