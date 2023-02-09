FROM python:3.10-slim

ARG USER=appuser
ARG USER_HOME=/home/${USER}

RUN useradd ${USER} -m

USER ${USER}

WORKDIR ${USER_HOME}

COPY --chown=${USER}:${USER} rates/* ${USER_HOME}/

RUN chmod +x entrypoint.sh

RUN pip install --user -U --no-cache-dir gunicorn && pip install --user --no-cache-dir -Ur requirements.txt

ENV PATH="${USER_HOME}.local/bin:${PATH}"

ENTRYPOINT ["./entrypoint.sh"]