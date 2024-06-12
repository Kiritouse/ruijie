#!bin/bash 
# 这里可能是usr/bin/bash,也可能是这个,得多尝试

#If received parameters is less than 2, print usage
if [ "${#}" -lt "2" ]; then
  echo "Usage: ./ruijie_template.sh username password"
  echo "Example: ./ruijie_template.sh 201620000000 123456"
  exit 1
fi

#Exit the script when is already online, use www.google.cn/generate_204 to check the online status
captiveReturnCode=`curl -s -I -m 10 -o /dev/null -s -w %{http_code} http://www.google.cn/generate_204`
if [ "${captiveReturnCode}" = "204" ]; then
  echo "You are already online!"
  exit 0
fi

#If not online, begin Ruijie Auth

#Get Ruijie login page URL
loginPageURL=`curl -s "http://www.google.cn/generate_204" | awk -F \' '{print $2}'`

#Structure loginURL
loginURL=`echo ${loginPageURL} | awk -F \? '{print $1}'`
loginURL="${loginURL/index.jsp/InterFace.do?method=login}"
#如果学校的认证需要选择运营商，需要填写此处的service，并删除注释符号
#service="%25E4%25B8%25AD%25E5%259B%25BD%25E7%25A7%25BB%25E5%258A%25A8ChinaMobile"
queryString="wlanuserip=0ab5b1c3c6fd84fea34e23c1a826c290&wlanacname=776e154f4e46ba9668906e203954b23a&ssid=&nasip=0d09a1de724f795b5b8c3bae719e0bd7&snmpagentip=&mac=e9369f2168979cf192f3fda08c28b6af&t=wireless-v2&url=2c0328164651e2b4f13b933ddf36628bea622dedcc302b30&apmac=&nasid=776e154f4e46ba9668906e203954b23a&vid=a800d539fa278dfb&port=b269ecbc3037b59d&nasportid=5b9da5b08a53a540e5ed3ad9c53cf9a42f0f1caded8e0c40f3c4033b256dac87"
queryString="${queryString//&/%2526}"
queryString="${queryString//=/%253D}"

#Send Ruijie eportal auth request and output result
if [ -n "${loginURL}" ]; then
  authResult=`curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36" -e "${loginPageURL}" -b "EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_PASSWORD=; EPORTAL_COOKIE_SERVER=; EPORTAL_COOKIE_SERVER_NAME=; EPORTAL_AUTO_LAND=; EPORTAL_USER_GROUP=; EPORTAL_COOKIE_OPERATORPWD=;" -d "userId=${1}&password=${2}&service=${service}&queryString=${queryString}&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" "${loginURL}"`
  echo $authResult
fi
