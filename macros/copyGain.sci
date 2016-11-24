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

//copies gain block

function [diagram] = copyGain(blockNo, diagram)
    
    global nextFree;
    
    gainBlock = GAINBLK_f('define');
    
    gainBlock.model.uid = syspath.children(blockNo).attributes(3);
    gainBlockID = syspath.children(blockNo).attributes(2);
    gainBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    gain = '1'; //default value
    if xmlAttributeExist('Gain') then //if other value is presented
        [w, ind] = xmlAttributeExist('Gain');
        gain = syspath.children(blockNo).children(ind).content
    end
    gainBlock.graphics.exprs = gain;
    if isnum(gain)
        gainBlock.model.rpar = strtod(gain);
    else
        gainBlock.model.rpar = gain;
        try
            varCont = evstr(gain);
            n = size(varCont);
            n = n(2);
            gainBlock.model.out = n;
        catch
        end
    end
    
    
//    gainBlock.model.out = -1;
    
    if syspath.children(blockNo).children(3).content == "on" then
        
        gainBlock.graphics.style = "GAINBLK_f;mirror=true"
//        gainBlock.graphics.in_style = "ExplicitInputPort;align=right;verticalAlign=middle;spacing=10.0;rotation=180"; //funktioniert nicht siehe scilab bug #14768 http://bugzilla.scilab.org/show_bug.cgi?id = 14768
//        gainBlock.graphics.out_style = "ExplicitOutputPort;align=left;verticalAlign=middle;spacing=10.0;rotation=180"; //s.O.
        gainBlock.graphics.flip = %f;
        
        
    end
    
    [orig, sz] = convertPosSize(blockNo);
    
    gainBlock.graphics.orig = orig;
    gainBlock.graphics.sz = sz;
    
    diagram.objs(nextFree) = gainBlock;
    
    endoffunction(gainBlock.model.uid);
    
endfunction
