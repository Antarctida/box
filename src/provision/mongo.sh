#!/bin/bash
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

if [ -n "$1" ] && [ -n "$2" ]; then
	if [ -n "$3" ]; then
		PHALCON_COUNT=$(mongo --quiet --eval "db.system.users.find({ user: 'phalcon' }).count();" admin)
		if [ ${PHALCON_COUNT} = 0 ];then
			echo "User 'phalcon' does not exist at MongoDB. Creating..."
			mongo admin --quiet --eval "$3"
		fi
	fi

	mongo $1 --quiet --eval "$2"
fi
