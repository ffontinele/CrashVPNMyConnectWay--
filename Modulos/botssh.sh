#!/bin/bash
clear
fun_bar() {
    comando[0]="$1"
    comando[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${comando[0]} -y >/dev/null 2>&1
        ${comando[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "\033[1;33m["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[1;31m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "\033[1;33m]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "\033[1;33m["
    done
    echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
    tput cnorm
}

fun_botOnOff() {
    [[ $(ps x | grep "bot_plus" | grep -v grep | wc -l) = '0' ]] && {
        clear
        echo -e "\E[44;1;37m             INSTALADOR BOT CrashVPN                \E[0m\n"
        echo -ne "\033[1;32mINFORME SEU TOKEN:\033[1;37m "
        read tokenbot
        echo ""
        echo -ne "\033[1;32mINFORME SEU ID:\033[1;37m "
        read iduser
        clear
        echo -e "\033[1;32mINICIANDO BOT CrashVPN \033[0m\n"
        fun_bot1() {
            [[ ! -e "/etc/CrashVPN/ShellBot.sh" ]] && wget https://raw.githubusercontent.com/ffontinele/CrashVPNMyConnectWay--/main/ShellBot.sh -O /etc/CrashVPN/ShellBot.sh
            cd /etc/CrashVPN
			rm -R bot
			wget https://raw.githubusercontent.com/ffontinele/CrashVPNMyConnectWay--/main/Modulos/bot
			chmod 777 bot
            screen -dmS bot_plus ./bot $tokenbot $iduser >/dev/null 2>&1
            [[ $(grep -wc "bot_plus" /etc/autostart) = '0' ]] && {
                echo -e "ps x | grep 'bot_plus' | grep -v 'grep' || cd /etc/CrashVPN && sudo screen -dmS bot_plus ./bot $tokenbot $iduser && cd $HOME" >>/etc/autostart
            } || {
                sed -i '/bot_plus/d' /etc/autostart
                echo -e "ps x | grep 'bot_plus' | grep -v 'grep' || cd /etc/CrashVPN && sudo screen -dmS bot_plus ./bot $tokenbot $iduser && cd $HOME" >>/etc/autostart
            }
            [[ $(crontab -l | grep -c "verifbot") = '0' ]] && (
                crontab -l 2>/dev/null
                echo "@daily /bin/verifbot"
            ) | crontab -
            cd $HOME
        }
        fun_bar 'fun_bot1'
        [[ $(ps x | grep "bot_plus" | grep -v grep | wc -l) != '0' ]] && echo -e "\n\033[1;32m BOT CrashVPN ATIVADO !\033[0m" || echo -e "\n\033[1;31m ERRO! REANALISE SUAS INFORMACOES\033[0m"
        sleep 2
        menu
    } || {
        clear
        echo -e "\033[1;32mPARANDO BOT CrashVPN... \033[0m\n"
        fun_bot2() {
            screen -r -S "bot_plus" -X quit
            screen -wipe 1>/dev/null 2>/dev/null
            [[ $(grep -wc "bot_plus" /etc/autostart) != '0' ]] && {
                sed -i '/bot_plus/d' /etc/autostart
            }
            [[ $(crontab -l | grep -c "verifbot") != '0' ]] && crontab -l | grep -v 'verifbot' | crontab -
            sleep 1
        }
        fun_bar 'fun_bot2'
        echo -e "\n\033[1;32m \033[1;31mBOT CrashVPN PARADO! \033[0m"
        sleep 2
        menu
    }
}

fun_instbot() {
    echo -e "\E[44;1;37m             INSTALADOR BOT CrashVPN                \E[0m\n"
    echo -e "                 \033[1;33m[\033[1;31m!\033[1;33m] \033[1;31mATENCAO \033[1;33m[\033[1;31m!\033[1;33m]\033[0m"
    echo -e "\n\033[1;32m1Â° \033[1;37m- \033[1;33mPELO SEU TELEGRAM ACESSE OS SEGUINTES BOT\033[1;37m:\033[0m"
    echo -e "\n\033[1;32m2Â° \033[1;37m- \033[1;33mBOT \033[1;37m@BotFather \033[1;33mCRIE O SEU BOT \033[1;31mOPCAO: \033[1;37m/newbot\033[0m"
    echo -e "\n\033[1;32m3Â° \033[1;37m- \033[1;33mBOT \033[1;37m@SSHPLUS_BOT \033[1;33mE PEGUE SEU ID \033[1;31mOPCAO: \033[1;37m/id\033[0m"
    echo -e "\033[0;34mâ”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”\033[1;32m"
    echo ""
    read -p "DESEJA CONTINUAR ? [s/n]: " -e -i s resposta
    [[ "$resposta" = 's' ]] && {
        fun_botOnOff
    } || {
        echo -e "\n\033[1;31mRetornando...\033[0m"
        sleep 2
        menu
    }
}
[[ -f "/etc/CrashVPN/ShellBot.sh" ]] && fun_botOnOff || fun_instbot
#fim