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

//checks if this kind of link is already present in the diagram

function [bln] = existLine(line)
    
    links = list();
    bln = %f
    
    for i = 1:length(diagram.objs)
        if typeof(diagram.objs(i)) == 'Link'
            links($+1) = diagram.objs(i); //every link is saved
        end
    end
    
    for i = 1:length(links)
        if links(i).from(1) == line.from(1) & links(i).to(1) == line.to(1) //are the block IDs matching?
            if links(i).from(2) == line.from(2) & links(i).to(2) == line.to(2) //are the block ports matching?
                bln = %t; //link already exists
            end
        end
    end
    
endfunction
