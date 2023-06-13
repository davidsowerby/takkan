# Prepare Back4App

Takkan uses some server side code for application management, and once you start developing an app, server side code can also be generated for validation.

To set all this up, there are a number of steps to follow.  (If you already use Back4App, it is likely that you have already done step 1).

There are more steps here than is ideal, and hopefully this will be simplified at some point - although all the steps are simple in themselves.

## Overview

1. Install the Back4App CLI
1. Create a new Back4App app
1. Create a Flutter app
1. Initialise Takkan locally (this prepares Takkan server side code for deployment)
1. Deploy code to Back4App
1. Initialise Takkan remote (server side).  This invokes a Cloud Code function created at step 3 and deployed at step 4.


## Steps

### Install the Back4App CLI

- install the Back4App CLI following Step 1 and 2 of the [instructions](https://www.back4app.com/docs/platform/parse-cli)


### Create a new Back4App app

:::tip Note
There is a slight difference in terminology here - for Back4App, every instance is an 'app'.  For Takkan, an app may have a dev, test, qa and prod instance (for example),
each of which would be a separate Back4App 'app'.
:::

- cd to your home directory:

```bash
cd
```

- Create a new Back4App app with the Back4App CLI. In a terminal enter:

```bash
b4a new
```
- and complete with the items in **bold** below:



>Would you like to create a new app, or add Cloud Code to an existing app?  
Type "(n)ew" or "(e)xisting": **n**  
Please choose a name for your Parse app.  
Note that this name will appear on the Back4App website,  
but it does not have to be the same as your mobile app's public name.  
Name: **MyApp**  
Awesome! Now it's time to set up some Cloud Code for the app: "",  
Next we will create a directory to hold your Cloud Code.  
Please enter the name to use for this directory,  
or hit ENTER to use "" as the directory name.  
Directory Name: **b4a/MyApp/dev**  
You can either set up a blank project or create a sample Cloud Code project  
Please type "(b)lank" if you wish to setup a blank project, otherwise press ENTER: **b**  
Successfully configured email for current project to: "your@email.com"  


- The CLI has created the folder you nominated, and also created a new app in Back4App.

:::tip Note
The directory naming convention we use for Cloud Code folders is ~/b4a/$AppName/$instance - but that is just our convention and not essential.
:::



