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

//build a system where a signal is demuxed and adds gains after the demux to prevent port size errors

function [diagram] = initBusDemux(in)
    
    diagram = scicos_diagram();
    
    localDueLinks = list();
    localNextFree = 1;
    
    inputBlock = IN_f('define');
    inputBlock.graphics.sz = [20 20];
    inputBlock.graphics.orig = [100 50*i];
    inputBlock.graphics.exprs = string(i);
    inputBlock.model.ipar = i;
    inputBlock.model.uid = 'input_' + busDemuxBlock.model.uid;
    
    diagram.objs(localNextFree) = inputBlock;
    localNextFree = localNextFree + 1;
     
    demuxBlock = DEMUX('define');
    demuxBlock.graphics.sz = [10 50*in];
    demuxBlock.graphics.orig = [10 50*in];
    demuxBlock.graphics.exprs = string(in);
    demuxBlock.model.in = in;
    out = [];
    for i = 1:in
        out = [out;i*-1]; //vector entry postition (negative)
    end
    demuxBlock.model.out = out;
    demuxBlock.model.ipar = in;
    diagram.objs(localNextFree) = demuxBlock;
    localNextFree = localNextFree + 1;
    
    line = scicos_link();
    line.id = 'drawlink';
    line.from = [1 1 0];
    line.to = [2 1 1];
    localDueLinks($+1) = line;
    
    for i = 1:in //gain block with the value 1 after every demux outport
        
        gainBlock = GAINBLK_f('define');
        gainBlock.graphics.sz = [40 40];
        gainBlock.graphics.orig = [50 50*i];
        
        a = localNextFree;
        
        diagram.objs(localNextFree) = gainBlock;
        localNextFree = localNextFree + 1;
        
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [2 i 0];
        line.to = [a 1 1];
        localDueLinks($+1) = line;
        
        outputBlock = OUT_f('define');
        outputBlock.graphics.sz = [20 20];
        outputBlock.graphics.orig = [100 50*i];
        outputBlock.graphics.exprs = string(i);
        outputBlock.model.ipar = i;
        outputBlock.model.uid = 'output_' + string(i) + '_' + busDemuxBlock.model.uid;
        
        b = localNextFree;
        
        diagram.objs(localNextFree) = outputBlock;
        localNextFree = localNextFree + 1;
        
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [a 1 0];
        line.to = [b 1 1];
        localDueLinks($+1) = line;
    end
    
    for i = 1:length(localDueLinks)
        diagram.objs($+1) = localDueLinks(i);
    end
    
endfunction
