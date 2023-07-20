# ESDL Drive data migration

## Introduction
The ESDL language is currently in development, e.g. concepts are added and updated according to use cases. This means that the structured model of ESDL changes over time. Most changes are additions, 
allowing for backwards compatibility: old ESDL files can still be read, edited and stored in the latest version of the MapEditor and ESDL Drive. Sometimes, the changes have more impact. 
Nonetheless, when ESDL changes, the database schema of the Postgres database that ESDL Drive uses needs to be updated to support this.

This document describes how to update this database schema.

## General approach
ESDL is specified in the esdl.ecore file. When a new version is created, the following steps need to be taken:

1. Regenerate the classes for the ESDL model
    1. For Python-based applications this means to rerun `pyecoregen` with the correct options. This holds for e.g. the MapEditor (there is a script in the MapEditor repo that does this for you).
     This command updated the esdl package used in python programs.
	 
    2. For Java-based applications there are two options:
	   1. CDO-based applications such as ESDL-Drive. CDO is used as ORM to map ESDL classes on Postgres database tables. This requires a specific way to create the Java clases, and is configured in the cdo-buildtools branch
	    of the ESDL-repository. Run `mvn clean install` in the `esdl.parent` folder to update an ESDL-based jar you can use in your Java projects.
	   2. Non-CDO application (almost all). They can use the jar that is automatically created when an update of ESDL is made in the repository. This is pushed to TNO's HESI maven repository. If you add the following to your maven 
		configuration, you'll always get the latest ESDL snapshot version:
		 
            ```xml
            <!-- the hesi snapshot repository updates ESDL after each push -->
            <repositories>
                <repository>
                    <id>hesi-snapshots</id>
                    <name>HESI snapshot artifactory</name>
                    <url>http://ci.hesi.energy:8081/artifactory/libs-snapshot-local</url>
                </repository>
            </repositories>
            ```
            
            and as dependency
                
            ```xml
            <dependency>
                <groupId>nl.tno.esdl</groupId>
                <artifactId>esdl</artifactId>
                <version>1.1.1-SNAPSHOT</version>
            </dependency>
            ```
    
            As alternative you can create the jar yourself.		
            Rerun maven on the ESDL-repository (`mvn clean install`) in the `esdl.parent` folder. This creates a Jar with all the lastest ESDL classes in it. 
		
# Updating the ORM mapping of CDO
ESDL drive uses CDO as ORM mapping tool (plus a lot of other features CDO offers). Unfortunately, migrating the database schema is not implemented. Several research project have done some activities in this area (part of EU FP7 Paasage project),
but is not ready for production. Therefore we've created a migrate tool to update the repository.
There are two ways:
1. Dump all the ESDL-files from the ESDL drive, update the ESDl drive to the latest version, clean the database, and upload all dumped files back to the drive. This is the easiest (and recommended) method, but all history is deleted. 
   Also, if ESDL has changed such that old ESDL files are not compatible with the newest version, you need to manually update these ESDL-files. (There are some ideas to automate this process, but this is not implemented yet.)
   
   This process is supported by the `esdl-drive` command-line tool, that allows you to dump all the ESDL-files from the repo on the local disk, using the `-X /` option. When logging in, use an account with esdl-drive-admin
   privileges, to be able to access all the files in the repo.
   
   The `esdl-drive` command line tool can be found in the esdl-drive-tools repository.
2. Run the steps below to update the database schema manually.



## Migrating manually
ESDL Drive database schema update
Use this to upgrade the database schema to the new ESDL version (so called model evolution)

### Summary of order of steps:
1.	Import dump of current db
2.	Create new db with new esdl tables
3.	Create diff and filter diff
4.	COPY renamed data in DB
5.	Run migrate script
6.	Run diff script
7.	Start cdo with REGISTER=1 option


Starting steps:
1.	Generate new ESDL-CDO java classes (ESDL project in branch cdo-buildutils) with mvn clean install (install it in the local maven repo). Set the correct version of the project in pom.xml and plugin.xml of the esdl-project in the esdl-repo.
2.	Generate a new cdo-server based on the new ESDL-CDO version (using the cdo-server repo).
3.	Generate a new esdl-drive based on the new ESDL-CDO version (using the esdl-drive repo).

### Steps

Steps:
1. Configure CDO Server to use the new ESDL version
2. Start CDO server on a new database (call it ‘new’) and upload a new ESDL file
    * This triggers the creation of all the tables for the new ESDL version in the new database as CDO Server is configured with ‘eagerTableCreation=true”
3. Dump production database to SQL
    ```
    pg_dump -U drive -h localhost -p 5432 esdlrepo > esdldrivedump-2020-01-01.sql
    ``` 
4. Import SQL in temporary database, call this db production
    ```psql  -U drive -h localhost -p 5432 production < esdldrivedump-2020-01-01.sql```
5. Create a schema difference between the new database and the production database using PgAdmin Tools->Create schema diff (this takes a while) (see screenshot) Make sure the target database is ‘production’ and the source database is ‘new’ 
    * Select only the changes to the tables in the public schema (e.g. not the topology schema)
6. Click “generate script” to get the diff SQL
7. Check the diff script and see if it makes sense. Keep an eye on tables that are dropped but do contain content. I did not solve this problem yet. Until now these ESDL classes were not used. If they are still referenced this will probably throw errors in CDO…
    i. A dropped table might also indicate a rename of a class. In that case you can copy over the content from the old table to the new table and configure Migrate.java to update the unique feature id’s in cdo_objects table. An example of that is defined at the top of Migrate.java.
    ii. For those renamed ESDL classes, copy the table data to the new table manually, and add the associated uri’s from the cdo_external_refs to the rename Hashmap in Migrate.java. Example SQL command:
    ```SQL
    BEGIN;
    INSERT into esdl_pvpark SELECT * FROM esdl_pvparc;
    INSERT into esdl_pvpark_port_list SELECT * FROM esdl_pvparc_port_list;
    INSERT into esdl_windpark SELECT * FROM esdl_windparc;
    INSERT into esdl_windpark_port_list SELECT * FROM esdl_windparc_port_list;
    END; 
    ```
9. Configure the Migrate.java with the correct database names
   In CDO each class is linked to a unique (negative) ID, the feature ID. In the new schema these IDs have changed and the old database needs to be updated to use these new IDs. Migrate.java updates these IDs in the cdo_external_refs and subsequently updates all the cdo_objects that use these id’s (the feature column)
10. Run Migrate.java and check it analysis and step through all the database changes.
11. The migration script from step 3 contains all kinds of updates on constraints. This is because the constraint’s name has changed. Running the db migration script directly causes errors, therefore use the FilterSchemaDiff.java to filter out these unnecessary constraints.
12. Apply the filtered database migration script from step 11.
13. If something goes wrong you need to reimport the data you dumped in step 3 and start over.
14. Restart cdo-server compiled with the latest version of ESDL to upgrade the ESDL version of the database. The esdl.ecore is namely also stored in the database in the cdo_package_units table (as a byte array). To re-register ESDL in the CDO database set the environment variable REGISTER=1 first before starting the cdo-server.jar:
    ```
    POSTGRESQL_DATABASE=production REGISTER=1 java -jar target/cdo-server-1.0.0-jar-with-dependencies.jar
    ```
15. Restart ESDLDrive API with the latest ESDL version compiled in and check if everything works. You can also use the CDO explorer in eclipse to check this.
16. If everything is ok, export/dump the updated ‘production’ database and import it in the production system. Update CDO-server and ESDL Drive api containers and have fun!






