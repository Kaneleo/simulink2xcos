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

//informs the user that a block is not copyable, or calls a function to create the block

function [diagram] = copyTrigFuncSpecial(blockNo, diagram, funct)
    
    global nextFree;
    
    if funct == 'atan2' then //not possible, user can abort or continue
        btn = messagebox(['The simulink model includes the trigonometric function atan with an imaginary part.', 'Xcos and scilab do not support this kind of function.', 'Do you want to continue without this function?'], 'atan2 function found!', 'warning', ['Yes' 'No'], 'modal');
        if btn~ = 1
            abort;
        end
    elseif funct == 'sincos' //can be created, function is called
        diagram = copySinCos(blockNo, diagram)
    else //every other (hint: there is only one) block cannot be copied, so the user has the choices like in line 5ff
        btn = messagebox(['The simulink model includes the trigonometric function cos + jsin with an imaginary part.', 'Xcos and scilab do not support this kind of function.', 'Do you want to continue without this function?'], 'cos + jsin function found!', 'warning', ['Yes' 'No'], 'modal');
        if btn~ = 1
            abort;
        end
    end
endfunction
