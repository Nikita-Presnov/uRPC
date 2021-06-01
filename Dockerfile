FROM python:3.6-alpine

COPY index.html /index.html

EXPOSE 8000
CMD ["python", "-m", "http.server"]
