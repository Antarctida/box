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

if [ -n "$1" ]; then
	mysql -e "CREATE DATABASE IF NOT EXISTS \`$1\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci" > /dev/null 2>&1
fi

if [ -n "$2" ]; then
	echo "$2" | tee /home/vagrant/.my.cnf > /dev/null 2>&1
fi

if [ -n "$3" ]; then
	echo "$3" | tee /root/.my.cnf > /dev/null 2>&1
fi
