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

//copies a sin block

function [diagram] = copySin(blockNo, diagram)
    
    global nextFree;
    
    sinBlock = SINBLK_f('define');
    
    sinBlock.model.uid = syspath.children(blockNo).attributes(3);
    sinBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    [orig, sz] = convertPosSize(blockNo);
    
    sinBlock.graphics.orig = orig;
    sinBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = sinBlock;
    
    endoffunction(sinBlock.model.uid);
    
endfunction
