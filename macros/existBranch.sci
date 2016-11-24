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

//function checks for the existance of a branch in a node, and decides upon further actions
//commented disp() function are for debugging purposes

function [diagram, branchDst] = existBranch(branchPath, branchDst, diagram, srcBranch)
    
//global layer; //also debugging related
//layer = layer+1; //dito
//disp('LAYER: '+string(layer));
//disp('BRANCHPATH');
//disp(branchPath);
//disp('BRANCHDST');
//disp(branchDst);
//disp('SRCBRANCH');
//disp(srcBranch);
    
    port = 1; //every port can support one link, when port 1 has been linked, port will be advanced
    i = 1;
    while i <= length(branchPath.children)
        
//disp('i = '+string(i));
        
        if branchPath.children(i).name == 'Branch' //is a branch?
            
//disp('condition 1, child is a branch');

        j = 1;
        n = 0;
            while j <= length(branchPath.children(i).children)
                
//disp('j = '+string(j));
                
                if branchPath.children(i).children(j).name == 'Branch' & n == 0 //subnode is a branch and no subbranch has been found yet?
                    
//disp('condition 2, branch includes branch');

                    srcBranch.port = port;
                    [diagram, branchID] = copyBranchception(branchPath.children(i), srcBranch, diagram); //oh boy, recursion here we go
                    a = struct('srcLine', srcBranch.line, 'branchPathLine', branchPath.children(i).line, 'child', i, 'To', string(branchID), 'ToPort', '1'); //information is prepared to be saved and transported
                    
//disp('EXISTBRANCH');
//disp('LAYER: '+string(layer));
//disp('BRANCHPATH');

                    branchDst($+1) = a; //and put into a container with every info about the branches destinations
                    
//disp(branchDst($));

                    port = port + 1; //port is advanced so every port only connects to one link
                    n = j; //n gets a value so that there wont't be another SPLIT_f; for two branch nodes (ergo branch destinations) there needs to be one SPLIT_f
                    
                end
                
//disp('n = '+string(n));
//disp(branchDst);
                
                if branchPath.children(i).children(j).attributes(1) == 'Dst' & j ~= n //destination data and not already run through copyBranchception?
                    
//disp('condition 3, no branch in branch');

                    branchDst = totoPort(branchPath.children(i), branchPath.children(i).children(j), branchDst, i, srcBranch);
                    
//disp('EXISTBRANCH');
//disp('LAYER: '+string(layer));
//disp('BRANCHPATH');

                    port = port+1; //see line 46
                end
                j = j+1;
            end
        end
    i = i+1;
    end
endfunction
