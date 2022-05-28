# Based on https://github.com/xxh/xxh/blob/master/xxh-portable-musl-alpine.Dockerfile

FROM alpine

ENV PYTHON_VER 3.10.4
ENV PYTHON_LIB_VER 3.10

RUN apk update && apk add --update musl-dev gcc python3-dev py3-pip chrpath git vim mc wget make openssh-client patchelf

RUN pip3 install Nuitka --no-cache


RUN mkdir /build /package
WORKDIR /build

RUN wget https://www.python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tgz && tar -xzf Python-$PYTHON_VER.tgz
WORKDIR Python-$PYTHON_VER
ADD Setup.local Modules/
RUN ./configure LDFLAGS="-static" --disable-shared
RUN make LDFLAGS="-static" LINKFORSHARED=" "
RUN cp libpython$PYTHON_LIB_VER.a /usr/lib

WORKDIR /build
ENV LDFLAGS "-static -l:libpython3.10.a"

ENV HOME=/tmp
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
