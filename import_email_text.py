import imaplib
import email
import codecs
import os
import email.utils
from email.parser import HeaderParser
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from datetime import datetime
import time
import email.header
from optparse import OptionParser
#######################################
# Fill in these details!!!
# mail means "connection"
#######################################

email_address="allison.berman@gmail.com"
password=""
destination_folder="pyemails"

#######################################
# The code begins...
# Worked for "Sent Mail"  
#######################################
def parseDate(date):  #find out where to call this - only if splitting header?
  timetuple = email.utils.parsedate_tz(date)
  return "%04d%02d%02d%02d%02d%02d" % timetuple[0:6]

os.makedirs(destination_folder)

mail = imaplib.IMAP4_SSL('imap.gmail.com')
mail.login(email_address, password)  #user / password
mail.select("[Gmail]/Sent Mail") # connect to folder with matching label - sent mail vs all vs draft etc

result, data = mail.uid('search', None, "ALL") # search and return uids instead
i = len(data[0].split())

for x in range(i):
    latest_email_uid = data[0].split()[x]
    result, email_data = mail.uid('fetch', latest_email_uid, '(RFC822)')
    raw_email = email_data[0][1]
    email_message = email.message_from_string(raw_email) #added content type check below
    for part in email_message.walk():  #.walk() - check if email_message.get_content_maintype() == 'multipart' first?
        c_type = part.get_content_type()
        c_disp = part.get('Content-Disposition')

        if c_type == 'text/plain' and c_disp == None:
            email_message = str(email_message) + '\n' + str(part.get_payload()) #error: unsupported operand type(s) for +: 'instance' and 'str'     ----- What instance?  
        else:
            continue
    save_string = os.path.join(destination_folder, 'myemail_' + str(x) + '.eml')
    myfile = open(save_string, 'a')
    myfile.write(str(email_message))
    myfile.close()

    ######## Maybe this will append the way I want  ######
 #    def read_messages(fd):

	# data = []; app = data.append

	# for line in fd:
	# 	if line[:5] == 'From ' and data:
	# 		yield ''.join(data)
	# 		data[:] = []
	# 	app(line)

	# if data:
	# 	yield ''.join(data)
	#########

