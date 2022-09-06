# Git Server
Another git Dockerfile implementation.
Was built to learn git ssh with  docker

## Features
- Alpine base
- EZ setup
- Awall firewall
- ./repos volume (for bare repos)
- ./.ssh volume (for authorized keys)
- SMALL 36MB

## USAGE:
- *Build* `docker compose build`

- *Start* `docker compose up -d`

- *Stop* `docker compose down`

*SSH into container*
`ssh -p 2222 git@127.0.0.1`

## 1. SSH KEY SETUP
1. make an ssh key follow the promps
```s
ssh-keygen
```
copy to clip board (optional)
```s
cat ~/.ssh/id_rsa_new-key | xsel --clipboard --input
```
2. append to .ssh/authorized_keys volume
```s
cat ~/.ssh/id_rsa_git-server.pub > .ssh/authorized_keys
```

## 2. MAKE BARE GIT REPO
```
mkdir ./repos/website.git
cd ./repos/website.git
git init --bare
```

## 3. Test Repo on local machine
```s
mkdir website
cd website
git init
echo "# test" >> test.md
git add .
git commit -m "test"
git remote add origin git@127.0.0.1:repos/website.git
git push -u origin main
```

#### Troubleshooting: Port 2222 for testing purposes. push defaults to 22
```s
vi ~/.ssh/config

Host github.com
Port 22
Host 127.0.0.1
Port 2222
```

## Further Reading
https://www.inmotionhosting.com/support/website/git/git-server/
https://git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server
https://www.cyberciti.biz/faq/how-to-install-openssh-server-on-alpine-linux-including-docker/
AWALL https://www.cyberciti.biz/faq/how-to-set-up-a-firewall-with-awall-on-alpine-linux/