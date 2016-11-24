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

//global debugger; //needs to be uncommented if the dbug() functions will be used
//debugger=0;
//version = '1.0'

appendStyleXml(); //adds a style for a function block with long functions to the style xml, has to be removed manually if needed

global pi;
pi = %pi;
global e;
e = %e;

global layer; //variable indication the current layer of the diagram, the main one being 1 and subsequent diagrams in Superblocks being 2,3,...
layer = 0;

global clockReminder;
clockReminder = 0;

global filepath;
filepath = get_absolute_file_path('simulink2xcos.sce'); //to load all functions, the directory has to be determined
getd(filepath);
filepath1 = filepath + 'MISC\'; //the functions in MISC need to be loaded too
getd(filepath1);

loadXcosLibs();

global xmlDoc;
xmlDoc = slxToXml(); //loads XML file

btn = messagebox(['If your simulink diagram uses external parameters that are defined in one or multiple M file(s)', 'you will have to load these prior to continuing.', 'Not loading these files will likely produce an error breaking the tool.', 'Do you have M file(s) that need to be loaded?'], 'Load external parameters', 'scilab', ['Yes', 'No'], 'modal');
if btn == 1
    loadMFiles();
end

global syspath; //variable which equals to the node number of the XML-node 'System'
syspath = findSystem();

global nextFree; //variable which is equal to the next unassigned Entry in the OBJS list of the current scicos_diagram
nextFree = 1;

global xcosIDList; //list which includes a list for every  layer, containing lists for every diagram on said layer
xcosIDList = list(); //these lists include the simulink SID of every Block in the order in which they were inserted into the scicos_diagram

global scs_m;
scs_m = [];
scs_m = scs_mSetup(); //scs_m.props gets initialized

global subsyspath; //a list of layers each including a list for every subdiagram; these lists contain the XML-elements of the Superblock,
subsyspath = list(); //the System and the line of the parent system
subsyspath = findSubsys(syspath, 0, subsyspath);

global busList
busList = xmlDocument();
busList.root = xmlElement(busList, 'BusList');
busSystem();

removeTriplesPrep(); //function changes XML-tree so that a branch can only have 2 subbranches
//xmlDoc gets relaoded at the end of the function

syspath = findSystem();

subsyspath = list(); //variable gets redefined, because lines change when reloading xmlDoc
subsyspath = findSubsys(syspath, 0, subsyspath);

scs_m = parsing(scs_m, 1, 1); //first layer is parsed from the XML-file and implemented in the scicos_diagram

if length(subsyspath) > 0 then //should there be sublayers
    scs_m = subsysParsingPrep(scs_m); //these are parsed
end

xcos(scs_m); //the scicos_diagram is loaded into xcos and displayed
