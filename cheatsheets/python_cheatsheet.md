# PYTHON CHEATSHEET

## DEPENDENCY MANAGEMENT
- it **sucks**: https://xkcd.com/1987/
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
### PIP
- to upgrade `pip install --upgrade somepackage`

# breakpoints:
    ```python
    import pdb
    pdb.set_trace()
    ```

## GREAT LIBS
- https://github.com/Textualize/rich - add rich text ANSI colors and formats to text
- [NumPy](https://numpy.org/) - extremely popular math lib used by everyone in data science for ML
- [Pandas](https://pandas.pydata.org/) - data analysis and manipulation tool, particularly time series and numerical tables
