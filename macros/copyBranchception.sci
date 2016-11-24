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

//function makes SPLIT_f block and finds the corresponding links

function [diagram, branchID] = copyBranchception(branchPath, srcBranch, diagram)
    
    global nextFree;
    global branchIDList;
    global xcosIDList;
    
    coodinates = [];
    
    srcID = srcBranch.ID; //source link and pos data
    srcIDPort = srcBranch.port;
    srcOrig = srcBranch.orig;
    
    for i = 1:length(branchPath.children)
        if branchPath.children(i).attributes(1) == 'Points' //vector from src to object to be made
            n = i;
            break;
        end
    end
    
    
    if n ~= 0 then //should be true
        
        orig = branchPath.children(n).content; //string manipulation and interpretation for SPLIT_f coordinates
        orig = part(orig, 2:$-1);
        n = length(orig);
        temp = strchr(orig, ',');
        m = length(temp);
        strdiff = n - m;
        orig = strtod(part(orig, 1:strdiff));
        temp = part(temp, 2:$);
        temp1 = strchr(string(orig), ',');
        n = length(temp);
        m = length(temp1);
        strdiff = n - m;
        orig = [orig, strtod(part(temp, 1:strdiff)) * -1];
        orig = orig + srcOrig;
        
    else
        
        messagebox(string(whereami), 'error'); //either broken XML-file or programming not perfect
        
    end
    
    branchBlock = SPLIT_f('define');
    
    branchBlock.model.uid = 'split'+string(nextFree); //split as id prefix to avoid multiple matching IDs
    branchBlock.graphics.sz = [7, 7];
    branchBlock.graphics.orig = orig;
    
    diagram.objs(nextFree) = branchBlock;
    branchID = 'split_f'+string(nextFree);
    
    nextFree = nextFree+1;
    srcBranch.ID = branchID; //make the created Block the src block for the following recursion
    srcBranch.orig = orig;
    srcBranch.line = branchPath.line
    
    xcosIDList(counter)(counter1)($+1) = string(branchID); //register in xIDL at position matching nextFree, but with modified ID
    
    [diagram, branchDst] = existBranch(branchPath, branchDst, diagram, srcBranch); //recursion
    
    dsts = list();
    n = 1
    
    for i = 1:length(branchDst)
        if branchDst(i).srcLine =  = srcBranch.line //does this destination belong to the SPLIT_f block created in this function?
            dsts(n) = branchDst(i);
            n = n + 1;
        end
    end
    
    outID = srcID;
    outIDPort = srcIDPort;
    To1 = dsts(1).To;
    To1Port = dsts(1).ToPort;
    To2 = dsts(2).To;
    To2Port = dsts(2).ToPort;
    branchIDList($+1) = [branchID, string(outID), string(outIDPort), To1, To1Port, To2, To2Port];
    
endfunction
