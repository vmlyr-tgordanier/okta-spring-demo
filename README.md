# Okta Spring Boot SPA Authentication Demo

## Prerequisites
If you plan to run the demo under Docker:
- Docker Engine
- Docker Compose
- An environment capable of running Bash scripts (Unix/Linux, OSX, and Windows 10 under WSL2)

If you plan to run directly with Java:
- JRE 8 or newer
- Gradle

<br />

## Configuration
You will need to create two configuration files before running the demo.  These files will contain settings specific to the Okta SPA app, which you should have created using their [Okta Developer Portal](https://developer.okta.com/) previously. 

### Frontend application.properties file
The first file will need to be placed at `front-end/src/main/resources/application.properties`.   A sample has been provided in this directory for you.  The two important values you will replace here are:
```
okta.oauth2.issuer=https://dev-XXXXXXXX.okta.com/oauth2/default
okta.oauth2.client-id=XXXXXXXXXXXXXXXX
```

Both settings can be found in the application's General settings tab. The domain name in the issuer url is same as your Okta domain.

### API application.yml file
The second file will need to be placed at `resource-server/src/main/resources/application.yml`.   A sample has also been provided in this directory for you.  The only value you will replace here is:
```
issuer: https://XXXXXXXXXXX.okta.com/oauth2/default
```

This value MUST match the value as set in the frontend application.properties file.

<br />


## Running via Docker
Two Docker setup scripts were created to get things up and running quickly for those who are impatient, or don't feel like setting up Java and Gradle on their system just yet.

Open a new terminal window to run the API server:
```
cd resource-server/docker
./setup.sh
./run.sh
```

Open a new terminal window to run the frontend server:
```
cd front-end/docker
./setup.sh
./run.sh
```

For both Docker containers, it is not necessary to run `setup.sh` more than once.  To exit the running shell script, just hit CTRL-C.  To restart the server, simply re-run `run.sh`.

<br />

## Running locally
To run the API locally, open a new terminal, change into the `resource-server` folder , then build and run using Gradle:

```
cd resource-server
./gradlew build && ./gradlew bootRun
```

Similarly, to startup the frontend server, open a new terminal, change into the 'front-end' folder, then build and run:

```
cd front-end
./gradlew build && ./gradlew bootRun
```

<br />

## Credits
This demo is almost entirely based on the [Spring Security OAuth Sample Applications for Okta](https://github.com/okta/samples-java-spring) project on GitHub. Some alterations were made to utilize Gradle vs. Maven, and Docker scripts were added to aid in quick installation.