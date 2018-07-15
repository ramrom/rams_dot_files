#!/usr/bin/python
import urllib2
import re
import smtplib
import time
import os


topurl = "http://192.168.1.1"
url = "http://192.168.1.1/RST_status.htm"
username = "admin"
password = "bogus"
WanIP = "1.1.1.1"
newWanIP = False
#WANIP = "2.2.2.2"

sender = 'someone@@gmail.com'
receivers = ['sreeram.mittapalli@gmail.com']
message = "blank"


def getwanip():
	password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
	password_mgr.add_password(None, topurl, username, password)
	handler = urllib2.HTTPBasicAuthHandler(password_mgr)

	# create "opener" (OpenerDirector instance)
	opener = urllib2.build_opener(handler)
	opener.open(url)

	# Install the opener.
	# Now all calls to urllib2.urlopen use our opener.
	urllib2.install_opener(opener)
	res = urllib2.urlopen(url)
	html = res.read()

	#get the wan IP (should be third IP in the response object)
	p = re.compile('\d+\.\d+\.\d+\.\d+')
	pr = p.findall(html)
	
	global message
	global newWanIP
 	global WanIP

	if pr[3] != WanIP:
		WanIP = pr[3]
		newWanIP = True

	message = """From: <{0}>\nTo: <{1}>\nSubject: WAN IP\n
	The WAN IP is: {2}
	""".format(sender,receivers[0],WanIP)


#Email it my account
def sendwanemail():
	smtpObj = smtplib.SMTP('smtp.gmail.com')  #mail01.smsi.com
	smtpObj.starttls()
	smtpObj.login(sender,'Blazin234')
	smtpObj.sendmail(sender, receivers, message)
	smtpObj.close()

#this will write the new WanIP to this file script itself
def writeselfwan():
	fs = open(os.path.abspath(__file__), 'r+')
	fil = fs.read()
	p = re.compile("WanIP = \"\d+\.\d+\.\d+\.\d+\"")
	fil = re.sub(p,"WanIP = " + "\"" + WanIP + "\"",fil)
	fs.seek(0)
	fs.write(fil)
	fs.close()    

def savewaniptoregistry():
	if os.name == 'nt':
		import _winreg
		 		
		


getwanip()
#If the WanIP changes then send an email and store the new Wan IP in this file
if newWanIP == True:
	sendwanemail()
	writeselfwan()
