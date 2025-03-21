## AWS config

```sh
aws configure --profile sms
```

- AWS Access Key ID [None]: <your-access-key-id>
- AWS Secret Access Key [None]: <your-secret-access-key>
- Default region name [None]: eu-west-1
- Default output format [None]: json # Options: json, text, table

## API

Package API artifact

```sh
make prod/api/package
```

Release artifact

```sh
make prod/api/release
```

or

```sh
make prod/api/release ver=1.0.0
```

Deploy Artifact

```sh
make prod/api/deploy
```

or

```sh
make prod/api/release ver=1.0.0
```

## Web Front

```sh
make prod/api/package
```

```sh
make prod/api/deploy
```
