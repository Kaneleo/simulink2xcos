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

//scope is copied

function [diagram] = copyScope(blockNo, diagram)
    
    global nextFree;
    global dueLinks;
    
    [w, ind] = xmlAttributeExist('NumInputPorts'); //number of input ports
    NIP = syspath.children(blockNo).children(ind).content;
    
    if strtod(NIP)>1 then //CSCOPE can only handle one input port, if there are more than one, CMSCOPE has to be used
        diagram = copyMScope(blockNo, diagram, NIP);
    else //if only one input port exists,  the CSCOPE is defined
        
        scopeBlock = CSCOPE('define');
        scopeBlock.model.uid = syspath.children(blockNo).attributes(3);
        scopeBlock.graphics.id = syspath.children(blockNo).attributes(2);
        
        [orig, sz] = convertPosSize(blockNo);
        scopeBlock.graphics.orig = orig;
        scopeBlock.graphics.sz = sz;
        
        clockBlock = copyClock(orig); //clock needed for data recording interval
        
        //Der entsprechend benötigte Buffer wird berechnet
    
        bs = scs_m.props.tf/clockBlock.model.rpar.objs(2).model.rpar(1); //buffer is calculated by ratio of simulation timeframe and clock interval
        
        scopeBlock.graphics.exprs(8) = string(bs);
    
        diagram.objs(nextFree) = scopeBlock;
        a = nextFree;
        endoffunction(scopeBlock.model.uid);
        
        diagram.objs(nextFree) = clockBlock;
        b = nextFree;
        endoffunction('clock'+string(b));
        
        iLink = mlist(['Link', 'xx', 'yy', 'id', 'thick', 'ct', 'from', 'to'], [], [], 'drawlink', [0 0], [5 -1], [b 1 0], [a 1 1]); //dueLink is created and saved to be made after every block is copied
        dueLinks($+1) = iLink;
        
    end
endfunction
