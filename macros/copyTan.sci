//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) - 2016 � German Aerospace Center � Nils Leimbach
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//

//copies a tan block

function [diagram] = copyTan(blockNo, diagram)
    
    global nextFree;
    
    tanBlock = TANBLK_f('define');
    
    tanBlock.model.uid = syspath.children(blockNo).attributes(3);
    tanBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    [orig, sz] = convertPosSize(blockNo);
    
    tanBlock.graphics.orig = orig;
    tanBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = tanBlock;
    
    endoffunction(tanBlock.model.uid);
    
endfunction
