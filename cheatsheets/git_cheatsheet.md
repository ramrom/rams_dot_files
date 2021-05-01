# GIT:
## RERFERNCES
- https://git-scm.com/
- basics of git plumbing, objects/trees/blobs/sha: https://git-scm.com/book/en/v2/Git-Internals-Git-Objects
- git lfs: https://git-lfs.github.com/, nice if u want to version large files

```sh
git rm -rf --cached foo bar # keep on disk but rm from git
git show-ref --tags         # tags with it's commit
git show-ref --tags -d      # above + what commit tag points to
git remote prune foo        # remove outdated references in remote
git branch -m OLD_B NEW_B   # rename branch
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

create branch and push:
```sh
git co -b foobranch
git push --set-upstream remote foobranch
```

- show tags in a proper sorted order
    - `git tag --sort -version:refname`

push/tracking:
```sh
git branch --set-upstream-to=origin/foobranch foobranch
git push -u remote local_branch # push branch to remote
git push -u remote              # push/track current branch to remote
```

```sh
git merge-base b1 b2 b3     # find most recent common ancestor commit of n branches
git show-branch b1 b2 b3    #  show sidebyside columar what commits exist in each branch
git commit --amend --author="Joe Shmoe <email@address.com>"
```

## SSH auth
- can use GIT_SSH to specify a script that can run a custom ssh commmand
    - this ssh command could do something like use a different config file or a different identity file
- git 2.3.0+ supports a GIT_SSH_COMMAND env var to run the custom ssh command
- if you use ssh-agent, and load multiple keys, it will only try the first key, so only load the single proper key


## GITHUB
- wiki: https://help.github.com/en/github/building-a-strong-community/adding-or-editing-wiki-pages
    - you can clone the wiki locally and commit and push
- render markdown to html, github sytle
    - https://docs.github.com/en/rest/reference/markdown
    - supported languages in code blocks: https://github.com/github/linguist/blob/master/lib/linguist/languages.yml

### AUTH
- TFA(two factor auth):
    - browser login requires the TFA
    - local cli, on a push/write to public repo or anything on private repo
        - git@ url repos: ssh keys dont require TFA
        - https:// url repos: can use personal api token as password
