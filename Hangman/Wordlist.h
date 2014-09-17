//
//  Wordlist.h
//  Hangman
//
//  Created by Douwe Knook on 16-09-14.
//
//

#import <Foundation/Foundation.h>

@interface Wordlist : NSObject

@property (nonatomic, weak) NSArray *wordList;

- (NSArray *)loadWordList;
- (NSNumber *)maximumWordLengthInList:(Wordlist *)words;
- (NSNumber *)minimumWordLengthInList:(Wordlist *)words;
- (NSNumber *)averageWordLengthInList:(Wordlist *)words;

@end
