#!/usr/bin/env bash

DC_PORTS=(53 88 135 139 389 445 464 593 636 3268 3269 3389 5985)

TOP100_PORTS=(
  7 9 13 21 22 23 25 26 37 53
  79 80 81 88 106 110 111 113 119 135
  139 143 144 179 199 389 427 443 444 445
  465 513 514 515 543 544 548 554 587 631
  646 873 990 993 995 1025 1026 1027 1028 1029
  1110 1433 1720 1723 1755 1900 2000 2001 2049 2121
  2717 3000 3128 3306 3389 3986 4899 5000 5009 5051
  5060 5101 5190 5357 5432 5631 5666 5800 5900 6000
  6001 6646 7070 8000 8008 8009 8080 8081 8443 8888
  9100 9999 10000 32768 49152 49153 49154 49155 49156 49157
)

TOP1000_PORTS=(
  80 23 443 21 22 25 3389 110 445 139
  143 53 135 3306 8080 1723 111 995 993 5900
  1025 587 8888 199 1720 465 548 113 81 6001
  10000 514 5060 179 1026 2000 8443 8000 32768 554
  26 1433 49152 2001 515 8008 49154 1027 5666 646
  5000 5631 631 49153 8081 2049 88 79 5800 106
  2121 1110 49155 6000 513 990 5357 427 49156 543
  544 5101 144 7 389 8009 3128 444 9999 5009
  7070 5190 3000 5432 3986 1900 13 1029 9 6646
  5051 49157 1028 873 1755 2717 4899 9100 119 37
  1000 3001 5001 82 10010 1030 9090 2107 1024 2103
  6004 1801 5050 19 8031 1041 255 3703 2967 1065
  1064 1056 1054 1053 1049 1048 17 808 3689 1031
  1071 1044 5901 9102 100 9000 8010 5120 4001 2869
  1039 2105 636 1038 2601 7000 1 1069 1066 625
  311 280 254 4000 5003 1761 2002 2005 1998 1032
  1050 6112 3690 1521 2161 6002 1080 2401 902 4045
  7937 787 1058 2383 32771 1059 1040 1033 50000 5555
  10001 1494 593 3 2301 7938 3268 1234 1022 9001
  8002 1074 1037 1036 1035 464 6666 497 2003 1935
  6543 24 1352 3269 1111 500 407 20 2006 3260
  15000 1218 1034 4444 264 33 2004 42510 1042 999
  3052 1023 222 1068 888 7100 563 1717 992 32770
  2008 7001 32772 8082 2007 5550 5801 512 2009 1043
  7019 50001 2701 1700 4662 2065 42 2010 9535 3333
  2602 161 5100 5002 4002 2604 9595 9594 9593 9415
  8701 8652 8651 8194 8193 8192 8089 6789 65389 65000
  64680 64623 6059 55600 55555 52869 5226 5225 4443 35500
  33354 3283 32769 2702 23502 20828 16993 16992 1311 1062
  1060 1055 1052 1051 1047 13782 1067 5902 366 9050
  85 5500 1002 8085 5431 51103 49999 45100 1864 1863
  10243 49 90 6667 6881 27000 1503 8021 340 1500
  9071 8899 8088 5566 2222 9876 9101 6005 5102 32774
  32773 1501 5679 163 648 1666 146 901 83 9207
  8084 8083 8001 5214 5004 3476 14238 912 30 12345
  2605 2030 6 541 8007 4 3005 1248 880 306
  2500 9009 8291 52822 4242 2525 1097 1088 1086 900
  6101 7200 2809 987 800 32775 211 12000 1083 705
  711 20005 6969 13783 9968 9900 9618 9503 9502 9500
  9485 9290 9220 9080 9011 9010 9002 8994 8873 8649
  8600 8402 8400 8333 8222 8181 8087 8086 7911 7778
  7777 7741 7627 7625 7106 6901 6788 6580 65129 6389
  63331 6156 6129 6123 60020 5989 5988 5987 5986 5985
  5962 5961 5960 5959 5925 5911 5910 5877 5825 5810
  58080 57294 5718 5633 5414 5269 5222 50800 5030 50006
  50003 49160 49159 49158 48080 4449 4129 4126 40193 4003
  3998 3827 3801 3784 3766 3659 3580 3551 34573 34572
  34571 3404 33899 3367 3351 3325 3323 3301 3300 32782
  32781 3211 31038 30718 3071 3031 3017 30000 2875 28201
  2811 27715 2718 2607 25734 2492 24800 2399 2381 22939
  2260 2190 2160 21571 2144 2135 2119 2100 20222 20221
  20031 20000 19842 19801 1947 19101 1840 17988 1783 1718
  1687 16018 16016 16001 15660 15003 15002 14442 14000 13456
  1310 1272 11967 1169 1148 11110 1108 1107 1106 1104
  1100 1099 1098 1096 1094 1093 1085 1082 1081 1079
  1078 1077 1075 1073 1072 1070 1063 10629 10628 10626
  10621 10617 10616 1061 1057 10566 1046 1045 10025 10024
  10012 10002 89 691 32776 212 2020 1999 1001 7002
  6003 50002 2998 898 5510 3372 32 2033 99 749
  5903 425 7007 6502 6106 5405 458 43 13722 9998
  9944 9943 9877 9666 9110 9091 8654 8500 8254 8180
  8100 8090 8011 7512 7443 7435 7402 7103 62078 61900
  61532 5963 5922 5915 5904 5859 5822 56738 55055 5298
  5280 5200 51493 50636 5054 50389 49175 49165 49163 4446
  4111 4006 3995 3918 3880 3871 3851 3828 3737 3546
  3493 3371 3370 3369 32784 3261 3077 3030 3011 27355
  27353 27352 2522 24444 2251 2191 2179 2126 19780 19315
  19283 18988 1782 16012 1580 15742 1334 1296 1247 1186
  1183 1152 1124 1089 1087 10778 10004 9040 32779 32777
  1021 700 666 616 32778 2021 84 5802 545 49400
  4321 38292 2040 1524 1112 32780 3006 2111 2048 1600
  1084 9111 6699 6547 2638 16080 801 720 667 6007
  5560 555 2106 2034 1533 1443 9917 9898 9878 9575
  9418 9200 9099 9081 9003 8800 8383 8300 8292 8290
  8200 8099 8093 8045 8042 8022 7999 7921 7920 7800
  7676 7496 7025 6839 6792 6779 6692 6689 6567 6566
  6565 6510 6100 60443 6025 5952 5950 5907 5906 5862
  5850 5815 5811 57797 5730 5678 56737 5544 55056 5440
  54328 54045 52848 52673 5221 5087 5080 5061 50500 5033
  50300 49176 49167 49161 4900 4848 4567 4550 44501 4445
  44176 4279 41511 40911 4005 4004 3971 3945 3920 3914
  3905 3889 3878 3869 3826 3814 3809 3800 3527 3517
  3390 3324 3322 32785 32783 3221 3168 30951 3003 2909
  27356 2725 26214 2608 25735 2394 2393 2323 19350 1862
  18101 18040 17877 16113 16000 15004 14441 1271 12265 12174
  1201 1199 1175 1151 1138 1131 1122 1119 1117 1114
  11111 1091 1090 10215 10180 10009 10003 981 777 722
  714 70 6346 617 4998 4224 417 2022 1009 765
  668 5999 524 301 2041 1076 10082 7004 6009 44443
  4343 416 259 2068 2038 1984 1434 1417 1007 911
  9103 726 7201 687 6006 4125 2046 2035 1461 109
  1010 903 683 6669 6668 481 2047 2043 2013 1455
  125 1011 9929 843 783 5998 44442 406 31337 256
  2045 2042 9988 9941 9914 9815 9673 9643 9621 9600
  9501 9444 9443 9409 9198 9197 9191 9098 8996 8987
  8889 8877 8766 8765 8686 8676 8675 8648 8540 8481
  8385 8294 8293 8189 8098 8097 8095 8050 8019 8016
  8015 7929 7913 7900 7878 7770 7749 7744 7725 7438
  7281 7278 7272 7241 7123 7080 7051 7050 7024 6896
  6732 6711 6600 6550 65310 6520 6504 6500 6481 6247
)


output_dir=""
result_file=""

timeout_sec=3
rate=0
open_only=0
hold_sec=0.4

service_name() {
  case "$1" in
    21) echo "ftp" ;; 22) echo "ssh" ;; 23) echo "telnet" ;;
    25) echo "smtp" ;; 53) echo "domain" ;; 80) echo "http" ;;
    88) echo "kerberos-sec" ;; 110) echo "pop3" ;; 111) echo "rpcbind" ;;
    135) echo "msrpc" ;; 139) echo "netbios-ssn" ;; 143) echo "imap" ;;
    389) echo "ldap" ;; 443) echo "https" ;; 445) echo "microsoft-ds" ;;
    464) echo "kpasswd5" ;; 465) echo "smtps" ;; 593) echo "http-rpc-epmap" ;;
    636) echo "ldaps" ;; 873) echo "rsync" ;; 993) echo "imaps" ;;
    995) echo "pop3s" ;; 1433) echo "ms-sql-s" ;; 1723) echo "pptp" ;;
    2049) echo "nfs" ;; 3128) echo "squid-http" ;; 3306) echo "mysql" ;;
    3389) echo "ms-wbt-server" ;; 4899) echo "radmin" ;; 5432) echo "postgresql" ;;
    5631) echo "pcanywheredata" ;; 5800) echo "vnc-http" ;; 5900) echo "vnc" ;;
    5985) echo "wsman" ;; 5986) echo "wsmans" ;; 8000) echo "http-alt" ;;
    8008) echo "http" ;; 8009) echo "ajp13" ;; 8080) echo "http-proxy" ;;
    8081) echo "blackice-icecap" ;; 8443) echo "https-alt" ;;
    8888) echo "sun-answerbook" ;; 10000) echo "snet-sensor-mgmt" ;;
    3268) echo "globalcatLDAP" ;; 3269) echo "globalcatLDAPssl" ;;
    47001) echo "winrm" ;;
    *) echo "unknown" ;;
  esac
}

is_high_value_port() {
  case "$1" in
    21|22|23|25|53|80|88|110|111|135|139|143|389|443|445|464|465|593|636|873|993|995|1433|1723|2049|3128|3306|3389|4899|5432|5631|5800|5900|5985|5986|8000|8008|8009|8080|8081|8443|8888|10000|3268|3269|47001)
      return 0 ;;
    *) return 1 ;;
  esac
}

usage() {
  cat << 'EOF'
Usage:
  ./port_checker.sh -t <target[,target2,...]> [options]
  ./port_checker.sh -f <targets_file> [options]

Target options:
  -t <targets>        Targets provided directly in the command.
                      Accepts IPs, hosts, comma-separated lists, CIDR ranges,
                      and last-octet ranges.
                      Example: -t 10.10.10.5
                      Example: -t 10.10.10.5,10.10.10.6
                      Example: -t 192.168.1.1/24
                      Example: -t 192.168.1.1-21

  -f <file>           File containing targets, one per line.
                      Empty lines and lines starting with # are ignored.
                      Example: -f targets.txt

Port options:
  -p <ports>          Custom ports, comma-separated.
                      Supports single ports and ranges.
                      Example: -p 22,80,443,8080
                      Example: -p 22-44
                      Example: -p 22,80,443,8000-8100

  -dc                 Adds common Domain Controller ports:
                      53,88,135,139,389,445,464,593,636,3268,3269,3389,5985

  -top100             Adds the Nmap-style top 100 TCP ports.
                      With -top100, only open ports are shown by default.
                      
  -top1000            Adds the hardcoded Nmap-style top 1000 TCP ports.
                      With -top1000, only open ports are shown by default.
                      Example: -top1000
                      
  -all                Adds all TCP ports from 1 to 65535.
                      With -all, only open ports are shown by default.
                      Example: -all

Scan options:
  -w <seconds>        Timeout per port, in seconds.
                      Default: 3
                      Example: -w 1

  -r <rate>           Approximate rate limit, in connections per second.
                      Default: 0, meaning no artificial delay.
                      Example: -r 10

  --open-only         Show only open ports.
                      Useful with -dc or -p, not only -top100.

  -h, --help          Show this help message.

Output:

  -o, --output <dir>  Write open ports to files.
                      Creates one file per target named <target>.txt.
                      Each file contains only open ports, one per line.
                      Creates one file with all the output with the name result.txt
                      Example: -o results
                      
  PORT                Tested port.
  SERVICE             Estimated service name based on the port, similar to Nmap.
                      This does not perform real version fingerprinting.
  STATE               open or closed/filtered.

  Services marked as *service* are considered higher-value from a security
  testing perspective and are marked only when the port is open.

Examples:
  ./port_checker.sh -t 10.10.10.5 -dc -o results
  ./port_checker.sh -t 10.10.10.5,10.10.10.6 -top100 -o results
  ./port_checker.sh -f targets.txt -dc -p 8080,8443 -o results
  ./port_checker.sh -f targets.txt -top100 -r 20 -w 1 -o results
  ./port_checker.sh -t dc01.local -p 445,3389,5985 --open-only -o results

Notes:
  This script uses nc for TCP connect checks.
  It does not call proxychains internally.
  If you need a proxy, run the whole script through proxychains externally:
    proxychains4 ./port_checker.sh -t 10.10.10.5 -top100
EOF
}

ip_to_int() {
  local IFS=.
  local a b c d
  read -r a b c d <<< "$1"
  echo $(( (a << 24) + (b << 16) + (c << 8) + d ))
}

int_to_ip() {
  local ip="$1"
  echo "$(( (ip >> 24) & 255 )).$(( (ip >> 16) & 255 )).$(( (ip >> 8) & 255 )).$(( ip & 255 ))"
}

add_target_once() {
  local new_target="$1"

  [ -z "$new_target" ] && return

  for existing_target in "${targets[@]}"; do
    [ "$existing_target" = "$new_target" ] && return
  done

  targets+=("$new_target")
}

expand_cidr() {
  local cidr="$1"
  local ip="${cidr%/*}"
  local prefix="${cidr#*/}"
  local ip_int mask network broadcast start end current

  if ! [[ "$prefix" =~ ^[0-9]+$ ]] || [ "$prefix" -lt 0 ] || [ "$prefix" -gt 32 ]; then
    echo "Invalid CIDR: $cidr" >&2
    return
  fi

  ip_int="$(ip_to_int "$ip")"
  mask=$(( (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF ))
  network=$(( ip_int & mask ))
  broadcast=$(( network | (~mask & 0xFFFFFFFF) ))

  if [ "$prefix" -lt 31 ]; then
    start=$((network + 1))
    end=$((broadcast - 1))
  else
    start="$network"
    end="$broadcast"
  fi

  for ((current=start; current<=end; current++)); do
    add_target_once "$(int_to_ip "$current")"
  done
}

expand_last_octet_range() {
  local range="$1"
  local base start end prefix current

  base="${range%-*}"
  end="${range#*-}"
  prefix="${base%.*}"
  start="${base##*.}"

  if ! [[ "$start" =~ ^[0-9]+$ ]] || ! [[ "$end" =~ ^[0-9]+$ ]]; then
    echo "Invalid range: $range" >&2
    return
  fi

  if [ "$start" -gt "$end" ] || [ "$end" -gt 255 ]; then
    echo "Invalid range: $range" >&2
    return
  fi

  for ((current=start; current<=end; current++)); do
    add_target_once "$prefix.$current"
  done
}

add_target() {
  local item="$1"
  local target

  IFS=',' read -ra split_targets <<< "$item"

  for target in "${split_targets[@]}"; do
    target="${target//[[:space:]]/}"
    [ -z "$target" ] && continue

    if [[ "$target" == */* ]]; then
      expand_cidr "$target"
    elif [[ "$target" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}-[0-9]{1,3}$ ]]; then
      expand_last_octet_range "$target"
    else
      add_target_once "$target"
    fi
  done
}

add_port_once() {
  local new_port="$1"

  for existing_port in "${ports[@]}"; do
    if [ "$existing_port" = "$new_port" ]; then
      return
    fi
  done

  ports+=("$new_port")
}

add_port() {
  local item="$1"
  local port start end current

  IFS=',' read -ra split_ports <<< "$item"

  for port in "${split_ports[@]}"; do
    port="${port//[[:space:]]/}"
    [ -z "$port" ] && continue

    if [[ "$port" =~ ^[0-9]+-[0-9]+$ ]]; then
      start="${port%-*}"
      end="${port#*-}"

      if [ "$start" -lt 1 ] || [ "$end" -gt 65535 ] || [ "$start" -gt "$end" ]; then
        echo "Invalid port range: $port" >&2
        continue
      fi

      for ((current=start; current<=end; current++)); do
        add_port_once "$current"
      done

    elif [[ "$port" =~ ^[0-9]+$ ]]; then
      if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Invalid port: $port" >&2
        continue
      fi

      add_port_once "$port"

    else
      echo "Invalid port: $port" >&2
    fi
  done
}

rate_sleep() {
  if [ "$rate" != "0" ]; then
    sleep "$(awk "BEGIN { printf \"%.3f\", 1 / $rate }")"
  fi
}

safe_filename() {
  echo "$1" | sed 's/[^A-Za-z0-9._-]/_/g'
}

log_result() {
  local line="$1"

  [ -z "$result_file" ] && return
  echo "$line" >> "$result_file"
}

print_and_log() {
  local line="$1"

  printf "%s\n" "$line"
  log_result "$line"
}

write_open_port() {
  local host="$1"
  local port="$2"

  [ -z "$output_dir" ] && return

  mkdir -p "$output_dir"

  local file
  file="$output_dir/$(safe_filename "$host").txt"

  echo "$port" >> "$file"
}

targets=()
ports=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    -h| --help)
      usage
      exit 0
      ;;
    -t)
      shift
      [ -z "$1" ] && usage && exit 1
      add_target "$1"
      ;;

    -f)
      shift
      [ -z "$1" ] && usage && exit 1
      [ ! -f "$1" ] && echo "File not found: $1" && exit 1

      while IFS= read -r host || [ -n "$host" ]; do
        [ -z "$host" ] && continue
        [[ "$host" =~ ^[[:space:]]*# ]] && continue
        add_target "$host"
      done < "$1"
      ;;

    -p)
      shift
      [ -z "$1" ] && usage && exit 1
      add_port "$1"
      ;;

    -dc)
      for port in "${DC_PORTS[@]}"; do
        add_port "$port"
      done
      ;;

    -top100)
      for port in "${TOP100_PORTS[@]}"; do
        add_port "$port"
      done
      open_only=1
      ;;
      
    -top1000)
      for port in "${TOP1000_PORTS[@]}"; do
        add_port "$port"
      done
      open_only=1
      ;;
      
    -all)
      for ((port=1; port<=65535; port++)); do
        add_port "$port"
      done
      open_only=1
      ;;

    -r)
      shift
      [ -z "$1" ] && usage && exit 1
      rate="$1"
      ;;

    -w)
      shift
      [ -z "$1" ] && usage && exit 1
      timeout_sec="$1"
      ;;
      
    -o| --output)
      shift
      [ -z "$1" ] && usage && exit 1
      output_dir="$1"
      ;;

    --open-only)
      open_only=1
      ;;

    *)
      echo "Unknown option: $1"
      
      usage
      exit 1
      ;;
  esac

  shift
done

if [ "${#targets[@]}" -eq 0 ] || [ "${#ports[@]}" -eq 0 ]; then
  usage
  exit 1
fi

if [ -n "$output_dir" ]; then
  mkdir -p "$output_dir"

  result_file="$output_dir/result.txt"
  : > "$result_file"

  for host in "${targets[@]}"; do
    : > "$output_dir/$(safe_filename "$host").txt"
  done
fi

interrupted=0
scanned=0
total=$(( ${#targets[@]} * ${#ports[@]} ))

cleanup() {
  interrupted=1
  printf "\r%-80s\r" ""
  echo "Scan interrupted. Stopping..."
  exit 130
}

show_progress() {
  local current_host="$1"
  local current_port="$2"
  local percent=0

  if [ "$total" -gt 0 ]; then
    percent=$(( scanned * 100 / total ))
  fi

  if [ -n "$current_host" ] && [ -n "$current_port" ]; then
    printf "\rScanned %d out of %d ports (%d%%) | Testing %s:%s" \
      "$scanned" "$total" "$percent" "$current_host" "$current_port"
  else
    printf "\rScanned %d out of %d ports (%d%%)" \
      "$scanned" "$total" "$percent"
  fi
}

trap cleanup INT TERM

for host in "${targets[@]}"; do
  print_and_log ""
  print_and_log "Target: $host"
  print_and_log "------------------------------------------------"
  print_and_log "$(printf "%-8s %-22s %s" "PORT" "SERVICE" "STATE")"
  print_and_log "$(printf "%-8s %-22s %s" "----" "-------" "-----")"

  for port in "${ports[@]}"; do
    show_progress "$host" "$port"
    service="$(service_name "$port")"

    if nc -w "$timeout_sec" -z "$host" "$port" 2>/dev/null; then
      state="open"
      write_open_port "$host" "$port"

      if is_high_value_port "$port"; then
        service="*$service*"
      fi

	printf "\r%-80s\r" ""
	line="$(printf "%-8s %-22s %s" "$port" "$service" "$state")"
	print_and_log "$line"
    else
      state="closed/filtered"

      if [ "$open_only" -eq 0 ]; then
	printf "\r%-80s\r" ""
	line="$(printf "%-8s %-22s %s" "$port" "$service" "$state")"
	print_and_log "$line"
      fi
    fi

    scanned=$((scanned + 1))
    show_progress
    rate_sleep
  done

  printf "\r%-80s\r" ""
done

show_progress
echo
