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

//Funktion die sowohl den Zähler nextFree erhöht, als auch die die UID an der Stelle der Liste xcosIDList speichert, die mit der xcosID korrespondiert

function []=endoffunction(uid)
    
    global nextFree;
    global xcosIDList;
    
    xcosIDList(counter)(counter1)($+1)=uid;
    nextFree=nextFree+1;
    
endfunction
