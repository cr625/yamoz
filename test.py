#!/usr/bin/python
# Fix concept id's on terms.
from __future__ import print_function
import sys
import optparse
import psycopg2 as pqdb

import seaice

#  Parse command line options. #

parser = optparse.OptionParser()

parser.add_option("--config", dest="config_file", metavar="FILE",
                  help="User credentials for local PostgreSQL database" +
                  "(defaults to '$HOME/.seaice'). " +
                  "If 'heroku' is given, then a connection to a foreign host specified by " +
                  "DATABASE_URL is established.",
                  default='heroku')

parser.add_option("--role", dest="db_role", metavar="USER",
                  help="Specify the database role to use for the DB connector pool. These roles " +
                  "are specified in the configuration file (see --config).",
                  default="default")

(options, args) = parser.parse_args()


#  Establish connection to PostgreSQL db #

try:

    if options.config_file == "heroku":

        sea = seaice.SeaIceConnector()

    else:
        try:
            config = seaice.auth.get_config(options.config_file)
        except OSError:
            print("error: config file '%s' not found" % options.config_file, file=sys.stderr)
            sys.exit(1)

        sea = seaice.SeaIceConnector(config.get(options.db_role, 'user'),
                                     config.get(options.db_role, 'password'),
                                     config.get(options.db_role, 'dbname'))

    cur = sea.con.cursor()
    cur.execute('SELECT NOW();')

    (t,) = cur.fetchone()
    print('{} {} {}'.format(t.day, seaice.pretty.monthOf[t.month - 1], t.year))


    #  Commit database mutations. #
    sea.commit()

except pqdb.DatabaseError as e:
    print('error: {}'.format(e))
    sys.exit(1)

except IOError:
    print("error: file not found", file=sys.stderr)
    sys.exit(1)

except ValueError:
    print("error: incorrect paramater type(s)", file=sys.stderr)
