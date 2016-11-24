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

function [diagram, vectSize] = busAssignment(name)
    
    diagram = scicos_diagram();
    
    localNextFree = 1;
    localDueLinks = list();
    
    [w, ind] = xmlAttributeExist('AssignedSignals');
    signals = syspath.children(blockNo).children(ind).content;
    signals = strsplit(signals, ',');
    
    [w, ind] = xmlAttributeExist('BusName');
    currentBus = syspath.children(blockNo).children(ind).content;
    n = find(busList.root.children.name == currentBus);
    bus = busList.root.children(n);
    vectSize = length(bus.children);
    
    busInportBlock = IN_f('define');
    busInportBlock.graphics.sz = [20 20];
    busInportBlock.graphics.orig = [10 10];
    busInportBlock.graphics.exprs = '1';
    busInportBlock.model.ipar = 1;
    busInportBlock.model.out = vectSize;
    busInportBlock.model.uid = 'busIn' + busassignment.model.uid;
    
    diagram.objs(localNextFree) = busInportBlock; //objs(1)
    localNextFree = localNextFree + 1;
    
    muxBlock = MUX('define');
    muxBlock.graphics.sz = [10 50*vectSize];
    muxBlock.graphics.orig = [200 50*vectSize];
    muxBlock.graphics.exprs = string(vectSize);
    in = [];
    for i = 1:vectSize
        in = [in; -i]; //vector entry postition (negative)
    end
    muxBlock.model.in = in;
    muxBlock.model.ipar = vectSize;
    muxBlock.model.out = vectSize;//ones(1, vectSize);
    diagram.objs(localNextFree) = muxBlock; //objs(2)
    localNextFree = localNextFree + 1;
    
    extractorBlock = EXTRACTOR('define');
    extractorBlock.model.uid = 'busAssignExtractor' + busassignment.model.uid;
    extractorBlock.graphics.sz = [60 40];
    extractorBlock.graphics.orig = [10 100]
    
    signalsLength = size(signals);
    signalsLength = signalsLength(1);
    for i = 1:signalsLength;
        
        inportBlock = IN_f('define');
        inportBlock.graphics.sz = [20 20];
        inportBlock.graphics.orig = [10 50*i];
        inportBlock.graphics.exprs = string(i+1);
        inportBlock.model.ipar = i+1;
        inportBlock.model.out = -1;
        inportBlock.model.uid = 'in' + string(i+1) + '_' + busassignment.model.uid;
        
        diagram.objs(localNextFree) = inportBlock; //objs(i+2)
        n = find(signals(i) == bus.children.name);
        dest = bus.children(n).content;
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [localNextFree 1 0];
        line.to = [2 strtod(dest) 1];
        localDueLinks($+1) = line; //inport to mux
        
        localNextFree = localNextFree + 1;
        
    end
    
    extr = [];
    expr = '';
    
    for i = 1:vectSize
        ind = 0
        for j = 1:length(localDueLinks)
            if i == localDueLinks(j).to(2)
                ind = 1;
                break;
            end
        end
        if ind == 0
            extr($+1) = i;
            expr = expr + string(i) + ' ';
        end
    end
    expr = part(expr, 1:$-1);
    
    extractorBlock.model.out = length(extr);
    extractorBlock.graphics.exprs = expr;
    extractorBlock.model.ipar = extr;
    extractorBlock.model.in = vectSize;
    
    diagram.objs(localNextFree) = extractorBlock;
    localNextFree = localNextFree + 1;
    
    line = scicos_link();
    line.id = 'drawlink';
    line.from = [1 1 0];
    line.to = [localNextFree-1 1 1];
    localDueLinks($+1) = line; //inport to extractor
    
    if length(extr)>1 then
        
        busDemuxBlock = SUPER_f('define');
        busDemuxBlock.graphics.sz = [10 50*length(extr)];
        busDemuxBlock.graphics.orig = [150 50*length(extr)];
        busDemuxBlock.model.in = [-1];
        busDemuxBlock.model.in2 = [-2];
        busDemuxBlock.model.intyp = [-1];
        out = [];
        out2 = [];
        outtyp = [];
        for i = 1:length(extr)
            out = [out; -1]; //vector entry postition (negative)
            out2 = [out2; -2];
            outtyp = [outtyp; -1];
        end
        busDemuxBlock.model.out = out;
        busDemuxBlock.model.out2 = out2;
        busDemuxBlock.model.outtyp = outtyp;
        busDemuxBlock.model.uid = 'busDemuxBlock' + name;
//        abc = initBusDemux();p;
        busDemuxBlock.model.rpar = initBusDemux(extractorBlock.model.out);
        
//        demuxBlock = DEMUX('define');
//        demuxBlock.graphics.sz = [10 50*length(extr)];
//        demuxBlock.graphics.orig = [150 50*length(extr)];
//        demuxBlock.graphics.exprs = string(length(extr));
//        demuxBlock.model.in = extractorBlock.model.out;
//        out = [];
//        for i = 1:length(extr)
//            out = [out;i*-1]; //vector entry postition (negative)
//        end
//        demuxBlock.model.out = out;
//        demuxBlock.model.ipar = ones(1, length(extr));
        
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [localNextFree-1 1 0];
        line.to = [localNextFree 1 1];
        localDueLinks($+1) = line; //extractor to busDemux
        diagram.objs(localNextFree) = busDemuxBlock;
        localNextFree = localNextFree + 1;
        
        for i = 1:length(extr)
            line = scicos_link();
            line.id = 'drawlink';
            line.from = [localNextFree-1 i 0];
            line.to = [2 extr(i) 1];
            localDueLinks($+1) = line; //busDemux to mux
        end
    else
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [localNextFree-1 1 0];
        line.to = [2 extr 1];
        localDueLinks($+1) = line; //extractor to mux
    end
    
    outportBlock = OUT_f('define');
    outportBlock.graphics.sz = [20 20];
    outportBlock.graphics.orig = [10 25*vectSize];
    outportBlock.graphics.exprs = '1';
    outportBlock.model.ipar = 1;
    outportBlock.model.in = vectSize;
    outportBlock.model.uid = 'out' + name;
    
    diagram.objs(localNextFree) = outportBlock;
    line = scicos_link();
    line.id = 'drawlink';
    line.from = [2 1 0];
    line.to = [localNextFree 1 1];
    localDueLinks($+1) = line;
    localNextFree = localNextFree + 1;
    
    for i = 1:length(localDueLinks)
        diagram.objs(localNextFree) = localDueLinks(i);
        localNextFree = localNextFree + 1;
    end
    
    
    
    //XML Node hat noch nicht die BusName Subnode
endfunction
