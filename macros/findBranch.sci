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

//function saves every line node that includes a branch node

function [branchList] = findBranch()

    global xmlDoc;
    
    [w, lineBranchEntryPosition]=findLine(); //every Line is loaded
    branchList=[];
    
    for i=1:length(lineBranchEntryPosition)
        
        n=syspath.children(lineBranchEntryPosition(i)).children.size
        
        for m=1:n
            
            if syspath.children(lineBranchEntryPosition(i)).children(m).name=='Branch' then //subnode is branch?
                
                if ~isPart(branchList,lineBranchEntryPosition(i)) then //line is not already on branchList?
                    
                    branchList=[branchList,lineBranchEntryPosition(i)]; //add to branchList
                    
                end
                
            end
            
        end
        
    end
    
endfunction
