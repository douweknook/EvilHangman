//
//  MainViewController.h
//  Hangman
//
//  Created by Douwe Knook on 10-09-14.
//
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, weak) IBOutlet UITextField *inputTextField;
@property (nonatomic, weak) IBOutlet UILabel *guessedLettersLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *guessesLeft;
@property (nonatomic, weak) IBOutlet UILabel *labelGuessesLeft;
@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *restart;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *settings;

- (IBAction)newGame:(id)sender;


@end
