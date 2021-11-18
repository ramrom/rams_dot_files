# PYTHON CHEATSHEET

## DEPENDENCY MANAGEMENT
- it sucks: https://xkcd.com/1987/
- pipenv is successor to virtualenv and does more, uses Pipfile and Pipfile.lock
- pip uses requirements.txt
    - u can specify packages and pin versions you want
- pipenv introduces Pipfile and Pipfile.lock
    - it's the official package management tool rec'd by python
    - pipenv uses virtualenv and pip under the hood
    - this replaces the requirements.txt mechanism
    - Pipfile lets u specify ranges of versions
- virtualenv installs packages locally vs global system dirs

# breakpoints:
    ```python
    import pdb
    pdb.set_trace()
    ```
