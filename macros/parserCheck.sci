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

//every Block of a system is mwatched with the list of supported blocks, and added to one of the two output lists respectively

function [nonParseList, ParseList] = parserCheck()
    
    global xmlDoc;
    
    nonParseList=[];
    ParseList=[];
    n=find(syspath.children.name=='Block'); //every Block
    bTL=blockTypeList(); //import of supported Blocks
    
    for i=1:length(n)
        
        if isPart(bTL, syspath.children(n(i)).attributes(1)) //Block supported?
            
            ParseList=[ParseList,n(i)];
            
        else
            
            nonParseList=[nonParseList,n(i)];
            
        end
        
    end
    
endfunction
