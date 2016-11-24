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

//fucntion logs the destination of a final branch

function [branchDst] = totoPort(branchPath, dstPath, branchDst, i, srcBranch)
    
    n = strindex(dstPath.content, '#');
    l = length(dstPath.content);
    To = part(dstPath.content, 1:n-1);
    ToPort = part(dstPath.content, n+4:l);
    
    a = struct('srcLine', srcBranch.line, 'branchPathLine', branchPath.line, 'child', i, 'To', To, 'ToPort', ToPort);
    branchDst($+1) = a;
    
endfunction
