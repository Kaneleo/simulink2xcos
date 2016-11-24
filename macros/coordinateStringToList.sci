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

//manipulates the string to a four entry list

function [convCoordinates] = coordinateStringToList(slcoordinates)
    
    convCoordinates = [];
    n = length(slcoordinates);
    slcoordinates = part(slcoordinates,2:(n-1));
    
    for i = 1:3
        
        n = length(slcoordinates);
        temp = strchr(slcoordinates,','); //the data is divided by commas, here it is used to analyze the string
        m = length(temp);
        strdiff = n-m;
    
        convCoordinates = [convCoordinates,part(slcoordinates,1:strdiff)];
    
        slcoordinates = part(temp,3:m);
        
    end
    
    convCoordinates = [convCoordinates,slcoordinates]; //last data entry doesn't have a comma after it, so it is copied seperately
    convCoordinates = strtod(convCoordinates);
    
endfunction
