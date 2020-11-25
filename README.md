# Precept

In development, but a number of concepts working.  [Detailed status](https://www.preceptblog.co.uk/status.html) updated regularly. 

## Key Features

- Configuration of Widget selection and layout by declarative JSON file.  

- Configuration of schema by declarative JSON file, ensuring data and presentation stay in sync

- Load configuration from server and ensure that clients are updated without any action from users

- Automatic data binding from the above declarations, making Forms really simple

- Built in edit / save / cancel functionality for Forms, with validation and permissions provided by the schema

- Could be used with any backend


## Documentation

Full documentation is being developed [here](https://www.preceptblog.co.uk/).


## Build

Uses json_serializable.

```bash
flutter packages pub run build_runner watch --delete-conflicting-outputs
```




