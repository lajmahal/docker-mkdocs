FROM python:3.7.3

WORKDIR /usr/src/app

RUN pip install mkdocs

COPY mkdockerize.sh ./

ENTRYPOINT [ "./mkdockerize.sh" ]