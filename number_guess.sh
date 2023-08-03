#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME

USER_DETAILS=$($PSQL "select user_id, games_played, best_game from users where username = '$USERNAME'";)
if [[ -z $USER_DETAILS ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  ENTER_USER_RESULT=$($PSQL "insert into users(username) values('$USERNAME');")
else
  echo $USER_DETAILS | while IFS="|" read USER_ID GAMES_PLAYED BEST_GAME
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done

fi

echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS