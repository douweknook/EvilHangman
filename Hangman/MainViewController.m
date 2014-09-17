//
//  MainViewController.m
//  Hangman
//
//  Created by Douwe Knook on 10-09-14.
//
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - synthesize properties

@synthesize placeholderLabel=_placeholderLabel;
@synthesize inputTextField=_inputTextField;
@synthesize guessedLettersLabel=_guessedLettersLabel;
@synthesize guessesLeft=_guessesLeft;

#pragma  mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Turn autocorrect of for textfield.
    _inputTextField.delegate = self;
    _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Hide textfield and show keyboard
    //_inputTextField.hidden = YES;
    [_inputTextField becomeFirstResponder];
    
    // Initialize label (placeholder) with hyphens (length as saved in NSUserDefaults)
    NSNumber *hyphens = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"];
    NSString *placeholders = [@"-" stringByPaddingToLength:[hyphens integerValue] withString:@"-" startingAtIndex:0];
    _placeholderLabel.text = placeholders;
    
    // Initialize label with guessed letters to all letter 'unguessed'
    _guessedLettersLabel.text = @"ABCDEFGHIJKLMNOPQRSTUVW";
    
    //Initialize bar with guesses-left to 100%
    _guessesLeft.progress = 1.0;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - New Game button

- (IBAction)newGame:(id)sender {
    _inputTextField.delegate = self;
    _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //_inputTextField.hidden = YES;
    [_inputTextField becomeFirstResponder];
    
    NSNumber *hyphens = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"];
    NSString *placeholders = [@"-" stringByPaddingToLength:[hyphens integerValue] withString:@"-" startingAtIndex:0];
    _placeholderLabel.text = placeholders;
    
    // Initialize label with guessed letters to all letter 'unguessed'
    _guessedLettersLabel.text = @"ABCDEFGHIJKLMNOPQRSTUVW";
    
    //Initialize bar with guesses-left to 100%
    _guessesLeft.progress = 1.0;
    
    // TODO: Create a reset/setup function to be called both here and in viewdidLoad
}

#pragma mark - Textfield

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Limit useable character set to alfabetic characters only
    if(textField == _inputTextField) {
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
        NSLog(@"%@", _inputTextField.text);
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

@end
