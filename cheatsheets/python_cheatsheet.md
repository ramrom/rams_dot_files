# PYTHON CHEATSHEET

## DOCS
- https://diveintopython.org/
- style and intro - https://docs.python-guide.org/writing/style/
- intro to decorators - https://realpython.com/primer-on-python-decorators/
- leary in y minutes - https://learnxinyminutes.com/docs/python/

## HISTORY
- python 3 breaking changes
    - print statement is a function, so parentheses are required
    - integer division always includes decimals, 2 always returned an integer
    - 2 uses ASCII strings, 3 uses unicode
    - 3 wont let you mix binary and text data

## DATA STRUCTURES
```python
arr = [1,2]   # array
assarr = { "a": 3, "b": [3,4] }    # associative-array (aka python dictionaries)
```

## SYNTAX
- `pass` - do nothing, used in places where syntax requires a statement
- `None` - null value, similar to `null` in JS or `nil` in Ruby
```python
# ternary logic example
a = 1 if True else 2   # a is 1
```

## STRING
```python
s = "hello world"
si = f"hi {s} "   # string interpolation
print(s, end='') # print without newline
"  strip ".strip()  # returns "strip", it remove trailing and leading whitespace
"  strip ".lstrip()  # returns "strip "
"  strip ".rstrip()  # returns "  strip"
```

## DEPENDENCY MANAGEMENT
- it **SUCKS**: https://xkcd.com/1987/
- `virtualenv` installs packages locally vs global system dirs
    - https://virtualenv.pypa.io/en/latest/
    - `virtualenv venv` - create a new virtual env
        - creates a `venv` dir that stores all tools/metadata for env
- `pipx` - https://github.com/pypa/pipx
    - install and run python programs in isolated environments
    - unlike `pip`, which has no ioslation and made for libs and apps, pipx is for app installs
### PIPENV
- quickstart - https://pipenv.pypa.io/en/latest/quick_start.html
- introduces `Pipfile` and `Pipfile.lock`
- it's the official package management tool rec'd by python
- `pipenv` uses `virtualenv` and `pip` under the hood
- this replaces the `requirements.txt` mechanism
- `Pipfile` lets u specify ranges of versions
- `pipenv graph` - show dependency graph
- `pipenv run pip list` - list installed packages
- `pipenv --python 3.10` - specify a python version
- OSX/Linux: virtual envs are stored in `~/.local/share/virtualenvs/`
### PIP
- to upgrade `pip install --upgrade somepackage`
- `pip` uses requirements.txt
- u can specify packages and pin versions you want
### UV
- rust written replacement for PIP: https://github.com/astral-sh/uv

## INTROSPECTION
- `type(foo)`   - print type

## CONVERSION
```python
s = str(3)  # convert int to string
```

## DEBUGGING
- breakpoints
    ```python
    import pdb
    pdb.set_trace()
    ```

## SCRIPTING
```sh
python -c 'print("hi")'  # prints "hi"

# delete last 4 lines of a file
python -c "import sys; a=[]; [a.append(line) for line in sys.stdin]; [sys.stdout.write(l) for l in a[:-4]]" < foo

sys.exit(1)  # exit a program with code 1

# read a csv
import csv
list_of_dicts = []
with open('some.csv', mode='r') as file:
    csv_reader = csv.DictReader(file)
    for row in csv_reader:
        list_of_dicts.append(row)
```

## GREAT LIBS
- https://github.com/Textualize/rich - add rich text ANSI colors and formats to text
- [NumPy](https://numpy.org/) - extremely popular math lib used by everyone in data science for ML
- [Pandas](https://pandas.pydata.org/) - data analysis and manipulation tool, particularly time series and numerical tables
- [requests](https://requests.readthedocs.io/)
- [colored](https://pypi.org/project/colored/) - inject ansi colors to strings
    - source code https://gitlab.com/dslackw/colored
- [pygments](https://pygments.org/) - syntax highlighter
    - injects ansi color codes to strings of many types of languages/syntaxes
