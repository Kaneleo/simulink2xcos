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

function [] = removeTriplesPrep()
    
    global xmlDoc;
    global syspath;
    

//!linesSys
    for i = 1:length(syspath.children)
        if syspath.children(i).name == 'Line' //Node is a line?
            removeTriples(syspath.children(i));
        end
    end
    
//!linesSubSys
    for i = 1:length(subsyspath) //every layer of subsyspath
        for j = 1:length(subsyspath(i)) //every element in a layer
            for k = 1:length(subsyspath(i)(j)(2).children)
                if subsyspath(i)(j)(2).children(k).name == 'Line' //Node is a line?
                    removeTriples(subsyspath(i)(j)(2).children(k));
                end
            end
        end
    end
    
//Pfad muss korrigiert werden!!!
    
    xmlWrite(xmlDoc, filepath + 'MISC\reload.xml', %t); //xmlDoc is reloaded to reread the lines
    xmlDoc = xmlRead(filepath + 'MISC\reload.xml');
    
endfunction
