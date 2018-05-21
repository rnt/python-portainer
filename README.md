# python-portainer
Python module to interact with the Portainer API

## Installation
Install Python Portainer with pip:

```bash
$ pip install portainer
```

If pip is not available, try easy_install:

```bash
$ easy_install portainer
```

## Usage
It's very simple to check the strength of a password:

```pycon
>>> from portainer import Portainer
>>> api = Portainer('https://portainer.local', 'username', 'password')
```
