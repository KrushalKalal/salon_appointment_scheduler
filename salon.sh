#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU(){
    if [[ $1 ]]
   then
    echo -e "\n$1"
   fi

   echo -e "\nWelcome to My Salon, how can I help you?"
   SERVICE_LIST=$($PSQL "SELECT * FROM services")
   echo "$SERVICE_LIST" | while read SERVICE_ID NAME
   do
    echo "$SERVICE_ID) $NAME" | sed 's/ |//'
   done

   read SERVICE_ID_SELECTED
   case $SERVICE_ID_SELECTED in
    [1-5]) SERVICES ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
    esac
}

SERVICES(){
   echo -e "\nWhat's your phone number?"
   read CUSTOMER_PHONE
   GET_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
   CUSTOMER_OUTPUT=$(echo $GET_NAME | sed 's/ //g')
   GET_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
   SERVICE_OUTPUT=$(echo $GET_SERVICE| sed 's/ //g')
   if [[ -z $GET_NAME ]]
   then 
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    NAME_OUTPUT=$(echo $CUSTOMER_NAME | sed 's/ //g')
    CUSTOMER_DETAILS=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE_OUTPUT, $NAME_OUTPUT?"
    read SERVICE_TIME
    APPOINTMENT_DETAILs=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($GET_CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_OUTPUT at $SERVICE_TIME, $NAME_OUTPUT."
    else
     GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
     echo -e "\nWhat time would you like your $SERVICE_OUTPUT, $CUSTOMER_OUTPUT?"
     read SERVICE_TIME
     APPOINTMENT_DETAILs=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($GET_CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
     echo -e "\nI have put you down for a $SERVICE_OUTPUT at $SERVICE_TIME, $CUSTOMER_OUTPUT."
   fi
   
}


MAIN_MENU
