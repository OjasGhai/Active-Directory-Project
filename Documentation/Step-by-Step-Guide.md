# 🏢 Active Directory & Group Policy Implementation (Windows Server 2022 on Azure)  
## 📖 Step-by-Step Implementation Guide  

---
## **📌 Step 1: Deploy an Azure Virtual Machine for Active Directory**
🔹 **Setting up an Azure VM to host Windows Server 2022 as a Domain Controller**

### **1️⃣ Create an Azure Virtual Machine**
1. Log in to the **Azure Portal**: [https://portal.azure.com](https://portal.azure.com)
   
![Azure VM Creation](../Screenshots/Azure_VM_Creation_Overview.png)

3. Navigate to **Virtual Machines** → Click **Create**.
4. Choose the following configuration:
   - **Subscription**: Select your Azure subscription.
   - **Resource Group**: Create a new or select an existing one.
   - **Virtual Machine Name**: `WindowsServer20`
   - **Region**: Select a close region (e.g., East US, West Europe).
   - **Image**: **Windows Server 2022 Datacenter**
   - **Size**: Standard B2s or higher.
   - **Administrator Username & Password**: Set strong credentials.
   - **Inbound Ports**: Allow **RDP (3389)**.

![Azure VM Creation](../Screenshots/Azure_VM_Resource_Group_Selection.png) <br>

![Azure VM Creation](../Screenshots/Azure_VM_Instance_Details.png)  <br>

![Azure VM Creation](../Screenshots/Azure_VM_Image_Selection.png)  <br>

![Azure VM Creation](../Screenshots/Azure_VM_Image_Selection.png)  <br>

   
5. Click **Review + Create** → Wait for Deployment to finish.

 ![Azure VM Creation](../Screenshots/Azure_VM_Administrator_Account.png)

---

### **2️⃣ Connect to the Azure Virtual Machine**
1. In **Azure Portal**, go to **Virtual Machines**.
2. Click on **WindowsServer20** → Select **Connect > RDP**.
3. Download the **RDP file** and open it.
4. Log in using the credentials set during VM creation.

![Azure VM Creation](../Screenshots/Azure_VM_Details)

![Azure VM Creation](../Screenshots/Azure_VM_Remote_Desktop_Connection)




---

### **3️⃣ Configure Static Private IP Address**
1. In **Azure Portal**, navigate to **Networking** for the VM.
2. Click on the **Network Interface**.
3. Select **IP Configuration** → Click on the **IP Address**.
4. Change **Assignment** to **Static**.
5. Click **Save**.

---

## **📌 Step 2: Install Active Directory Domain Services (AD DS)**
1. Open **Server Manager** on the Azure VM.
2. Click **Manage** → Select **Add Roles and Features**.
3. Select **Role-based or feature-based installation** → Click **Next**.
4. Choose **Select a server from the server pool** → Click **Next**.
5. Select **Active Directory Domain Services (AD DS)** → Click **Next**.
6. Click **Install** and wait for the installation to complete.
7. Once installed, **Promote the server to a Domain Controller**:
   - Open **Server Manager** → Click on the notification flag.
   - Select **Promote this server to a domain controller**.
   - Choose **Add a new forest**, enter the **Root Domain Name (e.g., oghai.local)**.
   - Set a **Directory Services Restore Mode (DSRM) password**.
   - Click **Next** and complete the installation.
   - The server will restart automatically.

---

## **📌 Step 3: Create Organizational Units (OUs)**
1. Open **Active Directory Users and Computers (ADUC)**.
2. Navigate to **yourdomain.local**.
3. Right-click on the domain name → Select **New > Organizational Unit**.
4. Create the following OUs:
   - **Sales**
   - **IT**
   - **Finance**
   - **HR**
5. Click **OK** to save.

---

## **📌 Step 4: Create Users and Groups**
1. Open **Active Directory Users and Computers**.
2. Navigate to **Sales OU**.
3. Right-click **Sales OU** → Select **New > User**.
4. Fill in the details:
   - **First Name**: John  
   - **Last Name**: Doe  
   - **User Logon Name**: jdoe  
5. Set a password and choose **User must change password at next logon**.
6. Repeat the same process for other users.
7. Create a **Security Group for Sales Team**:
   - Right-click **Sales OU** → Select **New > Group**.
   - Group Name: **Sales-Team** → Select **Global & Security**.
   - Click **OK**.

---

## **📌 Step 5: Install & Configure Group Policy Management**
1. Open **Server Manager**.
2. Click **Manage > Add Roles and Features**.
3. Select **Group Policy Management** → Click **Install**.
4. Once installed, open **Group Policy Management Console (GPMC)**.
5. Navigate to **Forest: yourdomain.local > Domains > yourdomain.local**.

---

## **📌 Step 6: Create & Link a Group Policy Object (GPO)**
1. In **GPMC**, right-click on **Group Policy Objects** → Select **New**.
2. Name the new GPO: **Security Policy for Sales OU**.
3. Right-click the new GPO → Select **Edit**.
4. Modify settings as needed.

---

## **📌 Step 7: Configure Password Policy for Users**
1. In **GPMC**, navigate to:  
   **Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy**.
2. Modify the following:
   - **Enforce password history**: 5 passwords remembered.
   - **Maximum password age**: 90 days.
   - **Minimum password length**: 10 characters.
   - **Password complexity requirements**: Enabled.
3. Click **OK** and close.

---

## **📌 Step 8: Restrict USB Drive Access for Finance & HR**
1. Navigate to:  
   **Computer Configuration > Policies > Administrative Templates > System > Removable Storage Access**.
2. Enable:
   - **All Removable Storage classes: Deny all access**.
3. Click **OK**.

---

## **📌 Step 9: Map Network Drive for Sales Team**
1. Navigate to:  
   **User Configuration > Preferences > Windows Settings > Drive Maps**.
2. Right-click **Drive Maps** → **New > Mapped Drive**.
3. Set the following:
   - **Location**: `\\WindowsServer20\SharedSales`
   - **Reconnect**: Yes
   - **Label**: Sales Shared Drive
   - **Drive Letter**: S:
4. Click **Apply** and **OK**.

---

## **📌 Step 10: Prevent IT Users from Changing Desktop Background**
1. In **GPMC**, create a new GPO: **"Restrict Wallpaper for IT"**.
2. Navigate to:  
   **User Configuration > Policies > Administrative Templates > Control Panel > Personalization**.
3. Enable:
   - **Prevent changing desktop background**.
4. Click **Apply** and **OK**.
5. Link this GPO to the **IT OU**.

---

## **📌 Step 11: Link Group Policy to Organizational Units (OUs)**
1. In **GPMC**, find the OU (e.g., Sales OU, IT OU).
2. Right-click the OU → Select **Link an Existing GPO**.
3. Choose the appropriate GPO → Click **OK**.

---

## **📌 Final Steps: Apply & Verify GPOs**
1. Open **Command Prompt (cmd)** or **PowerShell**.
2. Force apply the policies:
   ```powershell
   gpupdate /force
