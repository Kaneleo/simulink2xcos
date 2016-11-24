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

//function finds line nodes with or without branch subnodes

function [lineEntryPosition, lineBranchEntryPosition] = findLine()
    
    global xmlDoc;
    
    lineBranchEntryPosition = find(syspath.children.name == 'Line'); //every Line node is saved
    lineEntryPosition = lineBranchEntryPosition;
    
    for i=1:length(lineEntryPosition)
        
        if isPart(syspath.children(lineEntryPosition(i)).children.name, 'Branch') //branch in line?
            
            lineEntryPosition(i) = [-1]; //change list entry to -1
            
        end
        
    end
    
    i = 1;
    n = length(lineEntryPosition)
    
    while i<=length(lineEntryPosition)
        
        if lineEntryPosition(i) == -1
            
            lineEntryPosition(i) = []; //delete list if branch included
            
        else
            
            i = i+1;
            
        end
        
        n = length(lineEntryPosition);
        
    end
    
    
endfunction
