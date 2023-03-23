#!/bin/bash

# Define target URL
read -p "Insert Target URL: " target
printf "\n"

# Create Directories 
mkdir -p "Recon Result" "Recon Result/"$target
mkdir -p "Recon Result/$target/Passive Information Gathering"
mkdir -p "Recon Result/$target/Passive Information Gathering/WHOIS Lookup"
mkdir -p "Recon Result/$target/Passive Information Gathering/NSLookup"
mkdir -p "Recon Result/$target/Passive Information Gathering/Subdomains"
mkdir -p "Recon Result/$target/Passive Information Gathering/Directories"

mkdir -p "Recon Result/$target/Active Information Gathering"

echo -e "\033[33mRUNNING PASSIVE INFORMATION GATHERING\033[m"

# Running WHOIS Lookup
printf "\n-- Performing WHOIS Lookup --\n\n"
echo -e "\033[3m(This will perform WHOIS lookup to obtain informations about the target's domain)\033[m"
printf "\n"
whois $target > "Recon Result/$target/Passive Information Gathering/WHOIS Lookup/WHOIS.txt"
echo -e "\033[36mWHOIS lookup completed!\033[m"
printf "\n"

# Running NSLookup
printf "\n-- Performing NSLookup --\n\n"
echo -e "\033[3m(This will perform nslookup to obtain informations about the target's DNS records)\033[m"
printf "\n"
nslookup $target > "Recon Result/$target/Passive Information Gathering/NSLookup/nslookup.txt"
echo -e "\033[36mNSLookup completed!\033[m"
printf "\n"

# Enumerating Subdomains
printf "\n-- Enumerating Subdomains with AMASS --\n\n"
echo -e "\033[3m(This will perform subdomain enumeration to get target's subdomains)\033[m"
printf "\n"
mkdir -p "Recon Result/$target/Passive Information Gathering/Subdomains"
amass enum -passive -d "$target" -oA "Recon Result/$target/Passive Information Gathering/subdomains.txt"
echo -e "\033[36mSubdomain Enumeration completed!\033[m"
printf "\n"

# Run Directory Fuzzing using FFUF
printf "\n-- Performing Directory Enumeration using FFUF --\n\n"
echo -e "\033[3m(This will perform directory enumeration to find sensitive files and other juicy endpoints)\033[m"
printf "\n"
ffuf -c -r -mc 200,403 -u https://$target/FUZZ -w /data/Pentesting/Wordlist\ for\ fuzzing/OneListForAll/onelistforallshort.txt -of csv -o "Recon Result/$target/Passive Information Gathering/Directories/Directory Enumeration.csv"
echo -e "\033[36mDirectory Enumeration completed!\033[m"
printf "\n\n"

echo -e "\033[31mRUNNING ACTIVE INFORMATION GATHERING\033[m"

# Check for Website's Technology
printf "\n-- Checking Target Website's Technologies with WhatWeb--\n\n"
echo -e "\033[3m(This will discover what are the technologies that the target is using)\033[m"
printf "\n"
mkdir -p "Recon Result/$target/Active Information Gathering/Website Technologies"
whatweb -v $target --log-verbose="Recon Result/$target/Active Information Gathering/Website Technologies/Website Technologies.txt" --log-xml="Recon Result/$target/Active Information Gathering/Website Technologies/Website Technologies.xml" --log-json="Recon Result/$target/Active Information Gathering/Website Technologies/Website Technologies.json"
echo -e "\033[36mTarget technology discovery completed!\033[m"
printf "\n"

# Run port scanning using NMAP
printf "\n-- Running NMAP Port Scan --\n\n"
echo -e "\033[3m(This will scan for target's open ports)\033[m"
printf "\n"
mkdir -p "Recon Result/$target/Active Information Gathering/NMAP Scan Results"
nmap -sS -O -sV -sC -f -v --badsum -Pn -T4 -p- $target -oA "Recon Result/$target/Active Information Gathering/NMAP Scan Results/"
printf "\n"
echo -e "\033[36mNMAP Scanning completed!\033[m"

# Run vulnerability scanning with Nikto
printf "\n-- Running vulnerability scan with Nikto --\n\n"
echo -e "\033[3m(This will scan for possible vulnerabilites that can be exploited)\033[m"
printf "\n"
mkdir -p "Recon Result/$target/Active Information Gathering/NIKTO Results/"
nikto -host $target -output "Recon Result/$target/Active Information Gathering/NIKTO Results/nikto.csv" -Format csv
printf "\n"
echo -e "\033[36mVulnerability Scanning completed!\033[m"

printf "\n"
echo -e "\033[32mInformation Gathering is done! You can check the results in Recon Result directory.\033[m"
printf "\n"
