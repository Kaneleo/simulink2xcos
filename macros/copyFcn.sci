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

//copies a function block

function [diagram] = copyFcn(blockNo, diagram)
    
    global nextFree;

    fcnBlock = scifunc_block_m('define');
    
    fcnBlock.model.uid = syspath.children(blockNo).attributes(3);
    fcnBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    [w, ind] = xmlAttributeExist('Expr');
    expr = syspath.children(blockNo).children(ind).content;
    
    ind = 0;
    n = strindex(expr, 'u('); //u is the variable in the function; it can either have a '(...)'
    if n == [] then
        n = strindex(expr, 'u[') //or a '[...]' behind it, which will then include the vector entry
        if n == []
            vSize = 1; //vSize is then declared the vector size of u, it is either one, if there is none of the strings above in the function
        else
            vSize = length(n); //or it is the number of times 'u[' is found in the expression
            ind = 1;
        end
    else
        vSize = length(n); //or 'u(' is found
    end
    
    n = strindex(expr, 'u'); //positions of 'u' in expr
    j = n;

    if ~(part(expr, n(1)+1:n(1)+1) == '1') then //checks wether the character after the first 'u' is a '1'; theoretically should be false every time, don't know the reason i put it in
        for i = 1:length(n)
        expr = part(expr, 1:n(i)+i-1)+'1'+part(expr, n(i)+i:$); //adds a '1' after every 'u' to fit it with the xcos syntax of 'u1' being the proper variable
        end
    end
    
    if ind == 1 then //the brackets need to be switched out for parantheses
        for i = 1:length(j) //every 'u'
            n = strindex(expr, 'u');
            o = length(part(expr, 1:n(i)-1)); //length from the first symbol until the last symbol before 'u'
            m = strindex(part(expr, n(i):$), ']'); //position of the ']' after the current 'u'
            m = m(1); //only the first ']' after the current 'u'
            expr = part(expr, 1:n(i)+1)+'('+part(expr, n(i)+3:m+o-1)+')'+part(expr, m+o+1:$); //expr until 'u' + '(' + content of brackets + ')' + rest
        end
    end
    
    expr = strsubst(expr, 'atan2', 'atan'); //converts the matlab function atan2 to the scilab supported atan
    
    expr = 'y1 = '+expr; //adds starting bit to equation to fit xcos syntax
    
    fcnBlock.graphics.exprs(1)(1) = '[-'+string(vSize)+', 1]';
    fcnBlock.model.in = -1;
    fcnBlock.graphics.exprs(2)(1) = string(expr);
    fcnBlock.model.opar(1) = string(expr);
    
    [orig, sz] = convertPosSize(blockNo);
    
    fcnBlock.graphics.orig = orig;
    fcnBlock.graphics.sz = sz;
    
    if length(expr) > 15 then //equation longer than 15 characters
        fcnBlock.graphics.style = 'scifunc_block_m_no_label'; //instead of the function, the string 'Fcn' is displayed inside the block
    end
    
    diagram.objs(nextFree) = fcnBlock;
    
    endoffunction(fcnBlock.model.uid);
    
endfunction
