FROM gversmee/jupyter-full:latest

LABEL maintainer="Gregoire Versmee <gregoire.versmee@gmail.com>"

RUN git clone https://github.com/gversmee/dbGaP2x

RUN Rscript -e "devtools::install('dbGaP2x')"

WORKDIR $HOME
