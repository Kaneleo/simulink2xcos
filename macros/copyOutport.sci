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

//copies outport, see copyInport() for comments

function [diagram] = copyOutport(blockNo, diagram)
    
    global nextFree;
    
    outBlock = OUT_f('define');
    
    outBlock.model.uid = syspath.children(blockNo).attributes(3);
    outBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    if xmlAttributeExist('Port') then
        [w, ind] = xmlAttributeExist('Port');
        port = syspath.children(blockNo).children(ind).content;
    else
        port = '1';
    end
    
    outBlock.graphics.exprs = port;
    outBlock.model.ipar = strtod(port);
    
    [orig, sz] = convertPosSize(blockNo);
    
    outBlock.graphics.orig = orig;
    outBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = outBlock;
    endoffunction(outBlock.model.uid);
    
endfunction
