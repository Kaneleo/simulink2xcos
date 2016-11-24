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

//this assignes busnames to all blocks connected to a busassignment block
//the busassignment block doesnt have the bus name saved, so this needs to be done after the busassignment block has recieved its busname
// TODO: this should be performed one more time than there are busassignment blocks back to back; needs to be implemented!!! or should it? it works now without the change

function [] = busPrep2(syspath_new)
    
    global xmlDoc;
    
    for i = 1:length(syspath_new.children)
        if syspath_new.children(i).name == 'Line' //every line
//            disp('line found');
            for q = 1:length(syspath_new.children(i).children)
                if syspath_new.children(i).children(q).attributes(1) == 'Src'; //finds and saves source block of line
                    src = syspath_new.children(i).children(q).content;
                end
            end
            n = strindex(src, '#');
            src = part(src, 1:n-1);
            
            for j = 1:length(syspath_new.children)
                if syspath_new.children(j).name == 'Block' & syspath_new.children(j).attributes(3) == src //finds the sourceblock
//                    disp('src block found');
                    if syspath_new.children(j).attributes(1) == 'BusAssignment' //is the block a busassignment
//                        disp('busass block found');
                        for ba = 1:length(syspath_new.children(j).children)
                            if syspath_new.children(j).children(ba).attributes(1) == 'BusName'; //finds the busname node
                                busName = syspath_new.children(j).children(ba).content;
//                                disp('BusName: ' + string(busName));
                                for l = 1:length(syspath_new.children(i).children)
//                                    disp(syspath_new.children(i).children(l));
                                    addBusName(syspath_new.children(i).children(l)); //adds the busname to the dest blocks
                                end
                                break;
                            end
                        end
                    end
                end
            end
        end
    end
endfunction
