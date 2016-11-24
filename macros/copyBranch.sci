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

//function creates SPLIT_f blocks for a branch in simulink

function [diagram] = copyBranch(BranchID, diagram)
    
    global nextFree;
    global branchIDList;
    global xcosIDList;
    
//Die Herkunft des Signals wird zwischengespeichert
    
    coordinates = [];
    
    for i = 1:length(syspath.children(BranchID).children)
        if syspath.children(BranchID).children(i).attributes(1) == 'Src' //source node is saved
            m = i;
            break;
        end
    end
    n = strindex(syspath.children(BranchID).children(m).content, '#')
    outID = part(syspath.children(BranchID).children(m).content, 1:n-1); //string conversion for source signal
    outIDPort = part(syspath.children(BranchID).children(m).content, n+5:$);
    
    xIDLcc = [];
    for i = 1:length(xcosIDList(counter)(counter1))
        xIDLcc($+1) = xcosIDList(counter)(counter1)(i); //xcosIDList with corresponding layer and index gets saved to a list
    end
    
    xcosID = find(outID == xIDLcc); //outID gets matched with the corresponding xcosID
    
    if xcosID == [] then //corresponding xcosID is missing, the block has not been copied
        btn = messagebox(['A branch has been detected that cannot be placed', 'because the source block is not translatable.', 'Do you want to continue without copying said branch?'], 'Branch cannot be placed!', 'warning', ['Yes', 'No'], 'modal'); //user can abort or continue
        if btn == 2
            abort;
        end
    else //xcosID has been found
        
        orig = diagram.objs(xcosID).graphics.orig; //coordinates of sourceblock
        outSz = diagram.objs(xcosID).graphics.sz; //size of sourceblock
        for i = 1:length(syspath.children(BranchID).children)
            if syspath.children(BranchID).children(i).attributes(1) == 'Points' //vector from sourceblock to SPLIT_f
                o = i;
                break;
            end
        end
        toAdd = syspath.children(BranchID).children(o).content; //saved as a var
        convCoordinates = []; //string manipulation and conversion to doubles for SPLIT_f coordinates
        toAdd = part(toAdd, 2:$-1); 
        n = length(toAdd);
        temp = strchr(toAdd, ',');
        m = length(temp);
        strdiff = n-m;
        convCoordinates = [strtod(part(toAdd, 1:strdiff))];
        toAdd = part(temp, 3:m);
        convCoordinates = [convCoordinates, strtod(toAdd)];
        convCoordinates(2) = convCoordinates(2)*-1;
        
        outSz = outSz*0.5; //vector of middlepoint of sourceblock
        
        coordinates = convCoordinates+orig+outSz; //coordinates of sourceblock plus vector from srcblock to SPLIT_f plus middlepoint vector make the coordinates of the SPLIT_f
        
        branchBlock = SPLIT_f('define');
        
        branchBlock.model.uid = 'split'+string(nextFree); //split as id prefix to avoid multiple matching IDs
        branchBlock.graphics.sz = [7, 7]; //standart size
        branchBlock.graphics.orig = coordinates;
        
        branchXcosID = 'split_f'+string(nextFree); //uid gets saved to var before nextFree advances
        diagram.objs(nextFree) = branchBlock; //copy to diagram
        
        xcosIDList(counter)(counter1)($+1) = branchXcosID; //register in xIDL at position matching nextFree, but with modified ID
        
    //Die Verbindungsdaten des Blocks werden in der Liste branchIDList gespeichert
    //um die spätere Verknüpfung mit LINES zu ermöglichen
        
        branchDst = list();
        srcBranch = struct();
        srcBranch.ID = branchXcosID;
        srcBranch.orig = coordinates;
        srcBranch.line = syspath.children(BranchID).line;
        
        nextFree = nextFree+1;
            
        [diagram, branchDst] = existBranch(syspath.children(BranchID), branchDst, diagram, srcBranch); //big mess of recursive functions, works though, this took me forever, if problems arise, see the spartanic debugging functions
            
        dsts = list();
        n = 1
        for i = 1:length(branchDst)
            if branchDst(i).srcLine == srcBranch.line //does this destination belong to the SPLIT_f block created in this function?
                dsts(n) = branchDst(i);
                n = n+1;
            end
        end
        
        if length(dsts) == 2 //this should never be lower than two, nor higher than two, it only prevents an error
            
            outID = outID;
            outIDPort = outIDPort;
            To1 = dsts(1).To;
            To1Port = dsts(1).ToPort;
            To2 = dsts(2).To;
            To2Port = dsts(2).ToPort;
            
            branchIDList($+1) = [branchXcosID, outID, outIDPort, To1, To1Port, To2, To2Port]; //links data is stored to be copied later
            
        elseif length(dsts) > 2
            p;
            messagebox(['There has been unexpected data at','',string(whereami),'','where the variable ''dsts'' has more than two entries:','Please report this to the developer!'],'WARNING! Unexpected data!','warning','modal');
            
        else
            
             messagebox(['There has been unexpected data at','',string(whereami),'','where the variable ''dsts'' has less than two entries.','Please report this to the developer!'],'WARNING! Unexpected data!','warning','modal');
            
        end
    end
    
endfunction
