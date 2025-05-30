## install docker from github with script
in repo will find scripts/wp-docker.sh download it, set +x and run ./wp-docker.sh

will prompt folder name to clone repo

```
wp-docker.sh
```

after clone cd into the folder and run the script docker-compose up
will be call script setup-wp.sh

will download  wordpess latest version 
!!! need to wait untill wp will be downloaded(about 10sec)

to install wordpress call script
./scripts/install-wp.sh

after installing, in nginx config and /etc/hosts will be written theme.local
need to docker down adn docker build

### go to theme folder twentyseventeen 
```
run:

- wb init
- wb plugins base
- wb backup restore from downloads
