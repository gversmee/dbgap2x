FROM jupyter/base-notebook

LABEL maintainer="Gregoire Versmee <gregoire.versmee@gmail.com>"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libapparmor1 \
    libedit2 \
    lsb-release \
    psmisc \
    libssl1.0.0 \
    fonts-dejavu \
#   tzdata \
#    unixodbc \
#    unixodbc-dev \
#    r-cran-rodbc \
#    gfortran \
#    gcc \
    git \
    docker.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
RUN service docker start

USER $NB_UID 

RUN conda install --quiet --yes \
    'r-base=3.4.1' \
    'r-irkernel=0.8*' \
    'r-rcurl=1.95*' \
    'r-htmltools=0.3*' \
    'r-htmlwidgets=1.0*' \
    'r-xml' \
    'r-data.table' \
    'r-httr' \
    'r-rlist' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR

RUN echo "c = get_config()\n\
c.NotebookApp.ip = '0.0.0.0'\n\
c.NotebookApp.port = 8888\n\
c.FileContentsManager.delete_to_trash = False\n\
c.IPKernelApp.pylab = 'inline'\n\
c.NotebookApp.password = 'sha1:48b3bade9809:6e4fca934155cb2552e409a895a22534ff61a837'" > $HOME/.jupyter/jupyter_notebook_config.py 

USER root

RUN git clone https://github.com/gversmee/dbgap2x $HOME/dbgap2x && \
Rscript -e "install.packages('$HOME/dbgap2x', repos = NULL, type = 'source')"

RUN usermod -aG docker $NB_USER && \
chown -R $NB_USER $HOME/dbgap2x && \
chmod -R 4775 $HOME/dbgap2x && \
jupyter trust $HOME/dbgap2x/dbgap2x.ipynb && \
rm -rf $HOME/.local && \
fix-permissions $CONDA_DIR && \
fix-permissions $HOME

WORKDIR $HOME/dbgap2x
