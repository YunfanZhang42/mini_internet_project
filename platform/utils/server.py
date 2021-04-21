#!/usr/bin/python

import sys
import argparse
import time
import hashlib
import logging
import socket
import fcntl
import struct

from bottle import request, route, run, template

#def get_ip_address(interface):
#  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
#  return socket.inet_ntoa(fcntl.ioctl(
#    s.fileno(),
#    0x8915,  # SIOCGIFADDR
#    struct.pack('256s'.encode('utf-8'), 'utf-8'), interface[:15])
#  )[20:24])

@route('/stagec/stagec.txt')
def stagec_response():
  client_ip = request.environ.get('REMOTE_ADDR')
  split_ip = client_ip.split('.')
  asn = split_ip[0]
  is_seat_host = (split_ip[1:] == ['109', '0', '1'])
  t = time.time()
  info = 'Request from {} at {} from ASN {} SEAT-host {}'.format(client_ip,t, asn, 
                                                                is_seat_host)
  info = info.encode('utf-8')
  h = hashlib.sha224(info).hexdigest()[0:10]
  logging.info('{} key {}'.format(info, h)) 
  return template('Congratulations on building your own working Internet! The completion code is {{h}}\r\n', h=h)

logging.basicConfig(filename='stagec.log',level=logging.DEBUG)
parser = argparse.ArgumentParser()
parser.add_argument('--ip', help='IP to run server on')
parser.add_argument('--interface', default='newy', help='interface to run server on if no IP given')
parser.add_argument('--port', default='4119', help='port to run server on')
args = parser.parse_args()

ip = args.ip
#if not ip:
#  ip = get_ip_address(args.interface)

run(host=ip, port=int(args.port))
