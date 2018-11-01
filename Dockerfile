FROM gversmee/jupyter-full

LABEL maintainer="Gregoire Versmee <gregoire.versmee@gmail.com>"

USER root

RUN echo lol3
RUN git clone https://github.com/gversmee/dbGaP2x

RUN rm -rf /home/$NB_USER/.local && \
fix-permissions $CONDA_DIR && \
fix-permissions /home/$NB_USER

RUN Rscript -e "install.packages('htmlTable', repos='http://cran.us.r-project.org');library(htmlTable);install('dbGaP2x');print('success')"

RUN apt update -y
RUN apt install docker.io -y
RUN usermod -aG docker jovyan

CMD chgrp docker /var/run/docker.sock && start-notebook.sh

USER $NB_UID

WORKDIR $HOME
