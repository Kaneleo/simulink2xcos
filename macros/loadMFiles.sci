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

function [] = loadMFiles()
    
    global xmlDoc;
    
    path = part(xmlDoc.url, 9:$);
    n = strindex(path, '/');
    n = n($-1);
    path = part(path, 1:n);
    
    mFiles = uigetfile('*.m', path, 'Load external files', %t);
    n = size(mFiles);
    n = n(2);
    
    for i = 1:n
        mfile2sci(mFiles(i), path);
        mFileName = part(mFiles(i), 1:$-1) + 'sci';
        o = strindex(mFileName, '\');
        o = o($);
        mFileName = part(mFileName, o+1:$);
        
        try
            exec(path + mFileName);
        catch
            messagebox(['The converted M file could not be executed.', 'The tool will try to run without said file, if an error is produced,', 'you will have to manually set the parameters from the M file(s).'], 'M file could not be executed', 'scilab', 'modal');
        end
    end
    
endfunction
