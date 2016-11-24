::
:: Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
:: Copyright (C) - 2016 – German Aerospace Center – Nils Leimbach
::
:: This file must be used under the terms of the CeCILL.
:: This source file is licensed as described in the file COPYING, which
:: you should have received as part of this distribution.  The terms
:: are also available at
:: http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
::

@echo on
echo %1
echo %2
set path=%~2
set path1=%path:~0,2%
%path1%
echo.%path1%
cd %~2
WinRAR.exe x -ibck %1.zip %~dp1
del %1.zip
exit