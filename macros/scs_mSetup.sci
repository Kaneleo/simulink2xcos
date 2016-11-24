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

//scs_m.props is filled with the corresponding XML-data

function [scs_m] = scs_mSetup()
    
    global xmlDoc;
    global scs_m;
    
    scs_m = scicos_diagram(); //init of scs_m
    
//!title
//the title is set to the name of the slx file in the parent folder of the xmlDoc
//or, if there is more than one slx document, is requested from the user
    
    path = part(xmlDoc.url, 9:$-25); //name of xmlDoc and the lowest directory are removed
    cont = dir(path); //contend is scanned
    lengthCont = size(cont(2));
    lengthCont = lengthCont(1)
    slx = [];
    for i = 1:lengthCont; //every file or folder in the folder
        n = strindex(cont(2)(i),'.slx') //position of ending '.slx' if existing
        if n ~= [] //ending '.slx' was found
            slx($+1) = i; //index of file is logged
        end
    end
    if length(slx) > 1 then //more than one .slx file
        scs_m.props.title = string(x_dialog('Enter project name.','project_name')); //user input for prohject name
    elseif length(slx) < 1 then //no slx file
        scs_m.props.title = string(x_dialog('Enter project name.','project_name')); //user input for prohject name
    else
        scs_m.props.title = part(cont(2)(slx), 1:$-4); //name of the .slx file without the file ending
    end
    
//if the title is empty xcos() does not work on scs_m, the diagram will be empty although the blocks are in scs_m
    
    [bn, path] = configFileExist(); //checks existance of 'configSet0.xml', provides the path of the folder which might include the file
    if bn == %t then //file exists
        scs_m.props.tf = extractTF(path); //timeframe gets extracted from different XML-file
    else //timeframe gets extracted from xmlDoc
        
//tf
        
        i = 1;
        while i > 0
            if xmlDoc.root.children(1).children(i).name == 'ConfigurationSet'
                confSet = i;
                break;
            else
                i = i+1;
            end
        end
        
        i = 1;
        while i > 0
            if xmlDoc.root.children(1).children(confSet).children(i).name == 'Array'
                arr = i;
                break;
            else
                i = i+1;
            end
        end
        
        i = 1;
        while i > 0
            if xmlDoc.root.children(1).children(confSet).children(arr).children.name == 'Object'
                obj = i;
                break;
            else
                i = i+1;
            end
        end
        
        i = 1;
        while i > 0
            if xmlDoc.root.children(1).children(confSet).children(arr).children(obj).children(i).name == 'Array'
                arr1 = i;
                break;
            else
                i = i+1;
            end
        end
        
        bn = %f;
        i = 1;
        while i > 0
            if xmlDoc.root.children(1).children(confSet).children(arr).children(obj).children(arr1).children(i).name == 'Object'
                for j = 1:length(xmlDoc.root.children(1).children(confSet).children(arr).children(obj).children(arr1).children(i).attributes)
                    if xmlDoc.root.children(1).children(confSet).children(arr).children(obj).children(arr1).children(i).attributes(j) == 'Simulink.SolverCC'
                        bn = %t
                    end
                end
                if bn == %t
                    obj1 = i;
                    break;
                else
                    i = i+1;
                end
            else
                i = i+1;
            end
        end
        
        i = 1;
        while i > 0
            if xmlDoc.root.children(1).children(confSet).children(arr).children(obj).children(arr1).children(obj1).children(i).attributes(1) == 'StopTime'
                stopTime = i;
                break;
            else
                i = i+1;
            end
        end
        
        scs_m.props.tf = strtod(xmlDoc.root.children(1).children(confSet).children(arr).children(obj).children(arr1).children(obj1).children(stopTime).content);
    end
    
endfunction
