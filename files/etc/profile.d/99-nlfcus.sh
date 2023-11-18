fmtstr='%10s: %-20s %20s: %-30s\n'

printf "$fmtstr" 'USER' "$USER" 'YOUR IP' "$SSH_CLIENT"

uptime=$( uptime | sed -E 's/.+ up (.+)load average:.+/\1/' | sed -E 's/^\s+|,\s*$//g' )
loadavg=$(uptime | awk -F 'average: ' '{print $2}')

printf "$fmtstr" 'uptime' "$uptime" 'load average' "$loadavg"



echo -----------------------------------------------------