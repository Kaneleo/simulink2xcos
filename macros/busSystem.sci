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

function [] = busSystem()
    
    global xmlDoc;
    
    busPrep(syspath); //finds buses in the main diagram
    
    for i = 1:length(subsyspath) //every layer of subsyspath
        for j = 1:length(subsyspath(i)) //every element in a layer
//            disp([i j]);
            busPrep(subsyspath(i)(j)(2)); //finds buses in every subdiagram
        end
    end
//    p;
    xmlWrite(xmlDoc, filepath + 'MISC\reload.xml', %t); //xmlDoc is reloaded to reread the lines
    xmlDoc = xmlRead(filepath + 'MISC\reload.xml');
    
    syspath = findSystem(); //refind the syspath
    global subsyspath;
    subsyspath = list(); //refind the subsyspaths, etc 
    subsyspath = findSubsys(syspath, 0, subsyspath);
//    p;
    
    busPrep2(syspath); //redo busPrep but for the busassignment blocks (see function) TODO: see function
    for i = 1:length(subsyspath) //every layer of subsyspath
        for j = 1:length(subsyspath(i)) //every element in a layer
            busPrep2(subsyspath(i)(j)(2));
        end
    end
    
    xmlWrite(xmlDoc, filepath + 'MISC\reload.xml', %t); //xmlDoc is reloaded to reread the lines
    xmlDoc = xmlRead(filepath + 'MISC\reload.xml');
    
endfunction
