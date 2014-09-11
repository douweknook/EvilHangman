Evil Hangman
===========
In this folder is my implementation of the Evil Hangman assignment of the App Studio  course of the minor programming at the University of Amsterdam.

The Evil Hangman application looks like regular hangman, but the app keeps changing the word the user has to guess. The app starts off with a large list of English words. Each time the user enters a letter, the app checks whether there are more words in its list with the letter than without and then whittles the list down to the largest such subset.
===========
General Features:
- Upon launch, gameplay starts. If the app was backgrounded, gameplay resumes.
- The application is based upon the Utility Application template.
- The frontside consists of a keyboard, a placeholder for the to-be-guessed word, the amount of tries the user has, the letters the user has tried, a new game button and a settings button.
- The backside of the application consist of the settings screen. Here the user can change both the word length and the amount of guesses. These settings are implemented in the next new game.

Interface Features:
- The keyboard takes the input when the user presses return on the keyboard. Input needs to be one alfabetical letter only, case-insensitive.
- Every time the user makes a wrong guess, the amount of tries left goes one down. This is communicated to the user via a progress view object.
- Every time the user enters a letter, this letter is removed from the letters the user can still try. This is communicated through a label which is continuously updated.
- When the user enters a letter that is in the to-be-guessed word, it is shown in the placeholder. A hyphen is replaced with the letter.
- When the user taps the 'new game' button, a new game is started using the word length and amount of guesses input from the settings. The placeholder shows hyphens again and both the letters the user can still guess label and the amount of guesses are reset.
- When the user taps the 'settings' button, the UI flips around and the settings view is loaded.
- The settings view displays a slider for the word length and a slider for the amount of guesses. The position of the slider is communicated through a label.
- The settings view also has two buttons: done and cancel.
- When the user presses 'done', the settings are saved and used when a new game is started.
- When the user presses 'cancel', the app returns to the current game.
- When the user wins (i.e. no hyphens left) the user is presented with a 'you won' screen with at the top the new game and settings buttons.
- When the user loses (i.e. out of tries) the user is presented with a 'you lose' screen with at the top new game and settings buttons.

Algoritmic Features:
- The word length setting is limited to the largest word in the word list, thus reaching from [1, n]
- The app narrows down the list of possible words to the words of the length that is used in the current game.
- When a letter is entered, the app checks for every word whether it contains this letter and on what position in the word. Every position that exists becomes a subset of its own (also for words that contain the same letter twice or more or don't containt the letter). Next the app counts the amount of words in each subset and chooses the largest one.
- If the size of the largest subsets is equal, the algoritm will pseudorandomly pick one of them. 
- When the user wins, the algoritm returns that word to be displayed to the user.
- When the user loses, the algorithm should pick a word from the last subset it used and display that to the user in the 'you lose' screen.





