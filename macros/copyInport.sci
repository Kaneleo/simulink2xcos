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

//copies an inport

function [diagram] = copyInport(blockNo, diagram)
    
    global nextFree;
    
    inBlock = IN_f('define');
    
    inBlock.model.uid = syspath.children(blockNo).attributes(3);
    inBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    if xmlAttributeExist('Port') then //only exists if not default value
        [w, ind] = xmlAttributeExist('Port');
        port = syspath.children(blockNo).children(ind).content;
    else //default value
        port = '1';
    end
    
    inBlock.graphics.exprs = port;
    inBlock.model.ipar = strtod(port);
    
    [orig, sz] = convertPosSize(blockNo);
    
    inBlock.graphics.orig = orig;
    inBlock.graphics.sz = sz;

    diagram.objs(nextFree) = inBlock;
    endoffunction(inBlock.model.uid);
    
endfunction
