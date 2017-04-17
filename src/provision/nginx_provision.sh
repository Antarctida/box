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

# trace ERR through pipes
set -o pipefail

# trace ERR through 'time command' and other functions
set -o errtrace

# set -u : exit the script if you try to use an uninitialised variable
set -o nounset

# set -e : exit the script if any statement returns a non-true return value
set -o errexit

if [ -n "$1" ] && [ ! -z ${TPL_SERVER_NAME+x} ]; then
	echo "$1" | tee "/etc/nginx/sites-available/${TPL_SERVER_NAME}"  > /dev/null 2>&1
	goreplace --mode=template "/etc/nginx/sites-available/${TPL_SERVER_NAME}"

	ln -fs "/etc/nginx/sites-available/${TPL_SERVER_NAME}" "/etc/nginx/sites-enabled/${TPL_SERVER_NAME}"

	/usr/sbin/nginx -t
fi
