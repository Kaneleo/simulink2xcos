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

function [xmlDoc] = slxToXml_win()
    
    flag1 = 0;
    
    try //loads batch variable if existing
        load(filepath + 'MISC\batch.sod', 'batch');
    catch //initializes the batch variable
        batch = struct();
        tool = messagebox(['The archive configuartion file could not be found.', 'Archive tool needs to be reconfigured.', 'Which archiving rool do you have installed on your PC?'], 'Archive configuration', 'warning', ['7zip', 'WinRAR', 'neither'], 'modal');
        select tool
        case 1
            archivePath = uigetfile('7z.exe', 'C:', 'Select 7z.exe', %f);
            batch.tool = 1;
            batch.archivePath = archivePath;
        case 2
            archivePath = uigetfile('WinRAR.exe', 'C:', 'Select WinRAR.exe', %f);
            archivePath = part(archivePath, 1:$-11);
            batch.tool = 2;
            batch.archivePath = archivePath;
        case 3
            batch.tool = 3;
            flag1 = 1;
        end
        save(filepath + 'MISC\batch.sod', 'batch');
    end
    

        
    messagebox(["Please select your SLX file."],'modal');
    slxFile = uigetfile('*', home, 'SLX file', %f); //gets filepath of slx file
    n = strindex(slxFile, '\'); //string manipulation to the blockdiagram.xml
    n = n($);
    try
        xmlFile = part(slxFile, 1:n) + 'simulink\blockdiagram.xml'
    catch
        messagebox('ERROR!','ERROR','modal');
        abort;
    end
    
    bat1Filepath = filepath + 'MISC\SLX_to_XML.bat'; //gets filepath of batch file
    bat2Filepath = filepath + 'MISC\SLX_to_XML_7zip.bat';
    bat3Filepath = filepath + 'MISC\SLX_to_XML_winrar.bat';
        
    flag = 0; //used to determine wether there was an error
    
    if batch.tool ~= 3 then
        
        try
            dosCommand = 'cmd.exe /c '"'"' + bat1Filepath + ''" ' + slxFile + ' ' + string(batch.tool) + ' '"' + string(batch.archivePath) + ''"'"';
            sevenzipCommand = 'cmd.exe /c '"'"' + bat2Filepath + ''" '"' + slxFile + ''" '"' + string(batch.archivePath) + ''"'"';
            winrarCommand = 'cmd.exe /c '"'"' + bat3Filepath + ''" '"' + slxFile + ''" '"' + string(batch.archivePath) + ''"'"';
//            dosCommand = 'START '"SLX to XML'" '"' + batFilepath + ''" CALL ' + slxFile + ' ' + string(batch.tool) + ' '"' + string(batch.archivePath) + ''"'
            if dos(dosCommand)
                if batch.tool == 1
                    dos(sevenzipCommand);
                elseif batch.tool == 2
                    dos(winrarCommand);
                end
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
endfunction
