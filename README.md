# devops-project

** Developed by vesna.milovanovic@endava.com **

** Tech Stack **
- Java
- Maven
- AWS
- Docker
- Terraform
- Ansible
- Jenkins
- Git

## Part 1 - Java Web App with Unit Tests 

Source Code: https://github.com/codingvesna/devops-project/tree/java-web-app

App Deployed to AWS EBS: http://javawebapp-env.eba-mbeiybg4.eu-central-1.elasticbeanstalk.com/

Or run on local machine:

 - Clone repo, start Tomcat Server, open port 8081 and go to browser ` http://localhost:8081/java-web-app/ `

### App Description

A Simple Web App built with Java & Maven.

**Test Cases:**

- Test Register Page - index.jsp
- Test Login page - home.jsp

### Prerequisities for App Development

- Java 17.0.1
- JWebUnit - Framework used with JUnit to test the web application.
- Apache Tomcat 9.0.56
- Apache Maven 3.8.4
- AWS Elastic Beanstalk (deployment)
- IntelliJ IDEA - IDE for app development
