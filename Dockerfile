FROM python:3.9-slim 
RUN apt update && apt install -y git
WORKDIR /app
RUN git clone https://github.com/Mohammedirshaq/flask-web-apk.git .
RUN pip install flask
EXPOSE 5000
CMD ["python", "app.py"]
