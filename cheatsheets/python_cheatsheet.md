# PYTHON CHEATSHEET

## DOCS
- https://diveintopython.org/
- style and intro - https://docs.python-guide.org/writing/style/
- intro to decorators - https://realpython.com/primer-on-python-decorators/
- leary in y minutes - https://learnxinyminutes.com/docs/python/

## SCRIPTING
```sh
python -c 'print("hi")'  # prints "hi"
```

## DEPENDENCY MANAGEMENT
- it **SUCKS**: https://xkcd.com/1987/
- `pipenv` is successor to `virtualenv` and does more, uses `Pipfile` and `Pipfile.lock`
- `pip` uses requirements.txt
    - u can specify packages and pin versions you want
- `pipenv` introduces `Pipfile` and `Pipfile.lock`
    - it's the official package management tool rec'd by python
    - `pipenv` uses `virtualenv` and `pip` under the hood
    - this replaces the `requirements.txt` mechanism
    - `Pipfile` lets u specify ranges of versions
- `virtualenv` installs packages locally vs global system dirs
    - https://virtualenv.pypa.io/en/latest/
    - `virtualenv venv` - create a new virtual env
        - creates a `venv` dir that stores all tools/metadata for env
- `pipx` - https://github.com/pypa/pipx
    - install and run python programs in isolated environments
    - unlike `pip`, which has no ioslation and made for libs and apps, pipx is for app installs
### PIP
- to upgrade `pip install --upgrade somepackage`

## DEBUGGING
- breakpoints
    ```python
    import pdb
    pdb.set_trace()
    ```

## GREAT LIBS
- https://github.com/Textualize/rich - add rich text ANSI colors and formats to text
- [NumPy](https://numpy.org/) - extremely popular math lib used by everyone in data science for ML
- [Pandas](https://pandas.pydata.org/) - data analysis and manipulation tool, particularly time series and numerical tables
