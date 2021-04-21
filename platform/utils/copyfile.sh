#!/bin/bash

routers=("BOST" "NEWY" "ATLA" "MIAM" "PARI" "LOND" )
as=(3 4 5 6 7 8 9 10 23 24 25 26 27 28 29 30 43 44 45 46 47 48 49 50 63 64 65 66 67 68 69 70 83 84 85 86 87 88 89 90 103 104 105 106 107 108 109 110 123 124 125 126 127 128 129 130 143 144 145 146 147 148 149 150 163 164 165 166 167 168 169 170 183 184 185 186 187 188 189 190)
tier1routers=("LOND")
tier1stubs=(1 2 11 12 21 22 31 32 41 41 51 52 61 62 71 72 81 82 91 92 101 102 111 112 121 122 131 132 141 142 151 152 161 162 171 172 181 182 191 192)

for i in "${as[@]}"
do
	for j in "${routers[@]}"
	do
		echo "Sending to AS ${i} router ${j}" 
		sudo docker cp .bashrc ${i}_${j}host:/root/
	done
done

for i in "${tier1stubs[@]}"
do
	sudo docker cp .bashrc ${i}_LONDhost:/root/
done
