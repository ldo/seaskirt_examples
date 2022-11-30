#!/usr/bin/python3
#+
# Simple script using my Asterisk Manager library to perform a command function.
#
# Copyright 2010-2022 by Lawrence D'Oliveiro <ldo@geek-central.gen.nz>. This
# script is licensed CC0 <https://creativecommons.org/publicdomain/zero/1.0/>;
# do with it what you will.
#-

import sys
import getopt
import seaskirt

opts, args = getopt.getopt \
  (
    sys.argv[1:],
    "",
    ["debug", "user=", "password="]
  )
user = None
password = None
debug = False
for keyword, value in opts :
    if keyword == "--debug" :
        debug = True
    elif keyword == "--password" :
        password = value
    elif keyword == "--user" :
        user = value
    #end if
#end for
if user == None or password == None :
    raise getopt.GetoptError("--user and --password are required")
#end if
if len(args) != 1 :
    raise getopt.GetoptError("need exactly one arg, the command to perform")
#end if

the_conn = seaskirt.Manager(debug = debug)
if debug :
    sys.stdout.write("the_conn opened, hello = \"%s\"\n" % the_conn.hello)
#end if
the_conn.authenticate(user, password)
response = the_conn.do_command(args[0])
if debug :
    sys.stdout.write(repr(response) + "\n")
else :
    sys.stdout.write(response)
#end if
the_conn.transact("Logoff", {})
the_conn.close()
