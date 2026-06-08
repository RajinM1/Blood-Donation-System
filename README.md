# Blood Donation Management System

A comprehensive Java-based web application designed to manage blood donations, inventory, donor appointments, and hospital requests. Built using robust enterprise design patterns, the system offers an end-to-end solution for medical staff and administrators to handle blood bank operations efficiently.

## 🌟 Key Features

- **Donor Management**: Register donors, manage profiles, and schedule donation appointments.
- **Blood Stock Management**: Track blood units by blood group (A+, O-, etc.), update stock levels, and monitor low-stock thresholds.
- **Request & Fulfillment System**: Handle blood requests from hospitals or individuals, including approval workflows.
- **Event-Driven Notifications**: Automated email notifications, system alerts, and comprehensive audit logging powered by the Observer Pattern.
- **PDF Report Generation**: Export critical data (blood stock, donor lists, etc.) to PDF format using iText.
- **Security & Authentication**: Secure user authentication with password hashing using BCrypt and authorization via Servlet Filters.

## 🛠 Tech Stack

- **Backend**: Java 17, Jakarta Servlet API 6.0, JSP (Jakarta Server Pages)
- **Database**: MySQL 8.0 (MySQL Connector/J)
- **Frontend**: HTML5, CSS3, JavaScript (embedded in JSP views)
- **Libraries**:
  - `jBCrypt` for password hashing
  - `Jakarta Mail` for email notifications
  - `iText 7` for PDF report generation
  - `SLF4J` for application logging
- **Build Tool**: Maven
- **Deployment**: Apache Tomcat (WAR packaging)

## 🏗 Architecture & Design Patterns

The application is built with a strong focus on clean architecture and standard GoF (Gang of Four) / Enterprise design patterns:

1. **MVC (Model-View-Controller)**: Strict separation of concerns using JSP for Views, Servlets for Controllers, and Java POJOs for Models.
2. **DAO (Data Access Object)**: Extensively used to encapsulate all database interactions (e.g., `BloodStockDAO`, `DonorDAO`).
3. **Service Layer**: Coordinates business logic and orchestrates multiple DAOs (e.g., `BloodReportService`, `NotificationService`).
4. **Observer Pattern**: A centralized `EventNotificationManager` handles over 20 system events asynchronously, triggering Email, Alert, and Logging Observers.
5. **Singleton Pattern**: Ensures a single instance of core managers like the `EventNotificationManager`.
6. **Filter Pattern**: Utilized via `SecurityFilter` to intercept requests and ensure route protection.
7. **Utility Pattern**: Reusable helper classes (`DatabaseUtil`, `EmailUtil`, `ValidationUtil`).

## 🗄️ Database Setup

The project requires a MySQL database.

1. Ensure MySQL Server is running.
2. Create a new database named `blood_donation_db` (or as specified in your configuration).
3. Import the provided SQL schema to initialize the tables:
   ```bash
   mysql -u your_username -p blood_donation_db < FINAL_COMPLETE_DATABASE_SCHEMA.sql
   ```
4. Verify that tables such as `donors`, `blood_stock`, `appointments`, `alerts`, and `blood_requests` are created.

## 🚀 Installation & Deployment

### Prerequisites
- JDK 17+
- Apache Maven 3.x
- Apache Tomcat 10.x (Supports Jakarta EE 10 / Servlet API 6.0)
- MySQL 8.0+

### Steps to Run locally:

1. **Clone the repository / Navigate to the directory**:
   ```bash
   cd "Blood_donation 2/Blood_donation"
   ```

2. **Configure Database & Email**:
   Update your database credentials and SMTP email configurations in the utility classes or properties files (e.g., `DatabaseUtil.java` and `EmailUtil.java`).

3. **Build the Application**:
   Use Maven to clean and package the project into a WAR file.
   ```bash
   mvn clean install
   ```

4. **Deploy to Tomcat**:
   - Copy the generated `target/blood-donation-system1-1.0-SNAPSHOT.war` file.
   - Paste it into your Tomcat `webapps` directory.
   - Start the Tomcat server:
     ```bash
     catalina.bat start  # (Windows)
     # or
     catalina.sh start   # (Linux/Mac)
     ```

5. **Access the Application**:
   Open your browser and navigate to:
   ```
   http://localhost:8080/blood-donation-system1-1.0-SNAPSHOT
   ```

## 📂 Project Structure

```
├── src/
│   └── main/
│       ├── java/com/blooddonation/
│       │   ├── dao/         # Data Access Objects (Database logic)
│       │   ├── model/       # Data Models / POJOs
│       │   ├── observer/    # Observer Pattern implementations (Events/Notifications)
│       │   ├── service/     # Business logic layer
│       │   ├── servlet/     # Controllers handling HTTP requests
│       │   └── util/        # Utility classes (DB, Email, Validation)
│       ├── resources/       # Configuration files
│       └── webapp/          # Frontend assets and JSP files
├── pom.xml                  # Maven dependencies and build configuration
└── FINAL_COMPLETE_DATABASE_SCHEMA.sql  # Main database schema script
```

## 🔮 Future Enhancements

Based on the current architectural roadmap, the following improvements are planned:
- Implementation of **Factory Pattern** and **Builder Pattern** for more robust and extensible PDF report generation.
- Implementation of **Strategy Pattern** to support multiple report export formats (Excel, CSV alongside PDF).
- Introduction of Connection Pooling (e.g., HikariCP) for optimized database access.
