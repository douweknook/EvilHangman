//
//  FlipsideViewController.h
//  Hangman
//
//  Created by Douwe Knook on 10-09-14.
//
//

#import <UIKit/UIKit.h>
#import "Wordlist.h"

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (nonatomic, strong) Wordlist *words;
@property (nonatomic, weak) IBOutlet UISlider *sliderWordLength;
@property (nonatomic, weak) IBOutlet UILabel *labelWordLength;
@property (nonatomic, weak) IBOutlet UISlider *sliderGuessAmount;
@property (nonatomic, weak) IBOutlet UILabel *labelGuessAmount;


@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
- (IBAction)sliderWordLengthValueChanged:(id)sender;
- (IBAction)sliderGuessAmountValueChanged:(id)sender;

@end