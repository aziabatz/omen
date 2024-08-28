FROM ubuntu:latest AS builder

LABEL author="aziabatz"
LABEL version="1.0"

ENV toolchain /toolchain
ENV target "x86_64-elf"
ENV jobs 4
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    bison \
    flex \
    libgmp3-dev \
    libmpfr-dev \
    binutils \
    gcc \
    g++ \
    nasm \
    make \
    wget \
    libmpc-dev \
    texinfo \
    tree \
    gdb \
    mtools \
    xorriso \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD http://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.gz .
RUN tar xvzf binutils-2.39.tar.gz
RUN cd binutils-2.39
RUN ./configure --prefix=${toolchain} --target=${target} --disable-nls --disable-werror --with-sysroot
RUN make -j${jobs}
RUN make install
RUN cd ..
RUN rm -rf binutils-2.39
RUN rm binutils-2.39.tar.gz

ADD http://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.gz .
RUN tar xvzf gcc-12.2.0.tar.gz
RUN mkdir build-gcc
RUN cd build-gcc
RUN ../gcc-12.2.0/configure --prefix=${toolchain} --target=${target} --disable-nls --enable-languages=c,c++ --without-headers --disable-werror
RUN make -j${jobs} all-gcc
RUN make -j${jobs} all-target-libgcc
RUN make install-gcc
RUN make install-target-libgcc
RUN cd ..
RUN rm -rf build-gcc
RUN rm -rf gcc-12.2.0
RUN rm gcc-12.2.0.tar.gz

# Stage 2 image
FROM ubuntu:latest

LABEL author="aziabatz"
LABEL version="1.0"

ENV toolchain /toolchain
ENV code /src
ENV DEBIAN_FRONTEND=noninteractive

COPY --from=builder ${toolchain} ${toolchain}

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    nasm \
    make \
    gdb \
    mtools \
    xorriso \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="${toolchain}/bin:${PATH}"
WORKDIR ${code}
ENTRYPOINT ["/bin/bash"]
