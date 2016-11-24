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

//extracts timeframe from 'configSet0.xml'

function [TF] = extractTF(path)
    
    global xmlDoc;
    
    xmlConf = xmlRead(path+'/configSet0.xml');
    
    i = 1;
    while i > 0
        if xmlConf.root.children(1).children(i).name == 'Array'
            arr = i;
            break;
        else
            i = i+1;
        end
    end
    
    i = 1
    bn = %f;
    while i > 0
        if xmlConf.root.children(1).children(arr).children(i).name == 'Object'
            for j = 1:length(xmlConf.root.children(1).children(arr).children(i).attributes)
                if xmlConf.root.children(1).children(arr).children(i).attributes(j) == 'Simulink.SolverCC'
                    bn = %t
                end
            end
            if bn == %t
                obj = i;
                break;
            else
                i = i+1;
            end
        else
            i  = i+1;
        end
    end
    
    i = 1;
    while i > 0
        if xmlConf.root.children(1).children(arr).children(obj).children(i).attributes(1) == 'StopTime'
            stopTime = i;
            break;
        else
            i = i+1;
        end
    end
    
    TF = strtod(xmlConf.root.children(1).children(arr).children(obj).children(stopTime).content);
    
endfunction
