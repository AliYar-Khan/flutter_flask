import bcrypt
from flask import Flask, jsonify, request
import os
from flask_jwt_extended import JWTManager, create_access_token, get_jwt_identity, jwt_required
import psycopg2
import json

app = Flask(__name__)
app.config['JWT_SECRET_KEY'] = '3212dfkasdasd'
app.config['JWT_TOKEN_LOCATION'] = ['headers']

jwt = JWTManager(app)

def get_db_connection():
    conn = psycopg2.connect(
        host="localhost",
        database="postgres",
        user=os.environ['DB_USERNAME'],
        password=os.environ['DB_PASSWORD'])
    return conn

@app.route('/users/register', methods=['POST'])
def register():
    data = request.get_json()
    fullname = data.get('fullname')
    email = data.get('email')
    password = data.get('password')
    phone_number = data.get("phone")
    address = data.get("address")


    if not fullname or not email or not password or not phone_number:
        return jsonify({'message': 'Full name, email, password, and phone number are required'}), 400

    conn = get_db_connection()
    try:
        # Check if the email already exists
        with conn.cursor() as cur:
            cur.execute('SELECT id FROM users WHERE email = %s', (email,))
            if cur.fetchone():
                return jsonify({'message': 'User with this email already exists'}), 409

            # Hash the password
            password_bytes = password.encode('utf-8')
            salt = bcrypt.gensalt(rounds=12)
            hashed_password = bcrypt.hashpw(password=password_bytes,salt=salt).decode('utf-8')

            # Insert the new user into the database
            cur.execute(
                'INSERT INTO users (full_name, email, password, phone_number, address) '
                'VALUES (%s, %s, %s, %s, %s)',
                (fullname, email, hashed_password, phone_number, address)
            )
            conn.commit()

        return jsonify({'message': 'User registered successfully'}), 201

    except Exception as e:
        # Log or print the error for debugging
        print(f"Error: {e}")
        conn.rollback()
        return jsonify({'message': 'Internal server error'}), 500

@app.route('/users/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password_user = data.get('password')

    if not email or not password_user:
        return jsonify({'message': 'Email and password, both are required'}), 400
    
    conn = get_db_connection()
    try:
        with conn.cursor() as cur:
            cur.execute('SELECT id, email, password FROM users WHERE email = %s', (email,))
            user = cur.fetchone()

            if not user:
                return jsonify({'message': 'Invalid email or password'}), 401

            # Check the password
            id, email, password = user
            password_bytes = password_user.encode('utf-8')
            if not bcrypt.checkpw(password=password_bytes, hashed_password=password.encode('utf-8')):
                return jsonify({'message': 'Invalid email or password'}), 401
            identity = json.dumps({'id': id, 'email': email})
            access_token = create_access_token(identity=identity)
            return jsonify({'access_token': access_token}), 200

        
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'message': 'Internal server error'}), 500
    

@app.route('/users/', methods=['GET'])
@jwt_required()
def list_users():
    current_user = get_jwt_identity()
    data_jwt = json.loads(current_user)
    print(f"data_jwt {data_jwt}")
    if not current_user:
        return jsonify({'message': 'Invalid token or user not authenticated'}), 401

    conn = get_db_connection()
    try:
        # Fetch users from the database
        with conn.cursor() as cur:
            cur.execute('SELECT id, full_name, email, phone_number, address FROM users')
            users = cur.fetchall()

        # Format the user data as a list of dictionaries
        user_list = [
            {
                'id': user[0],
                'full_name': user[1],
                'email': user[2],
                'phone_number': user[3],
                'address': user[4]
            }
            for user in users
        ]

        return jsonify({ 'data': user_list}), 200

    except Exception as e:
        # Log the error and return an appropriate message
        print(f"Error: {e}")
        return jsonify({'message': 'Internal server error'}), 500
    

if __name__ == '__main__':
    app.run(debug=True, port=9000)