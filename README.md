# ESDL MapEditor and ESSIM

This project contains all information necesarry to run the open source ESDL MapEditor and ESSIM toolsuite on your local machine or cloud infrastructure.

## Open source components (with Github links)

This software stack consists of the following open source components with the link to their github repositories:
- [ESDL MapEditor](https://github.com/ESDLMapEditorESSIM/esdl-mapeditor)
- [ESDL Drive](https://github.com/ESDLMapEditorESSIM/esdl-drive)
- [ESSIM](https://github.com/ESDLMapEditorESSIM/essim)
- [Boundary Service](https://github.com/ESDLMapEditorESSIM/boundary-service)
- [Panel Service](https://github.com/ESDLMapEditorESSIM/panel-service)

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
    - [Step 1. Configuring and starting the software for the base infrastructure](#step-1-configuring-and-starting-the-software-for-the-base-infrastructure)
    - [Step 2. Creating user accounts](#step-2-creating-user-accounts)
    - [Step 3. Configure role based access control for ESSIM dashboard](#step-3-configure-role-based-access-control-for-essim-dashboard)
    - [Step 4. Create an API key in Grafana for the Panel Service](#step-4-create-an-api-key-in-grafana-for-the-panel-service)
    - [Step 5. Start the MapEditor and ESSIM](#step-5-start-the-mapeditor-and-essim)
    - [Step 6. Log in to the ESDL MapEditor](#step-6-log-in-to-the-esdl-mapeditor)
    - [Step 7. Upload some profiles](#step-7-upload-some-profiles)  
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

The ESDL MapEditor is a map-based energy system editor. You can use it to create ESDL based energy system descriptions, that can then be simulated with a growing number of ESDL-capable simulators, or processed with ESDL-capable tools.
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
- Identity & Access Management: using Keycloak, an open-source IAM solution, it provides user management, roles, groups, organisations, authentication and authorisation, role based access control
- ESDL Drive: cloud storage for ESDL files, with access control at user, group or organisation level (supports git-like versioning)
- Panel Service: service to create graphs from InfluxDB time series data
- Boundary Service: service that gives boundary information for provinces, municipalities, neighbourhoods, and so on
- Grafana: open-source analytics & monitoring solution for every database
- InfluxDB: open-source time series database solution
- PostgresDB with PostGIS extension: open-source relational database management system
- MongoDB: open-source document-oriented database program (NoSQL)

## Setting up and running the software stack

Although the software was designed to run in a hosted environment somewhere in the cloud or in your in-company datacenter, the software can be run on a local laptop or PC as well. The following steps describe the installation process on a local machine. In [the cloud deployment chapter](#cloud-deployment) we'll give some directions for cloud deployment

### Prerequisites

The current stack uses docker and docker compose. The tested versions are currently:

| Software       | Version |
| ---------------|---------|
| Docker engine  |  26.1.3 |
| Docker Compose |   2.6.1 |

> **_NOTE:_**  Macbook M1 users and users of the ARM64 architecture are experiencing difficulties when trying to install this software, because it is incompatible with the Intel x64 architecture we use on our servers and laptops. We are looking into creating multi-arch docker images but this is work in progress. For now: reach out to an Intel-based machine or VM to install this software.


### Steps to follow

- [Step 1. Configuring and starting the software for the base infrastructure](#step-1-configuring-and-starting-the-software-for-the-base-infrastructure)
- [Step 2. Creating user accounts](#step-2-creating-user-accounts)
- [Step 3. Configure role based access control for ESSIM dashboard](#step-3-configure-role-based-access-control-for-essim-dashboard)
- [Step 4. Create an API key in Grafana for the Panel Service](#step-4-create-an-api-key-in-grafana-for-the-panel-service)
- [Step 5. Start the MapEditor and ESSIM](#step-5-start-the-mapeditor-and-essim)
- [Step 6. Log in to the ESDL MapEditor](#step-6-log-in-to-the-esdl-mapeditor)
- [Step 7. Upload some profiles](#step-7-upload-some-profiles)

### Step 1. Configuring and starting the software for the base infrastructure

---
**NOTE FOR WINDOWS USERS:**

When cloning this repository using git for windows, file line endings are automatically converted from LF (Unix style) to CRLF (Windows style). This causes problems for the file `BaseInfrastructure/postgres/init-database.sh` as it is being mounted in one of the docker containers running linux. Please make sure that this file gets Unix style line endings, by converting it back using for example notepad++ or dos2unix, or configure git in such a way that it doesn't automatically convert line endings to windows style (Search for 'git autocrlf').

---

To configure the base infrastructure have a look at the `.env.template` file in de `BaseInfrastructure` folder and copy it to a `.env` file and adapt to your situation (defaults should work out of the box for a localhost installation, but are not secure).

Start the base infrastructure (databases, grafana, pgadmin, ...)


```sh
cd BaseInfrastructure
docker-compose up
```
> Note: use `docker-compose up -d` to start the base infrastructure in the background.

Wait for the base infrastructure to be ready.

### Step 2. Creating user accounts

Using you webbrowser, go to `http://localhost:8080/auth` to login to keycloak (Note: don't forget the `/auth`, this is needed for newer Keycloak versions to be compatible with older versions). 

Login with the admin credentials as specified in the docker-compose file or your adapted `.env` file.
![](Documentation/Images/keycloak-login-screen.png)

Once you're logged in, you see a welcome for the master realm (e.g. to configure other realms, or change the admin password).
![](Documentation/Images/keycloak-loggedin-master.png)

Select the `ESDL Studio (esdl-mapeditor)` realm using the drop-down on the top-left.
![](Documentation/Images/keycloak-loggedin-esdlstudio.png)

Click `Users` from the menu on the left
![](Documentation/Images/keycloak-users.png)

Click `Add User` and fill in the proper user information and click `Create`. Be sure to fill in an email address!
![](Documentation/Images/keycloak-add-user.png)

After clicking `Save` a number of tabs appear. Go to the `Credentials` tab, select `Set password` and set the password of the newly created user in the popup. 
![](Documentation/Images/keycloak-set-password.png)

Go to the `Attributes` tab and add an attribute with `role` as key and with `essim` as value, and press `Save`.
![](Documentation/Images/keycloak-set-attributes.png)

### Step 3. Configure role based access control for ESSIM dashboard

The ESSIM dashboard is a Grafana based solution for viewing simulation results. Grafana supports multiple roles: Viewer, Editor and Admin. If you want to give some users other roles than Viewer, add the roles Editor and/or Admin to Keycloak and assign these roles to the appropriate user. When you don't do this, all users get the Viewer rights.

Go to the user that needs to become an Editor or Admin, go to the `Role Mapping` tab, and press the `Assign Role` button. A popup is displayed with all possible client roles in the realm. Search for `essim-dashboard - Admin` or `essim-dashboard - Editor` and check the role and press `Assign` to add the Editor or Admin role to the user (select only one).
![](Documentation/Images/keycload-essim-dashboard-assign-role-to-user.png)

### Step 4. Create an API key in Grafana for the Panel Service

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

Fill in this API key in the file `.\ESDLMapEditor\panel-service.env` (Replace the key that is already there).

```sh
GRAFANA_API_KEY=eyJrIjoiV3g0Z3pGUUxBNkhucXlySjhCRFczNXZwVXhiREhrRXciLCJuIjoicGFuZWwtc2VydmljZSIsImlkIjoxfQ==
```

### Step 5. Start the MapEditor and ESSIM

In another terminal window, start ESSIM:

```sh
cd ESSIM
docker-compose up
```

In yet another terminal window, start the ESDL MapEditor and accompanying services:

```sh
cd ESDLMapEditor
docker-compose up
```

To start ESDL Drive storage do the following in another terminal (or use -d option for each `docker-compose` command, to start in detached mode):

```sh
cd ESDLDrive
docker-compose up
```

### Step 6. Log in to the ESDL MapEditor

Using your webbrowser go to `http://localhost:8111`
![](Documentation/Images/mapeditor-portal.png)

Press `Start` and log in using the credentials created in the previous step
![](Documentation/Images/mapeditor-login-screen.png)

You should see the following screen now:
![](Documentation/Images/mapeditor-main-page.png)
The ESDL Mapeditor is ready to be used!

### Step 7. Upload some profiles

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

> Recently we have also successful setups in Kubernetes. Reach out for more details.

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
- In `ESDLMapEditor\docker-compose.yml`
  - Find `EXTERNAL_GRAFANA_URL`: change `localhost` to the domain name for ESDL Mapeditor
- In `ESDLMapeditor\mapeditor_open_source.env`:
  - Find `PANEL_SERVICE_EXTERNAL_URL`: replace `localhost` with the domain name of the panel service
- (To be improved) Inside the MapEditor container, find the file `credentials\client_secrets_opensource.json`
  - Replace all occurences of `localhost` to the respective domain names (one for the mapeditor and 3 for keycloak)
  - or mount a different version in ./ESDLMapeditor/docker-compose.yml
  ```yaml
    volumes:
      - "./esdl-mapeditor/client_secrets_opensource.json:/usr/src/app/credentials/client_secrets_opensource.json"
  ```
- In `BaseInfrastructure\keycloak\esdl-mapeditor-realm.json` (or login to keycloak and change using their web-based management interface)
  - Replace all occurences of `localhost:port` to the respective domain names
- Keycloak is configured to start in `dev`-mode (`start-dev`), allowing it to be used without SSL certificates (meaning that all traffic is insecure). 
  Configure Keycloak to start in 'normal' mode, see the `./BaseInfrastructure/docker-compose.yml` for some hints on setting this up correctly in combination with a reverse proxy that terminates SSL traffic.


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
| Grafana    | admin            | admin    | docker-compose.yml                                |         |
| InfluxDB   | admin            | admin    | docker-compose.yml                                |         |
| PostgresDB | postgres         | password | docker-compose.yml                                |         |
| PostgresDB | keycloak         | password | init-database.sh                                  |         |
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

ESDL Drive (API) is secured by KeyCloak and needs some configuration, among others the URL of the ESDL-Mapeditor realm (both internal as external accessible by the browser). This is configuration is defined in `ESDLDrive/docker-compose.yml`. Environment variables defined in the YAML file are used in `server.xml` which configures the Open Liberty server that is packaged in the container in `/servers/esdl-drive-server`.


=======
##### Data migration
As ESDL is being updated frequently to support more use cases, the database schema of the ESDL Drive needs to be updated accordingly. If you set `AUTO_UPDATE=1` in the environmental variables of cdo-server, it will try to auto-update the schema, but no guarantees are given. Please backup your postgres database before migration, or use the esdl-drive tool to extract all ESDL-files from the drive before upgrading, to make sure you have a good backup.
See the [Data migration explanation](./Documentation/DataMigration/README.md) for more information.


## License

MapEditor and ESSIM are distributed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).
