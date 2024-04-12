
#!/bin/bash    
clear      

# my file data
fn="baza_stud.csv"
re='^[0-9]+$'
rn='^[a-zA-Z[:space:]]+$'

##########
if ! [ -f $fn ] ; then
  echo "ID,nume,notaSO,email" >> $fn
fi


function pause(){
 read -s -n 1 -p "Press any key to continue . . ."
  echo ""
}

# define functions
function max_id {
	local maxid
	maxid=0
	while IFS="," read -r val1 val2 val3 val4 #IFS = internal field separator
	do
	  if [[ $val1 =~ $re ]] ; then
		{
		 if [ $val1 -gt $maxid ]; then
			{
			  let maxid=$(($val1 + 0))
			}
		  fi
		}
		fi
 	done < <(tail -n +1 $fn) #getting rid of header, if any

	return  $maxid
}
function adaugare {

	while true; do
	  echo "Introduceti :"
	  # Nume
	  read -p "Nume : " Nume
	c=${#Nume}
  
		  if [ $c -le 3 ]
			then
				echo "Numele trebuie sa contina mai mult de 3 caractere ..."
				break
		  fi
	  #if ! [[ "Nume" =~ /^[a-z , . ' -]+$/i]]
	   if ! [[ $Nume =~ $rn ]]
	  then
	     echo "Nu este nume..."
			break
	  fi
	  # Nota
	  read -p "Nota : " Nota
	  
	  #if ! [[ "$Nota" =~ ^[0-9]+$ ]]
	  if ! [[ $Nota =~ $re ]] 
        then
            echo "Nu este intreg..."
			break
	  fi
	  
	  if ! [ $Nota -le 10 ] 
        then
            echo "Nota nu poate fi mai mare de 10..."
			break
	  fi
	  # Email
	  read -p "Email : " Email
		regex="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))\.)*([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,4}$"

		if ! [[ $Email =~ $regex ]] ; then
			echo "Introduceti un email valid..."
			break
		fi  
	  
	  
	  echo
	  read -p "Salvati ? (y/n) " yn
	
		case $yn in 
			[yY] ) {
			
				max_id 
				 
				COL1=$(($? + 1))
				COL2=$Nume
				COL3=$Nota
				COL4=$Email

				if [ -f $fn ]
				then
				   echo "$COL1,$COL2,$COL3,$COL4" >> $fn
				else
				   echo "File \"$fn\" not found "
				   exit 0
				fi
				
			########
				echo Adagare cu SUCCES..
				break
				}
			;;
			
				
			[nN] ) echo Renuntare...;
				break;;
			* ) echo Raspuns invalid;;
		esac

	done

 
  return 55
}

function modificare {

	while true; do

	  read -p "Introduceti id-ul inregistrarii de modificat : " idmod
	  if ! [[ $idmod =~ $re ]] 
        then
            echo "Nu este intreg..."
			break
	  fi
	  
	  max_id
	  idmax=$?
	  if ! [ $idmod -le $idmax ] 
        then
            echo "Id-ul de modificat nu poate fi mai mare decat id-ul maxim ($idmax)..."
			break
	  fi
		
		while IFS="," read -r val1 val2 val3 val4 #IFS = internal field separator
		do
			let val1=$(($val1 + 0))
			if [ $val1 -eq $idmod ] ;then
			{
			  break
			}
			fi
		done < $fn
		
		 oldval="$val1,$val2,${val3},${val4}"
		  xid=$(($idmod + 1))
		  echo
		  awk 'NR==1 || NR=='$xid' ' $fn
		  echo

		  ## Modificare
		#while true; do
		  echo "Introduceti :"
		  # Nume
		  read -p "Nume : " Nume
		  n=${#Nume}
  
		  if [ $n -le 3 ]
			then
				echo "Nu ati introdus numele ..."
				break
		  fi
		  
		  # Nota
		  read -p "Nota : " Nota
	
		  if ! [[ $Nota =~ $re ]] 
			then
				echo "Nu este intreg..."
				break
		  fi
		  
		  if ! [ $Nota -le 10 ] 
			then
				echo "Nota nu poate fi mai mare de 10..."
				break
		  fi
		  # Email
		  read -p "Email : " Email
			regex="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))\.)*([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,4}$"
			if ! [[ $Email =~ $regex ]] ; then
				echo "Introduceti un email valid..."
				break
			fi  
		  
		  
			echo
		    read -p "Modificati ? (y/n) " yn
		
			case $yn in 
				[yY] )
					{
					newval="$val1,$Nume,${Nota},${Email}"
					#echo $newval
					if [ -f $fn ]
					then
					   sed -i "s/$oldval/$newval/g" $fn
					else
					   echo "File \"$fn\" not found "
					   exit 
					fi
					
					echo MODIFICARE cu SUCCES..
					
					}
				;;
				[nN] ) echo Renuntare...;
					break;;
				* ) echo Raspuns invalid;;
			esac

		#done	  
		  

	done
 
  return 55
}


function stergere {
    read -p "Introduceți ID-ul înregistrării de șters: " idsterge
    if [[ $idsterge =~ $re ]]; then
        if [ -f $fn ]; then
            awk -F"," -v idsterge="$idsterge" '$1 == idsterge {print "ID:", $1, "Nume:", $2, "Nota:", $3, "Email:", $4}' $fn
            read -p "Sigur doriți să ștergeți această înregistrare? (y/n): " ynn
            case $ynn in 
                [yY] )
                    sed -i "/^$idsterge,/d" $fn
                    sed -i '/^[[:space:]]*$/d' $fn

                    # Rearanjarea ID-urilor după ștergere
                    awk -F"," -v OFS="," 'NR>1 {$1=NR-1} 1' $fn > temp.csv && mv temp.csv $fn

                    echo "Ștergere cu SUCCES."
                    ;;
                [nN] ) echo Renuntare...;
                    ;;
                * ) echo Raspuns invalid;;
            esac
        else
            echo "Fișierul \"$fn\" nu a fost găsit."
            exit 0
        fi
    else
        echo "ID-ul introdus nu este valid."
    fi
}




function sortare {
  echo 
  sort -t',' -k3,3nr $fn
}

opt=0
while [ $opt -lt 9 ]
do
  echo
  echo " 1. View 2. Adaugare 3. Modificare 4. Stergere 5. Sortare 9.Terminare "	
	typeset -i opt
	
	read -s -n 1 -p 'Introduceti optiunea dvs.: ' opt
	
	[[ "$opt" == 0 ]] && echo "introduceti un nr. din meniu"
	clear
	echo 
	case "$opt" in 
	"1") 
	{
		echo "VIZUALIZARE LISTA"
		awk -F"\t" '{print " "$1" "$2" "$3" "$4" "}' $fn
		echo ""
		read -s -n 1 -p "Sfarsit - apasati o tasta pentru continuare ..."
		
		clear	
	
	}

	;;
	"2") 
	{
		echo "ADAUGARE "
		adaugare
		read -s -n 1 -p "Sfarsit - apasati o tasta pentru continuare ..."
		clear

	}
	;;
	 "3") 
	 {
		 echo "MODIFICARE"
		 modificare
		 echo ""
			read -s -n 1 -p "Sfarsit - apasati o tasta pentru continuare ..."
		 clear
	 }
	 ;;
	"4") 
	{
		echo "STERGERE"
		stergere
		echo ""
			read -s -n 1 -p "Sfarsit - apasati o tasta pentru continuare ..."
		 clear
	}
	;;
      "5") 
      {
            echo "SORTARE"
    sorted_data=$(sortare)
    echo "$sorted_data" | awk -F"," '{print " "$1" "$2" "$3" "$4" "}'
    read -s -n 1 -p "Sfarsit - apasati o tasta pentru continuare ..."
    clear
       }
      ;;		
	"9") 
	{
		echo "Multumesc pentru utilizarea programului meu !"
	}
	;;
	esac

done


exit 

