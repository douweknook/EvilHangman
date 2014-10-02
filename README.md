Evil Hangman
===========
In this folder is my implementation of the Evil Hangman assignment of the App Studio  course of the minor programming at the University of Amsterdam.


Features:
===========
The Evil Hangman application looks like regular hangman, but the app cheats by continuously changing the word the user has to guess. The app starts off with a large list of English words. Each time the user enters a letter, the app checks whether there are more words in its list with this letter (and at which location in the word) than without and then whittles the list down to the largest such subset.
Other options include for the user to change the word length and amount of guesses used in the game. The app uses a word list of over 140.000 English words.

Views
===========
The application is devided in several views. Upon luanch the gameplay starts so the user is presented with the 'game view'. This consists of a keyboard for user input, a set of placeholders for the letters to be guessed and some additional data such as letters already guessed and guesses left. Atop the screen is a navigation var which offers two options: new game and settings. The new game button resets the game play view and updates it with the current settings.

The settings screen consists of two sliders. The first one lets the user change the amount of letters the word should consists of. The slider ranges from the amount of letters of the shortest word in the wordlist to the longest. The second slider is used to set the amount of guesses and ranges from 1 to 26.

When the game is finished one of two screens is shown. (1) The user has won (guessed the word) and is presented with a screen displaying a congratulaions message. (2) The user has lost (has run our of guesses) and is presented with a screen displaying the word and a textual message that he/she has lost.

Wireframes:
===========
These wireframes represent the different views of the application.

![alt tag](https://github.com/douweknook/EvilHangman/blob/master/doc/EvilHangmanWireframes.jpg)

Design:
===========
The design is described in detail in the design document located in the doc/ directory.

Algoritm
===========
First the algorithm has to resize the wordlist to only contain words of the length the user has specified in his/her settings. Next, it checks if the letter the user has entered is indeed in the word. However, the algorithm allows the game to cheat and tries to dodge the user's guesses.

When a letter is entered, the app checks for every word in the wordlist whether it contains this letter and on what position in the word. Every position that exists becomes a subset of its own (also for words that contain the same letter twice or more or don't containt the letter). Next the app counts the amount of words in each subset and chooses the largest one. If the size of the largest subsets is equal, the algoritm will pseudorandomly pick one of them. 

When the user wins, the algoritm returns that word to be displayed to the user. When the user loses, the algorithm should pick a word from the last subset it used and display that to the user in the 'you lose' screen.
