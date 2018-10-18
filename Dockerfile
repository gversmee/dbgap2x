FROM gversmee/jupyter-full:lab

LABEL maintainer="Gregoire Versmee <gregoire.versmee@gmail.com>"

USER root

RUN git clone https://github.com/gversmee/dbGaP2x

RUN rm -rf /home/$NB_USER/.local && \
fix-permissions $CONDA_DIR && \
fix-permissions /home/$NB_USER

RUN Rscript -e "install('dbGaP2x')"

RUN apt update -y
RUN apt install docker.io -y
RUN usermod -aG docker jovyan

CMD chgrp docker /var/run/docker.sock && start-notebook.sh

USER $NB_UID

WORKDIR $HOME
