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

function [diagram] = busSystemIn()
    
    global nextFree;
    global busList;
    
    diagram = scicos_diagram();
    
    [w, ind] = xmlAttributeExist('Inputs');
    inputs = syspath.children(blockNo).children(ind).content;
    inputs = strsubst(inputs, '''', '');
    inputs = strsplit(inputs, ',');
    inputsdim = size(inputs);
    inputsdim = inputsdim(1);
    
//    [w, ind] = xmlAttributeExist('OutDataTypeStr');
//    busName = syspath.children(blockNo).children(ind).content;
//    busXML = xmlElement(busList, busName);
    
    localNextFree = 1;
    
    ID4link = zeros(1,1);
    
    for i = 1:inputsdim
        
        inportBlock = IN_f('define');
        inportBlock.graphics.sz = [20 20];
        inportBlock.graphics.orig = [10 50*i-40];
        inportBlock.graphics.exprs = string(i);
        inportBlock.model.ipar = i;
        inportBlock.model.uid = 'in' + string(i);
        
//        busVector = xmlElement(busList, inputs(i));
//        busVector.content = string(i);
//        xmlAppend(busXML, busVector);
        
//        gotoBlock = GOTO('define');
//        gotoBlock.graphics.sz = [40 20];
//        gotoBlock.graphics.orig = [100 50*i-40];
//        gotoBlock.graphics.exprs = [inputs(i); '3'];
//        gotoBlock.model.ipar = 3;
//        gotoBlock.model.opar = list(inputs(i));
//        gotoBlock.model.uid = 'goto' + string(i);
        
        diagram.objs(localNextFree) = inportBlock;
        ID4link(i, 1) = localNextFree;
        localNextFree = localNextFree + 1;
//        diagram.objs(localNextFree) = gotoBlock;
//        ID4link(i, 2) = localNextFree;
//        localNextFree = localNextFree + 1;
        
    end
    
//    constBlock = CONST_m('define');
//    constBlock.graphics.sz = [40 40];
//    constBlock.graphics.orig = [200 10];
//    constBlock.graphics.exprs = '1';
//    constBlock.model.rpar = 1;
//    constBlock.model.uid = 'dummyOutValue';
    
    muxBlock = MUX('define');
    muxBlock.model.uid = 'busCreatorMux' + buscreator.model.uid;
    muxBlock.graphics.orig = [50 50*i];
    muxBlock.graphics.sz = [10 50*i];
    in = [];
    for i = 1:inputsdim
        in = [in;i*-1]; //vector entry postition (negative)
    end
    muxBlock.model.in = in;
    muxBlock.model.ipar = inputsdim;
    muxBlock.graphics.exprs = string(inputsdim);
    muxBlock.model.out = 0;//ones(1, inputsdim);
    
    diagram.objs(localNextFree) = muxBlock;
    ID4link($+1, 1) = localNextFree;
    localNextFree = localNextFree + 1;
    
    outputBlock = OUT_f('define');
    outputBlock.graphics.sz = [20 20];
    outputBlock.graphics.orig = [260 10];
    outputBlock.graphics.exprs = '1';
    outputBlock.model.ipar = 1;
    outputBlock.model.in = inputsdim;
    outputBlock.model.uid = 'busCreatorOut' + buscreator.model.uid;
    
//    diagram.objs(localNextFree) = constBlock;
//    ID4link($+1, 1) = localNextFree;
//    localNextFree = localNextFree + 1;
    diagram.objs(localNextFree) = outputBlock;
    ID4link($, 2) = localNextFree;
    localNextFree = localNextFree + 1;
    
    for i = 1:inputsdim
        
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [ID4link(i, 1), 1, 0];
        line.to = [ID4link($, 1), i, 1];
        
        diagram.objs(localNextFree) = line;
        localNextFree = localNextFree + 1;
        
    end
    
    line = scicos_link();
    line.id = 'drawlink';
    line.from = [ID4link($, 1), 1, 0];
    line.to = [ID4link($, 2), 1, 1];
    
    diagram.objs(localNextFree) = line;
    localNextFree = localNextFree + 1;
    
    
//    xmlAppend(busList.root, busXML);
//    p;
endfunction
