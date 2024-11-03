#!/bin/bash

# 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # 색상 초기화

echo -e "${GREEN}teneo 봇을 설치합니다.${NC}"
echo -e "${GREEN}스크립트작성자: https://t.me/kjkresearch${NC}"

echo -e "${GREEN}옵션을 선택하세요:${NC}"
echo -e "${YELLOW}1. teneo 봇 새로 설치${NC}"
echo -e "${YELLOW}2. 기존정보 그대로 이용하기(재실행)${NC}"
read -p "선택: " choice

case $choice in
  1)
    echo -e "${GREEN}teneo 를 새로 설치합니다.${NC}"
    # 파이썬 및 필요한 패키지 설치
    echo -e "${YELLOW}시스템 업데이트 및 필수 패키지 설치 중...${NC}"
    rm -rf /root/Teneo-Bot
    sudo apt update
    sudo apt install -y git

    # GitHub에서 코드 복사
    echo -e "${YELLOW}GitHub에서 코드 복사 중...${NC}"
    git clone https://github.com/airdropinsiders/Teneo-Bot.git

    # 작업 공간 생성 및 이동
    echo -e "${YELLOW}작업 공간 이동 중...${NC}"
    cd /root/Teneo-Bot

    echo -e "${YELLOW}Node.js LTS 버전을 설치하고 설정 중...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm을 로드합니다
    nvm install --lts
    nvm use --lts
    npm install

    # 사용자 정보 입력
    echo -e "${GREEN}사용자 정보를 입력받습니다.${NC}"

    echo -e "${GREEN}봇을 실행하기전에 다음 단계들이 필수적으로 필요합니다. 진행하신 후 엔터를 눌러주세요.${NC}"
    read -p "초대코드가 자동으로 입력되니 미리 가입을 진행하세요."
    read -p "다음 사이트로 이동하여 어플을 받아주세요: https://chromewebstore.google.com/detail/teneo-community-node/emcclcoaglgcpoognfiggmhnhgabppkm"
    read -p "가입을 진행하신 후 셀퍼럴을 진행하시거나 해당 코드를 입력해 주세요: Z5N0r"

    # 사용자로부터 이메일과 패스워드 입력받기
    read -p "이메일을 입력하세요 (쉼표로 구분): " emails
    read -p "패스워드를 입력하세요 (쉼표로 구분): " passwords

    # 이메일과 패스워드를 배열로 변환
    IFS=',' read -r -a email_array <<< "$emails"
    IFS=',' read -r -a password_array <<< "$passwords"

    # 이메일과 패스워드를 객체 배열로 변환
    accountLists=()
    for i in "${!email_array[@]}"; do
        accountLists+=("{ email: \"${email_array[i]}\", password: \"${password_array[i]}\" }")
    done

    # 결과를 accounts.js 파일에 저장
    {
        echo "export const accountLists = ["
        for account in "${accountLists[@]}"; do
            echo "    $account,"
        done
        echo "];"
    } > /root/Teneo-Bot/accounts/accounts.js

    # 프록시 정보 입력 안내
    echo -e "${YELLOW}프록시 정보를 입력하세요. 입력형식: http://proxyUser:proxyPass@IP:Port${NC}"
    echo -e "${YELLOW}여러 개의 프록시는 쉼표로 구분하세요.${NC}"
    echo -e "${YELLOW}챗GPT를 이용해서 형식을 변환해달라고 하면 됩니다.${NC}"
    read -p "프록시 정보를 입력하시고 엔터를 누르세요: " proxies
    
    # 프록시를 배열로 변환
    IFS=',' read -r -a proxy_array <<< "$proxies"

    # 결과를 proxy_list.js 파일에 저장
    {
        echo "export const proxyList = ["
        for proxy in "${proxy_array[@]}"; do
            echo "    \"$proxy\","
        done
        echo "];"
    } > /root/Teneo-Bot/config/proxy_list.js

    cp /root/Teneo-Bot/app/config/config_tmp.js /root/Teneo-Bot/app/config/config.js

    # 봇구동
    npm run start
    ;;
  2)
    echo -e "${GREEN}봇을 재실행합니다.${NC}"
    cd /root/Teneo-Bot
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # nvm을 로드합니다
    npm run start
    ;;
  *)
    echo -e "${RED}잘못된 선택입니다. 다시 시도하세요.${NC}"
    ;;
esac

