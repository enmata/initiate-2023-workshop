## AWS Initiate 2023 Migration workshop

### Table of contents
* [Abstract](#abstract)
* [Event URLs](#event-urls)
* [Workshop tools and services](#workshop-tools-and-services)
* [Main folder structure](#main-folder-structure)

### Abstract

This repository contains documentation and automations covering AWS Initiate 2023 Migration workshop workflow

### Event URLs

- INITIATE Barcelona 2023 Public Main website (22/10/2023) [AWS INITIATE BARCELONA](https://aws-experience.com/emea/iberia/e/2ddfe/aws-initiate-barcelona)
- Migration and modernization workshop Website [Workshop Public Event Initiate Lab: Migración de Aplicaciones Monolíticas (18/01/2024)](https://aws-experience.com/emea/iberia/e/f1dab/lab-migraci%C3%B3n-de-aplicaciones-monol%C3%ADticas)

### Workshop tools and services

The following tools and services has been used:

- Database Migration Tool (DMS)
    - Based Workshop URL [Modernize with AWS App2Container Workshop -> Modernize your Java App -> Migrate Your Database](https://catalog.us-east-1.prod.workshops.aws/workshops/2c1e5f50-0ebe-4c02-a957-8a71ba1e8c89/en-US/getting-started/on-your-own)
    - Based Workshop [CloudFormation s3 template](https://ws-assets-prod-iad-r-iad-ed304a55c2ca1aee.s3.us-east-1.amazonaws.com/2c1e5f50-0ebe-4c02-a957-8a71ba1e8c89/app2container_cfn_own_account.yml)

    - Related DMS links:
        - [AWS -> Documentation -> AWS Database Migration Service](https://docs.aws.amazon.com/dms/#user-guides-and-references)
        - [Database Migration Guide -> Step-by-Step Walkthroughs](https://docs.aws.amazon.com/dms/latest/sbs/dms-sbs-welcome.html)
        - [User Guide -> Components Network Reference Architecture](https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Introduction.Components.html)

    - Additional - DMS Related links:
        - [Schema Conversion Tool FAQs](https://aws.amazon.com/dms/schema-conversion-tool)
        - [AWS Cloud Operations & Migrations Blog -> Creating Database Migration Waves using AWS Schema Conversion Tool](https://aws.amazon.com/blogs/mt/creating-database-migration-waves-using-aws-schema-conversion-tool)

- App2Container
    - Based Workshop URL [Modernize with AWS App2Container Workshop -> Modernize your Java App -> Containerize your Java App](https://catalog.us-east-1.prod.workshops.aws/workshops/2c1e5f50-0ebe-4c02-a957-8a71ba1e8c89/en-US/java-modernize-your-app/java-containerize-your-app)
    - Based Workshop [CloudFormation s3 template](https://ws-assets-prod-iad-r-iad-ed304a55c2ca1aee.s3.us-east-1.amazonaws.com/2c1e5f50-0ebe-4c02-a957-8a71ba1e8c89/app2container_cfn_own_account.yml)

    - Related App2Container links:
        - [App2Container FAQs](https://aws.amazon.com/app2container/faqs)
        - [App2Container User Guide](https://docs.aws.amazon.com/app2container/latest/UserGuide/start-intro.html)
        - [GitHub aws-samples/aws-app2container-ansible](https://github.com/aws-samples/aws-app2container-ansible)

- Application Migration Service (AMS)
    - Based Workshop URL [Application Migration with AWS -> Application Migration -> Option-1 Rehost - AWS Application Migration Service (MGN)](https://catalog.us-east-1.prod.workshops.aws/workshops/c6bdf8dc-d2b2-4dbd-b673-90836e954745/en-US/01-getting-started)
    - Based Workshop [CloudFormation s3 template](https://ws-assets-prod-iad-r-pdx-f3b3f9f1a7d6a3d0.s3.us-west-2.amazonaws.com/c6bdf8dc-d2b2-4dbd-b673-90836e954745/migration_workshop_source_template.yml)
        - Related AMS links:
            - [AMS FAQs](https://aws.amazon.com/application-migration-service/faqs)
            - [AMS User Guide](https://docs.aws.amazon.com/mgn/latest/ug/getting-started.html)
            - [AMS Network Reference Architecture](https://docs.aws.amazon.com/mgn/latest/ug/Network-Settings-Video.html)

### Main folder structure

Files and scripts has been distributed as follows:

```
├── README.rd                                   _# repository documentation_
├── migracion aplicaciones monoliticas.pdf      _# workshop description_
├── AMS                                         _# folder containing scripts managing Application Migration Service_
    ├── 00-Installing-hugo-ubuntu.sh            _# script installing nginx web server and hugo example template on ubuntu_
    ├── 01-SetupAMS-agent.sh                    _# script installing Application Migration Service and its dependencies on ubuntu_
    └── migration_workshop_source_template.yml  _# original yaml file defining cloudformation original based workshop_
├── App2Container                               _# folder containing scripts managing App2Container Service_
    ├── 00-Installing-amazon-linux.sh           _# script installing App2Container and its dependencies on amazon linux_
    ├── 00-Installing-ubuntu.sh                 _# script installing App2Container and its dependencies on ubuntu linux_
    ├── 01-ContainerizeDeploy-ECSFargate-Workshop.sh  _# script analyzing Java sample APP, containerizing, setting up the deployment and deploying the APP on ECS Fargate on TargetVPC_
    └── app2container_cfn_own_account.yml        _# original yaml file defining cloudformation original based workshop_
├── DMS                                          _# folder containing scripts managing Database Migration Service_
    ├── 00-Installing-amazon-linux.sh            _# script installing jq dependency on ubuntu_
    ├── 01-CreateRDS-PostgreSQL-Workshop.sh      _# script creating target managed PostgreSQL RDS by using aws cli_
    ├── 02-SetupDMS-PostgreSQL-Workshop.sh       _# script setting up DMS replication by using aws cli_
    ├── app2container_cfn_own_account.yml        _# original yaml file defining cloudformation original based workshop_
    └── table-mappings-postgresql.json           _# json file defining replication schema used during replication task definition_
├── Presentation-slides                          _# Folder containing slides and agenda of related INITIATE 2023 Event in Barcelona (22/10/2023) (Spanish)_
    ├── AWS INITIATE BARCELONA - Agenda.pdf                     _# Agenda from initiate Barcelona 2023 Public Main website_
    └── DemoLab - Migracion de aplicaciones monoliticas.pdf     _# slides used during presentations_
```
