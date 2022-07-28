#!/usr/bin/env python3
# craig for MCH2022 CTF
# first part only, we do a binary search for P
# second part: calculate a + b (https://github.com/jvdsn/crypto-attacks/blob/master/attacks/ecc/parameter_recovery.py ??)
# third part, smart attack (https://github.com/jvdsn/crypto-attacks/blob/master/attacks/ecc/smart_attack.py)

import argparse
import socket
import time
import random
import _thread
import datetime
import os
import sys


def sendstuff(host,port,sendstring):
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sock.connect((host, port))
  answer = sock.recv(1024)
  sock.send(sendstring.encode())
  answer = sock.recv(1024)
  sock.close()
  return(answer)

def binary_search(start, end):
    low = start
    high = end
    mid = 0
 
    while low <= high:
 
        mid = (high + low) // 2
        os.system("clear")
        print("Hacking the gibson.")
        print("high: %s" % high)
        print(" low: %s" % low)
        print(" mid: %s" % mid)

        # If x is greater, ignore left half
        result=sendstuff("curvy.ctf.zone",6011,str(mid))
        
        if str(result).find("Nope")>0:
            low = mid + 1

        # If x is smaller, ignore right half
        elif str(result).find("Sorry")>0:
            high = mid - 1

        # means x is present at mid
        else:
            return mid

    # If we reach here, then the element was not present
    return -1

binary_search(1,1000000000000000000000000000000000000)

