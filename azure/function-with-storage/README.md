# Azure function for uploading files to object storage

Creates:

- Resource group
- Storage account
- Two storage containers (one for general function data and one for uploaded files)
- App service running Basic tier service
- Azure Function with [CloudFileUploadFunction](https://github.com/Loupeznik/CloudFileUploadFunction) API

## Additional info

Authentication to the function is achieved by _Function keys_ (can be found using the Azure Portal)
