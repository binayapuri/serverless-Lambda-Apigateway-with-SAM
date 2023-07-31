

import pymysql
import json

# Establish the database connection
def get_database_connection():
    endpoint = 'bp-rds.cmuokqciitb8.us-east-1.rds.amazonaws.com'
    username = 'binay'
    password = 'password'
    database_name = 'todos'
    connection = pymysql.connect(host=endpoint, user=username, passwd=password, db=database_name)
    return connection

# Create the "Students" table
def create_students_table():
    connection = get_database_connection()
    cursor = connection.cursor()
    query = '''
        CREATE TABLE IF NOT EXISTS Students (
            StudentID INT AUTO_INCREMENT PRIMARY KEY,
            LastName VARCHAR(255),
            FirstName VARCHAR(255),
            Address VARCHAR(255),
            City VARCHAR(255),
            Remark VARCHAR(255)
        )
    '''
    cursor.execute(query)
    connection.commit()
    connection.close()

# Retrieve all students
def get_students():
    connection = get_database_connection()
    cursor = connection.cursor()
    cursor.execute('SELECT * FROM Students')
    rows = cursor.fetchall()
    results = []
    for row in rows:
        result = {
            'StudentID': row[0],
            'LastName': row[1],
            'FirstName': row[2],
            'Address': row[3],
            'City': row[4],
            'Remark': row[5]
        }
        results.append(result)
    connection.close()
    return results

# Create a new student
def create_student(student_data):
    connection = get_database_connection()
    cursor = connection.cursor()
    # Assuming the student_data is a dictionary containing the student details
    query = "INSERT INTO Students (LastName, FirstName, Address, City, Remark) VALUES (%s, %s, %s, %s, %s)"
    values = (student_data['LastName'], student_data['FirstName'], student_data['Address'], student_data['City'], student_data['Remark'])
    cursor.execute(query, values)
    connection.commit()
    connection.close()
    return "Student created successfully"

# Update an existing student
def update_student(student_id, student_data):
    print("=====success =====")
    connection = get_database_connection()
    cursor = connection.cursor()
    query = "UPDATE Students SET LastName = %s, FirstName = %s, Address = %s, City = %s, Remark = %s WHERE StudentID = %s"
    values = (student_data['LastName'], student_data['FirstName'], student_data['Address'], student_data['City'], student_data['Remark'], student_id)
    cursor.execute(query, values)
    connection.commit()
    connection.close()
    return "Student updated successfully"

# Delete a student
def delete_student(student_id):
    connection = get_database_connection()
    cursor = connection.cursor()
    query = "DELETE FROM Students WHERE StudentID = %s"
    cursor.execute(query, student_id)
    connection.commit()
    connection.close()
    return "Student deleted successfully"

# Lambda handler function
def lambda_handler(event, context):
    create_students_table()  # Create the "Students" table if it doesn't exist
    
    if event['httpMethod'] == 'GET':
        students = get_students()
        json_data = json.dumps(students)
        return {
            "statusCode": 200,
            "body": json_data
        }
    elif event['httpMethod'] == 'POST':
        student_data = json.loads(event['body'])
        response = create_student(student_data)
        return {
            "statusCode": 200,
            "body": response
        }
    elif event['httpMethod'] == 'PUT':
        print(event)
        student_id = event['pathParameters']['id']
        student_data = json.loads(event['body'])
        response = update_student(student_id, student_data)
        return {
            "statusCode": 200,
            "body": response
        }
    elif event['httpMethod'] == 'DELETE':
        print(event)
        student_id = event['pathParameters']['id']
        response = delete_student(student_id)
        return {
            "statusCode": 200,
            "body": response
        }
    else:
        return {
            "statusCode": 400,
            "body": "Invalid request"
        }
