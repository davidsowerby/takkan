# takkan_schema

Provides a schema for [Takkan](https://takkan.org/).  

On the client, it is used to:

- provide validation
- control what is presented depending on defined role-based permissions

For the server, it is used to generate Back4App server side code which:

- create queries as defined by the schema
- provide validation (either for direct access without a client, or just additional protection)
- create required roles
- create required CLPs (Class Level Permissions)


## License

BSD-3

## Acknowledgements

With thanks to those who have provided these great packages:

- [json_serializable](https://pub.dev/packages/json_serializable)
- [equatable](https://pub.dev/packages/equatable)
- [get_it](https://pub.dev/packages/get_it)
- [validators](https://pub.dev/packages/validators)

## Build

Uses json_serializable.

```bash
flutter packages pub run build_runner watch --delete-conflicting-outputs
```