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

//copy goto block

function [diagram] = copyGoto(blockNo, diagram)
    
    global nextFree;
    
    gotoBlock = GOTO('define');
    
    gotoBlock.model.uid = syspath.children(blockNo).attributes(3);
    gotoBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    if xmlAttributeExist('GotoTag') then
        [w, ind] = xmlAttributeExist('GotoTag');
        gotoTag = syspath.children(blockNo).children(ind).content;
    else //default value
        gotoTag = 'A';
    end
    
    if xmlAttributeExist('TagVisibility')
        [w, ind] = xmlAttributeExist('TagVisibility');
        select syspath.children(blockNo).children(ind).content
        case 'global'
            tagVis = 3;
        case 'scoped'
            tagVis = 2;
        end
    else //local
        tagVis = 1;
    end
    
    gotoBlock.graphics.exprs = [string(gotoTag);string(tagVis)];
    gotoBlock.model.ipar = tagVis;
    gotoBlock.model.opar = list(string(gotoTag));
    
    [orig, sz] = convertPosSize(blockNo);
    
    gotoBlock.graphics.orig = orig;
    gotoBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = gotoBlock;
    
    endoffunction(gotoBlock.model.uid);
endfunction
