FROM alpine/git:1.0.7 as git

WORKDIR /root

RUN git clone https://github.com/gversmee/dbgap2x.git

FROM jupyter/base-notebook:38f518466042

LABEL maintainer="Gregoire Versmee <gregoire.versmee@gmail.com>"

RUN conda install --quiet --yes \
    'r-base=3.4.1' \
    'r-irkernel=0.8.*' \
    'r-rcurl=1.95.*' \
    'r-xml=3.98*' \
    'r-data.table=1.12.*' \
    'r-httr=1.*' \
    'r-rlist=0.4.*' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR

RUN echo "c = get_config()\n\
c.NotebookApp.ip = '0.0.0.0'\n\
c.NotebookApp.port = 8888\n\
c.FileContentsManager.delete_to_trash = False\n\
c.IPKernelApp.pylab = 'inline'\n\
c.NotebookApp.password = 'sha1:48b3bade9809:6e4fca934155cb2552e409a895a22534ff61a837'" > $HOME/.jupyter/jupyter_notebook_config.py 

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
#        libapparmor1 \
#        libedit2 \
#        libssl1.0.0 \
#        tzdata \
#        unixodbc \
#        unixodbc-dev \
#        r-cran-rodbc \
#        gfortran \
#        gcc \
        lsb-release \
        psmisc \
        fonts-dejavu \
        docker.io && \
	usermod -aG docker $NB_USER && \
	service docker start && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
COPY --from=git /root/dbgap2x $HOME/dbgap2x

RUN Rscript -e "install.packages('$HOME/dbgap2x', repos = NULL, type = 'source')" && \
chown -R $NB_USER $HOME/dbgap2x && \
chmod -R 4775 $HOME/dbgap2x && \
rm -rf $HOME/.local && \
fix-permissions $HOME

RUN jupyter trust $HOME/dbgap2x/dbgap2x.ipynb

WORKDIR $HOME/dbgap2x
