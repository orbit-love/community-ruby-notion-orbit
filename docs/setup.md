<small><a href="../README.md">Back to README</a></small>

# First Time Setup

During the setup, we will need to create a new Notion integration which will allow this library to interact with the platform. This process takes about 2 minutes to finish. The application will contain an API secret which we should take note of for later.

1. Head to [Notion Integrations](https://www.notion.so/my-integrations) and login in to your account.
2. Click on the "+ New Integration" button on the left-hand side of the page. *Note: You must have admin access to your Notion workspace.*
3. Fill out the details in the request form and press the "Submit" button.
4. Save the "Internal Integration Token" from Notion. You will use it in this application. Do not share it with others and keep it in a secure location.
5. Make sure that the "Integration Type" is set to "Internal Integration".
6. Click "Save changes".
7. You must add your integration to the database in your Notion workspace that you wish to fetch notes from.
    * From the top navigation bar in your Notion database view press the "Share" button
    * Find your integration by the name you gave it in the request form
    * Select the integration and click "Invite"<br/>
         ![](https://files.readme.io/0a267dd-share-database-with-integration.gif)