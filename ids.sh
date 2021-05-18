
# Declarar las variables del bot para que te avise telegram
TOKEN="1795143091:AAF9D5UHBNS6MnILWV3WBn0t8X869eINsCI"
ID="900674370"

# Escribe la IP de tu red
RED="192.168.1.1/24"

	# Archivo en el que apuntaremos las direcciones MAC conocidas (white list).
	white_list=$(cat /home/pablopc/asir/Proyecto/scripts/IDS/white_list.txt | grep "MAC_Addres" | cut -c 13-30)

	# Contiene las direcciones MAC de los equipos conectados en tu red.
	connected_host_list=$(sudo nmap -sP $RED | grep "MAC Address" | awk '{print $3}')


# Verifica si el host existe en nuestra lista blanca
match=0
for connected_host in ${connected_host_list[@]}
do
		for known_host in ${white_list[@]}
		do
			if [ $connected_host == $known_host ]
 				then
					match=1
				break
			fi
		done

	if [ $match == 1 ]
	then
		echo "$connected_host es conocida..."

	else
		# Envia una alarma a nuestro telegram
		MESSAGE="Creo que he visto un intruso en tu red, su MAC es: $connected_host "
		URL="https://api.telegram.org/bot$TOKEN/sendMessage"

		curl -s -X POST $URL -d chat_id=$ID -d text="$MESSAGE"
		echo -e "\n Te hemos notificado a tu Telegram"
	fi
	match=0
done

