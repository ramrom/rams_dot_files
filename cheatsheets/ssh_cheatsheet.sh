################### SSH ####################

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

# copy current users public key to authorized keys in remoteserver, now you can public/private key auth instead of password
ssh-copy-id foouser@fooserver

# CONFIG FILE
# location: ~/.ssh/config
# can turn on AddKeysToAgent, UseKeychain (for osx)
# can include other config files

# ssh multihop: http://sshmenu.sourceforge.net/articles/transparent-mulithop.html

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
$ ssh-keygen -p -f ~/.ssh/id_rsa
