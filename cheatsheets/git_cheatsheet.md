# GIT:
## RERFERNCES
- https://git-scm.com/
- basics of git plumbing, objects/trees/blobs/sha: https://git-scm.com/book/en/v2/Git-Internals-Git-Objects
- git lfs: https://git-lfs.github.com/, nice if u want to version large files


## CONFIGS
- basic heirarchy: system(machine/host level) -> global(user level: `~/.gitconfig`) -> local(repo `./.git/config`)
    - dec2022 - osx system config at `/Library/Developer/CommandLineTools/usr/share/git-core/gitconfig`
        - `git config --system list` thinks it's `/etc/gitconfig`
- `git config --get-all --show-origin credential.helper`
    - get all values for a config key from system, global, and local; as well as where those files are located as well

```sh
git rm -rf --cached foo bar # keep on disk but rm from git
git show-ref --tags         # tags with it's commit
git show-ref --tags -d      # above + what commit tag points to
git remote prune foo        # remove outdated references in remote
git push origin --delete somebranch # delete branch on remote
git branch -m OLD_B NEW_B   # rename branch
git rebase -i HEAD~3        # interactive rebase over last 3 commits
```

- assuming master branch is local branch, this will overwrite local
    `git reset --hard origin/master`

- show branches with commits merged into relativebranch
    - NOTE: authn squash commits a branch to new commit before merge, so commit number is diff
    `git branch --merged relativebranch`
- shows opposite
    `git branch --no-merged relativebranch`

- delete all branches not master or current
    `git branch | egrep -v "^\*|master" | xargs git branch -D`

- create branch and push to remote with tracking:
    ```sh
    git co -b foobranch
    git push --set-upstream remote foobranch
    ```

- show tags in a proper sorted order
    - `git tag --sort -version:refname`

- get tags from remote
    - `git ls-remote https://someremote.url`
    - `git ls-remote --tags https://someremote.url`

### PUSH/TRACKING
```sh
git branch --set-upstream-to=origin/foobranch foobranch
git push -u remote local_branch # push branch to remote
git push -u remote              # push/track current branch to remote
git push --force remote local_branch  # force push, overwriting remote branch
```

### OTHER
```sh
git merge-base b1 b2 b3     # find most recent common ancestor commit of n branches
git show-branch b1 b2 b3    #  show sidebyside columar what commits exist in each branch
git commit --amend --author="Joe Shmoe <email@address.com>"
```
- editing past commit metadata like author and email
    - https://www.codeconcisely.com/posts/change-author-data-for-all-existing-commits/

## AUTH
- TFA(two factor auth)
    - browser login requires the TFA
    - local cli, on a push/write to public repo or anything on private repo
        - git@ url repos: ssh keys dont require TFA
        - `https://` url repos: can use personal api token as password
- if using credential helper like osxkeychain can turn it off by setting config to empty list
    - e.g. `git -c credential.helper='' pull`
### SSH AUTH
- specify a custom ssh command
    - can use `GIT_SSH` to specify a script that can run a custom ssh commmand
        - this ssh command could do something like use a different config file or a different identity file
    - git 2.3.0+ supports a `GIT_SSH_COMMAND` env var to run the custom ssh command, takes precedence over `GIT_SSH`
- https://gist.github.com/Jonalogy/54091c98946cfe4f8cdab2bea79430f9
    - can specify seperate users for same host in `.ssh/config` file for same host(e.g. github)
        - `Host github.com-user1` and `Host github.com-user2`, and git uses repo url's username to discern
- *NOTE* if you use ssh-agent, and load multiple keys, it will only try the first key, so only load the single proper key
- `ssh-add -l` to list key loaded into ssh-agent
- can configure a repo to use a specific ssh command
    - `git config core.sshCommand 'ssh -i ~/.ssh/id_rsa_corp'`, keychain can have both keys
### HTTPS AUTH
- can specify a seperate credential store with `git -c credential.helper='store --file=/path/to/credfile' pull`
    - the cred file is plaintext format, each line something like `https://user:pass@example.com`
- osx keychain with multiple accounts for same host(e.g. github) setup
    - https://stackoverflow.com/questions/24275375/how-can-i-store-keychain-credentials-for-multiple-github-accounts
    - basically set`useHttpPath` to see full url, and url must have username in it

## GITHUB
- keyboard shortcuts: https://docs.github.com/en/github/getting-started-with-github/keyboard-shortcuts
    - s or /  ->  focus search bar
    - g + i -> go to issues tab
    - g + p -> go to pullrequest tab
    - g + w -> go to wiki tab
    - i  -> toggle showing comments in pull request diff
- wiki: https://help.github.com/en/github/building-a-strong-community/adding-or-editing-wiki-pages
    - you can clone the wiki locally and commit and push
- render markdown to html, github sytle
    - github GUI rendering: https://docs.github.com/en/repositories/working-with-files/using-files/working-with-non-code-files
        - https://github.com/github/markup
    - API to render HTML from markdown: https://docs.github.com/en/rest/reference/markdown
    - supported languages in code blocks: https://github.com/github/linguist/blob/master/lib/linguist/languages.yml
- render mermaid code in markdown code block: https://github.blog/2022-02-14-include-diagrams-markdown-files-mermaid/
