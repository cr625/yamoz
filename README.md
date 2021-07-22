
# YAMZ Metadata Dictionary

This is the README for the YAMZ metadictionary and includes instructions for
deploying on a local machine for testing and on a Linux based environment for a
scalable production version. These assume a Ubuntu GNU/Linux environment, but
should be easily adaptable to any system; YAMZ is written in Python and uses
only cross-platform packages.

Authored by Chris Patton.

Updated 2 November 2017 (Dillon Arevalo).

Last updated 21 July 2021 Christopher Rauch (cr625)

YAMZ was formerly known as SeaIce, so the database tables and API use names based on "SeaIce".

## Prerequisites
* PostgreSQL
## Installing Components from Ubuntu Repositories
Update Ubuntu package list

`sudo apt update`

Once the packages have been updated install PostgreSQL and the -contrib packackage

`sudo apt install postgresql postgresql-contrib`

## Postgress default users
The default unix admin user, postgres, needs a password assigned in order to connect to a database. To set a password:

1. Enter the command:
   `sudo passwd postgres`
2. You will get a prompt to enter your new password.
3. Close and reopen your terminal.


To run PostgreSQL with psql shell:

1. Start your postgres service:

`sudo service postgresql start`

2. Connect to the postgres service and open the psql shell:

`sudo -u postgres psql template1`

Once you have successfully entered the psql shell, you will see your command line change to look like this:

`template1=#`

`sudo -u postgres psql template1`

Postgres psql requires an administrative user called 'postgres'.

`template1=# alter user postgres with encrypted password 'PASS';` [use your own password you will need it later for the configuration files.]

`template1=# \q` 

## Postgress authentication configuration
Configure the authentication method for postgres and all other users connecting locally
In `/etc/postgresql/12/main/pg_hba.conf` change "peer" to md5 for the administrative account and local unix domain socket

    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    # "local" is for Unix domain socket connections only
    local   all             all                                     md5
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            md5


Next, we want to only be able to connect to the database from the local machine

In `/etc/postgresql/12/main/postgresql.conf`

uncomment the line

`listen_addresses = 'localhost'`

Restart the postgres server

`sudo service postgresql restart`

Finally, log back in to postgres to create the database,

`sudo -u postgres psql`

`postgres=# create database seaice with owner postgres;`

`postgres=# create user contributor with encrypted password 'PASS';`

clone the repository in the home directory from `https://github.com/cr625/yamz.git`

Change to the appropriate branch

`cd yamz`

`git checkout uwsgi_updates`


create a configuration file called `.seaice` for the database and user account you set up like the following but with the credentials you choose. There is a template in the repository, but the production passwords should obviously not be made public. This file is used by the SeaIce DB connector to grant access to the database.


    [default]
      dbname = seaice
      user = postgres
      password = PASS
    [contributor]
      dbname = seaice
      user = contributor
      password = PASS
    [reader]
      dbname = seaice
      user = reader
      password = PASS


Set permissions with

`chmod 600 .seaice`

Initialize the DB schema and tables

`$ ./sea.py --init-db --config=.seaice`

set up user standard read/write permissions on the table 

`sudo -u postgres psql`

`postgres=# \c seaice;`

`postgres=# grant usage on schema SI, SI_Notify to contributor;`

`postgres=# grant select, insert, update, delete on all tables in schema SI, SI_Notify to contributor;`

`postgres=# \q`



## OAuth Credentials and appkey

YAMZ uses Google for third party authentication (OAuth-2.0) management of
logins. Visit https://console.cloud.google.com to set this service up
for your instance. Navigate to something like APIs and Services -> Credentials
and select whatever lets you create a new OAauth client ID.  For local
configuration, supply these answers:

    Application type . . . . . . . . . . Web application

    Authorized javascript origins  . . . http://localhost:5000
                                         http://localhost
                                         https://domain.name

    Authorized redirect URI  . . . . . . http://localhost:5000/authorized
                                         http://localhost/authorized
                                         https://domain.name/authorized

The credentials minus the port is for when the proxy web server is set up and you are no longer using the flask development server and have set up https on a named server.

In each case, you should obtain a pair of values to put into another
configuration file called '.seaice_auth'.  Create or edit this file,
replacing google_client_id with the returned 'Client ID' and replacing
google_client_secret with the returned 'Client secret'.

================

The contents of this directory are as follows:

  sea.py . . . . . . . . . . Console utility for scoring and classifying
                             terms and other things.

  ice.py . . . . . . . . . . Web server front end.

  digest.py  . . . . . . . . Console email notification utility.

  requirements.txt . . . . . Heroku package dependencies.

  Procfile . . . . . . . . . Heroku configuration.

  seaice/  . . . . . . . . . The SeaIce Python module.

  html/  . . . . . . . . . . HTML templates, static Javascript and CSS,
                             including bootstrap.js.

  doc/ . . . . . . . . . . . API documentation and tools for building it.

#  .seaice/.seaic_auth  . . . DB credentials, API keys, app key, etc. Note
  .seaice/.seaice_auth  . . . DB credentials, API keys, app key, etc. Note
                             that these files are just templates and don't
                             contain actual keys.

Before you get started, you need to set up a database and some software
packages.  On Mac OS X, this may suffice:

  $ pip install psycopg2 Flask configparser flask-login flask-OAuth \
      python-dateutil

On Ubuntu, grab the following:

  python-flask . . . . . . . Simple HTTP server.

  postgresql . . . . . . . . We're using PostgreSQL for database managment.

  python-psycopg2  . . . . . Python API for PostgreSQL.

  python-pip . . . . . . . . Package manager for additional Python
                             programs.

and then download a package from pip that handles configuration files nicely:

  $ sudo pip install \
      configparser flask-login flask-OAuth python-dateutil urlparse




=====================
I also needed $ chmod 600 .seaice_auth
=====================
  $ ./sea.py --init-db --config=local_deploy/.seaice



1.4 OAuth credentials and app key
=================================

YAMZ uses Google for third party authentication (OAuth-2.0) management of
logins. Visit https://console.developers.google.com to set this service up
for your instance. Navigate to something like API Manager -> Credentials
and select whatever lets you create a new OAauth client ID.  For local
configuration, supply these answers:

 Application type . . . . . . . . . . Web application
 Authorized javascript origins  . . . http://localhost:5000
 Authorized redirect URI  . . . . . . http://localhost:5000/authorized

Create another set of credentials for your heroku instance, say yamz-dev:

 Application type . . . . . . . . . . Web application
 Authorized javascript origins  . . . http://yamz-dev.herokuapp.com
 Authorized redirect URI  . . . . . . http://yamz-dev.herokuapp.com/authorized

In each case, you should obtain a pair of values to put into another
configuration file called '.seaice_auth'.  Create or edit this file,
replacing google_client_id with the returned 'Client ID' and replacing
google_client_secret with the returned 'Client secret'.

xxx Where does app_secret come in? does it come from the 'API key'?
    Manoj: app_secret only needed for heroku deployment

(See section 2.) XXX Are the instructions there complete, eg, redirect URL?)
XXX ?document this in a 0.x section, since it applies to local and heroku?

Next, create a configuration file called '.seaice_auth' with the appropriate
client IDs and secret keys. For instance, you may have credentials for
'http://localhost:5000', as well as a deployment on heroku:

XXX the google_client_id identifies your client software/(app?) and is
    paired with the redirect URL, eg, one for 'http://localhost:5000'
    and another for http://yamz.net...
xxx is this correct? each unique post-auth redirection target needs its
    own unique google_client_id
XXX to do: allow local dev to take place offline, ie, without contact
     with google for Auth or with minters and binders and n2t
xxx to do: let people create test terms that expire in two weeks

  [dev]
  google_client_id = 000-fella.apps.googleusercontent.com
  google_client_secret = SECRET1
  app_secret = SECRET2

  [heroku]
  google_client_id = 000-guy.apps.googleusercontent.com
  google_client_secret = SECRET3
  app_secret = SECRET4

IMPORTANT NOTE: A template of this file is provided in the github
repository. This file should remain secret and must not be published.
We provide the template, since heroku requires a commited file.

IMPORTANT WIP NOTE FOR CURRENT DEV VERSION: There are currently orcid
oauth keys being asked for as well. the dev credentials above will also
want to have an orcid_client_id and an orcid_client_secret obtainable
from sandbox. Alternatively (and the recommended option): Comment out
mentions to orcid oauth in ice.py
lines to comment: 119-120
                  281-331

For convenience, this file will also keep the Flask app's secret key. For
this key, enter a long, random string of characters. Finally, set the correct
file permissions with:

  $ chmod 600 .seaice_auth


1.5 N2T persistent identifier resolver credentials
==================================================

Whenever a new term is created, YAMZ uses an API to n2t.net (maintained by
the California Digital Library) in order to generate ("mint") a persistent
identifier.  The main role of n2t.net is to be a resolver for the public-
facing URLs that persistently identify YAMZ terms.  It is necessary to
provide a minter password for API access to this web service.  To do so
include a line in ".seaice_auth" for every view:

   minter_password = PASS

A password found in the MINTER_PASSWORD environment variable, however, will
be preferred over the file setting.  This password is used again in the
API call to store metadata in a YAMZ binder on n2t.net.  The main bit of
metadata stored is the redirection target URL that supports resolution of
ARK identifiers for YAMZ terms.

Because real identifiers are meant to be persistent, no local or test
instance of YAMZ should ever set the boolean "prod_mode" parameter in
".seaice_auth".  For such instances the generated and updated terms
should just be for identifiers meant to be thrown away.  Only on the
real production instance of YAMZ, when you're done testing term creation
and update, should it be set to "enable" (the default is don't enable).


1.6 Test the instance
=====================

First, create the database schema:

   $ ./sea --config=.seaice --init-db
  ===========
    needs to be $ ./sea.py --config=.seaice --init-db
  ===========

Start the local server with:

  $ ./ice.py --config=.seaice --deploy=dev
  ==========
    Adding terms won't work without a minter password, even on local dev version.
    Note also that minter password can't be set on local (doesn't do anything) and
    will currently only read from the heroku chunk in .seaice_auth
  ==========

If all goes well, you should be able to navigate to your server by typing
'http://localhost:5000' in the address bar. To verify that you've set up
Google OAuth-2.0 correctly, try logging in. This will create an account.
Try adding a new term, modifying and deleting a term, and commenting on
terms. To classify a term, do:

  $ ./sea.py --config=.seaice --classify-terms


2. Deploying to Heroku
======================

The YAMZ prototype is currently hosted at http://yamz.herokuapp.com.
Heroku is a cloud-computing service which allows users to host web-based
software projects. Heroku is scalable for a price; however, we can
still achieve quite a bit without spending money. We have access to a
small Postgres database, can schedule jobs, use a variety of packages
(all we need are available), and deploy easily with Git. Some limitations
of Heroku are that it is impossible to set up DB roles and any local files
cannot be assumed to persist after a reboot.

To begin, you need to setup an account with Heroku and download their software.
(It's nothing major, just some tools for running commands, interacting with
the database, etc.) Visit http://www.heroku.com.

Heroku requires a couple additional configuration files and some small
code changes. The additional files (already set up in the repo) are:

  Procfile . . . . . . . specifies the commands that start web server, as
                         well as periodic jobs.

  requirements.txt . . . a list of packages required by our software that
                         Heroku needs to make available. These are
                         available via pip.

I used the following tutorial: https://devcenter.heroku.com/articles/python
to set these up.  Once you've set up your heroku account, you're ready to
deploy.

The recommended best practice for managing your heroku instance is to set up
a local branch called 'deploy_keys' based on 'master'. In this branch, edit
.seaice and .seaice_auth to contain actual passwords and API and app keys.
NOTE: IT IS CRITICAL THAT YOU DON'T PUSH THIS BRANCH TO GITHUB.
Publishing these secrets compromises the security of the entire app.

Login via the heroku website and create a new app. Let's say we've named it
"fella". Navigate to the directory containing the cloned repository. Create
and checkout the branch 'deploy_keys'.

  $ git checkout -b deploy_keys
  $ heroku login
  $ heroku git:remote -a fella

This creates a "slug" containing our code and its dependencies. To get the web
app running, we'll now need to set up a database and a couple of heroku backend
services.


2.1 Heroku-Postgres
===================

Heroku-Postgres is a scalable DB interface for heroku apps. (See the
python section of devcenter.heroku.com/articles/heroku-postgresql .)
To create a free addon,

  $ heroku addons:create heroku-postgresql:hobby-dev

The 'master' branch is set up to use either a local postgres database server
or Heroku-Postgres.  The location of the DB in the "cloud" is specified
when you create the heroku addon, and heroku automatically sets the
instance's environment variable DATABASE_URL, which you can query with

  $ heroku config

Using 'sea' or 'ice' with '--config=heroku' will force SeaIce to use the
web address found in this variable to connect to the DB. (Note this is the
default.) Heroku-Postgres doesn't allow you to create roles, so '--role'
will be ignored and the default will be used.  To create the database schema:

  $ heroku run python sea.py --init-db


2.2 Mailgun
===========

YAMZ provides an email notification service for users who opt in. A utility
called 'digest' collects for each user all notifications that haven't
previously been emailed into a single digest. The code uses a heroku backend
app called Mailgun for SMTP service. To set this up, simply type (you may be
asked to verify your heroku account with a credit card, but note your card
should not be charged for the most basic service level)

  $ heroku addons:create mailgun

This sets a number of instance environment variables (see "heroku config").
Of them the code uses "MAILGUN_SMTP_LOGIN" and "MAILGUN_SMTP_PASSWORD" to
connect to Mailgun. Normally that happens when notifications are harvested
by the scheduler (below), but to send out notifications manually, type:

  $ heroku run python digest.py


2.3 Heroku-Scheduler
====================

There are two periodic jobs that need to be scheduled in YAMZ: the term
classifier and the email digest. To set this up, do:

  $ heroku addons:create scheduler
  $ heroku addons:open scheduler

The second command will take you to the web interface for the scheduler. Add
the following two jobs:

  "python sea.py --classify-terms" . . . . . every 10 minutes
  "python digest.py" . . . . . . . . . . . . once per day


2.4 Starting the instance
=========================

Now that your instance is all prepared, you can get it up and running with

  $ git push heroku deploy_keys:master

This pushes the secret keys found in the local deploy_keys branch so that
they update the remote master branch on heroku.  (xxx see section 1.4 and
??? for setting the secrets)
# xxx app_secret is the (api key?) password from netrc, or "heroku auth:token"?


2.5 Making changes
==================

Deploying changes to heroku is made easy with Git. Suppose we have changes
to 'master' that we want to push to heroku.

  $ git checkout deploy_keys
  $ git merge master          # updates deploy_keys with latest master commits
  $ git push heroku deploy_keys:master

The first command checks out the already created local 'deploy_keys' branch.
The second command merges the latest commits from the master branch into it,
and the final command updates the heroku master branch, which also restarts
the instance.  This keeps the secrets outside the master branch.

When you next checkout the master branch, however, your keys and secrets in
the .seaice* files will be overwritten, so you may want to save them in
separate files that you can copy back in to the branch when you later deploy
again; just make sure those separate files don't ever become part of any
branch that will show up in the public github repo.


2.6 Exporting the dictionary
============================

The SeaIce API includes queries for importing and exporting database tables
in JSON formatted objects. This could be used to backup the entire database.
Note however that imports must be done in the proper order in order to satisfy
foreign key constraints. To back up the dictionary, do:

  $ heroku config | grep DATABASE_URL
  DATABASE_URL: <whatever>
  $ export DATABASE_URL=<whatever>
  $ ./sea.py --config=heroku --export=Terms >terms.json


3. URL forwarding
=================

The current stable implementation of YAMZ is redirected from http://yamz.net.
Setting this up takes a bit of doing. The following instructions are synthsized
from http://lifesforlearning.com/heroku-with-godaddy/ for redirecting a domain
name managed by GoDaddy to a Heroku app.

Launch the "Domains" app on GoDaddy. Under "Forward Domain" for the appropriate
domain (let's call it "fella.org"), add the following settings:

 Forward to . . . . . . . . . . . . . . . . . . . . http://www.fella.org
 Redirect type  . . . . . . . . . . . . . . . . . . 301 (Permanent)
 Forward settings . . . . . . . . . . . . . . . . . Forward only
 Update nameservers and DNS settings
           to support this change . . . . . . . . . yes

Next, under "Manage DNS", remove all entries except for 'A (Host)' and 'NS
(Nameserver)', and add the following under 'CName (Alias)':

 Record type  . . . . . . . . . . . . . . . . . CNAME (Alias)
 Host . . . . . . . . . . . . . . . . . . . . . www
 Points to  . . . . . . . . . . . . . . . . . . http://fella.herokuapp.com
 TTL  . . . . . . . . . . . . . . . . . . . . . 1 Hour

Next, change the IP address for entry '@' under 'A (Host)' to 50.63.202.31
(the current IP address of yamz.net).

That's it for DNS configuration. The last thing we need to do is modify the
redirect URLs in the Google OAuth API. Edit the authorized javascript origins
and redirect URI by replacing "fella.herokuapp.com" with "fella.org" and
save.

It can take a couple hours to a day for your DNS settings to propogate. Once
it's done, you can navigate to YAMZ by typing "fella.org" into your browser.
Try logging in to verify that the OAuth settings are also correct.


4. Building the docs
====================

The seaice package (but not this README file) is autodoc'ed using
python-sphinx. To install on Ubuntu:

  $ sudo apt-get install python-sphinx

The directory doc/sphinx includes a Makefile for exporting the docs to
various media. For example,

  make html
  make latex
