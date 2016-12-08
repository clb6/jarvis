# jarvis

Meta-repository used to install and to setup the Jarvis backend system.

## To install

1. Make sure all required dependencies are installed:
    - [`docker`](https://docs.docker.com/engine/installation/)
    - [`docker-compose`](https://docs.docker.com/engine/installation/)
2. Clone the latest version of this repository
3. `cd` into the root of the cloned repository
4. Run the following as root:

    ```
    sudo ./bin/install.sh <username> <password>
    ```
The `username` and `password` is used for http basic authentication.  This set of credentials must be used as configuration parameters in the `jarvis-cli`.

### For development

For Jarvis developers who are working on the `jarvis-api`, replacing step #4 with:

```
./bin/install.sh dev
```

Will install to `/tmp` and install only the required Elasticsearch and Redis containers under a `dev` name.  Have your development instance of `jarvis-api` to use these containers via port 9200 and port 6379 respectively.

## To run

From the top of the local of the jarvis directory,

```
docker-compose start
```

### For development

To start the set of backend services for jarvis-api development,

```
docker-compose -f docker-compose-dev.yml start
```
