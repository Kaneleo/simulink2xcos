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

//copy a sum block

function [diagram] = copySum(blockNo, diagram)
    
    global nextFree;
    
    sumBlock = SUMMATION('define');
    
    sumBlock.model.uid = syspath.children(blockNo).attributes(3);
    sumBlock.graphics.id = syspath.children(blockNo).attributes(2);
    
    [orig, sz] = convertPosSize(blockNo);
        
    sz(2) = sz(2)*2; //double the height to adjust for different graphical representation of sum block in xcos
    
    sumBlock.graphics.orig = orig;
    sumBlock.graphics.sz = sz;
    
    inputsstring = [];
    
    if xmlAttributeExist('Inputs') then
        [w, ind] = xmlAttributeExist('Inputs');
        inputsstring = syspath.children(blockNo).children(ind).content
        n = strtod(inputsstring); //try to get a double from XML
        a = '['; //string for exprs
        b = []; //labels for the in ports
        inputs = []; //rpar and ipar
        if isnan(n) then //simulink version where inputs are not double but ascii characters
            for i = 1:length(inputsstring)
                if part(inputsstring, i:i) ==  '+' //for addition
                    a = a+'1';
                    inputs($+1) = 1;
                    b($+1) = '+';
                elseif part(inputsstring, i:i) ==  '-' //for subtraction
                    a = a+'-1';
                    inputs($+1) = -1;
                    b($+1) = '-';
                end //if it is neither '+' nor '-' it is ignored, there may be a | in the string
                if i<length(inputsstring) //every value except for the last one is ended with a semicolon
                    a = a+';';
                end
            end
        else //if inputsstring can be converted to doubles, same procedure but with numbers
            for i = 1:n
                a = a+'1';
                b($+1) = '+';
                inputs($+1) = 1;
                if i < n
                    a = a+';';
                end
            end
        end
        a = a+']'; //end the string for exprs
    else //no Inputs node, so default values are applied
        a = '[1;1]';
        b = ['+';'+'];
        inputs = [1;1];
    end
    
    in = [];
    in2 = [];
    intyp = [];
    
    j = size(b); //number of inputs, the inputs attributes are set this way
    j = j(1);
    for i = 1:j
        in($+1) = -1;
        in2($+1) = -2;
        intyp($+1) = 1;
    end
    
    sumBlock.graphics.exprs = a;
    sumBlock.graphics.in_label = b;
    sumBlock.model.rpar = inputs;
    sumBlock.model.ipar = inputs;
    sumBlock.model.in = in;
    sumBlock.model.in2 = in2;
    sumBlock.model.intyp = intyp;

//    disp(sumBlock.graphics.exprs);
    
    diagram.objs(nextFree) = sumBlock
    
    endoffunction(sumBlock.model.uid);
    
endfunction
