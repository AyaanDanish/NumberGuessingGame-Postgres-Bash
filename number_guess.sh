#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUM=$(( RANDOM % 1000 ))
echo $RANDOM_NUM

echo -e -n "\nEnter your username: "
read USERNAME

USER_DETAILS=$($PSQL "select user_id, games_played, best_game from users where username = '$USERNAME'";)
if [[ -z $USER_DETAILS ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  ENTER_USER_RESULT=$($PSQL "insert into users(username) values('$USERNAME');")
else
  echo $USER_DETAILS | while IFS="|" read USER_ID GAMES_PLAYED BEST_GAME
  do
    echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

GUESS_COUNT=0

echo -e -n "\nGuess the secret number between 1 and 1000: "
while [[ $GUESS != $RANDOM_NUM ]]
do
  read GUESS
  until [[ $GUESS =~ ^[0-9]+$ ]]
  do
    echo -e -n "\nThat is not an integer, guess again: "
    read GUESS
  done

  if [[ $GUESS > $RANDOM_NUM ]]
  then
    echo -e -n "\nIt's lower than that, guess again:"
  elif [[ $GUESS < $RANDOM_NUM ]]
  then
     echo -e -n "\nIt's higher than that, guess again:"
  fi
done

echo "right!"