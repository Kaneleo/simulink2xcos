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

// TODO: there is certain number of times this function has to be called until every block that needs the busname has it (due to superblock structure), how many times does it have to be called? how can this be implemented? NOT SURE IF NEEDED ANYMORE
// TODO: what if there are more outports to a superblock? there needs to be a check which port is accessed if a superblock is accessed and the port needs to lead to the connection outport in the subdiagram

function [] = busPrep(syspath_new)
    
    global xmlDoc;
    
    for i = 1:length(syspath_new.children)
        if syspath_new.children(i).name == 'Line' //for every line
            for q = 1:length(syspath_new.children(i).children)
                if syspath_new.children(i).children(q).attributes(1) == 'Src';
                    src = syspath_new.children(i).children(q).content; //save the source block
                end
            end
            n = strindex(src, '#');
            src = part(src, 1:n-1); //string manipulaton
            
            for j = 1:length(syspath_new.children)
                if syspath_new.children(j).name == 'Block' & syspath_new.children(j).attributes(3) == src //find the sourceblock of the line
                    if syspath_new.children(j).attributes(1) == 'Inport' | syspath_new.children(j).attributes(1) == 'BusCreator' | syspath_new.children(j).attributes(1) == 'SubSystem' //starting point of a bus?
                        
                        if syspath_new.children(j).attributes(1) == 'SubSystem' //bus from inside of a subsystem?
                            busName = ''
                            for si = 1:length(syspath_new.children(j).children);
                                if syspath_new.children(j).children(si).name == 'System' //go inside
//                                disp(syspath_new.children(j).children(si).line);
                                    for sj = 1:length(syspath_new.children(j).children(si).children)
//                                      disp(syspath_new.children(j).children(si).children(sj).line);
                                        if syspath_new.children(j).children(si).children(sj).attributes(1) == 'Outport' //find the outport
//                                        disp('Outport');
                                            for sk = 1:length(syspath_new.children(j).children(si).children(sj).children)
                                                if syspath_new.children(j).children(si).children(sj).children(sk).attributes(1) == 'OutDataTypeStr' //find the BusName
//                                                disp('OutData');
                                                    busName = syspath_new.children(j).children(si).children(sj).children(sk).content;
                                                    syspath_new.children(j).children(si).children(sj).children(sk).content = strsubst(busName, ' ', '_');
                                                    busName = syspath_new.children(j).children(si).children(sj).children(sk).content;
                                                end
                                            end
                                        end
                                    end
                                end
                            end
//                            p;
                            if busName ~='' //there is a busname
                                for l = 1:length(syspath_new.children(i).children)
                                    addBusName(syspath_new.children(i).children(l)); //add busname to every destination of the line
                                end
                            end
                            
                        else //bus directly from source
                            busNamePos = 0;
                            for k = 1:length(syspath_new.children(j).children)
                                
                                if syspath_new.children(j).children(k).attributes(1) == 'OutDataTypeStr' //find the name
                                    busNamePos = k;
                                    break;
                                end
                            end
                            if busNamePos ~= 0 //name found?
//                                p;
                                busName = syspath_new.children(j).children(k).content;
                                syspath_new.children(j).children(k).content = strsubst(busName, ' ', '_');
                                busName = syspath_new.children(j).children(k).content; //save name
                                
                                for l = 1:length(syspath_new.children(i).children)
                                    addBusName(syspath_new.children(i).children(l)); //add busname to the destinations
                                end
                            end
                        end
                        if syspath_new.children(j).attributes(1) == 'BusCreator' //link positions of busobjects to the name
                            
                            for bi = 1:length(syspath_new.children(j).children)
                                if syspath_new.children(j).children(bi).attributes(1) == 'OutDataTypeStr'
                                    busName = syspath_new.children(j).children(bi).content; //find busname
                                    break;
                                end
                            end
                            
                            busXML = xmlElement(busList, busName); //make xml node for current bus
                            for bi = 1:length(syspath_new.children(j).children)
                                if syspath_new.children(j).children(bi).attributes(1) == 'Inputs' //find the names of the objects
                                    ind = bi;
                                    break;
                                end
                            end
                            inputs = syspath_new.children(j).children(ind).content; //string manipulation
                            inputs = strsubst(inputs, '''', '');
                            inputs = strsplit(inputs, ',');
                            inputsdim = size(inputs); //find number of objects
                            inputsdim = inputsdim(1);
                            for bi = 1:inputsdim //for every object
                                busVector = xmlElement(busList, inputs(bi)); //make an xml node that has the name of the object and the position in the vector as the content
                                busVector.content = string(bi);
                                xmlAppend(busXML, busVector);
                            end
                            xmlAppend(busList.root, busXML)
                        end
                    end
                end
            end
        end
    end
endfunction
