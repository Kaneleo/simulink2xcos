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

//function copies every element deemed parsable plus branches and links

function [diagram] = parsing(diagram, counter, counter1)
    
    global scs_m;
    global nextFree;
    global dueLinks;
    global xcosIDList;
    
    if size(xcosIDList) < counter then //add a layer to xcosIDList if it isn't present already
        xcosIDList(counter) = list();
    end
    xcosIDList(counter)(counter1) = list() //add list to the current layer whose index will correspond to the diagram that's to be created
    [nonParseList, ParseList] = parserCheck();
    dueLinks = list(); //init necessary
    
    global branchIDList; //list which contains every branch in the corresponding diagram with the elements that can be seen two lines down
    branchIDList = list();
    branchIDList(1) = (['xcosID', 'outID', 'outIDPort', 'To1', 'To1Port', 'To2', 'To2Port']);
    
    btn = parserMsg(); //confirm continue if non supported blocks present

    if btn == 2 then //user chooses abort
        
        abort;
        
    end
//    disp(ParseList);
    for i = 1:length(ParseList) //every item on the parselist
//        dbug(36);
        n = ParseList(i);
        
        select syspath.children(n).attributes(1) //blocktype calls corresponding copy function
        
        case 'Constant'
            
            diagram = copyConstant(n, diagram);
            
        case 'Integrator'
            
            diagram = copyIntegral(n, diagram);
            
        case 'Gain'
            
            diagram = copyGain(n, diagram);
            
        case 'Sum'
            
            diagram = copySum(n, diagram);
            
        case 'ToWorkspace'
            
            diagram = copyToWorkspace(n, diagram);
            
        case 'Mux'
            
            diagram = copyMux(n, diagram);
            
        case 'Demux'
            
            diagram = copyDemux(n, diagram);
            
        case 'Goto'
            
            diagram = copyGoto(n, diagram);
            
        case 'From'
            
            diagram = copyFrom(n, diagram);
            
        case 'SubSystem'
            
            diagram = copySubSystem(n, diagram);
            
        case 'Inport'
            
            diagram = copyInport(n, diagram);
            
        case 'Outport'
            
            diagram = copyOutport(n, diagram);
            
        case 'Product'
            
            diagram = copyProduct(n, diagram);
            
        case 'Scope'
            
            diagram = copyScope(n, diagram);
            
        case 'Derivative'
            
            diagram = copyDerivative(n, diagram);
            
        case 'Trigonometry'
            
            diagram = copyTrigonometry(n, diagram);
            
        case 'Reference'
            
            diagram = copyReference(n, diagram);
            
        case 'Fcn'
            
            diagram = copyFcn(n, diagram);
            
        case 'BusCreator'
            
            diagram = copyBuscreator(n, diagram);
            
        case 'BusSelector'
            
            diagram = copyBusselector(n, diagram);
            
        case 'BusAssignment'
            
            diagram = copyBusAssignment(n, diagram);
            
        end
    end
//    for i = 1:length(ParseList)
//        n = ParseList(i);
//        if syspath.children(n).attributes(1) == 'BusSelector'
//            diagram = copyBusselector(n, diagram);
//        end
//    end

    branchList = findBranch(); //branches loaded
    
    for i = 1:length(branchList)
        
        diagram = copyBranch(branchList(i), diagram); //copy every branch possible
        
    end
    
    lineEntryPosition = findLine(); //only the lines without branches are loaded
    
    for i = 1:length(lineEntryPosition);
    
        [w, from, to] = copyLine(lineEntryPosition(i), diagram); //from and to are loaded so that it can be determined wether the link is valid
        from = string(from);
        to = string(to);
        
        if lineDrawable() //both from block and to block are already present in diagram
            
            diagram = copyLine(lineEntryPosition(i), diagram); //inserts link into the diagram
            
            nextFree = nextFree+1;
            
        end
        
    end
    
    for i = 2:length(branchIDList)
        
        if cBLpossible(branchIDList(i)(1)) then //like line 128 but with two destinations
            
            diagram = copyBranchLine(branchIDList(i)(1), diagram);
            
        end
        
    end
    
    for i = 1:length(dueLinks)
        
        diagram.objs(nextFree) = dueLinks(i); //links in the dueLinks list are created
        nextFree = nextFree+1;
        
    end
    
endfunction
