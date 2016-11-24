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

//checks if from and to block of a line are in the diagram the link is supposed to be created in

function [bln] = lineDrawable()
    
    bln = %f;
    
//!inXcosIDList
    for i = 1:length(xcosIDList(counter)(counter1))
        if xcosIDList(counter)(counter1)(i) == from
            for j = 1:length(xcosIDList(counter)(counter1))
                if xcosIDList(counter)(counter1)(j) == to
//!inNonParseList
                    if ~isPart(nonParseList, strtod(from)) & ~isPart(nonParseList, strtod(to))
                        bln = %t
                    end
                end
            end
        end
    end
    
endfunction
