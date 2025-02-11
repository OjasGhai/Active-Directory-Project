# 📌 Active Directory Group Policy Implementation on Windows Server 2022

## 📝 Introduction
This project demonstrates the implementation of **Active Directory (AD) and Group Policy Objects (GPOs)** in a Windows Server 2022 environment. The goal is to create a secure, well-structured domain setup with **user management, security policies, and network drive mapping** using **Group Policy Management**.

This project is beneficial for **IT professionals, system administrators, and cybersecurity enthusiasts** who want to learn about **enterprise-level Active Directory management**.

---

## 🎯 Project Objectives
- ✅ **Set up an Active Directory domain with organizational units (OUs).**  
- ✅ **Implement Group Policy Objects (GPOs) to enforce security settings and configurations.**  
- ✅ **Automate user and group creation using PowerShell scripts.**  
- ✅ **Restrict USB storage access for security-sensitive departments (Finance & HR).**  
- ✅ **Enforce strong password policies to enhance security.**  
- ✅ **Automatically map network drives for Sales users for easy data sharing.**  
- ✅ **Prevent IT users from changing desktop backgrounds for corporate branding.**  
- ✅ **Implement Backup and Disaster Recovery strategies for AD.**  

---

## 🛠️ Technologies & Tools Used
- 🖥️ **Windows Server 2022** – Active Directory Domain Services (AD DS)  
- 🔒 **Active Directory (AD)** – User and group management  
- 🎯 **Group Policy Objects (GPOs)** – Centralized policy enforcement  
- 🖥️ **PowerShell Scripting** – Automate user and GPO management  
- 🔗 **Remote Desktop Protocol (RDP)** – Server access and configuration  
- 📂 **Network File Sharing (SMB)** – Shared network drive for Sales team  
- ♻️ **Backup and Recovery Strategies** – Disaster recovery testing  

---

## ⚙️ Implementation Details

### **1️⃣ Active Directory Setup**
- Created an **Active Directory Domain Controller (DC)**.
- Configured **5 users** and **4 Organizational Units (OUs)**:
  - **Sales, IT, Finance, and HR**.
  - A **Sales-Team** group under Sales OU.

### **2️⃣ Group Policy Implementation**
- 🔐 **Password Policy Enforcement** – Strong password requirements.
- 🔒 **USB Restriction for Finance & HR** – Prevent unauthorized data transfer.
- 📂 **Network Drive Mapping for Sales** – Automatically map *S:* drive.
- 🖥️ **Prevent Desktop Customization for IT Users** – Enforce uniform branding.

### **3️⃣ PowerShell Automation**
- 📝 Automated **User & Group Creation** in AD.
- 📜 Scripted **Group Policy (GPO) configurations**.
- ♻️ **Backup & Recovery Scripts** for Active Directory.

---

## 🚀 Future Enhancements
- 🔹 **Multi-Factor Authentication (MFA)** for enhanced security.
- 🔹 **Automate AD Backup & Restore processes** for disaster recovery.
- 🔹 **Advanced Logging & Monitoring** using Event Viewer and SIEM tools.
- 🔹 **Deploy Group Policy Preferences** for application control and user settings.
- 🔹 **Integrate with Azure Active Directory (Azure AD)** for cloud-based management.

---

## 🏆 Why This Project Matters
- 💡 **Practical IT Experience:** Demonstrates real-world **enterprise security & user management**.
- 📄 **Resume Boosting:** Shows expertise in **Windows Server, AD, and GPOs**.
- 🔐 **Cybersecurity & Compliance:** Implements security policies for **data protection**.
- ⚡ **Automation & Efficiency:** Uses **PowerShell scripting** for streamlined administration.

🚀 **This project is a valuable addition to any IT professional’s portfolio!** 🚀

---

