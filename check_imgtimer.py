#!/usr/bin/python2
# -*- coding: utf-8 -*-
import urllib2
import getopt
import random
import time
import socket
import math
import sys
import re

curlmode = None
curlurl = None
curliter = None
curlportal = None
usecdn = None
socket.setdefaulttimeout(80)
#Takes a random page
page = random.Random().randint(1,40)

myopts, args = getopt.getopt(sys.argv[1:],"u:m:i:p:c:")
for o, a in myopts:
	if o == '-u':
		curlurl=a
	elif o == '-m':
		curlmode=a
	elif o == '-p':
		curlportal=a
	elif o == '-i':
		curliter=a
	elif o == '-c':
		usecdn=a

if None in (curlmode, curlurl, curliter, curlportal, usecdn):
	print 'Usage: ./imgtimer.py -u server_url -m curl mode (balanced/single) -i number of iterations -p portal (one/two/three) -c Use cdn? (akamai/nginx)' 
	exit(2)

#Replaces akamai for static
if usecdn in ['Akamai', 'akamai']:
	USE_STATIC = False
elif usecdn in ['Nginx','nginx']:
	USE_STATIC = True

#Akamai url hardcoded :(
def akamaiurl(curlportal):
	return {
		'one': 'akamai.domainone.com',
		'two': 'akamai.domaintwo.com',
		'three': 'akamai.domainthree.com',
		}.get(curlportal)
AKAMAI = akamaiurl(curlportal)	

#We know static content is in another port. We'll use that if we're not through balancer
if curlmode in ['Single', 'single']:
	STATIC2 = curlurl + ':67'
if curlmode in ['Balanced', 'balanced']:
	STATIC2 = curlurl
IMAGES = int(curliter)

#Specific url depending on website
def portal(curlportal):
    return {
        'one': 'http://www.domainone.com/listing-' + str(page) + '.html',
        'two': 'http://www.domaintwo.com/listing-' + str(page) + '.html', 
        'three' : 'http://www.domainthree.com/listing-' + str(page) + '.html',
    }.get(curlportal)  

page_url = portal(curlportal)
before = time.time() 
search_results = urllib2.urlopen(page_url).read()
after = time.time()
if curlportal == 'domainone':
	images = re.findall('data-lazy="([^"]+)" width="280" class="rsTmb rsHide"', search_results)
else:
	images = re.findall('<a class="rsImg rsMainSlideImage rsHide" href="([^"]+)">', search_results)

if len(images) > IMAGES:
	images = images[:IMAGES]

timings = []
errors = 0
cache_misses = 0
count = 0

for image in images:
	try:
		if USE_STATIC:
			image = image.replace(AKAMAI, STATIC2)
		count = count + 1
		#print '[' + str(count) + '/' + str(len(images)) + ']', image #Intended for debugging 
		####DEBUGprint image
		before = time.time()
		u = urllib2.urlopen(image)
		data = u.read()
		u.close()
		after = time.time()
		t = int(math.ceil((after - before) * 1000))
		timings.append(t)
	except Exception, e:
		###DEBUGprint e
		errors = errors + 1

err_rate = str((errors/(len(images)))*100)
timing_data = ' Median time: ' + str(timings[len(timings)/2]) + 'ms Max time: ' + str(max(timings)) + 'ms Avg time: ' + str(sum(timings) / len(timings)) + 'ms | median=' + str(timings[len(timings)/2]) + ' avg=' + str(sum(timings) / len(timings))

if errors > 10:
	print 'CRITICAL - Error rate ' + err_rate + '%' + timing_data
	exit(2)
else:
	print 'OK - Error rate ' + err_rate + '%' + timing_data
	exit(0)
