# Welcome to My Sqlite
***

## Task
The task is to create a class MySqliteRequest that mimics the behavior of SQL requests using CSV files as the data source. Additionally, a Command Line Interface (CLI) must be created to interact with this class, allowing users to perform SQL-like operations such as SELECT, INSERT, UPDATE, and DELETE.

## Description
The problem is to implement a SQL-like interface for CSV files, allowing basic data operations through a familiar query syntax. The challenge lies in mimicking the SQL behavior and handling various query types, including joins, filtering, sorting, and modifying data, all while using Ruby to manipulate CSV files.

To solve this problem, the MySqliteRequest class is built to construct and execute queries step by step. Each method in the class returns the instance itself, allowing for method chaining. The class can handle SELECT, INSERT, UPDATE, DELETE operations, as well as WHERE conditions, ORDER BY clauses, and JOIN operations on a single CSV file.

The CLI is built using Ruby's readline library to interact with users, parse their input, and execute the corresponding operations using the MySqliteRequest class. This allows users to input queries in a SQL-like syntax and see the results directly in the terminal.

## Installation
To install and set up the project, follow these steps:
1. Clone the repository to your local machine: git clone https://github.com/your-username/my_sqlite_project.git
cd my_sqlite_project

2. Ensure you have Ruby installed. You can check this by running: ruby -v
If Ruby is not installed, follow the instructions on ruby-lang.org to install it.

3. No additional dependencies or packages are required for this project.


## Usage
To run the CLI and start interacting with your CSV files using SQL-like queries, execute the following command:
ruby my_sqlite_cli.rb

my_sqlite_cli> SELECT * FROM students;

my_sqlite_cli> quit


### The Core Team
ABDULKARIM MADINAH,  FAIZA HARUNA,  OTNI

<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px' /></span>
