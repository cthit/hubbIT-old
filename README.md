hubbIT
======
Is used together with https://github.com/cthit/hubbIT-sniffer

Is build in rails...

### To setup the docker development environment:

rename or copy the files `config/database.example.yml` to `config/database.yml` and `config/secrets.example.yml` to `config/secrets.yml`

``` bash
cp config/database.example.yml config/database.yml
cp config/secrets.example.yml config/secrets.yml
```

now run
```
docker-compose up --build
```

sometimes you will need to kill the server and restart it again if you encounter database errors.

```
docker-compose up
```

you should now have a server live on port 4000

To solve authentication against accounts add

```
0.0.0.0       local.chalmers.it
```
to `/etc/hosts`

If you use Windows. I don't know. Pray or Google it.

### Testing ###
If you want to simulate a user that is in the hub for testing purposes you can run:
```
curl -X PUT -H "Authorization: Token token=<API_TOKEN>" -F "macs[]=<The mac adresses, must be in testing database>" localhost:4000/sessions
```
ask digIT for the api_key production key
Or in development The key is set to 123456789

