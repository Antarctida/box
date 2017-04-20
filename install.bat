@echo off
rem
rem Phalcon Box
rem
rem Copyright (c) 2011-2017, Phalcon Framework Team
rem
rem The contents of this file are subject to the New BSD License that is
rem bundled with this package in the file LICENSE.txt
rem
rem If you did not receive a copy of the license and are unable to obtain it
rem through the world-wide-web, please send an email to license@phalconphp.com
rem so that we can send you a copy immediately.
rem
cls

If Not Exist %cd%\settings.yml (
    copy /-y %cd%\src\templates\settings.yml %cd%\settings.yml
)

If Not Exist %cd%\after_provision.sh (
    copy /-y %cd%\src\templates\after_provision.sh %cd%\after_provision.sh
)

If Not Exist %cd%\.bash_aliases (
    copy /-y %cd%\src\templates\.bash_aliases %cd%\.bash_aliases
)

echo
echo Phalcon Box initialized
echo
