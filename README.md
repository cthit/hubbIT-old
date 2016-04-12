hubbIT
======
Is used together with https://github.com/cthit/hubbIT-sniffer

Setup
------
You are going to need either a virtual machine running \*nix or \*nix yourself.

### Pre
You will need:

* Ruby, `apt-get installl ruby` / `pacman -S ruby`

* bundler, `gem install bundler`

* Mysql server, `apt-get install mysql-server` / `pacman -S mariadb`

For ubuntu you will also need:
```
sudo apt-get install ruby-dev
sudo apt-get install zlib1g-dev
sudo apt-get install libmysqlclient-dev
```

##### Configure
Configure the database by creating the config/database.yml file and add:
```
default: &default
  adapter: sqlite3
  pool: 5
  timeout: 5000

development:
  <<: *default
  adapter: mysql2
  host: localhost
  database: hubbIT

test:
  <<: *default
  database: db/test.sqlite3

production:
  <<: *default
```

Configure your secrets by copying the secrets.example.yml file:
```
cp config/secrets.example.yml config/secrets.yml
```

Clone the repo, navigate to it and run `bundler install` this will install all gem dependencies, you can find these in the Gemfile

You can now run `rake db:setup` and then `rails s` and the site will now be served on http://0.0.0.0:3000/.
##### Startup
You will probably be redirected to account in order to login since the cookies we use for chalmers.it are only allowed on \*.chalmers.it.

To fix this you can edit your /etc/hosts file and add the following line:
```
127.0.0.1       local.hubbit.chalmers.it localhost
```

The site is now available at http://local.hubbit.chalmers.it:3000/
