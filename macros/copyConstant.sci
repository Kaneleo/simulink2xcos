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

//copies a constant block

function [diagram] = copyConstant(blockNo, diagram)
    
    global nextFree;
    
    constBlock = CONST_m('define');
    
    constBlock.model.uid = syspath.children(blockNo).attributes(3);
    constBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    const = []
    for i = 1:length(syspath.children(blockNo).children) //find the node with the constant value, name of the node differs from version to version
        if syspath.children(blockNo).children(i).attributes(1) == 'Constant'
            const = syspath.children(blockNo).children(i).content;
            break; //stop search if found
        end
        if syspath.children(blockNo).children(i).attributes(1) == 'Value'
            const = syspath.children(blockNo).children(i).content;
            break; //see line 14
        end
    end
    if const == [] then //default value in simulink, if const is default value, the node with the value is not in the XML-file
        const = '1'; //the default value can be changed in simulink, this assumes that it wasn't, reading the defaults is a todo
    end
    
    constBlock.graphics.exprs = const;
    constBlock.model.rpar = strtod(const);
    
    [orig, sz] = convertPosSize(blockNo);
    
    constBlock.graphics.orig = orig;
    constBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = constBlock;
    
    endoffunction(constBlock.model.uid);
    
endfunction
