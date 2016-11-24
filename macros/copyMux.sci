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

//copies a multiplexer

function [diagram] = copyMux(blockNo, diagram)
    
    global nextFree;
    
    muxBlock = MUX('define');
    
    muxBlock.model.uid = syspath.children(blockNo).attributes(3);
    if ~syspath.children(blockNo).children(4).content == 'off' then //should the label be shown?
        muxBlock.graphics.id = syspath.children(blockNo).attributes(2);
    end
    
    if xmlAttributeExist('Inputs') then
        [w, ind] = xmlAttributeExist('Inputs');
        muxBlock.graphics.exprs = syspath.children(blockNo).children(ind).content;
        inputs = syspath.children(blockNo).children(ind).content;
    else
        muxBlock.graphics.exprs = '4';
        inputs = '4';
    end
    
    in = [];
    n = strtod(inputs);
    for i = 1:n
        in = [in;i*-1]; //vector entry postition (negative)
    end
    muxBlock.model.in = in;
    muxBlock.model.ipar = strtod(inputs);
    muxBlock.model.out = strtod(inputs);
    
    [orig, sz] = convertPosSize(blockNo);
    
    orig(2) = orig(2)-sz(2); //this tries to counteract the siye position direction issue, ok, but not perfect
    
    muxBlock.graphics.orig = orig;
    muxBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = muxBlock;
    endoffunction(muxBlock.model.uid);
    
endfunction
