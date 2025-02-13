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

![Azure VM Creation](../Screenshots/Azure_VM_Details.png)

![Azure VM Creation](../Screenshots/Azure_VM_Remote_Desktop_Connection.png)




---

### **3️⃣ Configure Static Private IP Address**
🔹 *Note: The virtual machine was automatically assigned a private IP during creation.*

1. In **Azure Portal**, navigate to **Networking** for the VM.
2. Click on the **Network Interface**.
3. Select **IP Configuration** → Click on the **IP Address**.
4. If the IP assignment is **Dynamic**, change it to **Static**.
5. Click **Save**.

![Azure VM Creation](../Screenshots/VM_Desktop_Screen.png)

![Azure VM Creation](../Screenshots/Server_Manager_Dashboard.png)


---

## **📌 Step 2: Install Active Directory Domain Services (AD DS)**

You can install **Active Directory Domain Services (AD DS)** using either the **Server Manager GUI** or **PowerShell**.

### **Option 1: Install via Server Manager**
1. Open **Server Manager** on the Azure VM.
2. Click **Manage** → Select **Add Roles and Features**.
3. Select **Role-based or feature-based installation** → Click **Next**.
4. Choose **Select a server from the server pool** → Click **Next**.
5. Select **Active Directory Domain Services (AD DS)** → Click **Next**.
6. Click **Install** and wait for the installation to complete.

### **Option 2: Install via PowerShell**
Alternatively, you can install AD DS using the following PowerShell command:


```powershell
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
```

![Azure VM Creation](../Screenshots/AD_Installation_Complete.png)


7. Once installed, **Promote the server to a Domain Controller**:
   - Open **Server Manager** → Click on the notification flag.
   - Select **Promote this server to a domain controller**.

![Azure VM Creation](../Screenshots/AD_DS_Configuration_Wizard_Deployment.png)

   - Choose **Add a new forest**, enter the **Root Domain Name (e.g., oghai.local)**.

     ![Azure VM Creation](../Screenshots/AD_DS_Configuration_Wizard_Deployment2.png)

     
   - Set a **Directory Services Restore Mode (DSRM) password**.

     ![Azure VM Creation](../Screenshots/AD_DS_Configuration_Wizard_Domain_Controller_Options.png)

   - Click **Next** and complete the installation.
     
   - The server will restart automatically.

     ![Azure VM Creation](../Screenshots/AD_DS_Configuration_Wizard_Deployment.png)

     ![Azure VM Creation](../Screenshots/AD_DS_Configuration_Wizard_Installation_Progress.png)

    


---

## **📌 Step 3: Create Organizational Units (OUs)**
1. Open **Active Directory Users and Computers (ADUC)** or type **dsa.msc** in **Run** .

![Azure VM Creation](../Screenshots/Active_Directory_Users_and_Computers_run_command.png)

2. Navigate to **yourdomain.local**.

![Azure VM Creation](../Screenshots/Active_Directory_Users_and_Computers_Overview.png)

3. Right-click on the domain name → Select **New > Organizational Unit**.

 ![Azure VM Creation](../Screenshots/New_Organizational_Unit_Creation.png)

 ![Azure VM Creation](../Screenshots/New_Organizational_Unit_Creation2.png)


4. Create the following OUs:
   - **Sales**
   - **IT**
   - **Finance**
   - **HR**

![Azure VM Creation](../Screenshots/New_Organizational_Unit_view.png)

![Azure VM Creation](../Screenshots/Active_Directory_Users_and_Computers_Organizational_Units.png)


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
     
![Azure VM Creation](../Screenshots/New_User_Creation.png)

5. Set a password and choose **User must change password at next logon**.

![Azure VM Creation](../Screenshots/New_User_Creation2.png)

7. Repeat the same process for other users.

![Azure VM Creation](../Screenshots/Active_Directory_Users_and_Computers_User_List.png)

9. Create a **Security Group for Sales Team**:
   - Right-click **Sales OU** → Select **New > Group**.
   - Group Name: **Sales-Team** → Select **Global & Security**.

![Azure VM Creation](../Screenshots/Sales_Team_Group_Properties.png)

   - Click **OK**.

### **📌 Adding Users to Groups**
To add members to a security group:
1. Open **Active Directory Users and Computers**.
2. Navigate to the **Sales OU** and locate the **Sales-Team** group.
3. Right-click the group → Select **Properties** → Go to the **Members** tab.

![Azure VM Creation](../Screenshots/Sales_Team_Group_Properties.png)

![Azure VM Creation](../Screenshots/Sales_Team_Member_Selection.png)

4. Click **Add...** and enter the user’s name (e.g., **Emily Davis**).
   
![Azure VM Creation](../Screenshots/Sales_Team_Members_Added.png)

5. Click **Check Names** → **OK** to add the user.
6. Repeat for additional users as needed.
7. Click **Apply** → **OK** to save changes.

![Azure VM Creation](../Screenshots/Sales_Team_Members_Added2.png)

![Azure VM Creation](../Screenshots/New_IT_Group_Creation.png)

### **🔄 Moving a User to a Different Organizational Unit (OU)**
> If a user is created in the domain and is not assigned to the correct OU during creation, you can move them later.

1. Open **Active Directory Users and Computers (ADUC)**.
2. Locate the user in the **Users** container or another incorrect OU.
3. Right-click the user and select **Move**.
4. Choose the **destination OU** (e.g., Sales, IT, Finance).
5. Click **OK** to complete the move.

![Azure VM Creation](../Screenshots/Moving_User_to_OU.png)


✅ This ensures that users are properly structured under the correct organizational units for better policy management.


---

## **📌 Step 5: Install & Configure Group Policy Management**
1. Open **Server Manager**.
2. Click **Manage > Add Roles and Features**.
3. Select **Group Policy Management** → Click **Install**.
4. Once installed, open **Group Policy Management Console (GPMC)** or type **gpmc.msc** in **Run**.

![Azure VM Creation](../Screenshots/GroupPolicy_Run_Command.png)

6. Navigate to **Forest: yourdomain.local > Domains > yourdomain.local**.

![Azure VM Creation](../Screenshots/Group_Policy_Management_Overview.png)

---

## **📌 Step 6: Create & Link a Group Policy Object (GPO)**
1. In **GPMC**, right-click on **Group Policy Objects** → Select **New**.
2. Name the new GPO: **Security Policy for Sales OU**.

![Azure VM Creation](../Screenshots/Group_Policy_Management_New_GPO.png)

3. Right-click the new GPO → Select **Edit**.

![Azure VM Creation](../Screenshots/Group_Policy_Management_New_GPO_edit.png)

4. Modify settings as needed.

---

## **📌 Step 7: Configure Password Policy for Users**
1. In **GPMC**, navigate to:  
   **Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy**.

![Azure VM Creation](../Screenshots/Group_Policy_Management_Editor_Security_Policy.png)

![Azure VM Creation](../Screenshots/Password_Policy_Settings.png)

2. Modify the following:
   - **Enforce password history**: 5 passwords remembered.

![Azure VM Creation](../Screenshots/Enforce_Password_history_Properties.png)

Enforce_Password_history_Properties
   - **Maximum password age**: 90 days.

![Azure VM Creation](../Screenshots/Maximum_Password_Age_Properties.png)

   - **Minimum password length**: 10 characters.

![Azure VM Creation](../Screenshots/Minimum_Password_Length_Properties.png)

   - **Password complexity requirements**: Enabled.

![Azure VM Creation](../Screenshots/Password_Complexity_Requirements.png)

4. Click **OK** and close.

---

## **📌 Step 8: Restrict USB Drive Access for Finance & HR**
1. Navigate to:  
   **Computer Configuration > Policies > Administrative Templates > System > Removable Storage Access**.

![Azure VM Creation](../Screenshots/USB_access_salesHR.png)

![Azure VM Creation](../Screenshots/USB_acces_settings.png)


2. Enable:
   - **All Removable Storage classes: Deny all access**.

![Azure VM Creation](../Screenshots/usb_access_enable.png)

3. Click **OK**.

---

## **📌 Step 9: Map Network Drive for Sales Team**
1. Navigate to:  
   **User Configuration > Preferences > Windows Settings > Drive Maps**.

![Azure VM Creation](../Screenshots/Group_Policy_Management_Editor_Drive_Maps.png)

3. Right-click **Drive Maps** → **New > Mapped Drive**.
4. Set the following:
   - **Location**: `\\Server\SharedSales`
   - **Reconnect**: Yes
   - **Label**: Sales Shared Drive
   - **Drive Letter**: S:

![Azure VM Creation](../Screenshots/New_Drive_Properties.png)

5. Click **Apply** and **OK**.

---

## **📌 Step 10: Prevent IT Users from Changing Desktop Background**
1. In **GPMC**, create a new GPO: **"IT Group Policy"**.
2. Navigate to:  
   **User Configuration > Policies > Administrative Templates > Control Panel > Personalization**.

![Azure VM Creation](../Screenshots/Control_Panel_Settings_Policy.png)

4. Enable:
   - **Prevent changing desktop background**.
5. Click **Apply** and **OK**.

![Azure VM Creation](../Screenshots/Prevent_Changing_Desktop_Background_Policy.png)


---

## **📌 Step 11: Link Group Policy to Organizational Units (OUs)**
1. In **GPMC**, find the OU (e.g., Sales OU, IT OU).

![Azure VM Creation](../Screenshots/OU_Linkto_GPO.png)

3. Right-click the OU → Select **Link an Existing GPO**.

![Azure VM Creation](../Screenshots/Select_GPO_Dialog.png)

![Azure VM Creation](../Screenshots/Select_GPO_Dialog2.png)

4. Choose the appropriate GPO → Click **OK**.

---

## 📌 Step 11: Apply Group Policy to All OUs and Allow Logon Through Remote Desktop Services

1. In **Group Policy Management Console (GPMC)**, create a new GPO named **"Company Policies"**.
2. Right-click **Group Policy Objects** → Select **New**.
3. Name the new GPO: **Company Policies** → Click **OK**.

![Azure VM Creation](../Screenshots/Group_Policy_Management_New_GPO_Company_Policies.png)

4. Right-click **Company Policies** → Select **Edit**.
5. Navigate to:  
   **Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > User Rights Assignment**.
6. Find **Allow log on through Remote Desktop Services** and open it.

   ![Navigating to User Rights Assignment](../Screenshots/User_Assignments_Policy.png)

8. Click **Add User or Group** and enter the required usernames or groups (e.g., IT Admins, specific users).
9. Click **Check Names** to validate the users and then click **OK**.

![Adding Users to Remote Desktop Access](../Screenshots/allow_logon_through_Remote_desktop.png)

10. Click **Apply** and **OK** to save the changes.
11. Close the **Group Policy Management Editor**.
12. Right-click **Company Policies GPO** → Select **Link an Existing GPO**.
13. Link the GPO to the **Root Domain (oghai.local)** to apply it to all OUs.

---

Now, this **Company Policies** GPO ensures that all OUs inherit these settings, including allowing designated users to log on through Remote Desktop Services.


---

## 📌 Final Steps: Apply & Verify GPOs 🛠️

1. Open **Command Prompt (cmd)** or **PowerShell**.
2. Force apply the policies:
   ```powershell
   gpupdate /force
   ```
   ![Applying Group Policy Updates](../Screenshots/Group_Policy_Update_Command.png)

3. **Test the Implemented Policies:**
   - Close the **Remote Desktop Connection**.
   - Log in again using **user credentials**.
   - Verify that the **configured Group Policies** are applied as expected.

---

### 🔹 **Troubleshooting**
- If the policies do not apply immediately, try logging out and logging back in.
- Run the command `gpresult /r` in **Command Prompt** to check the applied policies.
- Ensure that the GPO is properly linked to the **correct Organizational Unit (OU)** in **Group Policy Management Console (GPMC)**.
- Restart the computer if necessary.

This ensures that **users are correctly assigned the permissions and restrictions** set by the Group Policies. If any issues arise, re-run the `gpupdate /force` command or check the **GPO link status** in Group Policy Management Console (GPMC).


