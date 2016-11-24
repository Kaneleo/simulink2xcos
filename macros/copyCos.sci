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

//copies a cos block

function [diagram] = copyCos(blockNo, diagram)
    
    global nextFree;
    
    cosBlock = COSBLK_f('define');
    
    cosBlock.model.uid = syspath.children(blockNo).attributes(3);
    cosBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    [orig, sz] = convertPosSize(blockNo);
    
    cosBlock.graphics.orig = orig;
    cosBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = cosBlock;
    
    endoffunction(cosBlock.model.uid);
    
endfunction
