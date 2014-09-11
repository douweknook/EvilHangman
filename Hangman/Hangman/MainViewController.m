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

@synthesize placeholder=_placeholder;
@synthesize inputTextField=_inputTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _inputTextField.delegate = self;
    _inputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGame:(id)sender {
    // Retreive settings for New Game
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *wordLengthSetting = [defaults objectForKey:@"wordLengthSetting"];
    NSNumber *guessAmountSetting = [defaults objectForKey:@"guessAmountSetting"];
    NSLog(@"Word Length: %@\n Guess amount: %@", wordLengthSetting, guessAmountSetting);
}

- (BOOL)textFieldShouldReturn:(UITextField *)inputTextField {
    if ([_inputTextField.text length] > 0 && [_inputTextField.text length] < 2) {
        NSLog(@"Return YES");
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
