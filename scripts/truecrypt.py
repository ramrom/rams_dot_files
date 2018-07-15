# *** how can i bypass the space as a delimiter for parameters in the Popen function? ***

import subprocess
import sys

x = raw_input('password: ')
subprocess.Popen('c:\Program Files\TrueCrypt\truecrypt /v "c:\WorkVault.tc" /lv /pBlazin2 /a /q',shell=True)
# '"c:\Program Files\TrueCrypt"\truecrypt /v "c:\Temporary Files\testlockedvolume" /lv'

