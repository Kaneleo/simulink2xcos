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

//superblocks are registered in subsyspath under there corresponding layer and index on that layer
//additionaly to the superblock, the included subsystem and the line of the supersystem are saved in subsyspath

function [subsyspath] = findSubsys(syspath_new, counter, subsyspath)
    
    global xmlDoc;
    global subsyspath;
    
    counter = counter+1; //layer of current diagram
    
//Es werden die Superblöcke registriert, und das enthaltene System in jedem gefunden
//In subsyspath werden nun unter der Ebene des Systems (counter, 1 ist die erste Ebene unter der Hauptebene,
//2 die zweite, usw) der Superblock und das enthaltene System in einem Eintrag gespeichert
//Anschliessend wird die Funktion rekursiv auf das enthaltene System angewendet

//the commented disp() functions are for debugging purposes
    
//!existSubsys
    n = find(syspath_new.children.name == 'Block'); //every Block
    if length(n) > 0 then //are there blocks?
        for i = 1:length(n)
            if syspath_new.children(n(i)).attributes(1) == 'SubSystem' //is the block the subsystem?
//!parsing
                if size(subsyspath) < counter then //has there been an entry for this layer in subsyspath before?
                    subsyspath(counter) = list(); //if not, a list has to be defined
                end
                m = find(syspath_new.children(n(i)).children.name == 'System'); //where is the subsystem?
                
//                disp('counter1: '+string(counter1));
                
                subsyspath(counter)($+1) = list(syspath_new.children(n(i)), syspath_new.children(n(i)).children(m), syspath_new.line);
                //data entry into the next free spot of subsyspath(counter)
                
//                disp('counter before entering: '+string(counter));
//                disp('entering '+string(syspath_new.children(n(i)).attributes(2)));
                
                subsyspath = findSubsys(syspath_new.children(n(i)).children(m), counter, subsyspath); //recursive application of the function to register the subsystems in a subsystem
                
//                disp('exiting '+string(syspath_new.children(n(i)).attributes(2)));
//                disp('counter after exiting: '+string(counter));

            end
        end
    end
    
endfunction
