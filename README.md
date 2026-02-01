#  Secure Password Manager (ASP.NET Web Forms)

##  Overview
This is a **secure web-based Password Manager** developed as a university project using:

- **ASP.NET Web Forms (.NET Framework)**
- **SQL Server (LocalDB / SQL Express)**
- **AES Encryption for password storage**
- **Master Page architecture (`Main_Master_file`)**

The system allows users to safely store and manage their credentials while ensuring strong security practices such as hashing, salting, and encryption.



##  Features

### ✅ Implemented Features
- **Master Password Authentication**
  - Secure login using salted and hashed passwords

- **Password Vault (CRUD)**
  - Add, view, update, and delete stored credentials  
  - Credentials stored using **AES encryption**

- **Tagging & Search**
  - Organize credentials using tags  
  - Search by site name or tags

- **Password Generator**
  - Customizable length and character sets

- **Password Health Report**
  - Strength analysis (Weak/Medium/Strong)
  - Duplicate password detection
  - Expiry tracking based on `LastRotated` field

- **Password Expiry & Reminders**
  - Highlights old passwords that need updating

- **Clipboard Auto-Clear**
  - Prevents passwords from staying in clipboard

- **Centralized UI using Master Page**
  - `Main_Master_file.Master` provides:
    - Left navigation panel
    - Logout and Profile section at bottom


## 🗃 Database Design (Core Tables)

### Users Table
| Column       | Type           | Description                     |
| ------------ | -------------- | ------------------------------- |
| UserId (PK)  | int            | Unique user ID                  |
| Username     | nvarchar(50)   | Username for login (nullable)   |
| PasswordHash | varbinary(max) | Hashed master password          |
| Salt         | varbinary(32)  | Salt used in hashing            |
| CreatedAt    | datetime       | Account creation timestamp      |
| PfpPath      | nvarchar(255)  | Profile picture path (optional) |
| Birthday     | date           | Optional user birthday          |
| Gender       | nvarchar(20)   | Gender, default 'NotSpecified'  |
| Email        | nvarchar(100)  | Unique email                    |

### Vault Table
| Column            | Type           | Description                                    |
| ----------------- | -------------- | ---------------------------------------------- |
| VaultId (PK)      | int            | Unique credential entry ID                     |
| UserId (FK)       | int            | References `Users(UserId)`                     |
| SiteName          | nvarchar(100)  | Name of the website/application                |
| Username          | nvarchar(100)  | Login username for the site                    |
| PasswordEncrypted | varbinary(max) | AES-encrypted password                         |
| Notes             | nvarchar(255)  | Optional notes about the credential            |
| CreatedAt         | datetime       | Entry creation timestamp                       |
| LastUpdated       | datetime       | Last time entry was updated                    |
| LastRotated       | datetime       | Last time password was changed                 |
| CategoryId (FK)   | int            | References `Categories(CategoryId)`, nullable  |
| Strength          | nvarchar(10)   | Password strength (e.g., Weak, Medium, Strong) |
| IV                | varbinary(16)  | Initialization vector for AES encryption       |

### Categories Table
| Column          | Type          | Description                                   |
| --------------- | ------------- | --------------------------------------------- |
| CategoryId (PK) | int           | Unique category ID                            |
| CategoryName    | nvarchar(100) | Name of category (e.g., Social, Banking)      |
| CreatedAt       | datetime      | Timestamp when category was created           |
| UserId (FK)     | int           | Owner user ID, references `Users(UserId)`     |
| **Constraints** | —             | Unique combination of `UserId + CategoryName` |

### BreachList Table
| Column           | Type          | Description                                                |
| ---------------- | ------------- | ---------------------------------------------------------- |
| BreachId (PK)    | int           | Unique ID of breached password entry                       |
| BreachedPassword | nvarchar(100) | Plaintext or hashed password known to be breached (unique) |



## 🛠 Tech Stack

| Component      | Technology |
|-----------     |------------|
| Frontend       | ASP.NET Web Forms, HTML, CSS, JavaScript |
| Backend        | C# (.NET Framework) |
| Database       | SQL Server (LocalDB / Express) |
| Encryption     | AES (Advanced Encryption Standard) |
| Authentication | Hashed & Salted Master Password |
