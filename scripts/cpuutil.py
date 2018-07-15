# *** Why is the wmic text output have wierd characters? 

import subprocess
import time
import re

prevsum = 0
timeint = 1
proc = 'system idle process'

while True:
	prochan = subprocess.Popen('wmic process where name="{0}" get kernelmodetime,usermodetime'.format(proc), \
		shell=True,stdout=subprocess.PIPE)
	#prochan = subprocess.Popen('wmic process get kernelmodetime,usermodetime', shell=True,stdout=subprocess.PIPE)
		
	c = re.findall('[\d]+',prochan.stdout.read())
	
	'''
	csum = sum([int(item) for item in c])
	print float(csum - prevsum)/24000000
	prevsum = csum
	'''
	
	sum = int(c[0]) + int(c[1])
	print 'percent usage by {0}:'.format(proc), float(sum - prevsum) / (timeint*24000000)
	prevsum = sum
	time.sleep(timeint)
	
