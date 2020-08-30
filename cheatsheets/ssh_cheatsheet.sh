################### SSH ####################

# ssh-agent can remember your passwords

# copy current users public key to authorized keys in remoteserver, now you can public/private key auth instead of password
ssh-copy-id foouser@fooserver

# CONFIG FILE
# location: ~/.ssh/config
# can turn on AddKeysToAgent, UseKeychain (for osx)
# can include other config files
