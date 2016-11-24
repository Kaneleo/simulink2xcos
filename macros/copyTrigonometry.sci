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

//selects the appropriate function to handle the simulink trig function

function [diagram] = copyTrigonometry(blockNo, diagram)
    
    global nextFree;
    
    if xmlAttributeExist('Operator') then
        [w, ind] = xmlAttributeExist('Operator');
        funct = syspath.children(blockNo).children(ind).content;
    else //default value
        funct = 'sin';
    end
    
    select funct
    case 'sin'
        diagram = copySin(blockNo, diagram);
    case 'cos'
        diagram = copyCos(blockNo, diagram);
    case 'tan'
        diagram = copyTan(blockNo, diagram);
    else 
        diagram = copyTrigFunc(blockNo, diagram, funct); //special function to handle not directly implemented cases
    end
    
endfunction
