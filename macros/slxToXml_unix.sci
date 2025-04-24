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

function [xmlDoc] = slxToXml_unix()
    
    flag1 = 0;

    global filepath;
    
    messagebox(["Please select your SLX file."],'modal');
    slxFile = uigetfile('*', home, 'SLX file', %f); //gets filepath of slx file
    n = strindex(slxFile, '/'); //string manipulation to the blockdiagram.xml
    n = n($);
    slxFileDir = part(slxFile, 1:n);

    //initializes the batch variable
    batch = struct();
    batch.tool = 0;
    
    status = unix("which 7z");
    if status ~= 0 then
        status = unix("which unzip");
        if status ~= 0 then
            messagebox(["unzip and 7z is not installed or not found in PATH.", "Please install unzip or add it to your PATH."], "Error", "error", "modal");
            flag1 = 1;
            abort;
        else
            batch.tool = 2;
            batch.archivePath = 'unzip';
            unzipCommand = 'unzip -o ' + slxFile + ' -d ' + slxFileDir;
        end
    else
        batch.tool = 1;
        batch.archivePath = '7z';
        sevenzipCommand = '7z x -aoa ' + slxFile + ' -o' + slxFileDir;
    end




    save(filepath + 'MISC/batch.sod', 'batch');
        
    flag = 0; //used to determine wether there was an error

    if batch.tool ~= 0 then
        
        try
            if batch.tool == 1
                unix(sevenzipCommand);
            elseif batch.tool == 2
                unix(unzipCommand);
            else
                messagebox(['You do not have a supported archive tool installed.', 'Please unpack the slx file manually by following these steps:', '', '1. Duplicate the SLX file and change the file ending to zip.', '2. Extract the contents of the archive with an appropriate tool.', '3. Click OK when done.'], 'No supported archive tool available', 'warning', 'modal');
                abort;
            end

            try
                xmlFile = slxFileDir + 'simulink\blockdiagram.xml'
            catch
                messagebox('ERROR!','ERROR','modal');
                abort;
            end
        catch //in case the dos doesn't work, the XML has to be entered manually
            messagebox(['The SLX could not be converted.', 'Please do the following:', '', '1. Duplicate the SLX file and change the file ending to zip.', '2. Extract the contents of the archive with an appropriate tool.', '3. Click OK when done.'], 'Conversion error!', 'error', 'modal');
            xmlDoc = xmlRead(uigetfile('*', part(slxFile, 1:n), "Please select the file \simulink\blockdiagram.xml", %f));
            flag = 1;
        end
        
        if flag == 0 then //if the dos succeeded
            
            try
                xmlDoc = xmlRead(xmlFile); //read the XML
            catch //read does'nt work, input manually
                messagebox(['The XML file could not be read', 'Please select the file \simulink\blockdiagram.xml manually.'], 'XML file could not be read', 'warning', 'modal');
                try
                    xmlDoc = xmlRead(uigetfile('*', part(slxFile, 1:n), "Please select the file \simulink\blockdiagram.xml", %f));
                catch
                    messagebox('ERROR!', 'ERROR', 'error', 'modal');
                    abort
                end
            end
        end
    else
        messagebox(['You do not have a supported archive tool installed.', 'Please unpack the slx file manually by following these steps:', '', '1. Duplicate the SLX file and change the file ending to zip.', '2. Extract the contents of the archive with an appropriate tool.', '3. Click OK when done.'], 'No supported archive tool available', 'warning', 'modal');
        try
            messagebox('Please select the file \simulink\blockdiagram.xml', 'blockdiagram.xml', 'modal');
            xmlDoc = xmlRead(uigetfile('*', part(slxFile, 1:n), 'blockdiagram.xml', %f));
        catch
            messagebox('ERROR!', 'ERROR', 'error', 'modal');
            abort;
        end
    end

        
    flag = 0; //used to determine wether there was an error
    
    
endfunction
