#!/bin/bash
#
#   -- Author:      jackeywells
#

msg() {
    echo -e "\033[32m${@}\033[0m"
}

# footer msg
footer_msg() {
    msg "------------- begin -------------"
    msg "如需帮助+V：sert12315"
    msg "如遇密码错误请+V：sert12315"
    msg "chatgpt私有部署、商业部署，演示站：http://usa1y.studentgpt.top"
}

validateUser() {
    read -p $'请输入鉴权秘钥\x0a' secret
    if [[ "$secret" = "ifUtlpl1233j3jnr3q" ]]; then
        #statements
        echo "输入正确"
        return
    else
        echo "秘钥输入错误"
        rm -rf $0
        exit 1
    fi
}

footer_msg
validateUser

if [ -s "/etc/os-release" ];then
    os_name=$(sed -n 's/PRETTY_NAME="\(.*\)"/\1/p' /etc/os-release)

    if [ -n "$(echo ${os_name} | grep -Ei 'Debian|Ubuntu' )" ];then
        printf "Current OS: %s\n" "${os_name}"
        SYSTEM_RECOGNIZE="debian"

    elif [ -n "$(echo ${os_name} | grep -Ei 'CentOS')" ];then
        printf "Current OS: %s\n" "${os_name}"
        SYSTEM_RECOGNIZE="centos"
    else
        printf "Current OS: %s is not support.\n" "${os_name}"
    fi
elif [ -s "/etc/issue" ];then
    if [ -n "$(grep -Ei 'CentOS' /etc/issue)" ];then
        printf "Current OS: %s\n" "$(grep -Ei 'CentOS' /etc/issue)"
        SYSTEM_RECOGNIZE="centos"
    else
        printf "+++++++++++++++++++++++\n"
        cat /etc/issue
        printf "+++++++++++++++++++++++\n"
        printf "[Error] Current OS: is not available to support.\n"
    fi
else
    printf "[Error] (/etc/os-release) OR (/etc/issue) not exist!\n"
    printf "[Error] Current OS: is not available to support.\n"
fi


# 安装curl and socat
if [ $SYSTEM_RECOGNIZE = "debian" ];then
	apt update -y
	apt install -y curl
	apt install -y socat
elif [ $SYSTEM_RECOGNIZE = "centos" ]; then
	yum install -y curl
	yum install -y socat
else
	printf "Current OS is not support"
	printf $'[Error] Installing terminated\x0a'
    exit 1
fi

apt-get install cron
curl https://get.acme.sh | sh

inputDomain() {
    read -p $'请输入完整域名，比如：yuanyouyuan.studentgpt.top\x0a' domain
    if [[ "$domain" =~ ^.+\..+\..+ ]]; then
        echo 'OK'
    else
        echo '域名输入有误!!!!!!!'
        inputDomain
    fi
}

inputDomain

read -p $'请输入邮箱，格式:xxxx@xx.com\x0a' mail
~/.acme.sh/acme.sh --upgrade --auto-upgrade
~/.acme.sh/acme.sh --register-account -m 22${mail}
~/.acme.sh/acme.sh --issue -d ${domain} --standalone
~/.acme.sh/acme.sh --installcert -d ${domain} --key-file /root/private.key --fullchain-file /root/cert.crt

bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
# echo -e "\033[32m安装成功，重启后运行:./tcp.sh\033[0m"
rm -rf $0
