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

function []=removeTriples(branchPath)
    
    if existTriple()
        groupTriples(branchPath);
    end
    
    i = 1
    while i <= length(branchPath.children) //all subnodes
        if branchPath.children(i).name == 'Branch' //is branch?
            removeTriples(branchPath.children(i)); //recursive application of the functon until no more triples
        end
        i = i+1;
    end
endfunction
