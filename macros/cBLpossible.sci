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

//checks wether a SPLIT_f can be connected to all three corresponding blocks

function [bln] = cBLpossible(blID)
    
    global xcosIDList;

    xcosIDs = [];
    for i = 2:length(branchIDList)
        
        xcosIDs = [xcosIDs, branchIDList(i)(1)]; //copies branchIDs additionally to the xcosIDs
        
    end
    
    xIDLcc = [];
    for i = 1:length(xcosIDList(counter)(counter1))
        
        xIDLcc($+1) = xcosIDList(counter)(counter1)(i);
        
    end
    
    n = find(xcosIDs == blID); //ID to xcosID
    if isPart(xIDLcc, string(branchIDList(n+1)(2)))|isPart(xcosIDs, string(branchIDList(n+1)(2))) then //either part of xIDL or branchIDL
        
        if isPart(xIDLcc, string(branchIDList(n+1)(4)))|isPart(xcosIDs, string(branchIDList(n+1)(4))) then
            
            if isPart(xIDLcc, string(branchIDList(n+1)(6)))|isPart(xcosIDs, string(branchIDList(n+1)(6))) then
                
                bln = %t; //every to be connected block exists
                
            else
                
                bln = %f;
                
            end
            
        else
            
            bln = %f;
            
        end
        
    else
        
        bln = %f;
        
    end
    
endfunction
