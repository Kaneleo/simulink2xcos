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

//checks if string is the value of the name attribute of all nodes of a block

function [bln,ind]=xmlAttributeExist(name)
    
    n=length(syspath.children(blockNo).children);
    atts=[];
    
    for i=1:n
        
        atts=[atts,syspath.children(blockNo).children(i).attributes(1)];
        
    end
    
    bln=isPart(atts, name);
    
    if bln then
        ind=find(name==atts);
    end
    
endfunction
