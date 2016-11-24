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

bn = messagebox(['You are about to change the archive configuration', 'Are you sure you want to continue?'], 'Change configuration', 'warning', ['Yes', 'No'], 'modal');

if bn == 2 then
    abort;
end

filepath = get_absolute_file_path('configChange.sce');
load(filepath + 'batch.sod', 'batch');

if batch.tool == 1 then
    currentTool = '7zip';
elseif batch.tool == 2
    currentTool = 'WinRAR';
end
if batch.tool ~= 3 then
    bn = messagebox(['Your current archive tool is:', '', currentTool, '', 'Click your current tool to update its path', 'or click another one to change your archive tool'], 'Change configuration', 'scilab', ['7zip', 'WinRAR', 'neither'], 'modal');
else
    bn = messagebox(['Click the archive tool you want to use.'], 'Change configuration', 'scilab', ['7zip', 'WinRAR', 'neither'], 'modal');
end

select bn
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
        batch.archivePath = [];
        batch.tool = 3;
end
save(filepath + 'batch.sod', 'batch');
