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

//chooses appropriate function to copy a reference

function [diagram] = copyReference(blockNo, diagram)
    
    global nextFree;
    
    [w, ind] = xmlAttributeExist('SourceType');
    SourceType = syspath.children(blockNo).children(ind).content;
    
    select SourceType //there are different types of references, that need to be added
    case 'Ramp'
        diagram = copyRamp(blockNo, diagram);
    end
    
endfunction
