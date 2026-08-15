# port_checker

Works well with **proxychains** for quick port identification when while **pivoting** ( That`s the main reason why i made the script )

# TCP Port Checker

A lightweight Bash TCP port checker for quick internal security testing and reachability checks.

The script uses `nc` for TCP connect checks and estimates service names based on common port mappings, similar to Nmap service labels. It does not perform raw packet scanning, UDP scanning, OS detection, or version fingerprinting.

## Features

- Scan one target or multiple targets from the command line
- Expand CIDR ranges such as `192.168.1.1/24`
- Expand last-octet ranges such as `192.168.1.1-21`
- Scan targets from a file
- Use custom port lists
- Use a Domain Controller port preset with `-dc`
- Use an Nmap-style top 100 TCP ports preset with `-top100`
- Use a hardcoded Nmap-style top 1000 TCP ports preset with `-top1000`
- Scan all TCP ports from 1 to 65535 with `-all`
- Show only open ports with `--open-only`
- Automatically show only open ports when using `-top100`, `-top1000`, or `-all`
- Mark higher-value open services with `*service*`
- Display live scan progress on a single updating line
- Stop cleanly on `Ctrl+C`
- Configure timeout per port
- Configure connection hold time for tunnel/sshuttle scenarios
- Configure approximate scan rate
- Write per-target open-port files
- Write the full scan output to `result.txt`

## Requirements

- Bash
- `nc` / Netcat
- Standard Unix tools such as `sed`, `awk`, and `mkdir`

## Usage

```bash
./port_checker.sh -t <target[,target2,...]> [options]
./port_checker.sh -f <targets_file> [options]
```

## Target Options

```bash
-t <targets>
```

Targets provided directly in the command. Accepts IPs, hostnames, comma-separated lists, CIDR ranges, and last-octet ranges.

```bash
./port_checker.sh -t 10.10.10.5 -dc
./port_checker.sh -t 10.10.10.5,10.10.10.6 -top100
./port_checker.sh -t 192.168.1.1/24 -top100
./port_checker.sh -t 192.168.1.1-21 -dc
./port_checker.sh -t 192.168.1.1/24,10.10.10.1-10 -p 22,80,443
./port_checker.sh -t 10.10.10.5 -p 22-44
```

CIDR ranges expand to usable hosts when possible. For example, `192.168.1.1/24` expands to `192.168.1.1` through `192.168.1.254`.

Last-octet ranges keep the first three octets and expand only the final octet. For example, `192.168.1.1-21` expands to `192.168.1.1` through `192.168.1.21`.

```bash
-f <file>
```

File containing targets, one per line. Empty lines and lines starting with `#` are ignored.

```bash
./port_checker.sh -f targets.txt -dc
```

Example `targets.txt`:

```text
10.10.10.5
10.10.10.6
dc01.local
```

## Port Options

```bash
-p <ports>
```

Custom ports. Accepts single ports, comma-separated lists, and port ranges.

```bash
./port_checker.sh -t 10.10.10.5 -p 22,80,443,8080
./port_checker.sh -t 10.10.10.5 -p 22-44
./port_checker.sh -t 10.10.10.5 -p 22,80,443,8000-8100
```

```bash
-dc
```

Adds common Domain Controller ports:

```text
53,88,135,139,389,445,464,593,636,3268,3269,3389,5985
```

```bash
./port_checker.sh -t 10.10.10.5 -dc
```

```bash
-top100
```

Adds an Nmap-style top 100 TCP port list. When `-top100` is used, only open ports are shown by default.

```bash
./port_checker.sh -f targets.txt -top100
```

```bash
-top1000
```

Adds a hardcoded Nmap-style top 1000 TCP port list. When `-top1000` is used, only open ports are shown by default.

```bash
./port_checker.sh -f targets.txt -top1000
```

```bash
-all
```

Adds all TCP ports from `1` to `65535`. When `-all` is used, only open ports are shown by default.

```bash
./port_checker.sh -t 10.10.10.5 -all
```

Presets can be combined with custom ports:

```bash
./port_checker.sh -t 10.10.10.5 -dc -p 8080,8443
./port_checker.sh -f targets.txt -dc -top100 -p 47001
./port_checker.sh -f targets.txt -top1000 -p 5985,5986
./port_checker.sh -f targets.txt -dc -p 8000-8100
```

## Scan Options

```bash
-w <seconds>
```

Timeout per port, in seconds.

Default:

```text
3
```

Example:

```bash
./port_checker.sh -t 10.10.10.5 -top100 -w 1
```

```bash
--hold <seconds>
```

Keep the TCP connection alive for this long before deciding it is open.

Default:

```text
0.4
```

This is useful when scanning through tunnel tools such as `sshuttle`, where a simple `nc -z` style check may incorrectly report closed ports as open because the tunnel accepts the connection and then closes it immediately.

Example:

```bash
./port_checker.sh -t 10.10.10.5 -top100 --hold 0.5
```

```bash
-r <rate>
```

Approximate rate limit in connections per second.

Default:

```text
0
```

`0` means no artificial delay between checks.

Example:

```bash
./port_checker.sh -f targets.txt -top100 -r 20
```

```bash
--open-only
```

Show only open ports. Useful with `-dc` or `-p`.

```bash
./port_checker.sh -t 10.10.10.5 -dc --open-only
```

```bash
-o, --output <dir>
```

Write scan results to files.

The output directory contains:

- one file per target, named after the target
- each target file contains only open ports, one per line
- `result.txt`, containing the full scan output

Example:

```bash
./port_checker.sh -f targets.txt -top100 -o results
```

Example output directory:

```text
results/
  10.10.10.5.txt
  10.10.10.6.txt
  dc01.local.txt
  result.txt
```

Example per-target file:

```text
53
88
445
3389
```

```bash
-h, --help
```

Show the help menu.

```bash
./port_checker.sh --help
```

## Output

Interactive output uses this format:

```text
Target: 10.10.10.5
------------------------------------------------
PORT     SERVICE                STATE
----     -------                -----
53       *domain*               open
88       *kerberos-sec*         open
139      netbios-ssn            closed/filtered
445      *microsoft-ds*         open
```

Services marked as `*service*` are considered higher-value from a security testing perspective and are marked only when the port is open.

During scans, progress is displayed on a single updating line:

```text
Scanned 42 out of 100 ports (42%)
```

Pressing `Ctrl+C` stops the scan cleanly.

## Examples

Scan Domain Controller ports on one target:

```bash
./port_checker.sh -t 10.10.10.5 -dc
```

Scan the top 100 TCP ports on multiple targets:

```bash
./port_checker.sh -t 10.10.10.5,10.10.10.6 -top100
```

Scan the top 1000 TCP ports:

```bash
./port_checker.sh -t 10.10.10.5 -top1000
```

Scan all TCP ports:

```bash
./port_checker.sh -t 10.10.10.5 -all -w 1
```

Scan a CIDR range:

```bash
./port_checker.sh -t 192.168.1.1/24 -top100
```

Scan a last-octet range:

```bash
./port_checker.sh -t 192.168.1.1-21 -dc
```

Scan targets from a file and save results:

```bash
./port_checker.sh -f targets.txt -top100 -o results
```

Scan custom ports and show only open results:

```bash
./port_checker.sh -t dc01.local -p 445,3389,5985 --open-only
```

Scan a port range:

```bash
./port_checker.sh -t 10.10.10.5 -p 22-44
```

Scan mixed single ports and ranges:

```bash
./port_checker.sh -t 10.10.10.5 -p 22,80,443,8000-8100
```

Scan with faster timeout and a rate limit:

```bash
./port_checker.sh -f targets.txt -top100 -w 1 -r 20
```

Scan through an `sshuttle` route with a longer hold check:

```bash
./port_checker.sh -t 10.10.10.5 -top100 --hold 0.8
```

## Notes

This tool performs TCP connect checks through `nc`. It identifies services by port number only and does not confirm the actual service or version running on the port.

If you need proxy support, run the whole script externally through your proxy tool:

```bash
proxychains4 ./port_checker.sh -t 10.10.10.5 -top100
```

## Safety

Use this script only on systems and networks you own or are explicitly authorized to test.
