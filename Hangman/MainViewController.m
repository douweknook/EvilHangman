//
//  MainViewController.m
//  Hangman
//
//  Created by Douwe Knook on 10-09-14.
//
//

#import "MainViewController.h"
#include <stdlib.h>

@interface MainViewController ()

@property (nonatomic, readwrite, strong) NSMutableArray *words;
@property (nonatomic, readwrite, strong) NSMutableArray *guessedLetters;

@end

@implementation MainViewController

#pragma mark - synthesize properties

@synthesize words=_words;
@synthesize guessedLetters=_guessedLetters;

@synthesize placeholderLabel=_placeholderLabel;
@synthesize inputTextField=_inputTextField;
@synthesize guessedLettersLabel=_guessedLettersLabel;
@synthesize guessesLeft=_guessesLeft;
@synthesize labelGuessesLeft=_labelGuessesLeft;
@synthesize explainLabel=_explainLabel;

static bool correct;
static bool win;
static bool lose;
NSNumber *wordLength;
NSNumber *amountOfGuesses;

#pragma  mark - viewDidLoad

- (void)setup
{
    wordLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"];
    amountOfGuesses = [[NSUserDefaults standardUserDefaults] objectForKey:@"guessAmountSetting"];
    _inputTextField.delegate = self;
    _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _inputTextField.hidden = YES;
    [_inputTextField becomeFirstResponder];
    
    win = NO;
    lose = NO;
    
    _explainLabel.text = @"Enter a letter and press return to start playing";
    _explainLabel.textColor = [UIColor blackColor];
    _explainLabel.font = [UIFont systemFontOfSize:15];
    self.view.tintColor = [UIColor colorWithRed:0.0f
                                          green:122.0f/255.0f
                                           blue:1.0f
                                          alpha:1.0f];
    
    // Initialize label (placeholder) with hyphens (length as saved in NSUserDefaults)
    NSString *placeholders = [@"-" stringByPaddingToLength:[wordLength integerValue] withString:@"-" startingAtIndex:0];
    _placeholderLabel.text = placeholders;
    
    // Fill label with guessed letters to all letters 'unguessed'
    _guessedLetters = [[NSMutableArray alloc] init];
    NSArray *alphabet = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    for (NSString *character in alphabet) {
        NSMutableDictionary *letter = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       character, @"letter",
                                       [UIColor blackColor], @"color",
                                       [NSNumber numberWithBool:NO], @"guessed", nil];
        [_guessedLetters addObject:letter];
    }
    _guessedLettersLabel.text = [alphabet componentsJoinedByString:@" "];
    
    //Initialize bar with guesses-left to 100%
    _labelGuessesLeft.text = [NSString stringWithFormat:@"Guesses Left: %@", amountOfGuesses];
    _guessesLeft.progress = 1.0f;
}

-(void)initializeData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    _words = [[NSMutableArray alloc] initWithContentsOfFile:path];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self initializeData];
        NSLog(@"wordLength: %@, amountOfGuesses: %@", wordLength, amountOfGuesses);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - New Game button

- (IBAction)newGame:(id)sender
{
    [self setup];
    [self initializeData];
}

#pragma mark - Textfield

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Limit useable character set to alfabetic characters only
    if (textField == _inputTextField) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    else {
        return YES;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)inputTextField
{
    // Check if input is 1 character en character not entered before.
    NSString *input = [_inputTextField.text uppercaseString];
    if ([_inputTextField.text length] == 1) {
        for (NSDictionary *letter in _guessedLetters) {
            if ([[letter valueForKey:@"letter"] isEqualToString:input]) {
                if ([[letter valueForKey:@"guessed"] isEqualToValue:[NSNumber numberWithBool:YES]]) {
                    _explainLabel.text = @"You cannot enter the same letter twice!\n Try again.";
                    _inputTextField.text = @"";
                    return NO;
                }
                else {
                    [self narrowDownToWordLength];
                    [self equivalenceClasses];
                    [self updateGuessedLettersLabel];
                    _inputTextField.text = @"";
                    if (correct == YES) {
                        _explainLabel.text = @"Correct! Enter another letter.";
                        [self checkForWin];
                        if (win == YES) {
                            [self showWinScreen];
                        }
                    }
                    else {
                        _explainLabel.text = @"Wrong! Try again.";
                        if (lose == YES) {
                            [self showLoseScreen];
                        }
                    }
                    return YES;
                }
            }
        }
    }
    _explainLabel.text = @"You cannot input more than one letter per turn!\n Try again.";
    _inputTextField.text = @"";
    return NO;
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"win: %@", (win) ? @"YES" : @"NO");
    NSLog(@"lose: %@", (lose) ? @"YES" : @"NO");
    if ((win == YES || lose == YES)) {
        [_inputTextField resignFirstResponder];
    }
    else {
        [_inputTextField becomeFirstResponder];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

# pragma mark - Return handle methods

- (void)narrowDownToWordLength {
    // Delete all words longer & shorter than set length from array
    //NSNumber *wordLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"];
    [_words enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *word, NSUInteger index, BOOL *stop) {
        if ([word length] != [wordLength integerValue]) {
            [_words removeObjectAtIndex:index];
        }
    }];
}

- (void)equivalenceClasses {
    // Set variables needed later
    //NSNumber *wordLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"]; // Get wordlength from saved settings
    NSString *input = [_inputTextField.text uppercaseString];    // Set input letter to uppercase unichar for matching
    NSMutableArray *indexSets = [[NSMutableArray alloc] init];
    NSMutableString *placeholders = [_placeholderLabel.text mutableCopy];
    
    // Go over every word and create indexSet of letter appearences in word
    for (NSString *word in _words) {
        NSLog(@"%@", word);
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        for (NSInteger letter = 0; letter < [wordLength integerValue]; letter++) {
            unichar character = [word characterAtIndex:letter];
            if (character == [input characterAtIndex:0]) {
                [indexSet addIndex: letter];
            }
        }
        // Add indexSets to array of indexSets.
        [indexSets addObject:indexSet];
    }
    
    // Find most occurring set in array of sets (most occuring position of letter)
    NSCountedSet *sets = [NSCountedSet setWithArray:indexSets];
    NSMutableArray *occurrences = [NSMutableArray array];
    for (NSIndexSet *set in sets) {
        NSDictionary *setsDictionary = @{@"set":set, @"count":@([sets countForObject:set])};
        [occurrences addObject:setsDictionary];
    }
    // Sort unique indexes by occurence, first index is most occuring.
    NSArray *sortedIndexCount = [occurrences sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]];
    
    NSIndexSet *locations = [sortedIndexCount[0] valueForKey:@"set"];
    
    // If largest indexSet contains any indexes, add a letter to the view
    if ([[sortedIndexCount[0] valueForKey:@"set"] count] != 0 ) {
        for (int j = 0; j < [wordLength integerValue]; j++) {
            if ([locations containsIndex:j]) {
                NSRange range = NSMakeRange(j, 1);
                [placeholders replaceCharactersInRange:range withString:input];
                correct = YES;
            }
        }
    }
    else {
        [self updateGuessesLeft];
        correct = NO;
    }
    // Update label in view
    _placeholderLabel.text = placeholders;
    
    // Remove all impossible words from wordlist for efficiency.
    NSMutableArray *wordsCopy = [_words copy];
    for (NSString *word in wordsCopy) {
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
        for (NSInteger letter = 0; letter < [wordLength integerValue]; letter++) {
            unichar character = [word characterAtIndex:letter];
            if (character == [input characterAtIndex:0]) {
                [indexSet addIndex: letter];
            }
        }
        if ([indexSet isEqualToIndexSet:locations] == NO) {
            [_words removeObject:word];
        }
    }
}

- (void)updateGuessedLettersLabel {
    // Go over the letters of the alphabet (stored in _guessedLetters) and change colors to grey when a letter is guessed
    NSString *input = [_inputTextField.text uppercaseString];
    NSString *labelText = _guessedLettersLabel.text;
    NSDictionary *labelTextAttributes = @{NSForegroundColorAttributeName: _guessedLettersLabel.textColor,
                                          };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:labelText
                                                                                       attributes: labelTextAttributes];
    for (NSMutableDictionary *letter in _guessedLetters) {
        if ([[letter valueForKey:@"letter"] isEqualToString:input]) {
            // Update letter's data
            [letter setValue:[UIColor grayColor] forKey:@"color"];
            [letter setValue:[NSNumber numberWithBool:YES] forKey:@"guessed"];
        }
        // Update UI
        UIColor *letterColor = [letter valueForKey:@"color"];
        NSRange letterTextRange = [labelText rangeOfString:[letter valueForKey:@"letter"]];
        [attributedText setAttributes:@{NSForegroundColorAttributeName:letterColor}
                                range:letterTextRange];
    }
    _guessedLettersLabel.attributedText = attributedText;
}

- (void)updateGuessesLeft {
    // Update guesses left bar. Only do this if letter is wrong!
    //int amountOfGuesses = [[[NSUserDefaults standardUserDefaults] objectForKey:@"guessAmountSetting"] intValue];
    
    // Retreive number of guesses left from labelGuessesLeft
    NSString *labelTextGuessesLeft = _labelGuessesLeft.text;
    NSMutableCharacterSet *nonNumberCharacterSet = [NSMutableCharacterSet decimalDigitCharacterSet];
    [nonNumberCharacterSet invert];
    NSString *filtered = [[labelTextGuessesLeft componentsSeparatedByCharactersInSet:nonNumberCharacterSet] componentsJoinedByString:@""];
    
    int amountOfGuessesLeft = [filtered intValue] - 1;
    int guessesLeft = _guessesLeft.progress * 100;
    int downPerGuess = 100 / [amountOfGuesses intValue];
    guessesLeft = (guessesLeft - downPerGuess);
    
    // Update both Progressview and Label
    [_guessesLeft setProgress:((float)guessesLeft / 100) animated:YES];
    _labelGuessesLeft.text = [NSString stringWithFormat:@"Guesses Left: %d", amountOfGuessesLeft];
    
    // If user is out of guesses, game lost
    if (guessesLeft < downPerGuess) {
        [_guessesLeft setProgress:0.0f animated:YES];
        lose = YES;
    }
}

- (void)checkForWin {
    NSString *placeholder = _placeholderLabel.text;
    if ([placeholder rangeOfString:@"-" ].location == NSNotFound) {
        win = YES;
    }
}

- (void)showWinScreen {
    _explainLabel.text = @"Congratulations, you win!";
    _explainLabel.font = [UIFont systemFontOfSize:20];
    UIColor *winGreen = [UIColor colorWithRed:0.0f
                                        green:180.0f/255.0f
                                         blue:0.0f
                                        alpha:1.0f];
    _explainLabel.textColor = winGreen;
    self.view.tintColor = winGreen;
    [_inputTextField resignFirstResponder];
}

- (void)showLoseScreen {
    _explainLabel.text = @"Oh no, you lost!\n The word was:";
    _explainLabel.font = [UIFont systemFontOfSize:20];
    _explainLabel.textColor = [UIColor redColor];
    self.view.tintColor = [UIColor redColor];
    
    // Pick random word from words left in wordlist
    int lastIndex = [_words count] - 1;
    int randomNumber = arc4random_uniform(lastIndex);
    _placeholderLabel.text = [_words objectAtIndex:randomNumber];
    [_inputTextField resignFirstResponder];
}

@end
