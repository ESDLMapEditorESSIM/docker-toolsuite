# ESDL MapEditor and ESSIM

This project contains all information necesarry to run the ESDL MapEditor and ESSIM toolsuite on your local machine or cloud infrastructure.

## Contents

- [ESDL MapEditor and ESSIM](#esdl-mapeditor-and-essim)
  - [Contents](#contents)
  - [What can I do with the MapEditor and ESSIM?](#what-can-i-do-with-the-mapeditor-and-essim)
  - [What is ESDL?](#what-is-esdl)
  - [Features](#features)
    - [ESDL MapEditor Features](#esdl-mapeditor-features)
    - [ESSIM Features](#essim-features)
  - [The architecture of the Toolsuite](#the-architecture-of-the-toolsuite)
  - [Setting up and running the software stack](#setting-up-and-running-the-software-stack)
    - [Prerequisites](#prerequisites)
	- [Steps to follow](#steps-to-follow)
    - [Step 1. Edit the .env file according to your needs](#step-1-edit-the-env-file-according-to-your-needs)
    - [Step 2. Run the setup.sh script](#step-2-run-the-setup.sh-script)
    - [Step 3. Starting the toolsuite](#step-3-starting-the-toolsuite)
    - [Step 4. Creating user accounts](#step-4-creating-user-accounts)
    - [Step 5. Configure role based access control for ESSIM dashboard](#step-5-configure-role-based-access-control-for-essim-dashboard)
    - [Step 6. Create an API key in Grafana for the Panel Service](#step-6-create-an-api-key-in-grafana-for-the-panel-service)
    - [Step 7. Log in to the ESDL MapEditor](#step-7-log-in-to-the-esdl-mapeditor)
    - [Step 8. Upload some profiles](#step-8-upload-some-profiles)
  - [ESDL MapEditor and ESSIM Tutorials](#esdl-mapeditor-and-essim-tutorials)
  - [Cloud deployment](#cloud-deployment)
  - [Details](#details)
    - [Running services](#running-services)
    - [Default credentials](#default-credentials)
    - [Configuration](#configuration)
      - [InfluxDB](#influxdb)
      - [PostgresDB](#postgresdb)
      - [ESDL Drive](#esdl-drive)
  - [License](#license)

## What can I do with the MapEditor and ESSIM?

The ESDL MapEditor is a map based energy system editor. You can use it to create ESDL based energy system descriptions, that can then be simulated with a growing number of ESDL capable simulators.
ESSIM is our ESDL based energy system simulator that gives insights in the hourly energy (im)balance of an energy system described in the ESDL language.

![Toolsuite GUI impression](Documentation/Images/toolsuite-gui-impression.png)

To get an impression of what the tools can do and how they look like, have look at the [tutorials](https://github.com/ESDLMapEditorESSIM/essim-tutorials).

## What is ESDL?

ESDL is a modelling language created to describe complete (hybrid) energy systems in one uniform format. It allows to describe information about the individual energy system components, how they are connected, how they are used (e.g. using energy production or consumption profiles), where they are physically located (on the map), what they cost (now and in future). Furthermore information about buildings in an area, energy potential, KPIs (on buildings, areas, or any assets) can be described. Possible applications are facilitating interoperability between different energy transition models and publishing open data on energy systems.

Click [here](https://energytransition.gitbook.io/esdl/) for the ESDL documentation website

Click [here](https://energytransition.github.io/) for the ESDL class documentation website (a clickable ESDL model)

Click [here](https://github.com/EnergyTransition/ESDL) for the ESDL github website

## Features

### ESDL MapEditor Features

- Draw an energy system scenario by dragging and dropping energy assets on a map
- Connect components, set typical component characteristics (installed power, efficiencies, costs)
- Attach power or energy profiles to assets (demand and production profiles)
- Set control strategies (specifically needed for ESSIM simulations)
- Query external ESDL data sources, for example for solar or wind potential
- Visualize WMS layers with information that can be used to define your scenario
- Convert shapefiles into ESDL assets
- Query the boundary service for area borders (provinces, municipalities)
- Visualize results of simulations on the map (KPI dashboards, load animations, color areas based on KPI outcomes, load duration curves)

Click [here](https://energytransition.gitbook.io/esdl/esdl-based-tools/mapeditor) for some more information on the ESDL MapEditor

### ESSIM Features

- Simulates energy systems defined in ESDL and calculates energy balance over time
- Calculates optimal schedule of flexible producers and the effect of this schedule in terms of emissions, costs, load on the network
- Calculates schedules for conversion and storage in a similar manner

Click [here](https://energytransition.gitbook.io/esdl/esdl-based-tools/essim) for some more information on ESSIM

## The architecture of the Toolsuite

The architecture of the toolsuite provided is shown here (the gray components are open source solutions provided by others):
![](Documentation/Images/toolsuite-architecture.png)

It consists of the following functionalities:

- ESDL MapEditor: map based scenario editor
- ESSIM: energy system simulator, to calculate hourly energy balance and give insights in effects of conversion and storage
- Identity & Access Management: using keycloak, an open-source IAM solution, it provides user management, roles, groups, organisations, authentication and authorisation, role based access control
- ESDL Drive: cloud storage for ESDL files, with access control at user, group or organisation level (supports versioning in the near future)
- Panel Service: service to create graphs from influxdb time series
- Boundary Service: service that gives boundary information for provinces, municipalities, neighbourhoods, and so on
- Grafana: open-source analytics & monitoring solution for every database
- InfluxDB: open-source time series database solution
- PostgresDB with PostGIS extension: open-source relational database management system
- MongoDB: open-source document-oriented database program (NoSQL)

## Setting up and running the software stack

Although the software was designed to run in a hosted environment somewhere in the cloud or in your in-company datacenter, the software can be run on a local laptop or PC as well. The following steps describe the installation process on a local machine. In [the cloud deployment chapter](#cloud-deployment) we'll give some directions for cloud deployment

Caddy was added as a reverse proxy and to terminate SSL traffic, if you wish to use this version on your own device, comment anything that has something to do with Caddy out.

### Prerequisites

The current stack uses docker and docker-compose. The minimum versions required are currently:

| Software       | Version    |
| ---------------|------------|
| Docker engine  |   19.03.12 |
| docker-compose |     1.26.2 |
| GNU/Linux      | Any recent | (If you have Windows you can attempt to translate the setup.sh script into powershell or run it on WSL)
| Bash           |        Any |
| Curl           |        Any |

> **_NOTE:_**  Macbook M1 users and users of the ARM64 architecture are experiencing difficulties when trying to install this software, because it is incompatible with the Intel x64 architecture we use on our servers and laptops. We are looking into creating multi-arch docker images but this is work in progress. For now: reach out to an Intel-based machine or VM to install this software.


### Steps to follow

- [Step 1. Edit the .env file according to your needs](#step-1-edit-the-env-file-according-to-your-needs)
- [Step 2. Run the setup.sh script](#step-2-run-the-setup.sh-script)
- [Step 3. Starting the toolsuite](#step-3-starting-the-toolsuite)
- [Step 4. Creating user accounts](#step-4-creating-user-accounts)
- [Step 5. Configure role based access control for ESSIM dashboard](#step-5-configure-role-based-access-control-for-essim-dashboard)
- [Step 6. Create an API key in Grafana for the Panel Service](#step-6-create-an-api-key-in-grafana-for-the-panel-service)
- [Step 7. Log in to the ESDL MapEditor](#step-7-log-in-to-the-esdl-mapeditor)
- [Step 8. Upload some profiles](#step-8-upload-some-profiles)

### Step 1. Edit the .env file according to your needs

In the .env file, change the parameters required for your setup. If the section includes DEFAULTS in the comment leading the section, you can leave variables empty to set them to their defaults. Passwords will be automatically generated if left empty. If you are using your own domain to make the environment reachable from the outside, make sure to edit the domain name and set up the subdomains as shown in the .env file. Once you have defined the existing environment variables no other edits in other files should be necessary.

---
**NOTE FOR WINDOWS USERS:**

When cloning this repository using git for windows, file line endings are automatically converted from LF (Unix style) to CRLF (Windows style). This causes problems for the file BaseInfrastructure/postgres/init-database.sh as it is being mounted in one of the docker containers running linux. Please make sure that this file gets Unix style line endings, by converting it back using for example notepad++ or dos2unix, or configure git in such a way that it doesn't automatically convert line endings to windows style (Search for 'git autocrlf').

---
### Step 2. Run the setup.sh script
The setup.sh script makes sure the entire environment is started automatically. It defines secure passwords if not defined, and set values in files. In it's current state however, it is not yet fully automated. The manual parts of the setup are explained in the following steps. 

### Step 3. Starting the toolsuite
To start the toolsuite, type: docker-compose up. All the containers will be started in the right order for you.

### Step 4. Creating user accounts

Using you webbrowser, go to `http://localhost:8080` to open keycloak
![](Documentation/Images/keycloak-portal.png)

Login with the admin credentials as specified in the docker-compose file
![](Documentation/Images/keycloak-login-screen.png)

Once you're logged in, you should see the following screen
![](Documentation/Images/keycloak-loggedin.png)

Click `Users` from the menu on the left
![](Documentation/Images/keycloak-users.png)

Click `Add User` and fill in the proper user credentials and click `Save`. Be sure to fill in an email address!
![](Documentation/Images/keycloak-add-user.png)

After clicking `Save` a number of tabs appear. Go to the `Credentials` tab and set the password of the newly created user
![](Documentation/Images/keycloak-set-password.png)

Go to the `Attributes` tab and add an attribute `role` with value `essim`, press `Add` and press `Save`
![](Documentation/Images/keycloak-set-attributes.png)

### Step 5. Configure role based access control for ESSIM dashboard

The ESSIM dashboard is a Grafana based solution for viewing simulation results. Grafana supports multiple roles: Viewer, Editor and Admin. If you want to give some users other roles than Viewer, add the roles Editor and/or Admin to keycloak and assign these roles to the appropriate user. When you don't do this, all users get the Viewer rights.

Go to the user that needs to become an Editor or Admin, go to the `Role Mappings` tab, at `Client Roles` select `essim-dashboard` and add the Editor or Admin role to the user.
![](Documentation/Images/keycloak-essim-dashboard-assign-role-to-user.png)

### Step 6. Create an API key in Grafana for the Panel Service

Log in to Grafana, go to `http://localhost:3000` and login with the credentials from the user with Admin rights you've just created.
![](Documentation/Images/grafana-login.png)

Select the menu option 'API keys' in the settings menu.
![](Documentation/Images/grafana-create-apikeys.png)

Click the button 'New API key'
![](Documentation/Images/grafana-click-new-api-key.png)

Fill in the details for the API key. Choose a name (e.g. 'panel-service') and make sure to give it the 'Admin' role.
![](Documentation/Images/grafana-api-key-details.png)

Copy the generated API key.
![](Documentation/Images/grafana-api-key-copy.png)

Fill in this API key in the file `panel-service.env` (Replace the key that is already there).

```sh
GRAFANA_API_KEY=eyJrIjoiV3g0Z3pGUUxBNkhucXlySjhCRFczNXZwVXhiREhrRXciLCJuIjoicGFuZWwtc2VydmljZSIsImlkIjoxfQ==
```

Now that the API key is inserted in panel-service.env, ESSIM and the panel-service have to be restarted.
```bash
docker-compose restart panel-service
docker-compose restart essim
```

### Step 7. Log in to the ESDL MapEditor

Using your webbrowser go to `http://localhost:8111`
![](Documentation/Images/mapeditor-portal.png)

Press `Start` and log in using the credentials created in the previous step
![](Documentation/Images/mapeditor-login-screen.png)

You should see the following screen now:
![](Documentation/Images/mapeditor-main-page.png)

### Step 8. Upload some profiles

If you're installing this toolsuite to run ESSIM simulations or any other application that requires timeseries data, you need to upload some profiles. For that purpose we've created a profile manager. In the repository there is an example dataset with profiles created from publically available data (NEDU profiles for electricity and gas usage and KNMI solar profile).

Click `View` and select `Settings` from the menu. The application settings dialog appears. Click `Upload profiles`. In the first drop down menu select:
- Personal profiles: to upload profiles that will become available only for the current user
- Standard profiles: to upload profiles that will become available for all users
- Project profiles for ...: to upload profiles related to a project, so that all project members can use these profiles
![](Documentation/Images/settings-upload-profiles.png)

Drag the file `.\Data\Profiles\standard_profiles.csv` and drop it in the area indicated in the dialog. Depending on your local machine's regional settings (Use '.' or ',' as the decimal seperator) you might need to choose the other csv file in the same directory.
![](Documentation/Images/settings-upload-profiles-done.png)

After the uploading is finished, click `Profiles plugin` in the menu on the left. On the right side a window appears where you can view and edit the settings of the profiles you've just uploaded.
![](Documentation/Images/settings-profiles-plugin.png)

The profiles can now be used in the simulations.

## ESDL MapEditor and ESSIM Tutorials

Please go [here](https://github.com/ESDLMapEditorESSIM/essim-tutorials) to find five different tutorials that explain how to work with the ESDL MapEditor and ESSIM

## Cloud deployment

In order to run this software stack in a hosted environment, several services must be offered to the end-user:

- The MapEditor frontend: the main entry point for this software stack for end uses
- The ESSIM dashboard: to show ESSIM simulation results
- Keycloak (Identity & Access Management): to facilitate the login process
- The panel service: to visualize the profile data from within the MapEditor

Optionally the following services can be offered too:

- ESDL drive: although the functionality provided from within the MapEditor is more extensive

In our own hosted environment we use [traefik](https://containo.us/traefik/) as a reverse proxy in front on the above listed services, for two reasons:

- to terminate SSL traffic
- as a reverse proxy: to route HTTP traffic to the right container

Furthermore we use:

- [docker swarm](https://docs.docker.com/engine/swarm/): to create a cluster of several virtual machines
- [portainer](https://www.portainer.io/): for container management
- [docker registry](https://docs.docker.com/registry/deploying/): to locally push container images and make deployment in the swarm easier

The four (or five) services listed in the beginning of this chapter must be accessible via seperate domain names (using a local or global DNS server) or seperate IP addresses. As the essim dashboard and the panel service both use grafana as their frontend, they could be treated as the same service if that's desirable. We tried running the services using sub-paths (e.g. https://mycompany.com/mapeditor and https://mycompany.com/essim-dashboard) but we were not very successful to get everything up and running.

The following picture shows how a deployment with a reverse proxy
![](Documentation/Images/deployment-with-reverse-proxy.png)

Required changes:

- In `BaseInfrastructure\docker-compose.yml`
  - Find `GF_SERVER_ROOT_URL`: change `localhost` to the domain name for the ESSIM dashboard
  - Find `GF_AUTH_SIGNOUT_REDIRECT_URL`: change two (!) occurences of `localhost` to the domain name for keycloak
  - Find `GF_AUTH_GENERIC_OAUTH_AUTH_URL`: change `localhost` to the domain name for keycloak
- In `BaseInfrastructure\keycloak\esdl-mapeditor-realm.json` (or login to keycloak and change using their web-based management interface)
  - Replace all occurences of `localhost:port` to the respective domain names
- In `ESDLMapeditor\mapeditor_open_source.env`:
  - Find `PANEL_SERVICE_EXTERNAL_URL`: replace `localhost` with the domain name of the panel service
  - Find `EXTERNAL_GRAFANA_URL`: replace `localhost` with the domain name of grafana.
- In `ESSIM\docker-compose.yml`:
  - Find `GRAFANA_EXTERNAL_URL`: replace `localhost` with the domain name of grafana.
- (To be improved) Inside the MapEditor container, find the file `credentials\client_secrets_opensource.json`
  - Replace all occurences of `localhost` to the respective domain names (one for the mapeditor and 3 for keycloak)

## Details

### Running services

| Service   | Port | Environment variable |
| --------- | ---- | -------------------- |
| MapEditor | 8111 | MAPEDITOR_PORT       |
| Grafana   | 3000 | GRAFANA_PORT         |
| Keycloak  | 8080 | KEYCLOAK_PORT        |
| PGAdmin   | 5050 | PGADMIN_PORT         |

| Service    | Port  | Environment variable |
| ---------- | ----- | -------------------- |
| Mongo      | 27017 | MONGO_PORT           |
| InfluxDB   | 8086  | INFLUXDB_PORT        |
| PostgresDB | 5432  | POSTGRES_PORT        |

| Service    | Port            | Environment variable |
| ---------- | --------------- | -------------------- |
| ESDL Drive | 9080            | -                    |
| ESDL Drive | 9443 (SSL-port) | -                    |

### Default credentials

| Service    | User             | Password | Configured in                                     | Comment |
| ---------- | ---------------- | -------- | ------------------------------------------------- | ------- |
| Keycloak   | admin            | admin    | docker-compose.yml                                |         |
| Grafana    | admin            | admin    | docker-compose.yml and ESSIM/docker-compose.yml   |         |
| InfluxDB   | admin            | admin    | docker-compose.yml                                |         |
| PostgresDB | postgres         | password | docker-compose.yml                                |         |
| PostgresDB | keycloak         | password | init-database.sh and docker-compose.yml           |         |
| PostgresDB | boundary_service | password | init-database.sh                                  |         |
| PostgresDB | drive            | password | init-database.sh and ESDLDrive/docker-compose.yml |         |
| PGAdmin    | admin@admin.org  | admin    | docker-compose.yml                                |         |

### Configuration

#### InfluxDB

...

#### PostgresDB

The file `.\BaseInfrastructure\postgres\init-databases.sh` contains the initialization script for the postgres database.

#### ESDL Drive

ESDL Drive exists of 3 components: ESDL Drive (API), CDO-Server (ESDL -> Relational database mapper) and Postgres (Database).
ESDL Drive uses the Postgres database for storage of ESDL files. CDO-Server must be configured with the correct credentials to connect to Postgres database from the base infrastructure. This can be done in the `docker-compose.yml` of ESDLDrive. The database and 'drive' account are created in the `init-databases.sh` script

ESDL Drive (API) is secured by KeyCloak and needs some configuration, among others the URL of the ESDL-Mapeditor realm (both internal as external accessible by the browser). This is configuration is defined in `ESDLDrive/docker-compose.yml`. Environment variables defined in the YML file are used in `server.xml` which configures the Open Liberty server that is packaged in the container in `/servers/hub`.

ESDL Drive also needs the public key of the ESDL-Mapeditor realm, to verify the JWT tokens from Keycloak. For this setup the public key is already added in the `public.p12` keystore, but if it is changed, edit the file in `/server/hub/resources/security/public.p12` with the Java `keytool`.


=======
##### Data migration
As ESDL is being updated frequently to support more use cases, the database schema of the ESDL Drive needs to be updated accordingly. 
This is currently a manual process. See the [Data migration explanation](./Documentation/DataMigration/README.md) for more information.


Users/Password/Database

## License

MapEditor and ESSIM are distributed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).
