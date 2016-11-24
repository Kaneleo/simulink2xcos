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

//Funktion die den Block ToWorkspace kopiert

function[diagram] = copyToWorkspace(blockNo, diagram)
    
    global nextFree;
    global dueLinks; //links that will have to be created when every block has been
    
    towsBlock = TOWS_c('define');
    
    towsBlock.model.uid = syspath.children(blockNo).attributes(3);
    towsBlock.graphics.id = syspath.children(blockNo).attributes(2);
    towsBlock.graphics.exprs = syspath.children(blockNo).children(3).content;
    
    [orig, sz] = convertPosSize(blockNo);
    
    sz(1) = sz(1)*1.5 //makes the block longer to fit with xcos format
    
    towsBlock.graphics.orig = orig;
    towsBlock.graphics.sz = sz;
    
    clockBlock = copyClock(orig); //TOWS block needs a clock to determine when to save data to the variable, simulink equivalent does not, so a clock is made with every TOWS
    
    bs = scs_m.props.tf/clockBlock.model.rpar.objs(2).model.rpar(1); //buffer size; needs to be timeframe divided by clock interval    
    varN = syspath.children(blockNo).children(4).content; //variable Name for the workspace var
    
    towsBlock.graphics.exprs = [string(bs);varN;"0"];
    towsBlock.model.ipar(1) = bs;
    
    diagram.objs(nextFree) = towsBlock;
    a = nextFree; //saved for the dueLink
    endoffunction(towsBlock.model.uid);
    
    diagram.objs(nextFree) = clockBlock;
    b = nextFree; //saved for the dueLink
    endoffunction('clock'+string(b)); //clock is an additional block, like every SPLIT_f, so thi is to prevent interference of indices
    
    iLink = mlist(['Link', 'xx', 'yy', 'id', 'thick', 'ct', 'from', 'to'], [], [], 'drawlink', [0 0], [5 -1], [b 1 0], [a 1 1]); //link between TOWS and CLOCK is created
    
    dueLinks($+1) = iLink; //and stored for later realization
    
endfunction
