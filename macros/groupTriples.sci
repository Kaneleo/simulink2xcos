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

function []=groupTriples(branchPath)
    
    global xmlDoc;
    
    branches=[];
    
    for i = 1:length(branchPath.children)
        if branchPath.children(i).name == 'Branch' //is a branch?
            branches($+1) = i; //add to list of branches
        end
    end
    
    a=branchPath.children(branches(1)); //first two branches copied to vars
    b=branchPath.children(branches(2));
    
    c=xmlElement(xmlDoc, 'Branch'); //new XML-element 'Branch'
    c.name='Branch';
    
    d=xmlElement(xmlDoc, 'P'); //Subnode P for 'Points'-data
    d.attributes.Name='Points';
    d.content='[5, 5]'
    d.name='P'
    
    c.children(1)=a; //the two first branches and the 'Points'-data are added to the new Branch
    c.children(2)=b;
    c.children(3)=d;
    
    branchPath.children(branches(1))=c; //new branch replaces first old branch
    xmlRemove(branchPath.children(branches(2))); //second old branch is deleted, third remains
    
endfunction
