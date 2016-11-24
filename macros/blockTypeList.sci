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

//list of all supported blocks

function [blockTypeList] = blockTypeList()
    
    blockTypeList = ['Constant', 'Integrator', 'Gain', 'Sum', 'ToWorkspace', 'Mux', 'Demux', 'Goto', 'From', 'SubSystem', 'Inport', 'Outport', 'Product', 'Scope', 'Derivative', 'Trigonometry', 'Reference', 'Fcn', 'BusCreator', 'BusSelector', 'BusAssignment'] //this function might be changed to load a file if the list of supported blocks becomes to great or unmanageable for a function    
//    'BusCreator'
endfunction
