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

//selects further function if special case, copies trig block otherwise

function [diagram] = copyTrigFunc(blockNo, diagram, funct)
    
    global nextFree;
    
    if funct == 'atan2' | funct == 'sincos' | funct == 'cos + jsin' then //the xcos trig block does not know these cases, so another function is needed
        diagram = copyTrigFuncSpecial(blockNo, diagram, funct);
    else
        trigBlock = TrigFun('define');
        
        trigBlock.model.uid = syspath.children(blockNo).attributes(3);
        trigBlock.graphics.id = syspath.children(blockNo).attributes(2);
        
        trigBlock.graphics.exprs = funct; //the funct statement contains string like 'asin' or 'tanh', and tells the block what operation to perform
        
        [orig, sz] = convertPosSize(blockNo);
    
        trigBlock.graphics.orig = orig;
        trigBlock.graphics.sz = sz;
        
        diagram.objs(nextFree) = trigBlock;
        
        endoffunction(trigBlock.model.uid);
    end
endfunction
