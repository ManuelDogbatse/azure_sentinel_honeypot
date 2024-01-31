# Collecting logs from Virtual Machine

### Table of Contents

[Creating custom logs](#creating-custom-logs)

[Creating the Data Collection Endpoint](#creating-the-data-collection-endpoint)

[Sections](#sections)

## Creating custom logs

Before collecting the honeypot logs from the virtual machine, you need to create custom logs for each authentication attempt. To do this, go to Azure and go to the 'Log analytics workspaces' page.
Then select 'law-honeypot' and click the 'Tables' tab, underneath 'Settings'. Click 'Create > New custom log (MMA-based)' to begin creating the custom logs.

There are two custom logs that need to be made: one for password authentication attempts, and the other for public key authentication attempts.

Click the links to the sample logs from this repository and click the download button to save them in your local storage: [Sample Password Authentication Logs](https://github.com/ManuelDogbatse/azure_sentinel_honeypot/blob/main/contents/log_collection/files/ssh_password_logins.log), [Sample Public Key Authentication Logs](https://github.com/ManuelDogbatse/azure_sentinel_honeypot/blob/main/contents/log_collection/files/ssh_public_key_logins.log)

<p align="center">
<img src="../../images/github_download.png" alt="Download icon on GitHub repo file" height=70px>
</p>

Then in Azure, upload the password log file as the sample log.

<p align="center">
<img src="../../images/sample_log.png" alt="Sample log upload for custom log" height=60px>
</p>

Then click 'Next' and make sure 'New line' is selected as the delimiter. Click 'Next' to enter the log path. For the collection path, choose 'Linux' for the path type and enter absolute path of the ```logs``` folder in the ```ssh_honeypot``` repository clone in your virtual machine, followed by ```/ssh_password_logins.log``` for the path:

<p align="center">
<img src="../../images/custom_log_path.png" alt="Path for the custom log in VM" height=84px>
</p>

Click 'Next' and give the custom log the name 'SSH_PASSWORD_LOGS'. Azure will automatically append '_CL' to the custom log name, making the final name 'SSH_PASSWORD_LOGS_CL'.

<p align="center">
<img src="../../images/custom_log_name.png" alt="Name for the custom log in VM" height=74px>
</p>

Click 'Next' and then 'Create' to create the custom log for password authentication.

Repeat this step again, but this time:

- Upload the sample public key logs

- Enter the same path, but change the file name to ```ssh_public_key_logins.log```

- Give the custom log the name 'SSH_PUBKEY_LOGS'

You should now have two custom logs: ```SSH_PASSWORD_LOGS_CL``` and ```SSH_PUBKEY_LOGS_CL```.

<p align="center">
<img src="../../images/custom_log_list.png" alt="Custom logs in LAW" height=210px>
</p>

## Creating the Data Collection Endpoint

To gather the logs from the virtual machine, you need to create a data collection endpoint, which will collect logs directly from the machine and forward them to the log analytics workspace.

In Azure, search 'monitor' and select the 'Monitor' option:

<p align="center">
<img src="../../images/monitor_option.png" alt="Monitor option" height=90px>
</p>

## Sections

#### Home Page: [Azure Sentinel Honeypot](../../)

#### Previous Section: [Setting up the Honeypot](../honeypot_setup/)

#### Next Section: [Collecting logs from Virtual Machine](..)