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

//copies a product

function [diagram] = copyProduct(blockNo, diagram)
    
    global nextFree;
    global xmlDoc;
    
    productBlock = PRODUCT('define');
    
    productBlock.model.uid = syspath.children(blockNo).attributes(3);
    productBlock.graphics.id = syspath.children(blockNo).attributes(2)
    

    [w, ind] = xmlAttributeExist('Ports'); //input ports are aggregated
    ports = syspath.children(blockNo).children(ind).content;

    ports = part(ports, 2:$-1);
    n = strindex(ports, ', ');
    inports = strtod(part(ports, 1:n-1));
    in = []
    in2 = []
    intyp = []
    for i = 1:inports
        in = [in;-1];
        in2 = [in2;1];
        intyp = [intyp;1];
    end
    productBlock.model.in = in;
    productBlock.model.in2 = in2;
    productBlock.model.intyp = intyp;
    
    if xmlAttributeExist('Inputs') then //inputs other than default value
        [w, ind] = xmlAttributeExist('Inputs');
        inputs = syspath.children(blockNo).children(ind).content;
        if ~isnan(strtod(inputs)) //inputs is a number
            n = strtod(inputs);
            inputs = '';
            for i = 1:n
                inputs = inputs + '*'; //multiplication of all elements,  translated into string because of later retranslation
            end
        end
    else //default value
        inputs = '**';
    end
    ipar = [];
    exprs = '[';
    
    for i = 1:length(inputs)
        if part(inputs, i:i) == '*' //simulink to xcos arguments, '*' -> +1, '-' -> -1
            ipar = [ipar;1];
            exprs = exprs+'1;';
        else
            ipar = [ipar;-1];
            exprs = exprs+'-1;';
        end
    end
    exprs = part(exprs, 1:$-1);
    exprs = exprs+']';
    
    a = []; //in_label,  list of strings
    for i = 1:length(inputs)
        a($+1) = part(inputs, i:i);
    end
    
    productBlock.model.ipar = ipar;
    productBlock.graphics.exprs = exprs;
    productBlock.graphics.in_label = a;
    
    [orig, sz] = convertPosSize(blockNo);
    
    productBlock.graphics.orig = orig;
    productBlock.graphics.sz = sz;

    diagram.objs(nextFree) = productBlock;
    
    endoffunction(productBlock.model.uid);
endfunction
