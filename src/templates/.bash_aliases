#!/usr/bin/env bash
#
# Phalcon Box
#
# Copyright (c) 2011-2017, Phalcon Framework Team
#
# The contents of this file are subject to the New BSD License that is
# bundled with this package in the file LICENSE.txt
#
# If you did not receive a copy of the license and are unable to obtain it
# through the world-wide-web, please send an email to license@phalconphp.com
# so that we can send you a copy immediately.
#

alias cls=clear

function _psgrep
{
	if [ -z $1 ]; then
		echo -e "Usage: psgrep <appname> | awk '{print \$2}' | xargs kill"
	else
		ps aux | grep $1 | grep -v grep
	fi
}

alias psgrep="_psgrep"
