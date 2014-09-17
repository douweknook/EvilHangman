Design Document
================
This document contains the technical design for the Evil Hangman application.

Classes and Public Methods:
================
The <code>MainViewController</code> class contains all gameplay elements. It contains the IBAction method <code>newGame</code>, which resets the gameplay view, taking in changed settings set by the user.

The <code>FlipsideViewController</code> class contains the settings panel. It contains three IBAction methods: <code>done</code>, <code>sliderWordLengthValueChanged</code> and <code>sliderGuessAmountValueChanged</code>. <code>done</code> takes in the action of a user pressing the 'done' button and returns the user to the gameplay view. It also saves the setting changes for the next game. The other two methods take in the user action of changing the slider's value and return the value to the labels communicating this to the user.

The <code>Wordlist</code> class contains the list of available words. It has several methods. <code>loadWordList</code> is called to load the property list of words into the wordlist object. <code>maximumWordLengthInList</code>, <code>minimumWordLengthInList</code> and <code>averageWordLengthInList</code> are used to find the longest, shortest and average word length in the list of words respectively. 
