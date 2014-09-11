//
//  MainViewController.h
//  Hangman
//
//  Created by Douwe Knook on 10-09-14.
//
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

- (IBAction)newGame:(id)sender;

@end
