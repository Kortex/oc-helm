FROM debian:stable-slim 

ARG OC_FOLDER=${OC_FOLDER:-oc}
ARG HELM_FOLDER=${HELM_FOLDER:-helm}
ARG TARGET_OC_FOLDER=${TARGET_OC_FOLDER:-/opt/oc}
ARG TARGET_HELM_FOLDER=${TARGET_HELM_FOLDER:-/opt/helm}
ARG USER_NAME=app
ARG OC_CLIENT_LINK=https://github.com/okd-project/okd/releases/download/4.14.0-0.okd-2024-01-06-084517/openshift-client-linux-4.14.0-0.okd-2024-01-06-084517.tar.gz
ARG HELM_CLIENT_LINK=https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz
ARG BUILD_DATE=${BUILD_DATE}


LABEL org.opencontainers.image.authors="akourt"
LABEL org.opencontainers.image.documentation="https://github.com/Kortex/oc-helm"
LABEL org.opencontainers.image.source="https://github.com/Kortex/oc-helm"
LABEL org.opencontainers.image.title="oc-helm docker image"
LABEL org.opencontainers.image.description="A docker image with oc and helm clients installed"
LABEL org.opencontainers.image.created=${BUILD_DATE}

# Update and install ca-certs
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y wget ca-certificates

RUN mkdir -p ${HELM_FOLDER}
ADD $HELM_CLIENT_LINK $HELM_FOLDER
RUN mkdir -p $TARGET_HELM_FOLDER
RUN tar --strip-components 1 -xvf $HELM_FOLDER/*.gz -C $TARGET_HELM_FOLDER
RUN ln -s $TARGET_HELM_FOLDER/helm /usr/local/bin/

RUN mkdir -p ${OC_FOLDER}
ADD $OC_CLIENT_LINK $OC_FOLDER
RUN mkdir -p $TARGET_OC_FOLDER
RUN tar -xvf $OC_FOLDER/*.gz -C $TARGET_OC_FOLDER
RUN ln -s $TARGET_OC_FOLDER/oc /usr/local/bin/
RUN ln -s $TARGET_OC_FOLDER/kubectl /usr/local/bin/

# Cleanup directories
RUN rm -rf ${OC_FOLDER} ${HELM_FOLDER}

# Create a non-root user
RUN useradd -rm -d /home/${USER_NAME} -s /bin/bash -u 1001 ${USER_NAME}
USER ${USER_NAME}

CMD [ "bash" ]