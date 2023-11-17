input_file="$1"

if [ $# -ne 1 ]; then
    echo "Input Error: Three Argumets are needed!"
    exit 1
fi


awk '/real/ {
    printf "%s	", $2;  
    count++;        
    if (count % 3 == 0) {
        printf "\n"; 
    }
}' "$input_file"