stub_ixp = {
        13: 86,
        28: 86,
        27: 87,
        42: 87, 
        41: 88,
        56: 88,
        55: 89,
        70: 89,
        69: 90,
        84: 90,
        83: 91,
        14: 91,
    }

tier1 = [[1, 2], [15, 16], [29, 30], [43, 44], [57, 58], [71, 72]]
transit = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28],
           [29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42], [43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56],
           [57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70], [71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]]


template = '''#!/bin/bash

vtysh  -c 'conf t' \\
-c 'route-map IXP_OUT_{ixp} permit 10' \\
-c 'set community {set_community_str}' \\
-c 'match ip address prefix-list OWN_PREFIX' \\
-c 'exit' \\
-c 'route-map IXP_OUT_{ixp} permit 20' \\
-c 'set community {set_community_str}' \\
-c 'match community 1' \\
-c 'exit' \\
-c 'exit' -c 'write'
'''

if __name__ == "__main__":
    for pod_index in range(len(transit)):
        for stub in transit[pod_index][-2:]:
            connects_to = []
            
            for asn in transit[pod_index]:
                if asn not in tier1[pod_index] and asn % 2 == stub % 2 and asn != stub:
                    connects_to.append(asn)
            
            next_pod = 0
            if stub % 2 == 1:
                next_pod = pod_index + 1
                next_pod = 0 if next_pod >= len(transit) else next_pod
            else:
                next_pod = pod_index - 1
                next_pod = len(transit) - 1 if next_pod < 0 else next_pod
            connects_to.extend(transit[next_pod])

            ixp = stub_ixp[stub]

            set_community_str = ''
            for asn in connects_to:
                set_community_str += f'{ixp}:{asn} '

            with open(f'./{stub}_ZURIrouter.sh', 'w+') as f:
                print(template.format(ixp=ixp, set_community_str=set_community_str), file=f)
