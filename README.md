# Cinematrix
A course project for CS 257. Cinematrix is a DBMS that gives a user convenient access to information related to their favourite movies, TV shows, and celebrities.

Made by
| Name         | Roll No |
|--------------|---------|
| Aman Gupta        | 230001006     |
| Srinidhi Sai Boorgu          | 230001072     |
| Abhinav Bitragunta     | 230001003     |
| Ansh Jain     | 230004005     |


The website used the following technologies:
| Front-end         | Back-end |
|--------------|---------|
| HTML/CSS        | Node.js     |
| JavaScript          | Express     |
| Bootstrap     | EJS Templating engine     |
| Tailwind CSS     |  MySQL(for database)   |


## Features

- **Content Browsing**:  
  Access detailed information on movies, TV shows, celebrities, and award ceremonies categorized by genre, popularity, release date, and more.

- **User Profile Dashboard**:  
  Each user can maintain a personal profile, view their activity (watchlist, reviews, ratings), and update their preferences.

- **User Reviews & Ratings**:  
  Share opinions and rate movies and shows, helping others decide what to watch.

- **Personalized Watchlist**:  
  Save movies and shows for future viewing and manage your favorites in one place.

- **User Privacy & Security**:  
  User data is securely stored with proper session management and access control. Sensitive information is protected using encryption and authentication mechanisms.

- **Award Insights**:  
  View winners and nominees of various awards (Oscars, Emmys, etc.) over the years with filtering options.

- **Admin Panel**:  
  Secure panel for admins to manage content (CRUD operations for movies, users, etc.). They can also delete inappropriate or spam reviews.

## Instructions for setup (Windows)
`Node v18.20.8`, `npm 10.8.2`, `MySQL Workbench` are required. Once you've verified the installation and usage of said versions, follow the next instructions
### 1. Clone the repository and install dependencies
``` bash
git clone https://github.com/Aman1406-gupta/Cinematrix
cd Cinematrix
npm install
```
### 2. Configure the database
- Open MySQL Workbench and connect to your local MySQL instance.
- Run the following SQL scripts from the `database_queries` directory in the specified order:
    - Finalized Dataset.sql — Sets up the database schema and initial data.
    - indices.sql — Adds indexes to optimize query performance.

### 3. Get Nodemail password
- To use Nodemailer with Gmail:
- Go to your Google Account → Security
- Enable 2-Step Verification
- Under "Signing in to Google", select App passwords
- Generate a new app password.
- Use the generated 16-character password as your `nodemail_pass`.

### 4. Set Up Environment Variables

Create a `.env` file in the root directory of your project and add the following configuration:

```bash
sql_host='localhost'
sql_user='root'                # Your SQL username
sql_pass='pass'                # Your SQL password
sql_name='cinematrix_db'       # Database name
sql_port=3306                  # Database port
app_port_no=1200               # Application port number
app_ip="127.0.0.1"             # Application IP address
secret_key="aiqw179"           # Secret key (create a new one)
nodemail_pass="abcd efgh ijkl mnop"   # Nodemailer password
```

> **Note:** Replace the values above with your actual credentials and configuration.
---

### 5. Start the Server
After setting up the environment variables, launch the application using the following command:
```bash
node index.js
```
Once started, the server will be running at the specified port. For example:
```
http://localhost:<app_port_no>
```

Replace `<app_port_no>` with the actual port number you specified in the `.env` file.