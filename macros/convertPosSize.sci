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

//determines position and size of a block

function [blockPos, blockSize] = convertPosSize(blockNo)
    
    n = length(syspath.children(blockNo).children);
    atts = [];
    
    for i = 1:n
        
        atts = [atts, syspath.children(blockNo).children(i).attributes(1)]; //copy every attribute node to atts
        
    end
        
    n = find(atts == 'Position'); //filter for the position
    slcoordinates = syspath.children(blockNo).children(n).content;
    
    slcoordinates = coordinateStringToList(slcoordinates);
    
    blockPos = [slcoordinates(1), slcoordinates(2)*-1]; //the y-axis in simulink is opposite to the one in xcos, so the y value of the position is multiplied with -1; this creates the problem, that the y-part of the size cannot be negative, so the higher a block is, the more it is shifted up, becuase the size makes it grow in the 'wrong' direction; this can be fixed by subtracting the height from the y-coordinate of a block, but this is not a perfect solution; xcos messes up the coordinates of every block anyways, when loading, so if it has to look perfect, you have to rearrange the blocks anyways
    
    blockSize = [(slcoordinates(3)-slcoordinates(1)), (slcoordinates(4)-slcoordinates(2))]; //size is [x2-x1,y2,y1]
    
endfunction
