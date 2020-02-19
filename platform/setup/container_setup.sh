#!/bin/bash
#
# create all group containers(ssh, routers, hosts, switches)

set -o errexit
set -o pipefail
set -o nounset

DIRECTORY="$1"
source "${DIRECTORY}"/config/subnet_config.sh

# read configs
readarray groups < "${DIRECTORY}"/config/AS_config.txt
readarray l2_switches < "${DIRECTORY}"/config/layer2_switches_config.txt
readarray l2_hosts < "${DIRECTORY}"/config/layer2_hosts_config.txt

group_numbers=${#groups[@]}
n_l2_switches=${#l2_switches[@]}
n_l2_hosts=${#l2_hosts[@]}

#create all container
for ((k=0;k<group_numbers;k++)); do
    group_k=(${groups[$k]})
    group_number="${group_k[0]}"
    group_as="${group_k[1]}"
    group_config="${group_k[2]}"
    group_router_config="${group_k[3]}"

    readarray routers < "${DIRECTORY}"/config/$group_router_config
    n_routers=${#routers[@]}

    echo "creating containers for group: ""${group_number}"

    if [ "${group_as}" != "IXP" ];then

        location="${DIRECTORY}"/groups/g"${group_number}"
        subnet_dns="$(subnet_router_DNS "${group_number}" "dns")"

        # start ssh container
        docker run -itd --net='none'  --name="${group_number}""_ssh" \
          -v "${location}"/goto.sh:/root/goto.sh --privileged \
          --cpus=1 --pids-limit 100 --hostname="g${group_number}-proxy" thomahol/d_ssh

    	# start switches
    	for ((l=0;l<n_l2_switches;l++)); do

            switch_l=(${l2_switches[$l]})
            l2name="${switch_l[0]}"
            sname="${switch_l[1]}"

            docker run -itd --net='none' --dns="${subnet_dns%/*}" --privileged \
                --cpus=1 --pids-limit 100 --hostname "${sname}" \
                --name=${group_number}_L2_${l2name}_${sname} thomahol/d_switch
        done

        # start hosts in l2 network
        for ((l=0;l<n_l2_hosts;l++)); do
            host_l=(${l2_hosts[$l]})
            hname="${host_l[0]}"
            l2name="${host_l[1]}"
            sname="${host_l[2]}"

            if [[ $hname != vpn* ]]; then
                docker run -itd --net='none' --dns="${subnet_dns%/*}" --privileged \
                    --cpus=1 --pids-limit 100 --hostname "${hname}" \
                    --name="${group_number}""_L2_""${l2name}""_""${hname}" thomahol/d_host
            fi
        done

        # start routers and hosts
        for ((i=0;i<n_routers;i++)); do
            router_i=(${routers[$i]})
            rname="${router_i[0]}"
            property1="${router_i[1]}"
            property2="${router_i[2]}"

            location="${DIRECTORY}"/groups/g"${group_number}"/"${rname}"

            # start router
            docker run -itd --net='none'  --dns="${subnet_dns%/*}" \
                --name="${group_number}""_""${rname}""router" --privileged \
                --cpus=1 --pids-limit 100 --hostname "${rname}""_router" \
                -v "${location}"/looking_glass.txt:/home/looking_glass.txt \
                -v "${location}"/daemons:/etc/frr/daemons \
                -v "${location}"/frr.conf:/etc/frr/frr.conf thomahol/d_router

            # start host
            if [ "${property2}" == "host" ];then
                docker run -itd --net='none' --dns="${subnet_dns%/*}"  \
                    --name="${group_number}""_""${rname}""host" --privileged \
                    --cpus=1 --pids-limit 100 --hostname "${rname}""_host" thomahol/d_host \
                    # -v "${location}"/connectivity.txt:/home/connectivity.txt \
                    # add this for bgpsimple -v ${DIRECTORY}/docker_images/host/bgpsimple.pl:/home/bgpsimple.pl \

            fi
        done

    elif [ "${group_as}" = "IXP" ];then

        location="${DIRECTORY}"/groups/g"${group_number}"
        docker run -itd --net='none' --name="${group_number}""_IXP" \
            --pids-limit 100 --hostname "${group_number}""_IXP" \
            -v "${location}"/daemons:/etc/quagga/daemons \
            --privileged thomahol/d_ixp

    fi

done
