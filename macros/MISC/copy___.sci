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

// to add a type of block, the blocktype has to be added to blockTypeList.sci and to the switch case in parsing.sci, additionally

function [diagram] = copy____(blockNo, diagram)
    
    global nextFree; //load nextFree and make nextFree editable for the function

    ___Block = BLOCK('define'); //define corresponding xcos block
    
    ___Block.model.uid = syspath.children(blockNo).attributes(3); //implement simulink SID
    ___Block.graphics.id = syspath.children(blockNo).attributes(2); //implement simulink label
    
    
    
    [orig, sz] = convertPosSize(blockNo); //get position and size
    
    ___Block.graphics.orig = orig; //implement position
    ___Block.graphics.sz = sz; //implement size
    
    
    
    
    diagram.objs(nextFree) = ___Block; //implement finished block into current diagram at the next free object position
    
    endoffunction(___Block.model.uid); //add block ID (uid/SID) to xcosIDList at the nextFree spot and advance nextFree by one
    
endfunction
