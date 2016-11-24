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

//see copyGoto() for comments

function[diagram] = copyFrom(blockNo, diagram)
    
    global nextFree;
    
    fromBlock = FROM('define');
    
    fromBlock.model.uid = syspath.children(blockNo).attributes(3);
    fromBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    if xmlAttributeExist('GotoTag') then
        [w, ind]  =  xmlAttributeExist('GotoTag');
        gotoTag  =  syspath.children(blockNo).children(ind).content;
    else
        gotoTag  =  'A';
    end
    
    fromBlock.graphics.exprs = gotoTag;
    fromBlock.model.opar = list(gotoTag);
    
    [orig, sz] = convertPosSize(blockNo);
    
    fromBlock.graphics.orig = orig;
    fromBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = fromBlock;
    
    endoffunction(fromBlock.model.uid);
    
endfunction
