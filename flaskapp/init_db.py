import os
import psycopg2

conn = psycopg2.connect(
        host="localhost",
        database="postgres",
        user=os.environ['DB_USERNAME'],
        password=os.environ['DB_PASSWORD'])

# Open a cursor to perform database operations
cur = conn.cursor()

# Execute a command: this creates a new table
cur.execute('DROP TABLE IF EXISTS users;')
cur.execute('CREATE TABLE users (id serial PRIMARY KEY,'
                                 'full_name varchar (150) NOT NULL,'
                                 'email varchar (150) NOT NULL UNIQUE,'
                                 'password varchar (150) NOT NULL,'
                                 'phone_number varchar (150) NOT NULL,'
                                 'address varchar (500),'
                                 'date_added date DEFAULT CURRENT_TIMESTAMP);'
                                 )

conn.commit()

cur.close()
conn.close()