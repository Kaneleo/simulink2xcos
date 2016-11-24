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

//links a SPLIT_f to its corresponding blocks

function [diagram] = copyBranchLine(blID, diagram)
    
    global nextFree;
    
    xcosIDs = [];
    
    for i = 2:length(branchIDList)
        
        xcosIDs = [xcosIDs, branchIDList(i)(1)]; //xcosIDs of SPLIT_fs are copied
        
    end
    
    n = find(blID == xcosIDs); //position of the current branch in the branchIDList
    n = n+1; //first line of branchIDList is text
    
    xIDLcc = [];
    for i = 1:length(xcosIDList(counter)(counter1))
        xIDLcc($+1) = xcosIDList(counter)(counter1)(i); //xcosIDs of current layer and index
    end
    
    ID = branchIDList(n)(1); //string manipulation and data extraction
    xcosID = find(ID == xIDLcc)
    outID = branchIDList(n)(2);
    xcosOutID = find(outID == xIDLcc);
    outIDPort = strtod(branchIDList(n)(3));
    To1 = branchIDList(n)(4);
    if typeof(To1) == 'string' then
        xcosTo1 = find(To1 == xIDLcc)
    else
        xcosTo1 = find(string(To1) == xIDLcc);
    end
    To1Port = strtod(branchIDList(n)(5));
    To2 = branchIDList(n)(6);
    if typeof(To2) == 'string' then
        xcosTo2 = find(To2 == xIDLcc)
    else
        xcosTo2 = find(string(To2) == xIDLcc);
    end
    To2Port = strtod(branchIDList(n)(7));
    
    a = mlist('');
    a = mlist(['Link', 'xx', 'yy', 'id', 'thick', 'ct', 'from', 'to'], [], [], 'drawlink', [0 0], [1 1], [xcosOutID, outIDPort, 0], [xcosID, 1, 1]); //the links are created and filled with the extracted data, same possibility as in copyLine() in regards to link creation
    
    b = mlist('');
    b = mlist(['Link', 'xx', 'yy', 'id', 'thick', 'ct', 'from', 'to'], [], [], 'drawlink', [0 0], [1 1], [xcosID, 1, 0], [xcosTo1, To1Port, 1]);
    
    c = mlist('');
    c = mlist(['Link', 'xx', 'yy', 'id', 'thick', 'ct', 'from', 'to'], [], [], 'drawlink', [0 0], [1 1], [xcosID, 2, 0], [xcosTo2, To2Port, 1]);
    
    if ~existLine(a) //check if the link exists already; if so it is not copied into the diagram
       diagram.objs(nextFree) = a;
        nextFree = nextFree+1
    end
    if ~existLine(b) then
      diagram.objs(nextFree) = b;
        nextFree = nextFree+1
    end
    if ~existLine(c) then
        diagram.objs(nextFree) = c;
        nextFree = nextFree+1
    end
    
endfunction
