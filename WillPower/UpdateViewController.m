//
//  UpdateViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "UpdateViewController.h"
#import "WillPowerAppDelegate_iPhone.h"
#import "Singleton.h"

@implementation UpdateViewController
@synthesize keyboardToolbar;

#pragma save function.
-(void) save {
    
    // Check the minutes text has only numbers or '.'
    numbersSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789.N/A"] invertedSet];
    
    if ( ([score1.text stringByTrimmingCharactersInSet:numbersSet].length <= 0) || ([score2.text stringByTrimmingCharactersInSet:numbersSet].length <= 0) || ([rating.text stringByTrimmingCharactersInSet:numbersSet].length <= 0) ){
        
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Notice."];
        message = [[NSString alloc] initWithFormat:
                   @"Please type numbers or decimals for the two scores and rating."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }    
    else {
        
        char *update = "update goals set score1 = ?, score2 = ?,rating = ?, comment = ? where row = ?;";	
        int result1 = [score1.text intValue];
        int result2 = [score2.text intValue];
        int ratingint = [rating.text intValue];
        comment.text = [comment.text lowercaseString];
        
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
            sqlite3_bind_int(stmt, 1, result1);
            sqlite3_bind_int(stmt, 2, result2);
            sqlite3_bind_int(stmt, 3, ratingint);
            sqlite3_bind_text(stmt, 4, [comment.text UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 5, newrownum);
        }
        
        if(sqlite3_step(stmt) != SQLITE_DONE)
           //NSLog(@"statement failed");
        sqlite3_finalize(stmt);
        
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Updated"];
        message = [[NSString alloc] initWithFormat:
                   @"Your log entry has been updated."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"Thanks coach!"
                                 otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma delete log.
-(void)deleteLog{
    // Delete log in DB.
	char *update = "delete from goals where row = ?;";	
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
		sqlite3_bind_int(stmt, 1, newrownum);		
	}
    
    // Check if DB delete functioned
	if(sqlite3_step(stmt) != SQLITE_DONE) {
		//NSLog(@"statement failed");
    }
    else {
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Game Over"];
        message = [[NSString alloc] initWithFormat:
                   @"Your log entry has been deleted."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"Super!"
                                 otherButtonTitles:nil];
        [alert show];
    }
	sqlite3_finalize(stmt);    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma delete goal.
-(void)deleteGoal{
    
    // Delete log in DB.
	char *update = "delete from goals where name = ?;";	
	sqlite3_stmt *stmt;
	if(sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, [nameCheck UTF8String], -1, NULL);
	}
    
    // Check if DB delete functioned
	if(sqlite3_step(stmt) != SQLITE_DONE) {
        //NSLog(@"statement failed");
    }
    else {
        //Alert view message.
        title = [[NSString alloc] initWithFormat:@"Game Over"];
        message = [[NSString alloc] initWithFormat:
                   @"This goal has been deleted from your records."];
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:@"Super!"
                                 otherButtonTitles:nil];
        [alert show];
    }
	sqlite3_finalize(stmt);
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
    newrownum  = (int)[[Singleton sharedSingleton] getnewrownumber];
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        
        iphone4Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,455)];
        iphone4Background.image = [UIImage imageNamed:@"iphone4Background.png"];
        [self.view addSubview:iphone4Background];
        [iphone4Background release];
        
        goalName = [[UILabel alloc] initWithFrame:CGRectMake(20,4,280,21)];
        goalName.numberOfLines = 0;
        goalName.backgroundColor = [UIColor clearColor];
        goalName.textColor = [UIColor yellowColor];
        goalName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [goalName setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:goalName];
        
        goalDate = [[UILabel alloc] initWithFrame:CGRectMake(20,30,185,18)];
        goalDate.numberOfLines = 0;
        goalDate.backgroundColor = [UIColor clearColor];
        goalDate.textColor = [UIColor yellowColor];
        goalDate.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [goalDate setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate];
        
        lblPerformance = [[UILabel alloc] initWithFrame:CGRectMake(21,52,230,18)];
        lblPerformance.numberOfLines = 0;
        lblPerformance.backgroundColor = [UIColor clearColor];
        lblPerformance.textColor = [UIColor whiteColor];
        lblPerformance.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [lblPerformance setTextAlignment:UITextAlignmentLeft];
        lblPerformance.text = @"Performance Rating (1 to 10)";
        [self.view  addSubview:lblPerformance];
        
        rating = [[UITextField alloc]initWithFrame:CGRectMake(259,50,42,31)];
        rating.borderStyle = UITextBorderStyleRoundedRect;
        rating.font = [UIFont systemFontOfSize:15];
        rating.autocorrectionType = UITextAutocorrectionTypeNo;
        rating.keyboardType = UIKeyboardTypeDefault;
        rating.returnKeyType = UIReturnKeyDone;
        rating.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [rating setTextAlignment:UITextAlignmentCenter];
        [rating setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        rating.delegate = self;
        [self.view addSubview:rating];
        
        scoreLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(21,89,230,21)];
        scoreLabel1.numberOfLines = 0;
        scoreLabel1.backgroundColor = [UIColor clearColor];
        scoreLabel1.textColor = [UIColor whiteColor];
        scoreLabel1.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel1 setTextAlignment:UITextAlignmentLeft];
        scoreLabel1.text = @"Label";
        [self.view  addSubview:scoreLabel1];
        
        score1 = [[UITextField alloc]initWithFrame:CGRectMake(259,87,42,31)];
        score1.borderStyle = UITextBorderStyleRoundedRect;
        score1.font = [UIFont systemFontOfSize:15];
        score1.autocorrectionType = UITextAutocorrectionTypeNo;
        score1.keyboardType = UIKeyboardTypeDefault;
        score1.returnKeyType = UIReturnKeyDone;
        score1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [score1 setTextAlignment:UITextAlignmentCenter];
        [score1 setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        score1.delegate = self;
        [self.view addSubview:score1];
        
        scoreLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20,125,230,21)];
        scoreLabel2.numberOfLines = 0;
        scoreLabel2.backgroundColor = [UIColor clearColor];
        scoreLabel2.textColor = [UIColor whiteColor];
        scoreLabel2.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel2 setTextAlignment:UITextAlignmentLeft];
        scoreLabel2.text = @"Label";
        [self.view  addSubview:scoreLabel2];
        
        score2 = [[UITextField alloc]initWithFrame:CGRectMake(259,123,42,31)];
        score2.borderStyle = UITextBorderStyleRoundedRect;
        score2.font = [UIFont systemFontOfSize:15];
        score2.autocorrectionType = UITextAutocorrectionTypeNo;
        score2.keyboardType = UIKeyboardTypeDefault;
        score2.returnKeyType = UIReturnKeyDone;
        score2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        score2.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [score2 setTextAlignment:UITextAlignmentCenter];
        [score2 setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        score2.delegate = self;
        [self.view addSubview:score2];
        
        lblComment = [[UILabel alloc] initWithFrame:CGRectMake(20,154,140,21)];
        lblComment.numberOfLines = 0;
        lblComment.backgroundColor = [UIColor clearColor];
        lblComment.textColor = [UIColor whiteColor];
        lblComment.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [lblComment setTextAlignment:UITextAlignmentLeft];
        lblComment.text = @"Comment";
        [self.view  addSubview:lblComment];
        
        comment = [[UITextField alloc]initWithFrame:CGRectMake(19,176,280,31)];
        comment.borderStyle = UITextBorderStyleRoundedRect;
        comment.font = [UIFont systemFontOfSize:15];
        comment.autocorrectionType = UITextAutocorrectionTypeNo;
        comment.keyboardType = UIKeyboardTypeDefault;
        comment.returnKeyType = UIReturnKeyDone;
        comment.clearButtonMode = UITextFieldViewModeWhileEditing;
        comment.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        comment.autocorrectionType = UITextAutocorrectionTypeNo;
        comment.autocapitalizationType = UITextAutocapitalizationTypeNone;
        comment.delegate = self;
        [self.view addSubview:comment];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSave setFrame:CGRectMake(19,211,282,48)];
        [btnSave setImage:[UIImage imageNamed:@"button-save.png"] forState:UIControlStateNormal];
        [btnSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSave];
        
        btnDeleteResult = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDeleteResult setFrame:CGRectMake(19,263,282,48)];
        [btnDeleteResult setImage:[UIImage imageNamed:@"button-delete-result.png"] forState:UIControlStateNormal];
        [btnDeleteResult addTarget:self action:@selector(deleteLog) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDeleteResult];
        
        btnDeleteGoal = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDeleteGoal setFrame:CGRectMake(19,314,282,48)];
        [btnDeleteGoal setImage:[UIImage imageNamed:@"button-delete-goal.png"] forState:UIControlStateNormal];
        [btnDeleteGoal addTarget:self action:@selector(deleteGoal) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDeleteGoal];
    }
    else{
        iphone5Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,320,455)];
        iphone5Background.image = [UIImage imageNamed:@"iphone5Background.png"];
        [self.view addSubview:iphone5Background];
        [iphone5Background release];
        
        goalName = [[UILabel alloc] initWithFrame:CGRectMake(20,100,280,21)];
        goalName.numberOfLines = 0;
        goalName.backgroundColor = [UIColor clearColor];
        goalName.textColor = [UIColor blackColor];
        goalName.font = [UIFont fontWithName:@"Helvetica" size:18];
        [goalName setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:goalName];
        
        goalDate = [[UILabel alloc] initWithFrame:CGRectMake(20,140,185,18)];
        goalDate.numberOfLines = 0;
        goalDate.backgroundColor = [UIColor clearColor];
        goalDate.textColor = [UIColor blackColor];
        goalDate.font = [UIFont fontWithName:@"Helvetica" size:14];
        [goalDate setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate];
        
        lblPerformance = [[UILabel alloc] initWithFrame:CGRectMake(21,172,230,18)];
        lblPerformance.numberOfLines = 0;
        lblPerformance.backgroundColor = [UIColor clearColor];
        lblPerformance.textColor = [UIColor blackColor];
        lblPerformance.font = [UIFont fontWithName:@"Helvetica" size:14];
        [lblPerformance setTextAlignment:UITextAlignmentLeft];
        lblPerformance.text = @"Performance Rating (1 to 10)";
        [self.view  addSubview:lblPerformance];
        
        rating = [[UITextField alloc]initWithFrame:CGRectMake(259,170,42,31)];
        rating.borderStyle = UITextBorderStyleRoundedRect;
        rating.font = [UIFont systemFontOfSize:15];
        rating.autocorrectionType = UITextAutocorrectionTypeNo;
        rating.keyboardType = UIKeyboardTypeDefault;
        rating.returnKeyType = UIReturnKeyDone;
        rating.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [rating setTextAlignment:UITextAlignmentCenter];
        [rating setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        rating.delegate = self;
        [self.view addSubview:rating];
        
        scoreLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(21,209,230,21)];
        scoreLabel1.numberOfLines = 0;
        scoreLabel1.backgroundColor = [UIColor clearColor];
        scoreLabel1.textColor = [UIColor blackColor];
        scoreLabel1.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel1 setTextAlignment:UITextAlignmentLeft];
        scoreLabel1.text = @"Label";
        [self.view  addSubview:scoreLabel1];
        
        score1 = [[UITextField alloc]initWithFrame:CGRectMake(259,207,42,31)];
        score1.borderStyle = UITextBorderStyleRoundedRect;
        score1.font = [UIFont systemFontOfSize:15];
        score1.autocorrectionType = UITextAutocorrectionTypeNo;
        score1.keyboardType = UIKeyboardTypeDefault;
        score1.returnKeyType = UIReturnKeyDone;
        score1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [score1 setTextAlignment:UITextAlignmentCenter];
        [score1 setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        score1.delegate = self;
        [self.view addSubview:score1];
        
        scoreLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20,245,230,21)];
        scoreLabel2.numberOfLines = 0;
        scoreLabel2.backgroundColor = [UIColor clearColor];
        scoreLabel2.textColor = [UIColor blackColor];
        scoreLabel2.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel2 setTextAlignment:UITextAlignmentLeft];
        scoreLabel2.text = @"Label";
        [self.view  addSubview:scoreLabel2];
        
        score2 = [[UITextField alloc]initWithFrame:CGRectMake(259,243,42,31)];
        score2.borderStyle = UITextBorderStyleRoundedRect;
        score2.font = [UIFont systemFontOfSize:15];
        score2.autocorrectionType = UITextAutocorrectionTypeNo;
        score2.keyboardType = UIKeyboardTypeDefault;
        score2.returnKeyType = UIReturnKeyDone;
        score2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        score2.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [score2 setTextAlignment:UITextAlignmentCenter];
        [score2 setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        score2.delegate = self;
        [self.view addSubview:score2];
        
        lblComment = [[UILabel alloc] initWithFrame:CGRectMake(20,279,140,21)];
        lblComment.numberOfLines = 0;
        lblComment.backgroundColor = [UIColor clearColor];
        lblComment.textColor = [UIColor blackColor];
        lblComment.font = [UIFont fontWithName:@"Helvetica" size:14];
        [lblComment setTextAlignment:UITextAlignmentLeft];
        lblComment.text = @"Comment";
        [self.view  addSubview:lblComment];
        
        comment = [[UITextField alloc]initWithFrame:CGRectMake(19,301,280,31)];
        comment.borderStyle = UITextBorderStyleRoundedRect;
        comment.font = [UIFont systemFontOfSize:15];
        comment.autocorrectionType = UITextAutocorrectionTypeNo;
        comment.keyboardType = UIKeyboardTypeDefault;
        comment.returnKeyType = UIReturnKeyDone;
        comment.clearButtonMode = UITextFieldViewModeWhileEditing;
        comment.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        comment.autocorrectionType = UITextAutocorrectionTypeNo;
        comment.autocapitalizationType = UITextAutocapitalizationTypeNone;
        comment.delegate = self;
        [self.view addSubview:comment];
        
        btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSave setFrame:CGRectMake(19,351,282,48)];
        [btnSave setTitle:@"Update Result" forState:UIControlStateNormal];
        [btnSave setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnSave];
        
        btnDeleteResult = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDeleteResult setFrame:CGRectMake(19,400,282,48)];
        [btnDeleteResult setTitle:@"Delete Result" forState:UIControlStateNormal];
        [btnDeleteResult setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnDeleteResult addTarget:self action:@selector(deleteLog) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDeleteResult];
        
        btnDeleteGoal = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDeleteGoal setFrame:CGRectMake(19,449,282,48)];
        [btnDeleteGoal setTitle:@"Delete Goal" forState:UIControlStateNormal];
        [btnDeleteGoal setTitleColor:[UIColor colorWithRed:0.00 green:.478 blue:1.0 alpha:1] forState:UIControlStateNormal];
        [btnDeleteGoal addTarget:self action:@selector(deleteGoal) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDeleteGoal];
    }
    
    //Registering a notification when keyboard will show.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:self.view.window];
    
    app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app];
    
	
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
    
	// Run the database search.
	query = [[[NSString alloc] initWithFormat: @"SELECT name, date,scoretitle1, score1, scoretitle2, score2,rating, comment FROM goals where row = %i",newrownum] autorelease];
    
    //NSLog(@"query in update view - %@",query);
    
    sqlite3_stmt *statement;    
    if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
        while(sqlite3_step(statement) == SQLITE_ROW){
            nameChosen = (char *)sqlite3_column_text(statement, 0);
            //NSLog(@"name chosen in every log view is  %s", nameChosen);
            nameCheck = [[NSString alloc] initWithFormat:@"%s",nameChosen];
            //NSLog(@"name check in every log method in result view is  %@", nameCheck);
            
            dateInDatabase = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_double(statement, 1)];
            formatter = [[[NSDateFormatter alloc] init] autorelease];
            [formatter setDateFormat:@"MMMM dd yyyy"];
            strSelectedTime = [formatter stringFromDate:dateInDatabase];	    
            //NSLog(@"date from database: %@", strSelectedTime); 

            char *scti1 = (char *)sqlite3_column_text(statement, 2);
            int scor1 = sqlite3_column_int(statement, 3);
            char *scti2 = (char *)sqlite3_column_text(statement, 4);
            int scor2 = sqlite3_column_int(statement, 5);
            int rat = sqlite3_column_int(statement, 6);
            char *comm = (char *)sqlite3_column_text(statement, 7);
            
            // Capitalize the first letter of words.
            capitalizedName = [[NSString stringWithFormat: @"%s",nameChosen] capitalizedString];            
            capitalizedDate = [[NSString stringWithFormat: @"%@",strSelectedTime] capitalizedString];
            capitalizedScoreTitle1 = [[NSString stringWithFormat: @"%s",scti1] capitalizedString];            
            capitalizedScoreTitle2 = [[NSString stringWithFormat: @"%s",scti2] capitalizedString];
            capitalizedComment = [[NSString stringWithFormat: @"%s",comm] capitalizedString];
            
            //If there is no name for label 1.
            if([capitalizedScoreTitle1 isEqualToString:@"N/A"]){
                score1.text = @"N/A";
            }
            else{
                score1.text = [[[NSString alloc] initWithFormat:@"%i",scor1] autorelease];
            }
            
            //If there is no name for label 2.
            if([capitalizedScoreTitle2 isEqualToString:@"N/A"]){
                score2.text = @"N/A";
            }
            else{
                score2.text = [[[NSString alloc] initWithFormat:@"%i",scor2] autorelease];
            }
            
            //Fill out text fields
            scoreLabel1.text = [[[NSString alloc] initWithFormat:@"%@",capitalizedScoreTitle1] autorelease];
            scoreLabel2.text = [[[NSString alloc] initWithFormat:@"%@",capitalizedScoreTitle2] autorelease];
            goalName.text = [[[NSString alloc] initWithFormat:@"%@",capitalizedName] autorelease];
            goalDate.text = [[[NSString alloc] initWithFormat:@"%@",capitalizedDate] autorelease];
            comment.text = [[[NSString alloc] initWithFormat:@"%@",capitalizedComment] autorelease];
            rating.text = [[[NSString alloc] initWithFormat:@"%i",rat] autorelease];
        }
        sqlite3_finalize(statement);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  NSLocalizedString(@"Update Log Details", @"update log details");
    
    //Set up the keyboard toolbar.
    if(keyboardToolbar == nil) {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousField:)];
        
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextField:)];
        
        previousButton.width = 77.0f;
        nextButton.width = 77.0f;
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard:)];
        
        [keyboardToolbar setItems:[[[NSArray alloc] initWithObjects:previousButton,nextButton,extraSpace,doneButton,nil] autorelease]];
        
        [previousButton release];
        [nextButton release];
        [extraSpace release];
        [doneButton release];
    }
    
    score1.inputAccessoryView = keyboardToolbar;
    score2.inputAccessoryView = keyboardToolbar;
    rating.inputAccessoryView = keyboardToolbar;
    comment.inputAccessoryView = keyboardToolbar;
}

// If 'done' is clicked.
-(void) resignKeyboard:(id)sender {
    
    // If goal has the keyboard, we want to resign the keyboard to disappear because 'done' was clicked.
    if ([score1 isFirstResponder]) {
        [score1 resignFirstResponder];
        [self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
    }
    else if ([score2 isFirstResponder]) {
        [score2 resignFirstResponder];
        [self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
    }
    else if ([rating isFirstResponder]) {
        [rating resignFirstResponder];
        [self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
    }
    else if ([comment isFirstResponder]) {
        [comment resignFirstResponder];
        [self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
    }
}

-(void) previousField:(id)sender {
    
    if ([rating isFirstResponder]) {
        [comment becomeFirstResponder];
    }
    else if ([score1 isFirstResponder]) {
        [rating becomeFirstResponder];
    }
    else if ([score2 isFirstResponder]) {
        [score1 becomeFirstResponder];
    }
    else if ([comment isFirstResponder]) {
        [score2 becomeFirstResponder];
    }
}

-(void) nextField:(id)sender {
    
    if ([rating isFirstResponder]) {
        [score1 becomeFirstResponder];
    }
    else if ([score1 isFirstResponder]) {
        [score2 becomeFirstResponder];
    }
    else if ([score2 isFirstResponder]) {
        [comment becomeFirstResponder];
    }
    else if ([comment isFirstResponder]) {
        [rating becomeFirstResponder];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
	
	//Scroll keyboard down screen if showing.
	if(score1.editing){
		[score1 resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
	else if(score2.editing){
		[score2 resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
	else if(rating.editing){
		[rating resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
    else if(comment.editing){
		[comment resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
    
	
	//Unregistering keyboard notification.
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIKeyboardWillShowNotification object:nil];
    
    //Empty text fields
    goalName.text = @"";
    goalDate.text = @"";
    comment.text = @"";
    score1.text = @"";
    score2.text = @"";
    rating.text = @"";
    scoreLabel1.text = @"";
    scoreLabel2.text = @"";
	
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
	if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
		keyboardSize = keyboardEndFrame.size.height;
	}
	else {
		keyboardSize = keyboardEndFrame.size.width;
	}
	
    [[Singleton sharedSingleton] setkeyboardsize:keyboardSize];
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        if(rating.editing){
            float bottomPoint = (rating.frame.origin.y +
                                 rating.frame.size.height);
            scrollAmount = keyboardSize - (411 - bottomPoint);
        }
        else if(score1.editing){
            float bottomPoint = (score1.frame.origin.y +
                                 score1.frame.size.height);
            scrollAmount = keyboardSize - (411 - bottomPoint);
        }
        else if(score2.editing){
            float bottomPoint = (score2.frame.origin.y +
                                 score2.frame.size.height);
            scrollAmount = keyboardSize - (411 - bottomPoint);
        }
        else if(comment.editing){
            float bottomPoint = (comment.frame.origin.y +
                                 comment.frame.size.height);
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
        if (scrollAmount > 0) {
            //if there was an existing scroll amount, then move keyboard back whole way.
            rect.origin.y += scrollAmount;
        }
	}
	
	self.view.frame = rect;	
	[UIView commitAnimations];	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    keyboardSize = (int)[[Singleton sharedSingleton] getkeyboardsize];
    
    // Keyboard just appeared.
    if (keyboardSize == 0) {
        keyboardJustAppeared = true;
    }
    else {
        keyboardJustAppeared = false;
    }
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        if(rating.editing){
            // Get the existing scroll amount.
            if (scrollAmount  > 0) {
                scrollAmount = -scrollAmount;
            }
            else {
                scrollAmount = 0;
            }
        }
        else if(score1.editing){
            scrollAmount = 0;
        }
        else if(score2.editing){
            // Get the existing scroll amount.
            if (scrollAmount  > 0) {
                scrollAmount = -scrollAmount;
            }
            else {
                scrollAmount = 0;
            }
        }
        else if(comment.editing){
            // Get the existing scroll amount.
            if (scrollAmount < 0) {
                scrollAmount = -scrollAmount;
            }
            else {
                float bottomPoint = (comment.frame.origin.y +
                                     comment.frame.size.height);
                scrollAmount = keyboardSize - (411 - bottomPoint);
            }
        }
        
        if (keyboardJustAppeared == true) {
            moveViewUp = NO;
        }
        else {
            moveViewUp = YES;
            [self scrollTheView:YES];
        }
    }
}

-(BOOL) textFieldShouldReturn: (UITextField *) theTextField {	
	
	[theTextField resignFirstResponder];
	[self becomeFirstResponder];
	
	if(moveViewUp) [self scrollTheView:NO];	
	
	//After keyboard has been set back down, set scroll amount to nil.
	scrollAmount = 0;
    [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	
	return YES;
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *)event {	
	if(score1.editing){
		[score1 resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
    else if(score2.editing){
		[score2 resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
	}
    else if(rating.editing){
		[rating resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
        
        //After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];
    }
    else if(comment.editing){
		[comment resignFirstResponder];
		[self becomeFirstResponder];
		if(moveViewUp) [self scrollTheView:NO];	
		
		//After keyboard has been set back down, set scroll amount to nil.
		scrollAmount = 0;
        [[Singleton sharedSingleton] setkeyboardsize:scrollAmount];        
	}
    
	[super touchesBegan:touches withEvent:event];
}

- (void)dealloc
{
    [super dealloc];
    [query release];
    [query2 release];
    [numbersSet release];
    [title release];
    [message release];
    [alert release];
    [nameCheck release];
    [dateInDatabase release];
    [strSelectedTime release];
    [formatter release];
    [capitalizedName release];
    [capitalizedDate release];
    [capitalizedScoreTitle1 release];
    [capitalizedScoreTitle2 release];
    [capitalizedComment release];
    [goalName release];
    [goalDate release];
    [scoreLabel1 release];
    [score1 release];
    [scoreLabel2 release];
    [score2 release];
    [rating release];
    [comment release];
    [app release];
    [keyboardToolbar release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
