#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUM=$(( RANDOM % 1000 ))
echo $RANDOM_NUM

echo -e -n "\nEnter your username: "
read USERNAME

USER_DETAILS=$($PSQL "select user_id, games_played, best_game from users where username = '$USERNAME'";)
if [[ -z $USER_DETAILS ]]
then
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
  ENTER_USER_RESULT=$($PSQL "insert into users(username) values('$USERNAME');")
else
  IFS='|' read -r USER_ID GAMES_PLAYED BEST_GAME <<< "$USER_DETAILS"
  echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
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
    echo -e -n "\nIt's lower than that, guess again: "
  elif [[ $GUESS < $RANDOM_NUM ]]
  then
     echo -e -n "\nIt's higher than that, guess again: "
  fi

  (( GUESS_COUNT++ ))
done

echo -e "\nYou guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NUM. Nice job!"

if [[ $GUESS_COUNT < $BEST_GAME ]]
then
  echo "You did better!"
  BEST_GAME=$GUESS_COUNT
fi

UPDATE_GAMES_PLAYED=$($PSQL "update users set games_played = games_played + 1;")
UPDATE_BEST_GUESS=$($PSQL "update users set best_game = $BEST_GAME;")