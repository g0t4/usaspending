FROM postgres:latest 

# fish shell provides completions!
RUN apt update && apt install -y fish unzip file

