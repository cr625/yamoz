# YAMZ-O Metadictionary

YAMZ-O is an open-source vocabulary builder designed for managing data and metadata collaboratively. This README provides detailed instructions for setup, configuration, and deployment of the YAMZ-O application, both for local development and scalable production environments.

---

## Table of Contents

1. [Install](#install)
2. [Postgres Configuration](#postgres-configuration)
3. [Configuration (`config.py`)](#configuration-configpy)
4. [Running the Application](#running-the-application)
5. [OAuth Credentials](#oauth-credentials)
6. [Deploying to Production](#deploying-to-production)
7. [Nginx Configuration](#nginx-configuration)
8. [Backups](#backups)
9. [Development Environment](#development-environment)
10. [Reinstalling YAMZ Environment](#reinstalling-yamz-environment)

---

## Install

### Prerequisites
1. **Python 3.8 or later**
   - Install Python via your package manager. On macOS, use:
     ```bash
     brew install python3
     ```
   - Check your Python version:
     ```bash
     python3 --version
     ```

2. **Postgres**:
   - Install Postgres:
     - [Postgres Downloads](https://www.postgresql.org/download/)
     - On macOS:
       ```bash
       brew install postgresql
       brew services start postgresql
       ```
     - On Ubuntu:
       ```bash
       sudo apt update
       sudo apt install postgresql postgresql-contrib
       ```

3. **Virtualenv**:
   - Install virtualenv:
     ```bash
     pip3 install virtualenv
     ```

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/cr625/yamz-o.git
   cd yamz-o
   ```

2. **Set up a Virtual Environment**:
   ```bash
   virtualenv env
   source env/bin/activate
   ```

3. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure the Application**:
   - Update the `_config.py` file with your database credentials and rename it to `config.py`.

---

## Postgres Configuration

1. **Set a Password for the Postgres User**:
   ```bash
   sudo passwd postgres
   ```

2. **Configure Postgres Authentication**:
   - Open the `pg_hba.conf` file:
     ```bash
     sudo nano /etc/postgresql/14/main/pg_hba.conf
     ```
   - Replace `peer` with `md5` for the following lines:
     ```plaintext
     # TYPE  DATABASE        USER            ADDRESS                 METHOD
     local   all             all                                     md5
     host    all             all             127.0.0.1/32            md5
     ```

3. **Allow Local Connections**:
   - Open the `postgresql.conf` file:
     ```bash
     sudo nano /etc/postgresql/14/main/postgresql.conf
     ```
   - Uncomment and update:
     ```plaintext
     listen_addresses = 'localhost'
     ```

4. **Restart Postgres**:
   ```bash
   sudo service postgresql restart
   ```

5. **Create the Database**:
   ```bash
   sudo -u postgres psql
   postgres=# CREATE DATABASE yamz_o WITH OWNER postgres;
   postgres=# \q
   ```

---

## Configuration (`config.py`)

1. Rename `_config.py` to `config.py`:
   ```bash
   mv _config.py config.py
   ```

2. Update `config.py` with your credentials:
   ```python
   OAUTH_CREDENTIALS = {
       "google": {"id": "<google-client-id>", "secret": "<google-client-secret>"},
       "orcid": {"id": "<orcid-client-id>", "secret": "<orcid-client-secret>"},
   }
   ```

---

## Running the Application

1. **Initialize the Database**:
   ```bash
   flask db init
   flask db migrate
   flask db upgrade
   ```

2. **Run the Application**:
   ```bash
   export FLASK_APP=yamz_o.py
   export FLASK_ENV=development
   flask run
   ```

3. **Run on a Specific Port** (e.g., 5001):
   ```bash
   export FLASK_RUN_PORT=5001
   flask run
   ```

---

## OAuth Credentials

YAMZ uses Google and ORCID for authentication. Follow these steps:

1. **Google**:
   - Visit the [Google Console](https://console.cloud.google.com/apis/credentials).
   - Create a new OAuth Client ID.

2. **ORCID**:
   - Register at [ORCID](https://orcid.org/).

3. Update the `config.py` file with the credentials.

---

## Deploying to Production

1. **Create a `yamz_o.ini` File**:
   ```ini
   [uwsgi]
   module = yamz_o:app
   master = true
   processes = 5
   socket = yamz_o.sock
   chmod-socket = 660
   vacuum = true
   die-on-term = true
   ```

2. **Create a Systemd Unit File**:
   ```ini
   [Unit]
   Description=uWSGI instance to serve yamz
   After=network.target

   [Service]
   User=<your-username>
   Group=www-data
   WorkingDirectory=/home/<your-username>/yamz
   ExecStart=uwsgi --ini yamz.ini

   [Install]
   WantedBy=multi-user.target
   ```

3. **Enable the Service**:
   ```bash
   sudo systemctl start yamz
   sudo systemctl enable yamz
   ```

---

## Nginx Configuration

1. **Create a Server Block**:
   ```plaintext
   server {
       listen 80;
       server_name yamz-o.link www.yamz-o.link;

       location / {
           include uwsgi_params;
           uwsgi_pass unix:/home/<your-username>/yamz-o/yamz_o.sock;
       }
   }
   ```

2. **Enable the Configuration**:
   ```bash
   sudo ln -s /etc/nginx/sites-available/yamz /etc/nginx/sites-enabled
   sudo unlink /etc/nginx/sites-enabled/default
   sudo nginx -t
   sudo systemctl restart nginx
   ```

---

## Backups

1. **Backup the Database**:
   ```bash
   pg_dump -C -Fp -f yamz_o.sql -U postgres yamz_o
   ```

2. **Restore the Database**:
   ```bash
   dropdb -U postgres yamz_o
   psql -U postgres -f yamz_o.sql
   ```

---
