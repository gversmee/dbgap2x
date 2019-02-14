FROM jupyter/minimal-notebook

LABEL maintainer="Gregoire Versmee <gregoire.versmee@gmail.com>"

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		libapparmor1 \
		libedit2 \
		lsb-release \
		psmisc \
		libssl1.0.0 \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc \
    docker.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID 

# R packages
RUN conda install --quiet --yes \
    'r-base=3.4.1' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=1.13*' \
    'r-tidyverse=1.1*' \
    'r-rmarkdown=1.8*' \
    'r-forecast=8.2*' \
    'r-rsqlite=2.0*' \
    'r-reshape2=1.4*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-htmlwidgets=1.0*' \
    'r-devtools=1.13*' \
		'r-xml' \
		'r-data.table' \
		'r-httr' \
		'r-rlist' \
		'r-roxygen2' \
    'r-ggplot2=2.2*' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
		
USER root

RUN rm -rf /home/$NB_USER/.local && \
fix-permissions $CONDA_DIR && \
fix-permissions /home/$NB_USER

RUN jupyter labextension install @jupyterlab/hub-extension@^0.12.0

ENV JUPYTER_ENABLE_LAB "ok"
ENV TAR /bin/tar

COPY jupyter_notebook_config.py /home/jovyan/.jupyter/
COPY .Rprofile /home/jovyan/

RUN git clone https://github.com/gversmee/dbGaP2x

RUN Rscript -e "install.packages('htmlTable', repos='http://cran.us.r-project.org');library(htmlTable);install('dbGaP2x');print('success')"

RUN usermod -aG docker jovyan

CMD chgrp docker /var/run/docker.sock && start-notebook.sh

USER $NB_UID

WORKDIR $HOME/dbGaP2x
