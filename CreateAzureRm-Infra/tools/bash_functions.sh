#Color
Correct='\033[0;32m'            # Green
Warning='\033[0;33m'            # Jaune
Error='\033[0;31m'              # Red
NoColor='\033[0m'

function action_cmdlet {
    action="$1"
    cmdlet="$2"
    notanerror="$3"
    if [[ $notanerror = "" ]]; then notanerror="impossibletextthatyouwillneverfoundasanerror" ; fi

    echo -e "${Correct}$action...${NoColor}"
    action_cmdlet_output=$($cmdlet 2> /tmp/stderr_$$)
    if [[ $? != 0 ]]; then 
        if [[ $(cat /tmp/stderr_$$) =~ $notanerror ]]; then  
            echo -e "${Warning}You have decided that the following message is not an error : $(cat /tmp/stderr_$$) ${NoColor}"
        else
            echo -e "${Error}Error with action : $action...${NoColor}"
            echo -e "${Error}Error : $(cat /tmp/stderr_$$)...${NoColor}"
            exit 1
        fi
    fi
    return 0
}
