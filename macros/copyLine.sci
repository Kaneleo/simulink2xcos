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

//creates a link and provides information about source and destination

function [diagram, from, to] = copyLine(lineID, diagram)
    
    global nextFree;
    
//Standort der Reiter DST und SRC werden bestimmt
    
    o = size(syspath.children(lineID).children.name); //attribute nodes are scanned
    o = o(2);
    
    d = 0;
    s = 0;
    for i = 1:o
        
        if syspath.children(lineID).children(i).attributes(1) == 'Dst' //for destination
            
            d = i;
            
        end
        
        if syspath.children(lineID).children(i).attributes(1) == 'Src' //and for source
            
            s = i;
            
        end
        
        if d ~= 0 & s ~= 0 //when both are found the loop will end
            break;
        end
        
    end
    
    n = strindex(syspath.children(lineID).children(s).content, '#'); //string manipulation
    m = strindex(syspath.children(lineID).children(d).content, '#');
    
    xIDLcc = [];
    for i = 1:length(xcosIDList(counter)(counter1))
        xIDLcc($+1) = xcosIDList(counter)(counter1)(i); //the xcosIDs for the layer and index of the current diagram are copied
    end
    
    from = strtod(part(syspath.children(lineID).children(s).content, 1:n-1));
    fromTrans = find(xIDLcc == string(from)); //xcosID is found through matching ID with position in xIDL
    fromPort = strtod(part(syspath.children(lineID).children(s).content, n+5:length(syspath.children(lineID).children(s).content)));
    to = strtod(part(syspath.children(lineID).children(d).content, 1:m-1));
    toTrans = find(xIDLcc == string(to)); //see line 41
    toPort = strtod(part(syspath.children(lineID).children(d).content, m+4:length(syspath.children(lineID).children(d).content)));
    
    a = mlist('');
    a = mlist(['Link', 'xx', 'yy', 'id', 'thick', 'ct', 'from', 'to'], [], [], 'drawlink', [0 0], [1 1], [fromTrans, fromPort, 0], [toTrans, toPort, 1]); //all the data is made into a link; a could be defined as a link beforehand for easier access, I did not know this until I already wrote this section though
    
    diagram.objs(nextFree) = a; //the link is inserted into the diagram
    
endfunction
