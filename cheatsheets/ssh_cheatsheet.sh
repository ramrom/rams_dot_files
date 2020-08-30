################### SSH ####################

# ssh-agent can remember the passphrase of a private key, if the key has a passphrase, which is a good idea
# this ssh-agent only applies to the current shell/terminal session!
eval `ssh-agent -s`  # starting the agent, have to eval, running cmd plain fails, gives "could not open conn to auth agent" error

# ssh-agent can remember your passwords
ssh-add  # will add default locations for keys

# copy current users public key to authorized keys in remoteserver, now you can public/private key auth instead of password
ssh-copy-id foouser@fooserver

# CONFIG FILE
# location: ~/.ssh/config
# can turn on AddKeysToAgent, UseKeychain (for osx)
# can include other config files

# ssh multihop: http://sshmenu.sourceforge.net/articles/transparent-mulithop.html
