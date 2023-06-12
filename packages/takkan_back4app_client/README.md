# precept_back4app_backend

Precept BackendDelegate implementation for Back4App

## Getting Started

## Testing

Have not yet worked out how to start and stop Parse Server for local testing from within tests.

For now, from the terminal:

```bash
yarn pretest
```

Will start mongodb and Parse Server, but have to stop with ^C

```bash
dart run lib/backend/back4app/cloud/init_local.dart instance=precept-example
```

### Console on Local Parse Server

Available at http://localhost:1337/playground

```bash
yarn dashboard
```

To run the dashboard in the [browser](http://localhost:4040/apps/test/browser/)

```bash
yarn stop
```

Just does not work so just ^C

```bash
yarn db
```

Seems to restart the database! Can't guarantee it though ...

## Build

Uses json_serializable.

```bash
flutter packages pub run build_runner watch --delete-conflicting-outputs
```