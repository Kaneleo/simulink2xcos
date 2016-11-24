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

function [] = appendStyleXml()
    
    ind = 0; //who needs bools when you have 1s and 0s?
    styleXml = xmlRead(SCI + '/modules/xcos/etc/Xcos-style.xml'); //load the style xml
    for i = 1:length(styleXml.root.children)
        if styleXml.root.children(i).attributes(1) == 'scifunc_block_m_no_label' //checks for the node that needs to be added
            ind = 1;
            break;
        end
    end
    
    if ind == 0 then //node was not found
        newChild = xmlReadStr('<add as = '"scifunc_block_m_no_label'" extend = '"blockWithLabel'"><add as = '"displayedLabel'" value = '"Fcn'"/></add>');
        xmlAppend(styleXml.root, newChild.root); //node is added
        xmlWrite(styleXml, SCI + '/modules/xcos/etc/Xcos-style.xml'); //xml is saved
    end
    
endfunction
