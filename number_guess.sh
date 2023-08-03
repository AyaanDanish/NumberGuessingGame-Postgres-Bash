#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME

USERNAME_GET_RESULT=$($PSQL "select user_id, games_played, best_game from users where username = '$USERNAME'";)
echo $USER_NAME_GET_RESULT