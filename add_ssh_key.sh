#!/usr/bin/env bash

SERVERIP=$1

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
	echo "connecting..."
	scp "$SERVERIP":~/.ssh/authorized_keys /tmp/key.tmp~   # 输入口令
	cat "$HOME"/.ssh/id_rsa.pub >> /tmp/key.tmp~
	sort /tmp/key.tmp~ | uniq > /tmp/key.tmp2~
	echo "connecting..."
	scp /tmp/key.tmp2~ "$SERVERIP":~/.ssh/authorized_keys
	
	rm /tmp/key.tmp2~ /tmp/key.tmp~
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

