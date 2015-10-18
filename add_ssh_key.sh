#!/usr/bin/env bash

REMOTE=$1

# 生成密钥
gen_ssh_key()
{
	if [ ! -d "$HOME/.ssh" ]; then
		mkdir -p "$HOME"/.ssh
	fi
	
	if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
		cd "$HOME"/.ssh && ssh-keygen -t rsa -N "" -f "id_rsa"
		ssh-add "$HOME/.ssh/id_rsa"
	fi
}

# 添加到远程主机
add_pub_key()
{
	scp "$HOME"/.ssh/id_rsa.pub "$REMOTE":/tmp
	ssh "$REMOTE" "if [ ! -d .ssh ]; then mkdir .ssh; chmod 700 .ssh; fi; cat /tmp/id_rsa.pub >> .ssh/authorized_keys; chmod 640 .ssh/authorized_keys; sort -u -o .ssh/authorized_keys .ssh/authorized_keys; rm /tmp/id_rsa.pub"
}

help()
{
cat <<EOF
USAGE: $0 user@hostname

EXAMPLES:
	$0 root@192.168.1.23
EOF
}

if { [ -z "$1" ] && [ -t 0 ] ; } || [ "$1" = '-h' ]
then
	help
	exit 0
fi
gen_ssh_key
add_pub_key

