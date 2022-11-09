#!/usr/bin/python
#+
# Simple script using my Asterisk Manager library to perform a command function.
#
# Created by Lawrence D'Oliveiro <ldo@geek-central.gen.nz>.
#-

import sys
import getopt
import Asterisk

(Opts, Args) = getopt.getopt \
  (
    sys.argv[1:],
    "",
    ["debug", "user=", "password="]
  )
User = None
Password = None
Debug = False
for Keyword, Value in Opts :
    if Keyword == "--debug" :
        Debug = True
    elif Keyword == "--password" :
        Password = Value
    elif Keyword == "--user" :
        User = Value
    #end if
#end for
if User == None or Password == None :
    raise getopt.GetoptError("--user and --password are required")
#end if
if len(Args) != 1 :
    raise getopt.GetoptError("need exactly one arg, the command to perform")
#end if

TheConn = Asterisk.Manager()
if Debug :
    TheConn.debug = True
#end if
sys.stdout.write("TheConn opened, hello = \"%s\"\n" % TheConn.hello)
TheConn.authenticate(User, Password)
Response = TheConn.do_command(Args[0])
sys.stdout.write(repr(Response) + "\n")
TheConn.transact("Logoff", {})
TheConn.close()
