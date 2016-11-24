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

//scope with multiple inputs is copied
//for full comments see copyScope()

function [diagram] = copyMScope(blockNo, diagram, NIP)
    
    global nextFree;
    global dueLinks;
    
    MScopeBlock = CMSCOPE('define');
    
    MScopeBlock.model.uid = syspath.children(blockNo).attributes(3);
    MScopeBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    [w, ind] = xmlAttributeExist('ScopeSpecificationString');
    SSS = syspath.children(blockNo).children(ind).content;
    
    IPS = ''; //inputs port sizes
    yMinString = ''; //y-axis-minimums
    yMaxString = ''; //y-axis-maximums
    rr = ''; //refresh rate
    
    for i = 1:strtod(NIP) //every input is fitted with the same display settings, this can be changed by the user; it might be useful to include the option for UI here - let the user choose wether to accept default values or set his own 
        
        IPS = IPS+'1 '; //should not be messed with,  it is not clear,  if this needs to be adjusted if the input is a vector of 2, 3, etc, becuase it is not needed with the normal CSCOPE
        yMinString = yMinString+'-5 ';
        yMaxString = yMaxString+'5 ';
        rr = rr+string(30)+' ';
        
    end
   
    IPS = part(IPS, 1:$-1); //remove last ' '
    yMinString = part(yMinString, 1:$-1);
    yMaxString = part(yMaxString, 1:$-1);
    rr = part(rr, 1:$-1);
    
    MScopeBlock.graphics.exprs(1) = IPS;
    MScopeBlock.graphics.exprs(6) = yMinString;
    MScopeBlock.graphics.exprs(7) = yMaxString;
    MScopeBlock.graphics.exprs(8) = rr;
    
    MScopeBlock.model.in = ones(strtod(NIP), 1); //e.g. [1;1;1;1]; where NIP is the number of ones
    MScopeBlock.model.in2 = ones(strtod(NIP), 1);
    MScopeBlock.model.intyp = ones(strtod(NIP), 1);
    
    [orig, sz] = convertPosSize(blockNo);
    
    MScopeBlock.graphics.orig = orig;
    MScopeBlock.graphics.sz = sz;
    
    clockBlock = copyClock(orig);
    
    bs = scs_m.props.tf/clockBlock.model.rpar.objs(2).model.rpar(1);
        
    MScopeBlock.graphics.exprs(9) = string(bs);
    
    diagram.objs(nextFree) = MScopeBlock;
    a = nextFree;
    endoffunction(MScopeBlock.model.uid);
        
    diagram.objs(nextFree) = clockBlock;
    b = nextFree;
    endoffunction('clock'+string(b));
        
    iLink = mlist(['Link', 'xx', 'yy', 'id', 'thick', 'ct', 'from', 'to'], [], [], 'drawlink', [0 0], [5 -1], [b 1 0], [a 1 1]);
    
    dueLinks($+1) = iLink;
    
endfunction
