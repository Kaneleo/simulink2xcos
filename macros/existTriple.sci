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

function [bln]=existTriple()
    
    bln=%f; //standart value for bln
    index=0;
    
    for i = 1:length(branchPath.children)
        if branchPath.children(i).name == 'Branch' //is branch?
            index = index+1;
        end
    end
    
    if index >=3 then //more than three branches?
        bln = %t;
    end
endfunction
