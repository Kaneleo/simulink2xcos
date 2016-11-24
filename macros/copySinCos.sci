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

//creates sincos block from preset

function [diagram] = copySinCos(blockNo, diagram)
    
    global nextFree;
    load(filepath + 'MISC\sincos.sod', 'sinCosBlock'); //loads a preconfigured Superblock SinCos
    
    sinCosBlock.model.uid = syspath.children(blockNo).attributes(3);
    sinCosBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    [orig, sz] = convertPosSize(blockNo);
    
    sinCosBlock.graphics.orig = orig;
    sinCosBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = sinCosBlock;
    
    endoffunction(sinCosBlock.model.uid);
    
endfunction
