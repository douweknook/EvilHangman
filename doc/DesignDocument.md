Design Document
================
This document contains the technical design for the Evil Hangman application.

Classes and Public Methods:
================
The <code>MainViewController</code> class contains all gameplay elements. It contains the IBAction method <code>newGame</code>, which resets the gameplay view, taking in changed settings set by the user. This class also contains the methods <code>won</code> and <code>lost</code> which change the view to include a message telling the user he either won or lost.

The <code>FlipsideViewController</code> class contains the settings panel. It contains three IBAction methods: <code>done</code>, <code>sliderWordLengthValueChanged</code> and <code>sliderGuessAmountValueChanged</code>. <code>done</code> takes in the action of a user pressing the 'done' button and returns the user to the gameplay view. It also saves the setting changes for the next game. The other two methods take in the user action of changing the slider's value and return the value to the labels communicating this to the user. The <code>FlipsideViewController</code> class also contains the protocol to make the view flip when the user presses the 'settings' button in the <code>MainViewController</code>.

The <code>Wordlist</code> class contains the list of available words. It has several methods. <code>loadWordList</code> is called to load the property list of words into the wordlist object. <code>maximumWordLengthInList</code>, <code>minimumWordLengthInList</code> and <code>averageWordLengthInList</code> are used to find the longest, shortest and average word length in the list of words respectively. 

Sketches:
================
Below are sketches to give an impression of what the application looks like and how it works.

![alt tag](https://github.com/douweknook/EvilHangman/blob/master/doc/EvilHangmanDesign.jpg)

Frameworks:
================
The only frameworks used will be the frameworks standard included in the Utility Application upon which the Hangman application is build. These are the follwing: Foundation framework, CoreGraphics framework, UIKIT framework and XCTest framework. No additional APIs will be used.

