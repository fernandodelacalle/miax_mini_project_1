FROM python:3.8-slim

# set the working directory in the container
WORKDIR /code
# copy the dependencies file to the working directory
COPY src/api/requirements.txt .
# install dependencies
RUN pip install -r requirements.txt
# copy the content of the local src directory to the working directory
COPY src/api .
# Expose the API Port
EXPOSE 8080
# Run the server
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]