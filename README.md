### ✅ **Alternative GitHub Repository Info**

* **🔹 Repository Name:** `coldfusion-login-signup-crud-image`
* **🔹 Title:** `ColdFusion Login & Signup with CRUD and Image Upload (AJAX + Bootstrap)`

---

### 📄 **README.md**

```md
# ColdFusion Login & Signup with CRUD and Image Upload (AJAX + Bootstrap)

A complete ColdFusion (CFML) web application featuring secure login/signup, full user CRUD operations, image upload, profile management, and session-based authentication — all with AJAX (no page reloads) and a clean Bootstrap UI.

---

## 🚀 Key Features

- 🔐 **Login / Signup** system with password hashing
- 📸 **Image Upload** with size validation (max 2MB)
- 🧑‍💼 **User Dashboard** with DataTables AJAX listing
- 📝 **Edit Profile** with optional image update
- ❌ **Delete Users** (except self, with "Own" badge)
- 🟢 **Email Availability Check** (AJAX client + server)
- 💾 **ColdFusion Backend** with clean CFC structure
- 🎨 **Responsive UI** using Bootstrap 5
- 🕒 **Sticky Footer** with dynamic year
- 🔐 **Session Protection** with `Application.cfc`

---

## 🧾 Pages Overview

| Page               | Purpose                                               |
|--------------------|--------------------------------------------------------|
| `index.cfm`        | Redirects based on session (login or dashboard)       |
| `login.cfm`        | Secure login page (AJAX)                              |
| `register.cfm`     | Signup form with image upload (AJAX)                  |
| `dashboard.cfm`    | User listing with DataTables, delete button           |
| `profile.cfm`      | Logged-in user's editable profile                     |
| `logout.cfm`       | Destroys session and redirects to login               |
| `/ajax/*.cfm`      | AJAX handlers for login, register, delete, update     |

---

```

## 📁 Folder Structure


```
/coldfusion-login-signup-crud-image
├── includes/             # Header, footer templates
├── ajax/                 # Backend AJAX handlers
├── cfc/                  # Utility CFCs (e.g., Utils.cfc)
├── uploads/              # Profile image uploads
├── Application.cfc       # CF app lifecycle + session management
├── index.cfm             # Redirect logic
├── login.cfm             # Login form (AJAX)
├── register.cfm          # Signup with image (AJAX)
├── dashboard.cfm         # Protected users list
├── profile.cfm           # Profile page (update logic)
├── logout.cfm            # Session destroy
```


---

## 🔒 Security Highlights

- Passwords hashed using `generatePBKDF2Hash()` in `Utils.cfc`
- Email availability checked before register/update
- Protected routes via session check in `Application.cfc`
- SQL Injection safe via `cfqueryparam`

---

## 📦 Database Schema

```sql
CREATE TABLE persons (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  profile_image VARCHAR(255)
);
````

---

## 🛠️ Requirements

* Adobe ColdFusion (2021+ recommended) or Lucee
* DSN (`application.datasource`) configured
* A web server supporting `.cfm` execution
* Bootstrap & DataTables loaded via CDN


