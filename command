#!/usr/bin/python
#+
# Simple script using my Asterisk Manager library to perform a command function.
#
# Created by Lawrence D'Oliveiro <ldo@geek-central.gen.nz>.
#-

import sys
import getopt
import Asterisk

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

the_conn = Asterisk.Manager()
if debug :
    the_conn.debug = True
#end if
sys.stdout.write("the_conn opened, hello = \"%s\"\n" % the_conn.hello)
the_conn.authenticate(user, password)
response = the_conn.do_command(args[0])
sys.stdout.write(repr(response) + "\n")
the_conn.transact("Logoff", {})
the_conn.close()
