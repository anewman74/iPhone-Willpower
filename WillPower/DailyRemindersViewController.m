//
//  DailyRemindersViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "DailyRemindersViewController.h"
#import "DailyRemindersTableViewController.h"
#import "DailyReminderUpdate.h"
#import "EarthScreen.h"
#import "WillPowerAppDelegate_iPhone.h"

@implementation DailyRemindersViewController
@synthesize dailyTableVC;
@synthesize dailyUp;
@synthesize earthscreen;


-(IBAction) toDailyTable {	
    
	if (self.dailyTableVC == nil)
	{
		DailyRemindersTableViewController *aDetail = [[DailyRemindersTableViewController alloc] initWithNibName: @"DailyRemindersTableViewController" bundle:[NSBundle mainBundle]];
		self.dailyTableVC = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:dailyTableVC animated:YES];
}

-(IBAction) newQuote {	
    
    // Save into Singleton class
    rownum = 0; // so the text view is empty.
    [[Singleton sharedSingleton] setnewrownumber:rownum];
    
	if (self.dailyUp == nil)
	{
		DailyReminderUpdate *aDetail = [[DailyReminderUpdate alloc] initWithNibName: @"DailyReminderUpdate" bundle:[NSBundle mainBundle]];
		self.dailyUp = aDetail;
		[aDetail release];
	}	
	WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate.navController pushViewController:dailyUp animated:YES];
}

-(IBAction) startTimer {	
    
    // Get now and save in Singleton
    now = [[NSDate alloc] init];
    [[Singleton sharedSingleton] setdateoriginal:now];
      
    // Get quotes from database and add them into table.
    tableCellNames = 0;
    tableCellNames = [[NSMutableArray alloc] init];
    query = [[NSString alloc] initWithFormat: @"SELECT quote FROM reminders"];     
    //NSLog(@"query - %@", query);
    
    sqlite3_stmt *stmt3;
    if(sqlite3_prepare_v2(database, [query UTF8String],-1, &stmt3, nil) == SQLITE_OK){
        while(sqlite3_step(stmt3) == SQLITE_ROW){
            
            quoteChar = (char *)sqlite3_column_text(stmt3, 0);
            quoteDB = [[NSString alloc] initWithFormat:@"%s",quoteChar];
            // Take out backslashes from single quotes or double quotes.
            quoteDB = [quoteDB stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];            
            [tableCellNames addObject:quoteDB];
        }
        sqlite3_finalize(stmt3);
    }
    
    // Set table in Singleton class.
    [[Singleton sharedSingleton] setquotetable:tableCellNames];
    //NSLog(@"Table: %@", tableCellNames); 
   
    //Set the quoteNumber to 0 (the first index in the table).
    quoteNumber = 0;
    [[Singleton sharedSingleton] setquotenumber:quoteNumber];  
    
    // Check the minutes text has only numbers or '.'
    numbersSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    if ([minutes.text stringByTrimmingCharactersInSet:numbersSet].length <= 0) {
        
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Notice"];
        message = [[NSString alloc] initWithFormat:
                   @"Please type numbers or decimals in minutes field."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
    // Check if text view has content.
    else if([minutes.text isEqualToString:@"."]){
        
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Notice"];
        message = [[NSString alloc] initWithFormat:
                  @"Please type numbers or decimals in minutes field."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }
    else {
        
        // If there already is a timer, stop it.
        timerStarted = (int)[[Singleton sharedSingleton] gettimerstarted];
        if( timerStarted == 1 ) {
            
            // Stop timer.
            [timer invalidate];
            
            // Clear out old notifications before scheduling new ones.
            application4 = [UIApplication sharedApplication];
            oldNotifications = [application4 scheduledLocalNotifications];
            if ([oldNotifications count] > 0) {
                [application4 cancelAllLocalNotifications];
            }
            
            //Set the quoteNumber to 0 (the first index in the table).
            quoteNumber = 0;
            [[Singleton sharedSingleton] setquotenumber:quoteNumber]; 
            
            stringTimer = minutes.text;
            timerInMin = [stringTimer floatValue];
            timerInSec = timerInMin * 60;
            [[Singleton sharedSingleton] settimerinsecs:timerInSec];
            
            // Make sure timerStopped equals 0.
            timerStopped = 0;
            [[Singleton sharedSingleton] settimerstopped:timerStopped];
            
            if(timerInMin == 1) {
                strMin = @"minute";
            }
            else {
                strMin = @"minutes";
            }
            
            //Alert view message.
            title = [NSString stringWithFormat:@"Confirmed"];
            message = [NSString stringWithFormat:
                       @"The previous timer has been stopped.  With the new timer, you will receive an alert with a quote every %@ %@.", stringTimer, strMin];
            
            alert = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
            
            
            //Set timer
            timer = [NSTimer scheduledTimerWithTimeInterval:timerInSec
                                                     target:self
                                                   selector:@selector(beginAlerts)
                                                   userInfo:nil
                                                    repeats:NO];
            
            // Show Earth View
            if (self.earthscreen == nil)
            {
                EarthScreen *aDetail = [[EarthScreen alloc] initWithNibName: @"EarthScreen" bundle:[NSBundle mainBundle]];
                self.earthscreen = aDetail;
                [aDetail release];
            }	
            WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate.navController pushViewController:earthscreen animated:YES];
        }
        else {
            stringTimer = minutes.text;
            timerInMin = [stringTimer floatValue];
            timerInSec = timerInMin * 60;
            [[Singleton sharedSingleton] settimerinsecs:timerInSec];
            
            
            // Set timerStopped to 0.
            timerStopped = 0;
            [[Singleton sharedSingleton] settimerstopped:timerStopped];
            
            // Set timerStarted to 1.
            timerStarted = 1;
            [[Singleton sharedSingleton] settimerstarted:timerStarted];
            
            
            if(timerInMin == 1) {
                strMin = @"minute";
            }
            else {
                strMin = @"minutes";
            }
            
            //Alert view message.
            title = [NSString stringWithFormat:@"Confirmed"];
            message = [NSString stringWithFormat:
                       @"You will receive a reminder message with a quote every %@ %@. The notification will appear whether the App is open or closed.", stringTimer, strMin];
            
            alert = [[UIAlertView alloc] initWithTitle:title
                                               message:[NSString stringWithFormat:@"%@", message]
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
    
            //Set timer
            timer = [NSTimer scheduledTimerWithTimeInterval:timerInSec
                                                     target:self
                                                   selector:@selector(beginAlerts)
                                                   userInfo:nil
                                                    repeats:NO];
            
            // Show Earth View
            if (self.earthscreen == nil)
            {
                EarthScreen *aDetail = [[EarthScreen alloc] initWithNibName: @"EarthScreen" bundle:[NSBundle mainBundle]];
                self.earthscreen = aDetail;
                [aDetail release];
            }	
            WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate.navController pushViewController:earthscreen animated:YES];
        }        
    }
}

-(void) beginAlerts {
    
    timerInSec = (int)[[Singleton sharedSingleton] gettimerinsecs];
    tableCellNames = [[Singleton sharedSingleton] getquotetable];
    
    // Timer stopped is important to stop a timer that has already been run before the button "stop timer" was clicked.
    timerStopped = (int)[[Singleton sharedSingleton] gettimerstopped];
    if( timerStopped == 0 ) {
        
        // If table count != 0.
        if ([tableCellNames count] > 0) {
            // Get quote number.
            quoteNumber = (int)[[Singleton sharedSingleton] getquotenumber];
            
            // Continue reminders only until end of table.
            if (quoteNumber < [tableCellNames count]) {
                
                quoteString = [tableCellNames objectAtIndex:quoteNumber];
                
                //Show quote in alert
                title = [[NSString alloc] initWithFormat:@"Willpower"];
                message = [[NSString alloc] initWithFormat:
                           @"%@",quoteString];
                
                alert = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"Close"
                                         otherButtonTitles:nil];
                [alert show];
                
                // Add 1 to the quote number
                quoteNumber = quoteNumber + 1;
                [[Singleton sharedSingleton] setquotenumber:quoteNumber];
            
            //Set timer
            timer = [NSTimer scheduledTimerWithTimeInterval:timerInSec
                                                     target:self
                                                   selector:@selector(nextAlert)
                                                   userInfo:nil
                                                    repeats:NO];
            }
            else {
                // Set timerStopped to 1.
                timerStopped = 1;
                [[Singleton sharedSingleton] settimerstopped:timerStopped];
                
                // Set timerStarted to 0.
                timerStarted = 0;
                [[Singleton sharedSingleton] settimerstarted:timerStarted]; 
            }
        }
    }
}

-(void) nextAlert {
    
    timerInSec = (int)[[Singleton sharedSingleton] gettimerinsecs];
    tableCellNames = [[Singleton sharedSingleton] getquotetable];
    
    // Timer stopped is important to stop a timer that has already been run before the button "stop timer" was clicked.
    timerStopped = (int)[[Singleton sharedSingleton] gettimerstopped];
    if( timerStopped == 0 ) {
        
        // If table count != 0.
        if ([tableCellNames count] > 0) {
            // Get quote number.
            quoteNumber = (int)[[Singleton sharedSingleton] getquotenumber];
            
            // Continue reminders only until end of table.
            if (quoteNumber < [tableCellNames count]) {

                quoteString = [tableCellNames objectAtIndex:quoteNumber];
                
                //Show quote in alert
                title = [[NSString alloc] initWithFormat:@"Will Power."];
                message = [[NSString alloc] initWithFormat:
                           @"%@",quoteString];
                
                alert = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"Close"
                                         otherButtonTitles:nil];
                [alert show];
                
                // Add 1 to the quote number
                quoteNumber = quoteNumber + 1;
                [[Singleton sharedSingleton] setquotenumber:quoteNumber];
                
                //Set timer
                timer = [NSTimer scheduledTimerWithTimeInterval:timerInSec
                                                         target:self
                                                       selector:@selector(beginAlerts)
                                                       userInfo:nil
                                                        repeats:NO];
            }
            else {
                // Set timerStopped to 1.
                timerStopped = 1;
                [[Singleton sharedSingleton] settimerstopped:timerStopped];
                
                // Set timerStarted to 0.
                timerStarted = 0;
                [[Singleton sharedSingleton] settimerstarted:timerStarted]; 
            }
        }
    }
}


-(IBAction) stopTimer {
    
    timerStopped = 1;
    [[Singleton sharedSingleton] settimerstopped:timerStopped]; 
    
    timerStarted = 0;
    [[Singleton sharedSingleton] settimerstarted:timerStarted]; 
    
    // Clear out old notifications before scheduling new ones.
    application4 = [UIApplication sharedApplication];
    oldNotifications = [application4 scheduledLocalNotifications];
    if ([oldNotifications count] > 0) {
        [application4 cancelAllLocalNotifications];
    }
    
    //Alert view message.
    title = [[NSString alloc] initWithFormat:@"Confirmed"];
    message = [[NSString alloc] initWithFormat:
               @"The notifications have been stopped."];
    
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}


-(IBAction) earthView {	
    
	// Show Earth View
    if (self.earthscreen == nil)
    {
        EarthScreen *aDetail = [[EarthScreen alloc] initWithNibName: @"EarthScreen" bundle:[NSBundle mainBundle]];
        self.earthscreen = aDetail;
        [aDetail release];
    }	
    WillPowerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate.navController pushViewController:earthscreen animated:YES];
}


-(void) scheduleReminders:(double)timerSec reminders:(int)reminders {
    
    tableCellNames = [[Singleton sharedSingleton] getquotetable];
    
    application4 = [UIApplication sharedApplication];
    oldNotifications = [application4 scheduledLocalNotifications];
    
    // Clear out old notifications before scheduling new ones.
    if ([oldNotifications count] > 0) {
        [application4 cancelAllLocalNotifications];
    }
    
    // Get now as a double
    now = [[NSDate alloc] init];  
    doubleNew = [now timeIntervalSince1970];
    
    // If reminders != 0, create a new table of quotes.
    if (reminders != 0) {
        
        // Create new table.
        newTable = [[NSMutableArray alloc] init];
        
        //Original Date
        originaldate = [[Singleton sharedSingleton] getdateoriginal];
        doubleOriginal = [originaldate timeIntervalSince1970];
        
        // Get the doubleNew for the first element in the table.
        doubleNew = doubleOriginal + ((reminders + 1) * timerSec);
        
        // Put the next in line quotes into new table.
        while (reminders < [tableCellNames count]) {
            [newTable addObject:[tableCellNames objectAtIndex:reminders]];
             reminders = reminders + 1;
        }
        
        // Run through table of dates.
        for (int i=0; i < [newTable count]; i++) {
            
            // Get the date in future
            dateNew = [NSDate dateWithTimeIntervalSince1970:doubleNew];
            
            // Create a new notification.
            reminder = [[[UILocalNotification alloc] init] autorelease];
            if(reminder) {
                reminder.fireDate = dateNew;
                reminder.timeZone = [NSTimeZone defaultTimeZone];
                reminder.soundName = @"alert.wav";
                reminder.repeatInterval = 0;
                reminder.alertBody = [newTable objectAtIndex:i];
                
                [application4 scheduleLocalNotification:reminder];
            }
            doubleNew = doubleNew + timerSec;
        }
    }
    
    else {
        
        //Original Date
        originaldate = [[Singleton sharedSingleton] getdateoriginal];
        doubleOriginal = [originaldate timeIntervalSince1970];
        
        // Get the doubleNew for the first element in the table.
        doubleNew = doubleOriginal + ((reminders + 1) * timerSec);
        
        // Run through table of dates.
        for (int i=0; i < [tableCellNames count]; i++) {
        
            // Get the date in future
            dateNew = [NSDate dateWithTimeIntervalSince1970:doubleNew];
        
            // Create a new notification.
            reminder = [[[UILocalNotification alloc] init] autorelease];
            if(reminder) {
                reminder.fireDate = dateNew;
                reminder.timeZone = [NSTimeZone defaultTimeZone];
                reminder.soundName = @"alert.wav";
                reminder.repeatInterval = 0;
                reminder.alertBody = [tableCellNames objectAtIndex:i];
            
                [application4 scheduleLocalNotification:reminder];
            }
            doubleNew = doubleNew + timerSec;
        }
    }
}

-(void)applicationDidEnterBackground:(NSNotification *)notification {
    
    timerInSec = (int)[[Singleton sharedSingleton] gettimerinsecs];
    
    //Original Date
    originaldate = [[Singleton sharedSingleton] getdateoriginal];
    doubleOriginal = [originaldate timeIntervalSince1970];
    
    // Get now as a double
    now = [[NSDate alloc] init];
    doubleNow = [now timeIntervalSince1970];
    
    // Get the number of reminders passed since timer began.
    int remindersPassed = (doubleNow - doubleOriginal) / timerInSec;
    
    // If there is a timer.
    timerStarted = (int)[[Singleton sharedSingleton] gettimerstarted];
    if( timerStarted == 1 ) {
        
        // Stop original timer as local notifications will run alerts now.
        [timer invalidate];
        
        // Set up Local Notifications with reminders where app is in background.
        [self scheduleReminders:timerInSec reminders:remindersPassed];
    }
}


-(void)applicationWillEnterForeground:(NSNotification *)notification {
    
    timerInSec = (int)[[Singleton sharedSingleton] gettimerinsecs];
    
    //Original Date
    originaldate = [[Singleton sharedSingleton] getdateoriginal];
    doubleOriginal = [originaldate timeIntervalSince1970];
    
    // Get now as a double
    now = [[NSDate alloc] init];
    doubleNow = [now timeIntervalSince1970];
    
    // Get the number of reminders passed since timer began.
    int remindersPassed = (doubleNow - doubleOriginal) / timerInSec;
    
    // Get the saved quote table.
    tableCellNames = [[Singleton sharedSingleton] getquotetable];
    
    // If there is a timer and the reminders passed is less then the elements in the saved table.
    timerStarted= (int)[[Singleton sharedSingleton] gettimerstarted];
    if( (timerStarted == 1) && (remindersPassed < [tableCellNames count]) ) {
        
        // Set timer stopped to 0.
        timerStopped = 0;
        [[Singleton sharedSingleton] settimerstopped:timerStopped];

        // Set the quoteNumber to show next in Singleton class.
        quoteNumber = remindersPassed;
        [[Singleton sharedSingleton] setquotenumber:quoteNumber];
        
        //Original Date
        originaldate = [[Singleton sharedSingleton] getdateoriginal];
        doubleOriginal = [originaldate timeIntervalSince1970];
        
        // Get the doubleNew for the first element in the table.
        doubleNew = doubleOriginal + ((remindersPassed + 1) * timerInSec);
        
        // Get the timesecs until doublenew from doublenow.
        timesecs = doubleNew - doubleNow;
        
        // Call the start timer again.
        timer = [NSTimer scheduledTimerWithTimeInterval:timesecs
                                                 target:self
                                               selector:@selector(beginAlerts)
                                               userInfo:nil
                                                repeats:NO];
    }
    else {
        // Set timerStopped to 1.
        timerStopped = 1;
        [[Singleton sharedSingleton] settimerstopped:timerStopped];
        
        // Set timerStarted to 0.
        timerStarted = 0;
        [[Singleton sharedSingleton] settimerstarted:timerStarted];  
    }
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =  NSLocalizedString(@"Daily Reminders", @"daily reminders");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        
        iphone4Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,455)];
        iphone4Background.image = [UIImage imageNamed:@"iphone4Background.png"];
        [self.view addSubview:iphone4Background];
        [iphone4Background release];
        
        btnViewAllQuotes = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnViewAllQuotes setFrame:CGRectMake(19,15,282,48)];
        [btnViewAllQuotes setImage:[UIImage imageNamed:@"button-view-all-quotes.png"] forState:UIControlStateNormal];
        [btnViewAllQuotes addTarget:self action:@selector(toDailyTable) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnViewAllQuotes];
        
        btnInsertNewQuote = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnInsertNewQuote setFrame:CGRectMake(19,69,282,48)];
        [btnInsertNewQuote setImage:[UIImage imageNamed:@"button-insert-new-quote.png"] forState:UIControlStateNormal];
        [btnInsertNewQuote addTarget:self action:@selector(newQuote) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnInsertNewQuote];
        
        reminderSettings = [[UILabel alloc] initWithFrame:CGRectMake(80,128,161,22)];
        reminderSettings.numberOfLines = 0;
        reminderSettings.backgroundColor = [UIColor clearColor];
        reminderSettings.textColor = [UIColor yellowColor];
        reminderSettings.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [reminderSettings setTextAlignment:UITextAlignmentLeft];
        reminderSettings.text = @"Reminder Settings";
        [self.view  addSubview:reminderSettings];
        
        displayQuotes = [[UILabel alloc] initWithFrame:CGRectMake(41,162,168,21)];
        displayQuotes.numberOfLines = 0;
        displayQuotes.backgroundColor = [UIColor clearColor];
        displayQuotes.textColor = [UIColor whiteColor];
        displayQuotes.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [displayQuotes setTextAlignment:UITextAlignmentLeft];
        displayQuotes.text = @"Display quotes every:";
        [self.view  addSubview:displayQuotes];
        
        minutes = [[UITextField alloc]initWithFrame:CGRectMake(213,158,70,31)];
        minutes.borderStyle = UITextBorderStyleRoundedRect;
        minutes.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        minutes.autocorrectionType = UITextAutocorrectionTypeNo;
        minutes.keyboardType = UIKeyboardTypeDefault;
        minutes.returnKeyType = UIReturnKeyDone;
        minutes.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        minutes.placeholder = @"minutes";
        [minutes setTextAlignment:UITextAlignmentCenter];
        [minutes setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        minutes.delegate = self;
        [self.view addSubview:minutes];
        
        btnStartTimer = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnStartTimer setFrame:CGRectMake(19,201,282,48)];
        [btnStartTimer setImage:[UIImage imageNamed:@"button-start-timer.png"] forState:UIControlStateNormal];
        [btnStartTimer addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnStartTimer];
        
        btnStopTimer = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnStopTimer setFrame:CGRectMake(19,257,282,48)];
        [btnStopTimer setImage:[UIImage imageNamed:@"button-stop-timer.png"] forState:UIControlStateNormal];
        [btnStopTimer addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnStopTimer];
        
        btnEarthView = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnEarthView setFrame:CGRectMake(19,312,282,48)];
        [btnEarthView setImage:[UIImage imageNamed:@"button-earth-view.png"] forState:UIControlStateNormal];
        [btnEarthView addTarget:self action:@selector(earthView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnEarthView];
    }
    else{
        iphone5Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,320,455)];
        iphone5Background.image = [UIImage imageNamed:@"iphone5Background.png"];
        [self.view addSubview:iphone5Background];
        [iphone5Background release];
        
        btnViewAllQuotes = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnViewAllQuotes setFrame:CGRectMake(19,80,282,48)];
        [btnViewAllQuotes setTitle:@"View All Quotes" forState:UIControlStateNormal];
        [btnViewAllQuotes setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnViewAllQuotes addTarget:self action:@selector(toDailyTable) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnViewAllQuotes];
        
        btnInsertNewQuote = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnInsertNewQuote setFrame:CGRectMake(19,130,282,48)];
        [btnInsertNewQuote setTitle:@"Insert New Quote" forState:UIControlStateNormal];
        [btnInsertNewQuote setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnInsertNewQuote addTarget:self action:@selector(newQuote) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnInsertNewQuote];
        
        reminderSettings = [[UILabel alloc] initWithFrame:CGRectMake(80,185,161,22)];
        reminderSettings.numberOfLines = 0;
        reminderSettings.backgroundColor = [UIColor clearColor];
        reminderSettings.textColor = [UIColor blackColor];
        reminderSettings.font = [UIFont fontWithName:@"Helvetica" size:18];
        reminderSettings.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
        [reminderSettings setTextAlignment:UITextAlignmentCenter];
        reminderSettings.text = @"Reminder Settings";
        [self.view  addSubview:reminderSettings];
        
        displayQuotes = [[UILabel alloc] initWithFrame:CGRectMake(61,220,168,21)];
        displayQuotes.numberOfLines = 0;
        displayQuotes.backgroundColor = [UIColor clearColor];
        displayQuotes.textColor = [UIColor blackColor];
        displayQuotes.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:14];
        [displayQuotes setTextAlignment:UITextAlignmentLeft];
        displayQuotes.text = @"Display quotes every:";
        [self.view  addSubview:displayQuotes];
        
        minutes = [[UITextField alloc]initWithFrame:CGRectMake(183,216,65,31)];
        minutes.borderStyle = UITextBorderStyleRoundedRect;
        minutes.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        minutes.autocorrectionType = UITextAutocorrectionTypeNo;
        minutes.keyboardType = UIKeyboardTypeDefault;
        minutes.returnKeyType = UIReturnKeyDone;
        minutes.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        minutes.placeholder = @"minutes";
        [minutes setTextAlignment:UITextAlignmentCenter];
        [minutes setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        minutes.delegate = self;
        [self.view addSubview:minutes];
        
        btnStartTimer = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnStartTimer setFrame:CGRectMake(19,256,282,48)];
        [btnStartTimer setTitle:@"Start Notifications" forState:UIControlStateNormal];
        [btnStartTimer setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnStartTimer addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnStartTimer];
        
        btnStopTimer = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnStopTimer setFrame:CGRectMake(19,306,282,48)];
        [btnStopTimer setTitle:@"Stop Notifications" forState:UIControlStateNormal];
        [btnStopTimer setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnStopTimer addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnStopTimer];
        
        btnEarthView = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnEarthView setFrame:CGRectMake(19,356,282,48)];
        [btnEarthView setTitle:@"Earth View" forState:UIControlStateNormal];
        [btnEarthView setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnEarthView addTarget:self action:@selector(earthView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnEarthView];
        
        suggestion = [[UILabel alloc] initWithFrame:CGRectMake(20,400,280,100)];
        suggestion.backgroundColor = [UIColor clearColor];
        suggestion.textColor = [UIColor blackColor];
        suggestion.numberOfLines = 5;
        suggestion.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:16];
        [suggestion setTextAlignment:UITextAlignmentLeft];
        suggestion.text = @"To help maintain your focus and motivation during the day, we suggest you set as notifications these default quotes (or your own inspiring quotes) on a timer (every 30 minutes or so). Test it out.";
        [self.view  addSubview:suggestion];
    }

    // Initialize array.
    tableCellNames = 0;
	tableCellNames = [[NSMutableArray alloc] init];
    
    // Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
	
	char *errorMsg;
    
    // Create reminders table.
	createSQL = @"CREATE TABLE IF NOT EXISTS reminders (row integer primary key,quote varchar(25));";
	if(sqlite3_exec(database, [createSQL UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s", errorMsg);
	}
    
    // Create reminderschanged table.
    createSQL2 = @"CREATE TABLE IF NOT EXISTS reminderschanged (row integer primary key,changed integer);";
	if(sqlite3_exec(database, [createSQL2 UTF8String],NULL,NULL,&errorMsg) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert1(0,@"Error creating table: %s", errorMsg);
	}
    
    // Get changed variable from table. Variable changed = 0 at first so we need to make it equal to 1 in the database after quotes inserted.
	query2 = [[NSString alloc] initWithFormat: @"SELECT changed FROM reminderschanged where row = '1'"];     
    //NSLog(@"query2 - %@", query2);
    
    sqlite3_stmt *stmt2;
    if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &stmt2, nil) == SQLITE_OK){
        while(sqlite3_step(stmt2) == SQLITE_ROW){  
            changed = sqlite3_column_int(stmt2, 0);
        }
        sqlite3_finalize(stmt2);
    }
    
    // If changed = 0, then there are no rows in database because the variable 'changed' has not been changed from 0.
    if (changed == 0) {
        
        // initialize table data.
        quote1 = [[NSString alloc] initWithFormat: @"You are in control of what you consciously think about, your subconscious skills, and your self-image growth. You have a ladder to cross. It is the ladder of mental control and it leads to your dreams. (Olympic Champion, Lanny Bassham)"];
        quote1 = [[Singleton sharedSingleton] formatQuoteDB:quote1];
        [tableCellNames addObject:quote1];
        
        
        quote2 = [[NSString alloc] initWithFormat: @"He who knows others is learned; He who knows himself is wise. (Lao-tzu, Tao te Ching)"];
        quote2 = [[Singleton sharedSingleton] formatQuoteDB:quote2];
        [tableCellNames addObject:quote2];
        
        quote3 = [[NSString alloc] initWithFormat: @"If you fight your destiny, you will be miserable. You must embrace it and revel in every moment.  You saved the treasure. And escaped the bad guys. And rescued lady fair.  And your heart is beating.  Every nerve in your body is alive.  Who else can live such a life?  Don't hide from it Flynn.  Celebrate it! (The Librarian - The Curse of the Judas Chalice)"];
        quote3 = [[Singleton sharedSingleton] formatQuoteDB:quote3];
        [tableCellNames addObject:quote3];
        
        quote4 = [[NSString alloc] initWithFormat: @"In order to live freely and happily, you must sacrifice boredom.  It is not always an easy sacrifice. (Illusions - Richard Bach)"];
        quote4 = [[Singleton sharedSingleton] formatQuoteDB:quote4];
        [tableCellNames addObject:quote4];
        
        quote5 = [[NSString alloc] initWithFormat: @"Success is conditional - but it's within your reach as long as you have the discipline to try, try again. (Roy Baumeister and John Tierney)"];
        quote5 = [[Singleton sharedSingleton] formatQuoteDB:quote5];
        [tableCellNames addObject:quote5];
        
        quote6 = [[NSString alloc] initWithFormat: @"Life's but a walking shadow: a poor player who struts and frets his hour upon the stage, and then is heard no more; it is a tale told by an idiot, full of sound and fury, signifying nothing. (William Shakespeare)"];
        quote6 = [[Singleton sharedSingleton] formatQuoteDB:quote6];
        [tableCellNames addObject:quote6];
        
        quote7 = [[NSString alloc] initWithFormat: @"A man who views the world the same at fifty as he did at twenty has wasted thirty years of his life. (Muhammad Ali)"];
        quote7 = [[Singleton sharedSingleton] formatQuoteDB:quote7];
        [tableCellNames addObject:quote7];
        
        quote8 = [[NSString alloc] initWithFormat: @"This poor body of mine has suffered terribly .. it has been degraded, pained, wearied & sickened, and has well nigh sunk under the task imposed on it; but this was but a small portion of myself. For my real self lay darkly encased, & was ever too haughty & soaring for such miserable environments as the body that encumbered it daily. (Henry Morton Stanley)"];
        quote8 = [[Singleton sharedSingleton] formatQuoteDB:quote8];
        [tableCellNames addObject:quote8];
        
        quote9 = [[NSString alloc] initWithFormat: @"You must concentrate upon and consecrate yourself wholly to each day, as though a fire were raging in your hair. (Taisen Deshiaru)"];
        quote9 = [[Singleton sharedSingleton] formatQuoteDB:quote9];
        [tableCellNames addObject:quote9];
        
        quote10 = [[NSString alloc] initWithFormat: @"They had the ability to step outside of their own pain, put aside their own fear, and ask: 'How can I help the guy next to me? They had more than the 'fist' of courage and physical strength. They also had a heart large enough to think about others. (U.S. Navy SEAL officer Eric Greitens, recalling fellow 'Hell Week' survivors)"];
        quote10 = [[Singleton sharedSingleton] formatQuoteDB:quote10];
        [tableCellNames addObject:quote10];
        
        quote11 = [[NSString alloc] initWithFormat: @"Imagine throwing a pebble into a still pond. How does the water respond? The answer is, totally appropriately to the force and mass of the input; then it returns to calm. It doesn't overreact or underreact. (David Allen)"];
        quote11 = [[Singleton sharedSingleton] formatQuoteDB:quote11];
        [tableCellNames addObject:quote11];
        
        quote12 = [[NSString alloc] initWithFormat: @"A pessimist sees the difficulty in every opportunity; an optimist sees the opportunity in every difficulty. (Winston Churchill)"];
        quote12 = [[Singleton sharedSingleton] formatQuoteDB:quote12];
        [tableCellNames addObject:quote12];
        
        quote13 = [[NSString alloc] initWithFormat: @"A small daily task, if it be really daily, will beat the labors of a spasmodic Hercules. (Anthony Trollope)"];
        quote13 = [[Singleton sharedSingleton] formatQuoteDB:quote13];
        [tableCellNames addObject:quote13];
        
        quote14 = [[NSString alloc] initWithFormat: @"To cast aside regret and fear.  To do the deed at hand.  Every man that can ride should be sent west at once, as Eomer counselled you: we  must first destroy the threat of Saruman, while we have time.  If we fail, we fall.  If we suceed - then we will face the next task. (Gandalf - Lord of the Rings)"];
        quote14 = [[Singleton sharedSingleton] formatQuoteDB:quote14];
        [tableCellNames addObject:quote14];
        
        quote15 = [[NSString alloc] initWithFormat: @"Excellence matters ... Whatever it is that you do, you are making a stand, either for excellence or for mediocrity. (former U.S. Navy SEAL Sniper Instructor, Brandon Webb)"];
        quote15 = [[Singleton sharedSingleton] formatQuoteDB:quote15];
        [tableCellNames addObject:quote15];
        
        quote16 = [[NSString alloc] initWithFormat: @"What?  No one here believes in a comeback?  You know - human beings - we've got to give them a break.  We're all mixed bags.  (Wall Street - Money Never Sleeps)"];
        quote16 = [[Singleton sharedSingleton] formatQuoteDB:quote16];
        [tableCellNames addObject:quote16];
 
        // Run through the quotes in the table and insert them into the database.
        
        for (int i=0; i < [tableCellNames count] ; i++) {
            
            char *insert = "INSERT INTO reminders (quote) VALUES(?);";	
            sqlite3_stmt *stmt;
            if(sqlite3_prepare_v2(database, insert, -1, &stmt, nil) == SQLITE_OK){
                sqlite3_bind_text(stmt, 1, [[tableCellNames objectAtIndex:i] UTF8String], -1, NULL);
            }
            if(sqlite3_step(stmt) != SQLITE_DONE) {
                //NSLog(@"statement failed");
            } 
            sqlite3_finalize(stmt); 
        }   
        
        // Make the changed = 1. then I don't have to insert the quotes into the database every time I load this view.
        changed = 1;
        char *insert = "INSERT INTO reminderschanged (changed) VALUES(?);";	
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, insert, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt,1, changed);
        }
        if(sqlite3_step(stmt) != SQLITE_DONE) {
            //NSLog(@"statement failed");
        }
        sqlite3_finalize(stmt); 
        
        // Get changed to confirm
        query3 = [[NSString alloc] initWithFormat: @"SELECT changed FROM reminderschanged where row = '1'"];     
        //NSLog(@"query3 - %@", query3);
        
        sqlite3_stmt *stmt3;
        if(sqlite3_prepare_v2(database, [query3 UTF8String],-1, &stmt3, nil) == SQLITE_OK){
            while(sqlite3_step(stmt3) == SQLITE_ROW){  
                changed = sqlite3_column_int(stmt3, 0);
            }
            sqlite3_finalize(stmt3);
        }
        //NSLog(@"table cell names inserted into database - %@", tableCellNames);
    }
    
    // Where changed = 1
    else {
        
        // If there is a timer already ON, create the tableCellNames table.
        if(timerStopped == 0) {
            
            // Get quotes from database and fill into tableCellNames.
            query = [[NSString alloc] initWithFormat: @"SELECT quote FROM reminders"];     
            //NSLog(@"query - %@", query);
            
            sqlite3_stmt *stmt3;
            if(sqlite3_prepare_v2(database, [query UTF8String],-1, &stmt3, nil) == SQLITE_OK){
                while(sqlite3_step(stmt3) == SQLITE_ROW){
                    
                    quoteChar = (char *)sqlite3_column_text(stmt3, 0);
                    quoteDB = [[NSString alloc] initWithFormat:@"%s",quoteChar];
                    
                    // Take out backslashes from single quotes or double quotes.
                    quoteDB = [quoteDB stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
                    [tableCellNames addObject:quoteDB];
                }
                sqlite3_finalize(stmt3);
            }
        }
    }
    // Registering a notification when keyboard will show.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:self.view.window];
    
    // Registering application did enter background.
    if (!application) {
        application = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:application];
    }
    
    // Registering application will terminate.
    if (!application2) {
        application2 = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillTerminate:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:application2];
    }
    
    // Registering application will enter foreground.
    if (!application3) {
        application3 = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:application3];
    }
    
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title =  NSLocalizedString(@"Daily Reminders", @"daily reminders");
}

-(void) viewWillDisappear:(BOOL)animated {
	
	//Scroll keyboard down screen if showing.
	if(minutes.editing){
		[minutes resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
    
	
	//Unregistering keyboard notification.
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification object:nil];
    
    //Empty text fields
    minutes.text = [[[NSString alloc] initWithFormat:@"minutes"] autorelease];
	[super viewWillDisappear:animated];
}

-(void)applicationWillTerminate:(NSNotification *)notification {
	sqlite3_close(database);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - methods for the keyboard scrolling effect.
-(void) keyboardWillShow:(NSNotification *)notif {
	CGRect keyboardEndFrame;
	[[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	CGFloat keyboardSize;
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
		keyboardSize = keyboardEndFrame.size.height;
	}
	else {
		keyboardSize = keyboardEndFrame.size.width;
	}
	
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        if(minutes.editing){
            minutes.text = @"";
            float bottomPoint = (minutes.frame.origin.y +
                                 minutes.frame.size.height);
            scrollAmount = keyboardSize - (411 - bottomPoint);
        }
        
        if(scrollAmount > 0) {
            moveViewUp = YES;
            [self scrollTheView:YES];
        }
        else {
            moveViewUp = NO;
        }
    }
}
- (void) scrollTheView: (BOOL) movedUp {
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];	
	CGRect rect = self.view.frame;
	
	if(movedUp){
		rect.origin.y -= scrollAmount;
	}
	else {
		rect.origin.y += scrollAmount;
	}
	
	self.view.frame = rect;	
	[UIView commitAnimations];	
}

-(BOOL) textFieldShouldReturn: (UITextField *) theTextField {	
	
	[theTextField resignFirstResponder];
	[self becomeFirstResponder];
	
	if(moveViewUp) [self scrollTheView:NO];	
	
	//After keyboard has been set back down, set scroll amount to nil.
	scrollAmount = 0;	
	
	return YES;
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *)event {	
	if(minutes.editing){
		[minutes resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
	}
    
	[super touchesBegan:touches withEvent:event];
}

- (void)dealloc
{
    [super dealloc];
    [createSQL release];
    [createSQL2 release];
    [dailyTableVC release];
    [dailyUp release];
    [earthscreen release];
    [minutes release];
    [stringTimer release];
    [title release];
    [message release];
    [alert release];
    [timer release];
    [tableCellNames release];
    [rowString release];
    [query release];
    [query2 release];
    [query3 release];
    [quoteDB release];
    [quoteString release];
    [quote1 release];
    [quote2 release];
    [quote3 release];
    [quote4 release];
    [quote5 release];
    [quote6 release];
    [quote7 release];
    [quote8 release];
    [quote9 release];
    [quote10 release];
    [quote11 release];
    [quote12 release];
    [quote13 release];
    [quote14 release];
    [now release];
    [originaldate release];
    [dateNew release];
    [numbersSet release];
    [application release];
    [application2 release];
    [application3 release];
    [application4 release];
    [oldNotifications release];
    [newTable release];
    [reminder release];
}


@end
