## Project Overview

This project is a chat system API that allows client applications to create and manage chats and messages. The API supports functionality such as creating applications, managing chats, sending messages, and searching through messages using Elasticsearch.

### Project Configuration
1. **Create Databases:**
   Ensure that the following databases exist in MySQL:
   - `chat_system_development`
   - `chat_system_test`

2. **Setup Environment Variables:**
   Create a `.env` file in the root of your project with the following content, adjusting for your MySQL username and password:
   ```env
   MYSQL_ROOT_PASSWORD=RootPass321
   RAILS_USERNAME=rails_user
   RAILS_PASSWORD=MysqlPass321
3. **Build and start your Docker containers** by running:
   ```env
   docker-compose up --build
 
### Technologies Used

- **Ruby on Rails**: Web framework used to build the APIs.
- **MySQL**: Database used for storing application, chat, and message data.
- **Elasticsearch**: Search engine used for fast and flexible partial search across messages.
- **Sidekiq + Redis**: Background job processing with Redis as the data store, used for updating chat counts and messages count for each application.
- **RSpec**: Testing framework used for writing and running test cases.


## API Endpoints

### Applications

- **Create Application**  
  `POST /applications`  
  Create a new client application.

  **Request Body**:  
  - `name` (string): Name of the application.

  **Response**:  
  - `application_token` (string): Unique token for the created application.

---

- **Update Application**  
  `PATCH /applications/:application_token`  
  Update an existing application.

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application to update.

  **Request Body**:  
  - `name` (string): New name for the application.

---

- **Get Application Details**  
  `GET /applications/:application_token`  
  Retrieve details of a specific application. (Name - Chats Count)

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application to retrieve.

---

### Chats

- **Create Chat**  
  `POST /applications/:application_token/chats`  
  Create a new chat under a specific application.

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application.
 
  **Response**:  
  - `number` (int): Unique chat number for the created application.
---

- **List Chats**  
  `GET /applications/:application_token/chats`  
  Retrieve a list of chats under a specific application.

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application.

---

- **Get Chat Details**  
  `GET /applications/:application_token/chats/:chat_number`  
  Retrieve details of a specific chat. (messages count)

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application.  
  - `chat_number` (integer): Number of the chat to retrieve.

---

### Messages

- **Create Message**  
  `POST /applications/:application_token/chats/:chat_number/messages`  
  Create a new message under a specific chat.

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application.  
  - `chat_number` (integer): Number of the chat.

  **Response**:  
  - `number` (int): Unique message number for the created application.
---

- **List Messages**  
  `GET /applications/:application_token/chats/:chat_number/messages`  
  Retrieve a list of messages in a specific chat.

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application.  
  - `chat_number` (integer): Number of the chat.

---

- **Get Message Details**  
  `GET /applications/:application_token/chats/:chat_number/messages/:message_number`  
  Retrieve details of a specific message.

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application.  
  - `chat_number` (integer): Number of the chat.  
  - `message_number` (integer): Number of the message.

---

- **Update Message**  
  `PATCH /applications/:application_token/chats/:chat_number/messages/:message_number`  
  Update a specific message.

  **Path Parameters**:  
  - `application_token` (string): Unique token of the application.  
  - `chat_number` (integer): Number of the chat.  
  - `message_number` (integer): Number of the message to update.

  **Request Body**:  
  - `message_body` (string): New content for the message.

---

### Message Search

- **Search Messages**  
  `GET /messages/search`  
  Partial search for messages in a specific chat.

  **Query Parameters**:
  - `application_token` (string): Unique token of the application.  
  - `chat_number` (integer): Number of the chat.  
  - `query` (string): Search query to match message content.

## Unresolved Challenges
I ran into a few challenges during the project that I wasn't able to fully solve Since this was my first time working with Docker.
  - I was unable to set up the full process for creating the database and granting the necessary permissions within the Docker environment. As a result, you'll need to manually configure the permissions and create the database in MySQL
  - I had trouble using environment variables in the entrypoint script even after setting them in Docker Compose. So, you'll need to manually put the MySQL username and password into the entrypoint script.
  - I was unable to run my test specs within the Docker environment due to issues with the test setup, but I was able to run all specs successfully outside of Docker
