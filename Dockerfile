FROM jupyter/all-spark-notebook

COPY --chown=jovyan:users . /home/jovyan/work
