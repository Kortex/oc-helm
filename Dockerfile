FROM debian:stable-slim 

ARG OC_FOLDER=oc-client
ARG HELM_FOLDER=helm-client
ARG USER_NAME=app

ARG OC_CLIENT_LINK=https://github.com/okd-project/okd/releases/download/4.13.0-0.okd-2023-06-04-080300/openshift-client-linux-4.13.0-0.okd-2023-06-04-080300.tar.gz
ARG HELM_CLIENT_LINK=https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y wget

# Install OC client
RUN mkdir -p ${OC_FOLDER} \
    && cd ${OC_FOLDER} \
    && wget ${OC_CLIENT_LINK} \
    && tar -xvf *.gz \
    && mv oc kubectl /usr/local/bin \
    && cd ..
# Install helm
RUN mkdir -p ${HELM_FOLDER} \
    && cd ${HELM_FOLDER} \
    && wget ${HELM_CLIENT_LINK} \
    && tar -xvf *.gz \
    && mv linux-amd64/helm /usr/local/bin \
    && cd ..

# Cleanup directories
RUN rm -rf ${OC_FOLDER} ${HELM_FOLDER}

# Create a non-root user
RUN useradd -rm -d /home/${USER_NAME} -s /bin/bash -u 1001 ${USER_NAME}
USER ${USER_NAME}

CMD [ "bash" ]