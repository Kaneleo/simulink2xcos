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

//copies an integral block

function [diagram] = copyIntegral(blockNo, diagram)
    
    global nextFree;
    global xmlDoc;
    global scs_m;
    
    integratorBlock = INTEGRAL_m('define');
        
    initialCondition = "0"; //this is the default default in simulink
    if xmlAttributeExist('InitialCondition') then //if initial condition is an XML-node, it will replace the default
        
        initialCondition = syspath.children(blockNo).children(4).content;
        
    end
    
    integratorBlock.model.uid = syspath.children(blockNo).attributes(3);
    integratorBlock.graphics.id = syspath.children(blockNo).attributes(2);
    integratorBlock.graphics.exprs = [initialCondition, "0", "0", "1", "-1"]; //doubleclick integrator block to see what these values mean
    
    [orig, sz] = convertPosSize(blockNo);
    
    integratorBlock.graphics.orig = orig;
    integratorBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = integratorBlock;
    
    endoffunction(integratorBlock.model.uid);

endfunction
