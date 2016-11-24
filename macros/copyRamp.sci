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

//copies a ramp

function [diagram] = copyRamp(blockNo, diagram)
    
    global nextFree;
    
    rampBlock = RAMP('define');
    
    rampBlock.model.uid = syspath.children(blockNo).attributes(3);
    rampBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    n = find(syspath.children(blockNo).children.name == 'InstanceData'); //all the data of the ramp is in the node InstanceData of the Reference block
    
    InstData = [];
    for i = 1:length(syspath.children(blockNo).children(n).children)
        InstData($+1) = syspath.children(blockNo).children(n).children(i).attributes(1);
    end
    
    m = find(InstData == 'slope'); //selfexplanitory, really
    slope = '';
    slope = syspath.children(blockNo).children(n).children(m).content;
    m = find(InstData == 'start');
    start = syspath.children(blockNo).children(n).children(m).content;
    m = find(InstData == 'X0');
    X0 = syspath.children(blockNo).children(n).children(m).content;
    
    rampBlock.model.rpar = [strtod(slope);strtod(start);strtod(X0)];
    rampBlock.graphics.exprs = [slope;start;X0];
    
    [orig, sz] = convertPosSize(blockNo);
    
    rampBlock.graphics.orig = orig;
    rampBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = rampBlock;
    
    endoffunction(rampBlock.model.uid);
    
endfunction
