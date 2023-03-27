# SSH

```sh
# ssh into host and run single command and set a VAR for the command as well
ssh foo@host.bar VAR=1 somecommand arg1

# ssh-agent can remember the passphrase of a private key, if the key has a passphrase, which is a good idea
# this ssh-agent only applies to the current shell/terminal session!
eval `ssh-agent -s`  # starting the agent, have to eval, running cmd plain fails, gives "could not open conn to auth agent" error

# ssh-agent can remember your passwords
ssh-add                  # will add default locations for keys
ssh-add ~/path/to/key    # add a specific key

ssh-add -l  # list the cached keys in the ssh-agent

ssh-add -D   # delete all cached keys

# using multiple ssh keys for git on the same host: https://gist.github.com/jexchan/2351996
    # created ssh config file and had to change the repo remote name to match
    # https://www.freecodecamp.org/news/how-to-manage-multiple-ssh-keys

# copy current users public key to authorized keys in remoteserver, now you can public/private key auth instead of password
ssh-copy-id foouser@fooserver

# CONFIG FILE
# location: ~/.ssh/config
# can turn on AddKeysToAgent, UseKeychain (for osx)
# can include other config files

# ssh multihop: http://sshmenu.sourceforge.net/articles/transparent-mulithop.html
ssh -t user@foo.com ssh -t user2@bar.com

# github only allows a key to be used with one github account
# see https://docs.github.com/en/github/authenticating-to-github/error-key-already-in-use
ssh -ai ~/.ssh/id_rsa git@github.com   # to verify the github account the key belongs to

# can tell ssh server, in sshd_config, to allow specific users from specific address ranges or hostnames
# here foouser is allowed from anywhere, but bar users is only allowed from private C addresses (everyone else denied)
AllowUsers foouser@* baruser@192.168.*

# creating keys
# good ref: https://linuxnatives.net/2019/how-to-create-good-ssh-keys
ssh-keygen

# change passphrase on particular private key
ssh-keygen -p -f ~/.ssh/id_rsa

# removing a host key for a known host
# NOTE: use when a trusted domain changes thier key and you trust the key change isn't a MITM hack
ssh-keygen -f "/home/foouser/.ssh/known_hosts" -R "somedomain.com"

# X11 Forwarding
# server side X11Fowarding must be yes in server config(sshd_config file)
# for OSX, make sure XQuartz is installed and working, if ssh'ing from osx to be used as display server
# verify $DISPLAY var has a value on remote host
ssh -Y foouser@foo.com
ssh -X foouser@foo.com  # -X is done without X11 authority

# SOCKS PROXY
# connect to remote server and create a locak SOCKS5 on local port 1234
# the curl command will use the socks5 proxy to make http request
ssh -D 1234 foouser@yarserver
curl -x socks5h://127.0.0.1:1234 https://google.com

# TCP PROXY
# create local TCP 8080 to forward to remote port 8080
# -n (redir stdin from /dev/.null, so run in background), -N(dont execute remote command), -f(go to background b4 cmd execution)
ssh -f -N -n -L8080:127.0.0.1:8080 someremotehost
```
