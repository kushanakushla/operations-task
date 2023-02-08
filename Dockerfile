FROM python:alpine3.17


RUN adduser -D appuser

USER appuser

WORKDIR /app

COPY --chown=appuser:appuser rates/* /app/

RUN chmod +x entrypoint.sh

RUN pip install --user -U gunicorn && pip install --user -Ur requirements.txt

ENV PATH="/home/appuser/.local/bin:${PATH}"

ENTRYPOINT ["./entrypoint.sh"]
