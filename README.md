# jarvis

Meta-repository used to install and to setup the Jarvis backend system.

## To run the installation

1. Make sure all required dependencies are installed:
    - `docker`
    - `docker-composed`
2. Clone the latest version of this repository
3. `cd` into the root of the cloned repository
4. Run the following as root:

    ```
    sudo ./bin/install.sh
    ```

## Development mode

For Jarvis developers who are working on the `jarvis-api`, replacing step #4 with:

```
./bin/install.sh dev
```

Will install to `/tmp` and install only the required Elasticsearch and Redis containers under a `dev` name and use different ports - 9300 and 6400 respectively.  Have your development instance of `jarvis-api` to use these containers.
