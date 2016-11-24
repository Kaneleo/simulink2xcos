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

//copies a superblock, but not the included system

function [diagram] = copySubSystem(blockNo, diagram)
    
    global nextFree;
    global subsysList;
    
    superBlock = SUPER_f('define');
    
    superBlock.model.uid = syspath.children(blockNo).attributes(3);
    superBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    [orig, sz] = convertPosSize(blockNo);
    
    superBlock.graphics.orig = orig;
    superBlock.graphics.sz = sz;
    
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
    
    superBlock.model.in = in;
    superBlock.model.in2 = in2;
    superBlock.model.intyp = intyp;
    
    out = []; //same for outports
    out2 = [];
    outtyp = [];
    for i = 1:outPorts
        out = [out; -1];
        out2 = [out2; -2];
        outtyp = [outtyp; -1];
    end
    
    superBlock.model.out = out;
    superBlock.model.out2 = out2;
    superBlock.model.outtyp = outtyp;
    
    diagram.objs(nextFree) = superBlock;
    
    endoffunction(superBlock.model.uid);
    
endfunction
