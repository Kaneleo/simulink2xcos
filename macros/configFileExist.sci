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

//checks wether file 'xonfigSet0.xml' exists

function [bn,path]=configFileExist()
    
    global xmlDoc;
    
    path=xmlDoc.url;
    fileStr=strrchr(path,'/');
    slashPos=strindex(path,fileStr);
    path=part(path,9:slashPos-1);
    files=dir(path);
    bn=isPart(files(2),'configSet0.xml');
    
endfunction
