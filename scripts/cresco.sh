#!/usr/bin/env bash
set -e -u -o pipefail
set -x

alma_version=9.2
apptainer_tag=v1.4.1


podman build \
  --build-arg ALMALINUX_VERSION=${alma_version} \
  --build-arg APPTAINER_COMMITISH=${apptainer_tag} \
  --build-arg APPTAINER_VERSION=${apptainer_tag} \
  --build-arg install_dir=/opt/apptainer/${apptainer_tag}/build \
  --target builder \
  --tag apptainer_builder \
  --file ../cresco/Dockerfile \
  .

podman build \
  --build-arg ALMALINUX_VERSION=${alma_version} \
  --build-arg APPTAINER_COMMITISH=${apptainer_tag} \
  --build-arg APPTAINER_VERSION=${apptainer_tag} \
  --target tester \
  --tag apptainer_tester \
  --file ../cresco/Dockerfile \
  .

podman run --rm apptainer_tester apptainer version

podman create --name apptainer_rpm_extract apptainer_builder

podman cp apptainer_rpm_extract:/root/rpmbuild/RPMS/x86_64/apptainer-${apptainer_tag}-1.el9.x86_64.rpm .
