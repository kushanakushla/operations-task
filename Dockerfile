FROM python:alpine3.17

ARG USER=appuser
ARG USER_HOME=/home/${USER}

#Create app user and home directory
RUN adduser -D ${USER} -h ${USER_HOME}

USER ${USER}

WORKDIR ${USER_HOME}

#update permission of home directory and copy application files
COPY --chown=${USER}:${USER} rates/* ${USER_HOME}/

RUN chmod +x entrypoint.sh

RUN pip install --user -U --no-cache-dir gunicorn && pip install --user --no-cache-dir -Ur requirements.txt

ENV PATH="${USER_HOME}/.local/bin:${PATH}"

ENTRYPOINT ["./entrypoint.sh"]