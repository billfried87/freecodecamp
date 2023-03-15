#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"
#Make random number
RANDOM_NUMBER=$((RANDOM % 1000 + 1))
#Initialize guess count
GUESS_COUNT=0
#read username
echo "Enter your username:"
read USERNAME_INPUT
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME_INPUT'")
BEST_GAME_CHECK=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME_INPUT'")
#USERCHECK=$($PSQL "SELECT username FROM users WHERE username='$USERNAME_INPUT'")
if [[ -z $GAMES_PLAYED || -z $BEST_GAME_CHECK ]] 
then 
  NEW_NAME=$($PSQL "INSERT INTO users(username, games_played) VALUES('$USERNAME_INPUT', 0)")
  echo "Welcome, $USERNAME_INPUT! It looks like this is your first time here."
  GAMES_PLAYED='0'
else
  #GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME_INPUT'")
  #BEST_GAME_CHECK=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME_INPUT'")
  echo "Welcome back, $USERNAME_INPUT! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME_CHECK guesses."
fi
echo "Guess the secret number between 1 and 1000:" 
#echo $RANDOM_NUMBER
read GUESS
while true
do
if [[ ! $GUESS =~ ^[0-9]+$ ]]
then 
  echo "That is not an integer, guess again:"
  #((GUESS_COUNT++))
  read GUESS
  continue
fi
((GUESS_COUNT++))
if [[ "$GUESS" -eq "$RANDOM_NUMBER" ]] 
then
  if [[ -z $BEST_GAME_CHECK || $BEST_GAME_CHECK -gt $GUESS_COUNT ]] 
  then
    NEW_BEST_GAME=$($PSQL "UPDATE users SET best_game = $GUESS_COUNT WHERE username='$USERNAME_INPUT'")
  fi
  NEW_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = (games_played + 1) WHERE username='$USERNAME_INPUT'")
  echo "You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NUMBER. Nice job!"
 exit
fi
if [[ $GUESS -gt $RANDOM_NUMBER ]]
then
echo "It's lower than that, guess again:"
read GUESS
else
echo "It's higher than that, guess again:"
read GUESS
fi
done
