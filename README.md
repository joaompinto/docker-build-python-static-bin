# Build a static binary from a Python script

The Docker image availbale on this repository allows to build Linux static binaries from python scripts/applications. This binaries should run fine on any Linux system (x64 only).

The binary is built using [Nuitka] together with a Python 3.10 static build.

The build logic was adapted from  https://github.com/xxh/xxh .


[Nuitka]: https://nuitka.net/

## How to use this repository (from source)

Create the docker image
```sh
docker build . -t build-python-bin
```

Create an hello world script (test.py)
```python
print("Hello world from static python")
```

Create the static binary
```sh
docker run --user $(id -u) -v $(pwd):/build -it build-python-bin test.py

# Resulting binary will be at test.dist/test, rename, check and cleanup
mv test.dist/test my_static_binary
file my_static_binary
rm -rf test.dist/
```

Test it in some docker images (not containing Python):
```sh
docker run -v $(pwd):/tmp -it alpine /tmp/my_static_binary
docker run -v $(pwd):/tmp -it debian /tmp/my_static_binary
docker run -v $(pwd):/tmp -it ubuntu /tmp/my_static_binary
```


