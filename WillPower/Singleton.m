//
//  Singleton.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "Singleton.h"


@implementation Singleton

@synthesize newrownumber;
@synthesize testresultnumber;
@synthesize doublesat;
@synthesize doublesun;
@synthesize selectedmonth;
@synthesize selectedyear;
@synthesize monthString;
@synthesize formatQuote;
@synthesize quotenumber;
@synthesize dateoriginal;
@synthesize timerinsecs;
@synthesize timerstarted;
@synthesize timerstopped;
@synthesize quotetable;
@synthesize keyboardsize;

static Singleton* _sharedSingleton = nil;

+ (Singleton*)sharedSingleton {
	
	@synchronized([Singleton class]) {
		if(!_sharedSingleton)
			_sharedSingleton = [[self alloc] init];
		
		return _sharedSingleton;
	}
	return nil;
}


+ (id) alloc {
	@synchronized ([Singleton class]) {
		NSAssert(_sharedSingleton == nil, @"Attempted to allocate a second instance of a Singleton.");
		_sharedSingleton = [super alloc];
		return _sharedSingleton;
	}
	
	return nil;
}

-(id) init {
	
	self = [super init];
	
	if (self != nil) {
	} 
	return self;
}


- (NSUInteger) getnewrownumber {
	return newrownumber;
}
- (void) setnewrownumber:(NSUInteger)value {
	newrownumber = value;
}

- (NSUInteger) gettestresultnumber {
	return testresultnumber;
}
- (void) settestresultnumber:(NSUInteger)value {
	testresultnumber = value;
}

- (NSUInteger) getdoublesat {
	return doublesat;
}
- (void) setdoublesat:(NSUInteger)value {
	doublesat = value;
}

- (NSUInteger) getdoublesun {
	return doublesun;
}
- (void) setdoublesun:(NSUInteger)value {
	doublesun = value;
}

- (NSUInteger) getselectedmonth {
	return selectedmonth;
}
- (void) setselectedmonth:(NSUInteger)value {
	selectedmonth = value;
}

- (NSUInteger) getselectedyear {
	return selectedyear;
}
- (void) setselectedyear:(NSUInteger)value {
	selectedyear = value;
}

- (NSUInteger) getquotenumber {
	return quotenumber;
}
- (void) setquotenumber:(NSUInteger)value {
	quotenumber = value;
}

- (NSDate *) getdateoriginal {
	return dateoriginal;
}
- (void) setdateoriginal:(NSDate *)value {
	dateoriginal = value;
}

- (NSUInteger) gettimerstarted {
	return timerstarted;
}
- (void) settimerstarted:(NSUInteger)value {
	timerstarted = value;
}

- (NSUInteger) gettimerinsecs {
	return timerinsecs;
}
- (void) settimerinsecs:(NSUInteger)value {
	timerinsecs = value;
}

- (NSUInteger) gettimerstopped {
	return timerstopped;
}
- (void) settimerstopped:(NSUInteger)value {
	timerstopped = value;
}

- (NSMutableArray *) getquotetable {
	return quotetable;
}
- (void) setquotetable:(NSMutableArray *)value {
	quotetable = value;
}

- (NSUInteger) getkeyboardsize {
	return keyboardsize;
}
- (void) setkeyboardsize:(NSUInteger)value {
	keyboardsize = value;
}

-(NSString *) getMonthString:(NSUInteger)monthInt {
    
    // Get month name
    switch (monthInt) {
        case 1:
            monthString = [[NSString alloc] initWithFormat:@"Jan"];
            break;
        case 2:
            monthString = [[NSString alloc] initWithFormat:@"Feb"];
            break;
        case 3:
            monthString = [[NSString alloc] initWithFormat:@"Mar"];
            break;
        case 4:
            monthString = [[NSString alloc] initWithFormat:@"Apr"];
            break;
        case 5:
            monthString = [[NSString alloc] initWithFormat:@"May"];
            break;
        case 6:
            monthString = [[NSString alloc] initWithFormat:@"Jun"];
            break;
        case 7:
            monthString = [[NSString alloc] initWithFormat:@"Jul"];
            break;
        case 8:
            monthString = [[NSString alloc] initWithFormat:@"Aug"];
            break;
        case 9:
            monthString = [[NSString alloc] initWithFormat:@"Sep"];
            break;
        case 10:
            monthString = [[NSString alloc] initWithFormat:@"Oct"];
            break;
        case 11:
            monthString = [[NSString alloc] initWithFormat:@"Nov"];
            break;
        case 12:
            monthString = [[NSString alloc] initWithFormat:@"Dec"];
            break;
        default:
            break;
    }
    return monthString;
}

-(NSString *) formatQuoteDB: (NSString *)cellQuote {
    
    // Put a backslash in front og single quotes or double quotes.
    formatQuote = [cellQuote stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
    formatQuote = [formatQuote stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
    
    return formatQuote;
}

- (NSString *)dataFilePath {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

@end
