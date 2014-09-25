//
//  MainViewController.m
//  Hangman
//
//  Created by Douwe Knook on 10-09-14.
//
//

#import "MainViewController.h"

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


#pragma  mark - viewDidLoad

- (void)setup {
    _inputTextField.delegate = self;    // Set delegate to self
    _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;    // Turn autocorrect off
    //_inputTextField.hidden = YES; // Hide textfield
    [_inputTextField becomeFirstResponder]; // Set textfield to firstresponder to show keyboard
    
    // Initialize label (placeholder) with hyphens (length as saved in NSUserDefaults)
    NSNumber *hyphens = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"];
    NSString *placeholders = [@"-" stringByPaddingToLength:[hyphens integerValue] withString:@"-" startingAtIndex:0];
    _placeholderLabel.text = placeholders;
    
    // Fill label with guessed letters to all letter 'unguessed'
    _guessedLettersLabel.text = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    _guessedLetters = [[NSMutableArray alloc] init]; // Initialize array to keep track of guessed letters
    
    //Initialize bar with guesses-left to 100%
    _guessesLeft.progress = 1.0;
    
}

-(void)initializeData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    _words = [[NSMutableArray alloc] initWithContentsOfFile:path];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    [self initializeData];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - New Game button

- (IBAction)newGame:(id)sender {
    [self setup];
    [self initializeData];
}

#pragma mark - Textfield

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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

- (BOOL)textFieldShouldReturn:(UITextField *)inputTextField {
    if ([_inputTextField.text length] > 0 && [_inputTextField.text length] < 2) {
        [self narrowDownToWordLength];
        [self equivalenceClasses];
        
        // Update guesses letters label
        NSString *input = [_inputTextField.text uppercaseString];
        
        /*
         Dit werkt nog niet volledig. De grijze letter wordt weer zwart bij invoer volgende letter.
         Misschien NSdictionary creeren met alle letters + key voor hun kleur value.
         Als key = grijs, maak letter grijs.
         */
        
        [_guessedLetters addObject:input];
        NSLog(@"%@", _guessedLetters);
        NSString *labelLetters = _guessedLettersLabel.text;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:labelLetters];
        for (int i = 0; i < [labelLetters length]; i++) {
            for (NSString *letter in _guessedLetters) {
                NSLog(@"HIER1");
                if ([labelLetters characterAtIndex:i] == [letter characterAtIndex:0]) {
                    NSLog(@"HIER2");
                    [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1]}
                                            range:[labelLetters rangeOfString:input]];
                }
            }
        }
        _guessedLettersLabel.attributedText = attributedText;
        
        //TODO: send returnvalue to algorithm.
        //TODO: clear textfield
        
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    NSNumber *wordLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"];
    [_words enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *word, NSUInteger index, BOOL *stop) {
        if ([word length] != [wordLength integerValue]) {
            [_words removeObjectAtIndex:index];
        }
    }];
}

- (void)equivalenceClasses {
    //Create all possible equivalence classes
    NSNumber *wordLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"]; // Get wordlength from saved settings
    NSString *input = [_inputTextField.text uppercaseString];    // Set input letter to uppercase unichar for matching
    
    NSMutableArray *indexSets = [[NSMutableArray alloc] init];
    
    NSMutableString *placeholders = [_placeholderLabel.text mutableCopy];
    
    /* Create indexSet of filled-in letterlocations to see if location is still available
    NSMutableIndexSet *filledLocations = [[NSMutableIndexSet alloc] init];
    for (int h = 0; h < placeholders.length; h++) {
        if ([placeholders characterAtIndex:h] != '-') {
            [filledLocations addIndex:h];
        }
    }*/
    
    for (NSString *word in _words) {    // Go over each word in the wordlist
        NSLog(@"%@", word);
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init]; // Allocate and initialize new indexset
        for (NSInteger letter = 0; letter < [wordLength integerValue]; letter++) {  // Go over each letter in the word
            unichar character = [word characterAtIndex:letter]; // Set current letter in word to a unichar for matching
            if (character == [input characterAtIndex:0]) {   // Check if letter is equal to input
                [indexSet addIndex: letter];    // Add the index of the matching letter to the indexset
            }
        }
        //NSLog(@"%@", indexSet);
        [indexSets addObject:indexSet]; // Add indexset to array of indexsets
    }
    
    // Find most occurring sets in array of sets
    NSCountedSet *sets = [NSCountedSet setWithArray:indexSets]; // Convert array of indices to countedSet
    NSMutableArray *occurrences = [NSMutableArray array];   // Create array to keep track of occurences of particular indexSet
    for (NSIndexSet *set in sets) {     // Loop over all indexsets and count how many each occurs
        NSDictionary *setsDictionary = @{@"set":set, @"count":@([sets countForObject:set])};
        [occurrences addObject:setsDictionary];
    }
    NSArray *sortedIndexCount = [occurrences sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]];   // Sort the index counts in descending order (highest at index 0)
    
    NSIndexSet *locations = [sortedIndexCount[0] valueForKey:@"set"];   // Put indexes back in NSIndexSet object.
    
    // If largest indexSet contains indexes, add letter to view
    if ([[sortedIndexCount[0] valueForKey:@"set"] count] != 0 ) {
        NSLog(@"bevat index, letter toevoegen, woorden zonder deze index verwijderen");
        // Update placeholders label
        for (int j = 0; j < [wordLength integerValue]; j++) {
            if ([locations containsIndex:j]) {      // If location exists in indexSet, replace character at this locaton with input
                NSRange range = NSMakeRange(j, 1);
                [placeholders replaceCharactersInRange:range withString:input];
            }
        }
    }
    _placeholderLabel.text = placeholders;  // Update label in view
    
    NSMutableArray *wordsCopy = [_words copy];  // Create copy of words array to enable deleting objects during enumeration
    for (NSString *word in wordsCopy) {    // Go over each word in the wordlist
        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init]; // Allocate and initialize new indexset
        for (NSInteger letter = 0; letter < [wordLength integerValue]; letter++) {  // Go over each letter in the word
            unichar character = [word characterAtIndex:letter]; // Set current letter in word to a unichar for matching
            if (character == [input characterAtIndex:0]) {   // Check if letter is equal to input
                [indexSet addIndex: letter];    // Add the index of the matching letter to the indexset
            }
        }
        if ([indexSet isEqualToIndexSet:locations] == NO) {
            [_words removeObject:word];
        }
    }

        // check if letter is at this index of word (done)
        // if yes: add index to indexset (done)
        // keep index sets in one array (each indexset is a equivalance class)
        // check amount of indexes in each indexsets, pick largest
        // select words at indexset, delete all others
}

@end
