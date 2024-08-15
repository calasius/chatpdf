FROM mcr.microsoft.com/azureml/promptflow/promptflow-runtime:20240529.v1
# Check here for new versions:
# https://mcr.microsoft.com/v2/azureml/promptflow/promptflow-runtime/tags/list

WORKDIR /

COPY ./requirements.txt /flow/requirements.txt

RUN python3 -m pip install --upgrade pip

RUN python3 -m pip install -r /flow/requirements.txt

RUN python3 -m pip install gunicorn==20.1.0

RUN python3 -m pip install 'uvicorn>=0.27.0,<1.0.0'

RUN python3 -m pip install keyrings.alt

COPY ./ /flow

EXPOSE 8080

COPY openai.yaml /connections/

# reset runsvdir
RUN rm -rf /var/runit
COPY ./runit /var/runit
# grant permission
RUN chmod -R +x /var/runit

COPY ./start.sh /
CMD ["bash", "./start.sh"]