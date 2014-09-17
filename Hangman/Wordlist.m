//
//  Wordlist.m
//  Hangman
//
//  Created by Douwe Knook on 16-09-14.
//
//

#import "Wordlist.h"

@implementation Wordlist

@synthesize wordList=_wordList;

- (NSArray *)loadWordList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    NSArray *wordList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    return wordList;
}

- (NSNumber *)maximumWordLengthInList:(Wordlist *)words {
    NSNumber *maximumLength = [words.wordList valueForKeyPath:@"@max.length"];
    NSLog(@"%@", maximumLength);
    return maximumLength;
}

- (NSNumber *)minimumWordLengthInList:(Wordlist *)words {
    NSNumber *minimumLength = [words.wordList valueForKeyPath:@"@min.length"];
    return minimumLength;
}

- (NSNumber *)averageWordLengthInList:(Wordlist *)words {
    NSNumber *averageLength = [words.wordList valueForKeyPath:@"@avg.length"];
    return averageLength;
}


@end
