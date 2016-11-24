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

//see copyMux() for comments

function [diagram] = copyDemux(blockNo, diagram)
    
    global nextFree;
    
    container = SUPER_f('define');
    container.model.uid = syspath.children(blockNo).attributes(3);
    if ~syspath.children(blockNo).children(4).content == 'off' then
        container.graphics.id = syspath.children(blockNo).attributes(2);
    end
    
    container.model.in = -1;
    container.model.in2 = -2;
    container.model.intyp = -1;
    
    contDiag = scicos_diagram();
    
    localDueLinks = list();
    localNextFree = 1;
    
    inputBlock = IN_f('define');
    inputBlock.graphics.sz = [20 20];
    inputBlock.graphics.orig = [10 10];
    inputBlock.graphics.exprs = '1';
    inputBlock.model.ipar = 1;
    inputBlock.model.uid = 'input_' + container.model.uid;
    
    contDiag.objs(localNextFree) = inputBlock; //1
    localNextFree = localNextFree + 1;
     
    demuxBlock = DEMUX('define');
    demuxBlock.graphics.exprs = '';
    if xmlAttributeExist('Outputs') then
        [w, ind] = xmlAttributeExist('Outputs');
        demuxBlock.graphics.exprs = syspath.children(blockNo).children(ind).content;
        output = syspath.children(blockNo).children(ind).content;
    else //default value
        demuxBlock.graphics.exprs = '4';
        output = '4';
    end
    out = []
    n = strtod(output);
    for i = 1:n
        out = [out;i*-1];        
    end
    demuxBlock.model.out = out;
    container.model.out = out;
    
    [orig, sz] = convertPosSize(blockNo);
    orig(2) = orig(2)-sz(2);
    container.graphics.orig = orig;
    container.graphics.sz = sz;
    demuxBlock.graphics.sz = sz;
    demuxBlock.graphics.orig = [50 10];
    demuxBlock.graphics.exprs = output;
    demuxBlock.model.in = n;
    demuxBlock.model.out = out;
    demuxBlock.model.ipar = n;
    contDiag.objs(localNextFree) = demuxBlock; //2
    localNextFree = localNextFree + 1;
    
    line = scicos_link();
    line.id = 'drawlink';
    line.from = [1 1 0];
    line.to = [2 1 1];
    localDueLinks($+1) = line;
    
    for i = 1:n
        gainBlock = GAINBLK_f('define');
        gainBlock.graphics.sz = [40 40];
        gainBlock.graphics.orig = [50 50*i];
        gainBlock.model.uid = 'gain_' + string(i) + '_' + container.model.uid;
        
        a = localNextFree;
        
        contDiag.objs(localNextFree) = gainBlock;
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
        outputBlock.model.uid = 'output_' + string(i) + '_' + container.model.uid;
        
        b = localNextFree;
        
        contDiag.objs(localNextFree) = outputBlock;
        localNextFree = localNextFree + 1;
        
        line = scicos_link();
        line.id = 'drawlink';
        line.from = [a 1 0];
        line.to = [b 1 1];
        localDueLinks($+1) = line;
    end
    
    for i = 1:length(localDueLinks)
        contDiag.objs($+1) = localDueLinks(i);
    end
    
    container.model.rpar = contDiag;
    
    diagram.objs(nextFree) = container;
    endoffunction(container.model.uid);
    
endfunction
