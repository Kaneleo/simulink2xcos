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

function [diagram, inputsdim] = busSystemOut(out)
    
    diagram = scicos_diagram();
    
    outputsdim = length(out); //number of output ports
    
    [w, ind] = xmlAttributeExist('OutputSignals');
    outputs = syspath.children(blockNo).children(ind).content;
    outputs = strsplit(outputs, ','); //name of output objects
    
    localNextFree = 1;
    
    ID4link = zeros(1,1); //matrix that will hold the blocks that will need to be connected
    
    for i = 1:outputsdim //for every output
        
        outportBlock = OUT_f('define'); //an output port for the subsystem is created
        outportBlock.graphics.sz = [20 20];
        outportBlock.graphics.orig = [260 50*i-40];
        outportBlock.graphics.exprs = string(i);
        outportBlock.model.ipar = i;
        outportBlock.model.uid = 'out' + string(i);
        
        diagram.objs(localNextFree) = outportBlock;
        ID4link(i, 2) = localNextFree;
        localNextFree = localNextFree + 1;
        
    end
    
    if outputsdim ~= 1 then //more than one output
        
        busDemuxBlock = SUPER_f('define'); //a container block for the demuxing is created
        busDemuxBlock.graphics.sz = [10 50*i];
        busDemuxBlock.graphics.orig = [200 -50*i];
        busDemuxBlock.model.in = [-1];
        busDemuxBlock.model.in2 = [-2];
        busDemuxBlock.model.intyp = [-1];
        out = [];
        out2 = [];
        outtyp = [];
        for i = 1:outputsdim
            out = [out; -1]; //vector entry postition (negative)
            out2 = [out2; -2];
            outtyp = [outtyp; -1];
        end
        busDemuxBlock.model.out = out;
        busDemuxBlock.model.out2 = out2;
        busDemuxBlock.model.outtyp = outtyp;
        busDemuxBlock.model.uid = 'busDemuxBlock' + busselector.model.uid;
        busDemuxBlock.model.rpar = initBusDemux(outputsdim); //container block is populated
        
        diagram.objs(localNextFree) = busDemuxBlock;
        for i = 1:outputsdim
            ID4link(i, 1) = localNextFree;
        end
        localNextFree = localNextFree + 1;
    end
    
    for i = 1:length(syspath.children(blockNo).children)
        if syspath.children(blockNo).children(i).attributes(1) == 'BusName'
            busName = syspath.children(blockNo).children(i).content; //busname is pulled
        end
    end
    outVect = [];
    exprs = '';
    n = find(busName == busList.root.children.name); //busname is checked in busList and the vector entries are pulled
    for i = 1:outputsdim
//        p;
        m = find(outputs(i) == busList.root.children(n).children.name);
        outVect($+1) = strtod(busList.root.children(n).children(m).content);
        exprs = exprs + busList.root.children(n).children(m).content + ' ';
    end
    
    inputsdim = length(busList.root.children(n).children); //number of objects in the bus
    
    exprs = part(exprs, 1:$-1);
    
    extractorBlock = EXTRACTOR('define'); //the extractor is built
    extractorBlock.model.uid = 'busSelectorExtractor' + busselector.model.uid;
    extractorBlock.graphics.sz = [60 40];
    extractorBlock.graphics.orig = [100 10]
    extractorBlock.model.ipar = outVect;
    extractorBlock.graphics.exprs = exprs;
    extractorBlock.model.out = length(outVect);
    extractorBlock.model.in = length(busList.root.children(n).children);
    
    inputBlock = IN_f('define'); //one input block for the incomming signal
    inputBlock.graphics.sz = [20 20];
    inputBlock.graphics.orig = [10 10];
    inputBlock.graphics.exprs = '1';
    inputBlock.model.ipar = 1;
    inputBlock.model.out = length(busList.root.children(n).children);
    inputBlock.model.uid = 'busSelectorIn' + busselector.model.uid;
    
    diagram.objs(localNextFree) = extractorBlock;
    ID4link($+1, 2) = localNextFree;
    localNextFree = localNextFree + 1;
    diagram.objs(localNextFree) = inputBlock;
    ID4link($, 1) = localNextFree;
    localNextFree = localNextFree + 1;
    
    if outputsdim ~= 1 then
       for i = 1:outputsdim //linking
            
            line = scicos_link();
            line.id = 'drawlink';
            line.from = [ID4link(i, 1), i, 0];
            line.to = [ID4link(i, 2), 1, 1];
            
            diagram.objs(localNextFree) = line;
            localNextFree = localNextFree + 1;            
        end
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [ID4link($, 2), 1, 0];
        line.to = [ID4link(1, 1), 1, 1];
        
        diagram.objs(localNextFree) = line;
        localNextFree = localNextFree + 1;
    else
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [ID4link($, 2), 1, 0];
        line.to = [ID4link(1, 2), 1, 1];
        
        diagram.objs(localNextFree) = line;
        localNextFree = localNextFree + 1;
    end
    
    line = scicos_link();
    line.id = 'drawlink';
    line.from = [ID4link($, 1), 1, 0];
    line.to = [ID4link($, 2), 1, 1];
    
    diagram.objs(localNextFree) = line;
    localNextFree = localNextFree + 1;
    
endfunction
