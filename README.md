hubbIT
======
Is used together with https://github.com/cthit/hubbIT-sniffer

Setup
------
You are going to need either a virtual machine running \*nix or \*nix yourself.

#### Pre
You will need:
..* Ruby, `apt-get installl ruby` / `pacman -S ruby`
..* bundler, `gem install bundler`
..* Mysql server, `apt-get install mysql-server` / `pacman -S mariadb`

Clone the repo, navigate to it and run `bundler install` this will install all gem dependencies, you can find these in the Gemfile

You can now run `rake db:setup` and then `rails s` and the site will now be served on http://0.0.0.0:3000/.

You will probably be redirected to account in order to login since the cookies we use for chalmers.it are only allowed on \*.chalmers.it.

To fix this you can edit your /etc/hosts file and add the following line:
`127.0.0.1       local.hubbit.chalmers.it localhost`

The site is now available at http://local.hubbit.chalmers.it:3000/
