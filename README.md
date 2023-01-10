### Assessment Task

DevOps Engineer


#### Given: 

You are given an application with APIs which extracts text from images.


#### Task: 

You have to build a lightweight docker container that will map port 4000 of

your app to your machine. You also have to create a Kubernetes manifest file that

can deploy replica sets in a cluster. Create a requirements.txt file for this repo. Create

a contract of rest API read_ocr. The solution will be evaluated by running the manifest

file on minikube.

Note: Please download this repo and email a zip file over email.

Extra marks will be given for:

• setting up CI/CD files for the same app.

• adding logging functionality in the repo.

Dependencies: opencv-python==4.4.0.46 pytesseract==0.3.7

Please find the link below:

<https://github.com/precilyinc/tess/blob/main/README.md>


### Solution

1. Cloned the provided GitHub repo

2. Created requirements.txt in the root folder for the dependencies. Initially tried with opencv-python module but faced few issues. Upon researching, it was suggested to use opencv-python-headless instead.

   1. opencv-python-headless==4.6.0.66
   2. pytesseract==0.3.10
   3. Flask==2.2.2
   4. requests==2.28.1
   5. urllib3==1.26.13

Directory Structure so far:

precily

|\_\_\_\_ app.py

|\_\_\_\_ views.py

|\_\_\_\_ README.md

|\_\_\_\_ requirements.txt

3. Make the flask application run locally using **_python app.py_**. Tested the root  from the browser and got the expected response {"API Documentation":""}

![](https://lh6.googleusercontent.com/kUqdceGtvEyP5czIAlEjSWI2EF1dt3qAdL15hdmUebrOCAglDC_oIk7FoynoUACVCjbtTBvfrwqQz9BrFteqV4Oalz2EZLOdjY6IDFw7h5PTRl4dZtKzHNPnR6vqFr505YtHtItBC_yV_d5yvngFBUdd7BgTPpipwCk89GsORj366WCza9Rz2aQ314xSeg)

4. Created Dockerfile in the root directory. Dockerfile has the following 

```
# Dockerfile
FROM python:3.8-slim-buster

RUN apt-get update && apt-get install -y \
  tesseract-ocr \
  libtesseract-dev

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

EXPOSE 4000

CMD ["python", "app.py"]

```
Used python 3.8 version and chose slim-buster in order to reduce the size of the docker images. This can help us deploy the docker image faster. Added tesseract-ocr  and libtesseract-dev from the ubuntu package manager. Created a working directory. Copied only requirements.txt because docker images are built layer by layer. Whenever the bottom layer gets changed, all the layers above them are rebuilt. So, application code changes often however, dependencies won't change much. Moreover, building the dependencies takes more time during the building process. Downloading and Installation of all the required dependencies is done using the command pip3 install. The source code is copied to the container and port 4000 is exposed as per the given task. Finally ran the app.py file from the container.

Directory Structure so far:

precily

|\_\_\_\_ app.py

|\_\_\_\_ views.py

|\_\_\_\_ README.md

|\_\_\_\_ requirements.txt

|\_\_\_\_ Dockerfile

5. Build and Pushed the docker image

Created a new repository named precily in the Docker Hub account. A Docker image is built using the docker build command and a tag is used to set the name of the image. The Docker images command is used to list the images and the docker push command is used to push them to the docker hub repository. 
```
docker build --tag abdulkader4513/precily:latest .
docker images
docker push abdulkader4513/precily:latest .
```
![](https://lh3.googleusercontent.com/tF9svcd3d_0VnnrYqNKPXgrGeOdQ48moJm108zA4_WbQVrE31yROVoI8DSJ5BNZQ82c0Z-1lRYBNDZTfXZobRc1ZoUKLZojDVNbagT0uDlcTxlpE6oZZa5vJ6-Zcrv_MlnYNFMxtZOx9FxV3_oYC79rsZfOi6n7L4imcsyljBTiBDTGIdwT63oG-xIV3nA)

6. Created a new GitHub repository named precily and added all the files to the repository. Repository link: <https://github.com/abdulkader4513/precily>
7. Created an Ubuntu EC2 instance with t3.large instance size and 30 GB EBS volume disk space.
8. Connected to the EC2 instance from the browser using EC2 instance connect. 
9. Update the apt package index and install the docker
```
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo service docker start
```

10. Installed kubectl using the below commands
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```
11. Minikube installation is done using the below commands
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube start
minikube status
```
12. Created the Kubernetes configuration file named deploy-to-minikube.yaml. This file has Deployment and Service configuration in a single file. Took the sample configuration from the official Kubernetes documentation for the Nginx container. Made the changes in the spec selector, template labels, and container spec (changed the name, image, and container port) to suit our needs.

13. Using triple hyphens splits the deployment and service configuration. In the service configuration, mage the change in metadata, spec selector, and ports

14. Using the below commands, deployed the kubernetes deployment and service
```
kubectl apply -f deploy-to-minikube.yaml
```
15. Using the below commands, validated the deployments and service. Opened the port mentioned in the load balancer in the EC2 Security groups.
```
kubectl get deployments
kubectl get svc
kubectl get all
```
16. Checked it from the browser for the main page and was able to see the json text API Documentation. Tested with Postman for the main page

Curl Command: 
```
curl --location --request GET 'http://54.91.77.101:4000/'
```
![](https://lh6.googleusercontent.com/42lq5bdCfT7ZuUpXncpgs7gXZWfKs36N8yx_uHNqDaOuG_0Z35H3vdSQHbbi4NozT7XNeIqraguAd_NpHSnNmXkP80chFeUpNtmcvz9gUFoQem6VJZGAFJSOLy64pmhN1wKbYNi-rmmQoIXB1n_dfofQ62iOs8X0Maaq0J690VklU_6XoqrYDjglHmXmlQ)

17. Tested the read ocr function from the postman.

- Made a few changes in the views.py
- Added a logging module to see the errors and to print other information. 
```
import logging
logging.basicConfig(level=logging.INFO)
```
- Printed the configuration like image, lang, and config before the request is made to fetch the image to make sure the request is received correctly. Image is fetched and stored in the root directory, so did not join the directory named data hard coded as IMAGEPATH variable. 
```
image_path = os.path.join(image_name)
```
_The below_ image is used for testing purposes.

![](https://lh3.googleusercontent.com/rLYhthjQhg7Ln8G_kOqqN1JU_AOrKjDZgnYmC_3DAnqLDZa74nA2vaJDC4_1T-Hs0XH1bj53TO6eVhd5k1oLAKongwZcBN5kqVGJDGGWdhfTWIxYFZcHAdRe2Q26Rg7GSq9MHVDNCrmY6JTZbx-TQ1PHNXSxOcJ9gPSVcGHEUlbIhO5uxXR6kkmluNzeiA)

Send the request from the postman.

Postman output

![](https://lh4.googleusercontent.com/oEA4qORU1B8yJh1gp2KsL5-WRnUeYFS9RuJxCrAjBaDv_ufIB9DSqRqOsIiykNwQRoPdGrZmvPbAcxS14Ui51GTxhlINdp35EcgsPX8XrED_U_m9PStWk2avyVKJ_--xR6B-Ur-6ROC3HUA69n7GjhhMXE81wyyvZiLZ-cGsMaz_kQVwz33BAinQ0N9uFQ)

Curl command used to send the request:
```
curl --location --request POST 'http://54.91.77.101:4000/read_ocr' \
--header 'Content-Type: application/json' \
--data-raw '{
    "image": "https://miro.medium.com/max/640/1*t4bo8ptFFmSNbYduTCrcKg.webp",
    "lang": "eng",
    "config": ""
}'
```

### Continuous Integration and Continuous Deployment:

CICD is achieved through the GitHub repository and GitHub Actions.  

On the [GitHub repository](https://github.com/abdulkader4513/precily),  added two new repository secrets - one named DOCKER_HUB_USERNAME to store the username of the Docker Hub repository and the second one named DOCKER_HUB_ACCESS_TOKEN to store the password of the docker hub. 

Created a new file named main.yml in the directory .github/workflows. Basically, on every change in the main branch, GitHub actions spin up the ubuntu container. 

Below are the steps performed in the GitHub Action

Step 1: Check out the repository
```
	name: Checkout
	uses: actions/checkout@v3
```
Step 2: Log in to Docker Hub with Credentials at the Secrets which we created
```
        name: Login to Docker Hub with Credentials at the Secrets
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_HUB_USERNAME }}
          password: ${{ secrets.DOCKER_HUB_ACCESS_TOKEN }}
```

Step 3: Instals and starts the minikube
```
      	name: Start minikube
        uses: medyagh/setup-minikube@master
```
Step 4: Checking kubectl command inside the minikube
```
      - name: Try the cluster !
        run: kubectl get pods -A
```
![](https://lh3.googleusercontent.com/ZOvtl2fRPpbFFGDxhA4chT0v1bMkYNIr_VAmoZ6-YphirOZVoMBIEhehOeRXSrOWHr7qp2XLV72GlOrhyyDdz-x7_Nezi_zhHE5UtZDUZhlhuPneW1XBaQmKjI1xPrdgbpzZGvbJtxu6vjRawOQc3YKdlf8ZKoR0OfuAUKlZmXtLxdkURyqnnsyNvKxnrw)

Step 5: docker-env is used to build docker images inside the minikube. Performed docker build and tag. Listed the docker images. Pushed the image to the Docker Hub.
```
        name: Build and push
        run: |
          export SHELL=/bin/bash
          eval $(minikube -p minikube docker-env)
          docker build -f ./Dockerfile -t abdulkader4513/precily .
          docker tag abdulkader4513/precily abdulkader4513/precily:latest
          docker images
          docker push abdulkader4513/precily:latest
          echo -n "verifying images:"
```
![](https://lh4.googleusercontent.com/seSLpjPMdqHjEO_1CfQLIEN_lcd5oLsAZLldWtuHtjYOgnj-mw8gnmga9eIjRYiBS8amo3wVPBj_b7JQO3tFj4Ytivi0UJ9_xu3l119Gp_YLmpMFnI75puQBA_9gH444_qCeZWw33hMoC_jv_nNZVoxzVb8VKAU-yJ0gAHtEiJqr4qCWyQ5GVXsxOyV4pg)

Step 6: Deployed the Kubernetes Deployment and Service using kubectl apply on the Kubernetes created configuration file deploy-to-minikube.yaml
```
        name: Deploy to minikube
        run:
          kubectl apply -f deploy-to-minikube.yaml
```
![](https://lh4.googleusercontent.com/rICbDmUYbVHy4CJtznlmkj4r6bEbsbSRbyhKPC0ScqaNCPhdfiXn-6pK6PWiLdS4yqPEToGtyC4DvjQpU3DEvS5aQxwlbK-grJHyO1DX_6xJ31AU3TbZvO85MVy-M-MesyufEOsSl2bvb9WR-9jtMxd4OJMKL1JX0a3vY8s-dgfAoSlO-1ENI0MKbTAncQ)

Step 7: In this stage, test two APIs. One uses a GET request and another uses a POST request. At the beginning of this stage, intentionally made the container sleep for one minute. This is because the Kubernetes service takes some time to give the External IP. Then listed the service using kubectl. Got the service URL of the container with the port. 
```
        name: Test service URLs
        run: |
          sleep 1m
          kubectl get svc
          minikube service list
          minikube service precily --url
          echo "------------------opening the service------------------"
          echo "curl $(minikube service precily --url)"
          echo "------------------TESTING ROOT FUNCTION------------------"
          curl $(minikube service precily --url)
          echo "------------------TESTING READ OCR FUNCTION------------------"
          echo "curl -X POST -H "Content-Type: application/json" -d '{"image":"https://miro.medium.com/max/640/1*t4bo8ptFFmSNbYduTCrcKg.webp","lang":"eng","config":""}' $(minikube service precily --url)/read_ocr"
          curl -X POST -H "Content-Type: application/json" -d '{"image":"https://miro.medium.com/max/640/1*t4bo8ptFFmSNbYduTCrcKg.webp","lang":"eng","config":""}' $(minikube service precily --url)/read_ocr
```
<!-- ![](https://lh5.googleusercontent.com/UprrCHCuQHQkCiMy5QaFpzdU3megU9LUwRKoYrDizCEhdwK2g8dv70C-3kScsQAt3dEOSq0djkTqWV7GRAju5VKK9GANUDTxyR-tS4Di2vzVm15sVSp8RjzzG1lmSXn9EG6yFf-QCVuiFRw19WNZs-wZwohBW1EgO6iHqQ93tnnqsDhsmn16Ehl9dVhA-Q) -->

![image](https://user-images.githubusercontent.com/114874167/205524146-52124e75-a7be-424a-8a1f-15142e7ad0b0.png)

The above image shows the response of the root page API and the read_ocr API functionality.  

Overall, CI and CD process is completed. Steps 1-5 belong to Continuous Integration and Step 6, Step 7 belong to Continuous deployment.


### Improvements:

1. CI and CD can be separated into two separate GitHub Actions. It would be great to have an approval process between them. Proposed CICD method: 

CI - Step 1 to 5  → Developer Lead/Manager → CD - Step 6 to 7 (Development Server) → Approval from Architect/Manager  → CD - Step 6 to 7 (QA Server) → QA Sign Off → Approval from Architect/Manager  → CD - Step 6 to 7 (Production Server)

2. Minikube is suitable for proof of concept and maybe for the development environment. It is better to go with managed Kubernetes Services like (AWS EKS, Linode LKE, or something similar). 
3. Provisioning of the EC2 server is performed using AWS Console. Provisioning of EC2 using Terraform is much preferred because of the state file. 
4. While performing the Flask API for read OCR, the response took almost 6 seconds on average. This may make the end users wait a long time. So it is better to go with the decoupled process meaning get the request from the end user, store the message in the queue and send the response to the user that we received your request. All the queue messages can be processed by worker servers and they can notify the end user after processing is over, and deletes the message from the queue.
5. Setting up a minikube requires lots of installation. Ansible can help here to make the installation process easier and at scale. 

### Reference:

1. Dockerfile for Python

   1. <https://docs.docker.com/language/python/build-images/#create-a-dockerfile-for-python>

2. Kubernetes Deployment

   1. <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>

3. Kubernetes Service

   1. <https://kubernetes.io/docs/concepts/services-networking/service/>

4. Running flask application in minikube

   1. <https://thecodinginterface.com/blog/flask-rest-api-minikube/>

5. Docker and Minikube Installation on Amazon EC2

   1. <https://faun.pub/how-to-install-minikube-on-ec2-ubuntu-22-04-lts-2022-fe642d6cbc40>

6. Image used for testing read ocr API

   1. <https://miro.medium.com/max/640/1*t4bo8ptFFmSNbYduTCrcKg.webp>

7. CI/CD configuration for Python Application

   1. <https://docs.docker.com/language/python/configure-ci-cd/>

8. Minikube in Github Actions

   1. <https://minikube.sigs.k8s.io/docs/tutorials/setup_minikube_in_github_actions/>
