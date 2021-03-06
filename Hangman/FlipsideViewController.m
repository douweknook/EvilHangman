//
//  FlipsideViewController.m
//  Hangman
//
//  Created by Douwe Knook on 10-09-14.
//
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize sliderWordLength=_sliderWordLength;
@synthesize labelWordLength=_labelWordLength;
@synthesize sliderGuessAmount=_sliderGuessAmount;
@synthesize labelGuessAmount=_labelGuessAmount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    NSArray *wordList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    // Find maximum and minimum word length in words.plist
    NSNumber *maximumLength = [wordList valueForKeyPath:@"@max.length"];
    NSNumber *minimumLength = [wordList valueForKeyPath:@"@min.length"];
    
    // Set slider's maximum value to maximum word length
    _sliderWordLength.maximumValue = [maximumLength floatValue];
    _sliderWordLength.minimumValue = [minimumLength floatValue];
    
    // Set slider values to previously selected settings
    NSString *wordLengthValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"wordLengthSetting"];
    NSString *guessAmountValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"guessAmountSetting"];
    _labelWordLength.text = wordLengthValue;
    _labelGuessAmount.text = guessAmountValue;
    _sliderWordLength.value = [wordLengthValue floatValue];
    _sliderGuessAmount.value = [guessAmountValue floatValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self.delegate flipsideViewControllerDidFinish:self];
    //Save settings for New Game
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_labelWordLength.text forKey:@"wordLengthSetting"];
    [defaults setObject:_labelGuessAmount.text forKey:@"guessAmountSetting"];
    [defaults synchronize];
}

// Actions to change label when slider changes
- (IBAction)sliderWordLengthValueChanged:(UISlider *)sender {
    _labelWordLength.text = [NSString stringWithFormat:@"%.0f", [sender value]];
}
- (IBAction)sliderGuessAmountValueChanged:(UISlider *)sender {
    _labelGuessAmount.text = [NSString stringWithFormat:@"%.0f", [sender value]];
}

@end
