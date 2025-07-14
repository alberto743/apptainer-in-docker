ARG ALMALINUX_VERSION=9.2


FROM almalinux:${ALMALINUX_VERSION} AS builder

ARG APPTAINER_COMMITISH="v1.4.1"
ARG install_dir=/opt/apptainer/${APPTAINER_COMMITISH}/build

RUN    dnf install -y epel-release \
    && dnf config-manager --set-enabled crb \
    && dnf upgrade -y
RUN    dnf install -y libseccomp-devel fakeroot cryptsetup wget git shadow-utils-subid-devel \
    && dnf install -y fuse3-devel lz4-devel lzo-devel zlib-devel \
    && dnf install -y rpm-build golang \
    && dnf install -y autoconf automake libtool libzstd-devel xz-devel

WORKDIR /root
RUN    git clone --depth 1 --branch ${APPTAINER_COMMITISH} https://github.com/apptainer/apptainer.git \
    && cd apptainer \
    && ./mconfig -b builddir \
    && ./scripts/download-dependencies \
    && make -C builddir rpm RPMPREFIX=${install_dir}


FROM almalinux:${ALMALINUX_VERSION} AS tester

ARG APPTAINER_VERSION="1.4.1"
ARG APPTAINER_COMMITISH="v1.4.1"
ARG install_dir=/opt/apptainer/${APPTAINER_COMMITISH}/build

RUN    dnf install -y epel-release \
    && dnf config-manager --set-enabled crb \
    && dnf upgrade -y

WORKDIR /root
COPY --from=builder /root/rpmbuild/RPMS/x86_64/apptainer-${APPTAINER_VERSION}-1.el9.x86_64.rpm /root/apptainer-${APPTAINER_VERSION}-1.el9.x86_64.rpm
RUN dnf install -y /root/apptainer-${APPTAINER_VERSION}-1.el9.x86_64.rpm
ENV PATH="${install_dir}/bin:$PATH"
