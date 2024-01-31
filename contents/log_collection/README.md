# Collecting logs from Virtual Machine

### Table of Contents

[Creating custom logs](#creating-custom-logs)

[Creating the Data Collection Endpoint](#creating-the-data-collection-endpoint)

[Sections](#sections)

## Creating custom logs

Before collecting the honeypot logs from the virtual machine, you need to create custom logs for each authentication attempt. To do this, go to Azure and go to the 'Log analytics workspaces' page.
Then select 'law-honeypot' and click the 'Tables' tab, underneath 'Settings'. Click 'Create > New custom log (MMA-based)' to begin creating the custom logs.

There are two custom logs that need to be made: one for password authentication attempts, and the other for public key authentication attempts. Download the sample logs from this repository into your local storage: [Sample Password Authentication Logs](), [Sample Public Key Authentication Logs]()

<!-- ## Creating the Data Collection Endpoint

To gather the logs from the virtual machine, you need to create a data collection endpoint, which will collect logs directly from the machine and forward them to the log analytics workspace.

Go to Azure and in the search bar, search 'monitor' and select the 'Monitor' option -->

## Sections

#### Home Page: [Azure Sentinel Honeypot](../../)

#### Previous Section: [Setting up the Honeypot](../honeypot_setup/)

#### Next Section: [Collecting logs from Virtual Machine](..)