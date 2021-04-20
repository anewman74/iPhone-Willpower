//
//  Singleton.h
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kFilename	@"willpower.sqlite3"


@interface Singleton : NSObject {
	NSUInteger newrownumber;
    NSUInteger testresultnumber;
    NSUInteger doublesat;
    NSUInteger doublesun;
    NSUInteger selectedmonth;
    NSUInteger selectedyear;
    NSString *monthString;
    NSString *formatQuote;
    NSUInteger quotenumber;
    NSDate *dateoriginal;
    NSUInteger timerinsecs;
    NSUInteger timerstarted;
    NSUInteger timerstopped;
    NSMutableArray *quotetable;
    NSUInteger keyboardsize;
}
@property (nonatomic, assign) NSUInteger newrownumber;
@property (nonatomic, assign) NSUInteger testresultnumber;
@property (nonatomic, assign) NSUInteger doublesat;
@property (nonatomic, assign) NSUInteger doublesun;
@property (nonatomic, assign) NSUInteger selectedmonth;
@property (nonatomic, assign) NSUInteger selectedyear;
@property (nonatomic, assign) NSString *monthString;
@property (nonatomic, assign) NSString *formatQuote;
@property (nonatomic, assign) NSUInteger quotenumber;
@property (nonatomic, assign) NSDate *dateoriginal;
@property (nonatomic, assign) NSUInteger timerinsecs;
@property (nonatomic, assign) NSUInteger timerstarted;
@property (nonatomic, assign) NSUInteger timerstopped;
@property (nonatomic, assign) NSMutableArray *quotetable;
@property (nonatomic, assign) NSUInteger keyboardsize;

+ (Singleton*) sharedSingleton;

- (NSUInteger) getnewrownumber;
- (void) setnewrownumber:(NSUInteger)value;

- (NSUInteger) gettestresultnumber;
- (void) settestresultnumber:(NSUInteger)value;

- (NSUInteger) getdoublesat;
- (void) setdoublesat:(NSUInteger)value;

- (NSUInteger) getdoublesun;
- (void) setdoublesun:(NSUInteger)value;

- (NSUInteger) getselectedmonth;
- (void) setselectedmonth:(NSUInteger)value;

- (NSUInteger) getselectedyear;
- (void) setselectedyear:(NSUInteger)value;

- (NSUInteger) getquotenumber;
- (void) setquotenumber:(NSUInteger)value;

- (NSDate *) getdateoriginal;
- (void) setdateoriginal:(NSDate *)value;

- (NSUInteger) gettimerinsecs;
- (void) settimerinsecs:(NSUInteger)value;

- (NSUInteger) gettimerstarted;
- (void) settimerstarted:(NSUInteger)value;

- (NSUInteger) gettimerstopped;
- (void) settimerstopped:(NSUInteger)value;

- (NSMutableArray *) getquotetable;
- (void) setquotetable:(NSMutableArray *)value;

- (NSUInteger) getkeyboardsize;
- (void) setkeyboardsize:(NSUInteger)value;

-(NSString *) getMonthString:(NSUInteger)monthInt;
-(NSString *) formatQuoteDB: (NSString *)cellQuote;
-(NSString *)dataFilePath;

@end