FROM jupyter/datascience-notebook:66c99628f4b8

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt update \
    && apt install -y apt-transport-https curl iputils-ping gnupg
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | sudo apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" \
    | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

RUN apt update \
    && apt install -y kubectl git gcc mono-mcs musl-dev octave vim figlet \
    && rm -rf /var/lib/apt/lists/*

# kubefwd for local development and testing
RUN apt-get clean && apt-get autoremove --purge
RUN wget https://github.com/txn2/kubefwd/releases/download/v1.9.0/kubefwd_amd64.deb \
    && dpkg -i kubefwd_amd64.deb \
    && rm kubefwd_amd64.deb

USER $NB_UID

# Installs data science, machine learning, blockchaine and iot python packages
RUN pip install --no-cache \
    nbgitpuller \
    rubix \
    python-gitlab \
    scipy \
    numpy \
    pandas \
    scikit-learn \
    matplotlib \
    tensorflow \
    torch \
    torchvision \
    fastai \
    octave_kernel \
    jupyterlab-git \
    paho-mqtt \
    web3 \
    py-solc

# Jupyter lab and server enstension
RUN jupyter labextension install @jupyterlab/git
RUN jupyter labextension install @jupyterlab/plotly-extension
RUN jupyter serverextension enable --py jupyterlab_git

RUN mkdir -p ./.jupyter/lab/user-settings/@jupyterlab/apputils-extension
COPY ./user-settings/themes.jupyterlab-settings ./.jupyter/lab/user-settings/@jupyterlab/apputils-extension
