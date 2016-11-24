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

//syspath is defined as the upmost XML-node 'System'

function [syspath]=findSystem()
    
    global xmlDoc;
    
    childNo=find(xmlDoc.root.children(1).children.name=='System')
    
    syspath=xmlDoc.root.children(1).children(childNo);
    
endfunction
