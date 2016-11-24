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

function [clockBlock] = copyClock(orig)
    
    if layer > 1 & clockReminder == 0 then
        messagebox(['A block that extracts data from the simulation (eg. CSCOPE or TOWS) has been created on a subdiagram on layer ' + string(layer) + '.', 'This type of block only works on the topmost layer.', 'Please route this block to the first layer manually or delete it, so that the simulation will work.'], 'Data extraction on subsystem layer', 'warning', 'modal');
        clockReminder = 1;
    end
    
    orig(2) = orig(2)+sz(2)+30; //30 above the parent block plus the height of the parent block
    orig(1) = orig(1)+sz(1)*0.5-20 //middle of the parent block and middle of the CLOCK
    
    clockBlock = CLOCK_c('define');
    
    clockBlock.graphics.orig = orig;
    clockBlock.graphics.sz = [40, 40];
    
    clockBlock.model.rpar.objs(2).model.rpar(1) = evstr(x_mdialog('Timesteps', 'Timesteps', '0.1')); //user input for timesteps of clocks, default is 0.1
    
endfunction
