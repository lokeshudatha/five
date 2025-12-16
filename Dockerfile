FROM python:3.9-slim

# Install git
RUN apt update && apt install -y git

WORKDIR /app

# Clone repo
RUN git clone https:

# Install Flask
RUN pip install flask

EXPOSE 5000

CMD ["python", "app.py"]
