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

//function warns user that blocks are present that are not supported
//user can decide wether to abort or continue without copying the non supported blocks

function [btn] = parserMsg()
    
    nPLstring=[];
    
    if ~isempty(nonParseList) then //nonParseList has elements?
        
        for i=1:length(nonParseList)
            
            n=nonParseList(i);
            
            if ~isPart(nPLstring,syspath.children(n).attributes(1)) then //not already in nPLstring
                
                nPLstring=[nPLstring,syspath.children(n).attributes(1)]; //add name attribute to nPLstring
                
            end
            
        end
        
        List=string('');
        sz=size(nPLstring);
        sz=sz(2);
        
        for i=1:sz-1
            
            List=[List+string(nPLstring(i))+','+' '+' ']; //manipulation to front-end string
            
        end
        
        List=[List+string(nPLstring(sz))];
        
        btn=messagebox(['The following blocks can not be parsed','as they are not implemented in the script yet:','',+string(List),'','Do you want to parse without these blocks?'],"Non-parsable blocks detected!","warning",['Yes','No'],'modal');
        
    else
        
        btn=1; //nonParseList is empty, so every block can be copied
        
    end
    
endfunction
