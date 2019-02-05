#!/bin/bash
# ------------------------------------------------------------------
# Generates the Terraform tf var file used to manage Azure Firewall rules
# ------------------------------------------------------------------
#

#Sample
#./main.sh ./main_fw_rules.template.tf ./var_fw_rules.json ../../module/Create-AzureRmFirewall/main_fw_rules.tf

#Variable initialisation
template_file_location=$1
variable_file_location=$2
target_file_location=$3
source "../tools/bash_functions.sh"

#Color
Correct='\033[0;32m'            # Green
Warning='\033[38;5;202m'        # Orange
Error='\033[0;31m'              # Red
NoColor='\033[0m'

#Ensuring that node cmdlet is available
if [ $(which node) ] ; then 
    echo -e "${Correct}node cmdlet is available${NoColor}"
else 
    echo -e "${Error}node cmdlet is not not available${NoColor}"
    exit 1
fi

action="Generating the file : $target_file_location using mustache-handlebar"
cmdlet="node ../tools/process_template.handlebar.js $template_file_location $variable_file_location $target_file_location"
notanerror="" #Use it only if you know th exact text of the output error that you don't want to consider as an error.
action_cmdlet "$action" "$cmdlet" "$notanerror"