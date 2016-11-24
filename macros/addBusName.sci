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

function [] =  addBusName(node)
    
    global xmlDoc;
    if node.attributes(1) == 'Dst' then //is the node a node pointing to a block?
//        disp('DST found');
        dest = node.content; //destination saved
        o = strindex(dest, '#'); //string manipulation
        dest = part(dest, 1:o-1);
//        disp('dst = ' + dest);
        
        for p = 1:length(syspath_new.children)
//            disp('SID = ' + string(syspath_new.children(p).attributes(3)));
//            disp('dbug');
//            dbug(32);
            if syspath_new.children(p).name == 'Block' & syspath_new.children(p).attributes(3) == dest //find the destination block
//                disp('IT WORKED');
//                disp(busName);
                busNameXML = xmlElement(xmlDoc, 'P'); //add a node
                busNameXML.attributes.Name = 'BusName'; //called busname
                busNameXML.content = busName; //containing the busname
                xmlAppend(syspath_new.children(p), busNameXML); //and add it to the block node
//                xmlDump(syspath_new.children(p));
            end
        end
                
        
    elseif node.name == 'Branch' //if there is a  branch
        
        for m = 1:length(node.children) //every node in the branch gets run trhough this function to find all destinations
            addBusName(node.children(m));
        end
        
    end
    
endfunction
