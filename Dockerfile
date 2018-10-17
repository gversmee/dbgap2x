FROM gversmee/jupyter-full:lab

LABEL maintainer="Gregoire Versmee <gregoire.versmee@gmail.com>"

USER root

RUN git clone https://github.com/gversmee/dbGaP2x

RUN rm -rf /home/$NB_USER/.local && \
fix-permissions $CONDA_DIR && \
fix-permissions /home/$NB_USER

RUN Rscript -e "install('dbGaP2x')"

USER $NB_UID

WORKDIR $HOME
