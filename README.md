### **Unnormalized Structure (0NF)**

At first, all your tables are in an unnormalized state (0NF), where multiple attributes (such as `Address`, `Location`, `Services`, etc.) could be repeated, leading to redundancy and potential anomalies.

#### **Unnormalized Example:**

Let's take the **Clients** and **Projects** table as an example, where a client could have many projects, and for each project, there might be many associated services, reports, collected data, etc.

**Clients and Projects (0NF Example)**:

| ClientID | CompanyName | ContactName | Email        | Phone     | Address    | Industry | Location  | ProjectID | ProjectName | Description       | StartDate | EndDate   | PaymentSubtotal | Services   |
|----------|-------------|-------------|--------------|-----------|------------|----------|-----------|-----------|-------------|-------------------|-----------|-----------|-----------------|------------|
| 1        | ABC Corp    | John Doe    | <john@abc.com> | 123-456   | Street 1   | IT       | New York  | 101       | AI Project | AI development    | 2024-01-01| 2024-06-01| 10000.00         | Dev, Testing |
| 1        | ABC Corp    | John Doe    | <john@abc.com> | 123-456   | Street 1   | IT       | New York  | 102       | App Project| Mobile app dev    | 2024-03-01| 2024-09-01| 8000.00          | Dev         |

---

### **Step 1: First Normal Form (1NF)**

To achieve **1NF**, we must:

1. Eliminate repeating groups.
2. Ensure that each column contains only **atomic values** (no multi-valued attributes).

Here, we will:

- Separate **Clients** and **Projects** into distinct tables.
- Ensure all attributes in a table hold only single values.

#### **Changes Made in 1NF:**

1. **Projects Table** (Separate project details):

| ProjectID | ClientID | ProjectName | Description        | StartDate | EndDate   | PaymentSubtotal | TaxRate | Location |
|-----------|----------|-------------|--------------------|-----------|-----------|-----------------|---------|----------|
| 101       | 1        | AI Project  | AI development     | 2024-01-01| 2024-06-01| 10000.00         | 10.0    | New York |
| 102       | 1        | App Project | Mobile app dev     | 2024-03-01| 2024-09-01| 8000.00          | 8.0     | New York |

2. **Clients Table** (Client info without project-specific details):

| ClientID | CompanyName | ContactName | Email        | Phone     | Address    | Industry | ClientSince |
|----------|-------------|-------------|--------------|-----------|------------|----------|-------------|
| 1        | ABC Corp    | John Doe    | <john@abc.com> | 123-456   | Street 1   | IT       | 2020-01-01  |

---

### **Step 2: Second Normal Form (2NF)**

To achieve **2NF**, we must:

1. Ensure the table is in **1NF**.
2. Eliminate **partial dependencies** (attributes that depend only on part of a composite primary key).

In the **Projects Table**, we see that the `Location` and `TaxRate` attributes depend only on `ClientID`, not on the project itself. Hence, we need to separate location and tax rate info from the `Projects` table into another table.

#### **Changes Made in 2NF:**

1. **Projects Table** (Remove location and tax rate, as they depend on the client):

| ProjectID | ClientID | ProjectName | Description        | StartDate | EndDate   | PaymentSubtotal | DiscountValue |
|-----------|----------|-------------|--------------------|-----------|-----------|-----------------|---------------|
| 101       | 1        | AI Project  | AI development     | 2024-01-01| 2024-06-01| 10000.00         | 500.00        |
| 102       | 1        | App Project | Mobile app dev     | 2024-03-01| 2024-09-01| 8000.00          | 400.00        |

2. **Clients Table** (Location and industry info removed):

| ClientID | CompanyName | ContactName | Email        | Phone     | Address    | ClientSince |
|----------|-------------|-------------|--------------|-----------|------------|-------------|
| 1        | ABC Corp    | John Doe    | <john@abc.com> | 123-456   | Street 1   | 2020-01-01  |

3. **Locations Table** (Add Location-related details):

| LocationID | City      | State   | Country |
|------------|-----------|---------|---------|
| 1          | New York  | NY      | USA     |

---

### **Step 3: Third Normal Form (3NF)**

To achieve **3NF**, we must:

1. Ensure the table is in **2NF**.
2. Eliminate **transitive dependencies** (non-key attributes should depend only on the primary key).

For example, if there is a **Department Manager** and a **ManagerID** in the **Departments Table**, there might be unnecessary transitive dependencies for data such as `ManagerName`. To eliminate this, we will ensure that only essential foreign keys are used and remove any other attributes that do not rely directly on the primary key.

#### **Changes Made in 3NF:**

1. **Departments Table** (Remove manager info, store it separately):

| DepartmentID | DepartmentName | ManagerID |
|--------------|----------------|-----------|
| 1            | Tech           | 3         |
| 2            | Marketing      | 4         |

2. **Employees Table** (Include Manager Name but only as part of employee data, avoid redundancy):

| EmployeeID | FirstName | LastName | Position       | HireDate   | Email         | Phone   | Salary    |
|------------|-----------|----------|----------------|------------|---------------|---------|-----------|
| 3          | Sarah     | Smith    | Tech Manager   | 2020-01-15 | <sarah@abc.com> | 123-789 | 120000.00 |
| 4          | Alex      | Johnson  | Marketing Lead | 2019-06-10 | <alex@xyz.com>  | 456-101 | 90000.00  |

---

### **Final Tables After 3NF:**

1. **Projects Table** (Now only includes project-related data):

| ProjectID | ClientID | ProjectName | Description        | StartDate | EndDate   | PaymentSubtotal | DiscountValue |
|-----------|----------|-------------|--------------------|-----------|-----------|-----------------|---------------|
| 101       | 1        | AI Project  | AI development     | 2024-01-01| 2024-06-01| 10000.00         | 500.00        |
| 102       | 1        | App Project | Mobile app dev     | 2024-03-01| 2024-09-01| 8000.00          | 400.00        |

2. **Clients Table** (Client info only):

| ClientID | CompanyName | ContactName | Email        | Phone     | Address    | ClientSince |
|----------|-------------|-------------|--------------|-----------|------------|-------------|
| 1        | ABC Corp    | John Doe    | <john@abc.com> | 123-456   | Street 1   | 2020-01-01  |

3. **Locations Table** (Separate location info):

| LocationID | City      | State   | Country |
|------------|-----------|---------|---------|
| 1          | New York  | NY      | USA     |

4. **Departments Table** (No manager name, only manager ID):

| DepartmentID | DepartmentName | ManagerID |
|--------------|----------------|-----------|
| 1            | Tech           | 3         |
| 2            | Marketing      | 4         |

5. **Employees Table** (Employee info):

| EmployeeID | FirstName | LastName | Position       | HireDate   | Email         | Phone   | Salary    |
|------------|-----------|----------|----------------|------------|---------------|---------|-----------|
| 3          | Sarah     | Smith    | Tech Manager   | 2020-01-15 | <sarah@abc.com> | 123-789 | 120000.00 |
| 4          | Alex      | Johnson  | Marketing Lead | 2019-06-10 | <alex@xyz.com>  | 456-101 | 90000.00  |

6. **ProjectConsultants Table** (Consultants working on projects):

| ProjectID | EmployeeID | EmployeeRole |
|-----------|------------|--------------|
| 101       | 3          | Lead Consultant |
| 102       | 4          | Consultant    |

---

### **Summary of Changes for Each NF**

- **0NF

 (Unnormalized)**: Raw data with repeated groups and non-atomic columns.

- **1NF (First Normal Form)**: Removed repeating groups, each column holds atomic values.
- **2NF (Second Normal Form)**: Removed partial dependencies, creating separate tables for dependent data (e.g., locations).
- **3NF (Third Normal Form)**: Eliminated transitive dependencies, ensured that each non-key attribute depends only on the primary key.

With this, we have achieved a normalized schema for your business database.

---

Let me know if you'd like further adjustments or if you'd like me to go deeper into any specific table!

----------------

Apologies for the oversight! I'll include all your tables in the correct order, along with the observations and normalization steps for each table. Here's the **complete analysis** for all of them, from **1NF** to **3NF**. Let's go through each table properly.

---

### **1. Locations Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Locations (
    LocationID INT PRIMARY KEY AUTO_INCREMENT,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);
```

#### **1NF**

- The table satisfies **1NF** because each column contains atomic values, and there are no repeating groups.

#### **2NF**

- The table satisfies **2NF** because the primary key (`LocationID`) uniquely identifies all non-key attributes.

#### **3NF**

- The table satisfies **3NF** as there are no transitive dependencies. All non-key attributes depend directly on the primary key.

---

### **2. Clients Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Address VARCHAR(255),
    Industry VARCHAR(100),
    ClientSince DATE,
    LocationID INT,
    ApplyDiscount BOOL,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);
```

#### **1NF**

- The table satisfies **1NF** because all columns have atomic values.

#### **2NF**

- **Issue**: The `Industry` column is dependent on `CompanyName` and not directly on the primary key `ClientID`, causing a **partial dependency**.
  
**Solution**: Create a separate `Industries` table to eliminate this dependency.

#### **After 2NF** (with normalization)

```sql
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    ClientSince DATE,
    LocationID INT,
    ApplyDiscount BOOL,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID)
);

CREATE TABLE Industries (
    IndustryID INT PRIMARY KEY AUTO_INCREMENT,
    IndustryName VARCHAR(100)
);

CREATE TABLE ClientIndustries (
    ClientID INT,
    IndustryID INT,
    PRIMARY KEY (ClientID, IndustryID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (IndustryID) REFERENCES Industries(IndustryID)
);
```

#### **3NF**

- The table is now in **3NF** because all non-key attributes directly depend on `ClientID`, and there are no transitive dependencies. The `Industry` has been moved to a separate table to prevent redundancy.

---

### **3. Projects Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY AUTO_INCREMENT,
    ClientID INT,
    ProjectName VARCHAR(255),
    Description TEXT,
    StartDate DATE,
    EndDate DATE,
    Status VARCHAR(50),
    PaymentSubtotal DECIMAL(10, 2),
    DiscountValue DECIMAL(10, 2),
    TaxRate DECIMAL(3, 1),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);
```

#### **1NF**

- The table satisfies **1NF** as all attributes are atomic.

#### **2NF**

- The table satisfies **2NF**, as all non-key attributes are fully dependent on the primary key (`ProjectID`).

#### **3NF**

- The table satisfies **3NF** since there are no transitive dependencies. However, the `TaxRate` could be placed in a separate table if it varies by region or project type, but for simplicity, it remains here.

---

### **4. Employees Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Position VARCHAR(100),
    HireDate DATE,
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Salary DECIMAL(10, 2)
);
```

#### **1NF**

- The table satisfies **1NF** as all attributes are atomic.

#### **2NF**

- The table satisfies **2NF**, as all non-key attributes are fully dependent on the primary key (`EmployeeID`).

#### **3NF**

- The table satisfies **3NF**, as there are no transitive dependencies.

---

### **5. Departments Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100),
    ManagerID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);
```

#### **1NF**

- The table satisfies **1NF**, as all attributes are atomic.

#### **2NF**

- The table satisfies **2NF** because all non-key attributes are fully dependent on the primary key (`DepartmentID`).

#### **3NF**

- The table satisfies **3NF**, as there are no transitive dependencies.

---

### **6. ProjectConsultants Table**

#### Original Schema (0NF)

```sql
CREATE TABLE ProjectConsultants (
    ProjectID INT,
    EmployeeID INT,
    EmployeeRole VARCHAR(100),
    PRIMARY KEY (ProjectID, EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
```

#### **1NF**

- The table satisfies **1NF** as all attributes are atomic.

#### **2NF**

- The table satisfies **2NF** because the composite primary key (`ProjectID`, `EmployeeID`) uniquely determines all non-key attributes.

#### **3NF**

- The table satisfies **3NF**, as there are no transitive dependencies.

---

### **7. CollectedData Table**

#### Original Schema (0NF)

```sql
CREATE TABLE CollectedData (
    DataID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT,
    DataType VARCHAR(100),
    Format VARCHAR(50),
    CollectionDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
```

#### **1NF**

- The table satisfies **1NF** as all attributes are atomic.

#### **2NF**

- The table satisfies **2NF**, as all non-key attributes depend on `DataID`.

#### **3NF**

- The table satisfies **3NF**, as there are no transitive dependencies.

---

### **8. Reports Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT,
    ReportTitle VARCHAR(255),
    ReportDate DATE,
    ReportStatus VARCHAR(50),
    ReportContent TEXT,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
```

#### **1NF**

- The table satisfies **1NF** as all attributes are atomic.

#### **2NF**

- The table satisfies **2NF** as all non-key attributes depend on `ReportID`.

#### **3NF**

- The table satisfies **3NF**, as there are no transitive dependencies.

---

### **9. Services Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Services (
    ServicesID INT PRIMARY KEY AUTO_INCREMENT,
    ProjectID INT,
    ServiceType VARCHAR(255),
    ShortDescription TEXT,
    ServiceDate DATE,
    ServiceCost DECIMAL(100, 2),
    ServiceStatus VARCHAR(50),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
```

#### **1NF**

- The table satisfies **1NF** as all attributes are atomic.

#### **2NF**

- The table satisfies **2NF** because all non-key attributes depend on `ServicesID`.

#### **3NF**

- The table satisfies **3NF**, as there are no transitive dependencies.

---

### **10. Skills Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Skills (
    SkillID INT PRIMARY KEY AUTO_INCREMENT,
    SkillName VARCHAR(100),
    SkillLevel VARCHAR(100),
    CertificationRequired VARCHAR(10)
);
```

#### **1NF**

- The table satisfies **1NF**.

#### **2NF**

- The table satisfies **2NF** because all non-key attributes depend on `SkillID`.

#### **3NF**

- The table satisfies **3NF** because there are no transitive dependencies.

---

### **11. EmployeeSkills Table**

#### Original Schema (0NF)

```sql
CREATE TABLE EmployeeSkills (
    EmployeeID INT,
    SkillID INT,
    PRIMARY KEY (EmployeeID, SkillID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (SkillID) REFERENCES Skills(SkillID)
);
```

#### **1NF**

- The table satisfies **1NF** as all attributes are atomic.

#### **2NF**

- The table satisfies **2NF** as the composite primary key (`EmployeeID`, `SkillID`) determines all non-key attributes.

#### **3NF**

- The table satisfies **3NF** because there are no transitive dependencies.

---

### **12. Logs Table**

#### Original Schema (0NF)

```sql
CREATE TABLE Logs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    Action VARCHAR(255),
    Description TEXT,
    Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Employees(EmployeeID)
);
```

#### **1NF**

- The table satisfies **1NF**.

#### **2NF**

- The table satisfies **2NF** because all non-key

 attributes are dependent on `LogID`.

#### **3NF**

- The table satisfies **3NF**, as there are no transitive dependencies.

---

### **Conclusion**

All tables are now fully normalized into **3NF**. The **Clients** table had the main issue, with the `Industry` column causing partial dependency. The `Industry` was moved to a separate `Industries` table, resolving this. All other tables were already compliant with **2NF** and **3NF**.
