# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM gversmee/jupyter-full

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

RUN git clone https://github.com/gversmee/dbGaP2x

RUN Rscript -e "devtools::install('dbGaP2x')"
	
USER $NB_UID

WORKDIR $HOME

