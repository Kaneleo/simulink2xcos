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

//Use this function to pause right before an error occurs
//First insert the function dbug(0) into whichever line you want to pause at
//Second you run the program, and change the 0 in the dbug call to whatever number was the last return
//the execution will pause right before the error, so that variables can be examined to determine the source of error

//Especially usefull if a function is called successfully multiple times before generating an error
//rather than putting a pause into the function and having to resume each time, this allows the function to work until before the error

//I realize this could have been done with try catch commands, but i didn't know until just now so yeah

function [] = dbug(dumb)
    global debugger;
    debugger = debugger+1;
    if dumb ~= 0 then
        if debugger == dumb; //+1 maybe?
            pause;
        end
    else
        disp(debugger);
    end
endfunction
