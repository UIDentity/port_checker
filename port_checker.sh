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

output_dir=""
result_file=""

timeout_sec=3
rate=0
open_only=0

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
                      Accepts one IP/host or a comma-separated list.
                      Example: -t 10.10.10.5
                      Example: -t 10.10.10.5,10.10.10.6

  -f <file>           File containing targets, one per line.
                      Empty lines and lines starting with # are ignored.
                      Example: -f targets.txt

Port options:
  -p <ports>          Custom ports, comma-separated.
                      Example: -p 22,80,443,8080

  -dc                 Adds common Domain Controller ports:
                      53,88,135,139,389,445,464,593,636,3268,3269,3389,5985

  -top100             Adds the Nmap-style top 100 TCP ports.
                      With -top100, only open ports are shown by default.

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

add_target() {
  local item="$1" target
  IFS=',' read -ra split_targets <<< "$item"
  for target in "${split_targets[@]}"; do
    target="${target//[[:space:]]/}"
    [ -n "$target" ] && targets+=("$target")
  done
}

add_port() {
  local item="$1" port
  IFS=',' read -ra split_ports <<< "$item"
  for port in "${split_ports[@]}"; do
    port="${port//[[:space:]]/}"

    if ! [[ "$port" =~ ^[0-9]+$ ]]; then
      echo "Invalid port: $port" >&2
      continue
    fi

    for existing_port in "${ports[@]}"; do
      [ "$existing_port" = "$port" ] && continue 2
    done

    ports+=("$port")
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
  local percent=0

  if [ "$total" -gt 0 ]; then
    percent=$(( scanned * 100 / total ))
  fi

  printf "\rScanned %d out of %d ports (%d%%)" "$scanned" "$total" "$percent"
}

trap cleanup INT TERM

for host in "${targets[@]}"; do
  print_and_log ""
  print_and_log "Target: $host"
  print_and_log "------------------------------------------------"
  print_and_log "$(printf "%-8s %-22s %s" "PORT" "SERVICE" "STATE")"
  print_and_log "$(printf "%-8s %-22s %s" "----" "-------" "-----")"

  for port in "${ports[@]}"; do
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