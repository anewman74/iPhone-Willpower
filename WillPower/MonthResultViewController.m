//
//  MonthResultViewController.m
//  WillPower
//
//  Created by Andrew Newman and Stephen Kaiser on 7/7/12.
//  Copyright 2012 The Infinite 3. All rights reserved.
//

#import "MonthResultViewController.h"
#import "Singleton.h"

@implementation MonthResultViewController

#pragma mark - View lifecycle.
-(void)viewWillAppear:(BOOL)animated {
    
    // Date formatter
    formatter = [[[NSDateFormatter alloc] init] autorelease]; 
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    float screensize = [[UIScreen mainScreen] bounds].size.height;
    if ((int)screensize == 480) {
        
        iphone4Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,455)];
        iphone4Background.image = [UIImage imageNamed:@"iphone4Background.png"];
        [self.view addSubview:iphone4Background];
        [iphone4Background release];
        
        goalName = [[UILabel alloc] initWithFrame:CGRectMake(11,7,280,21)];
        goalName.numberOfLines = 0;
        goalName.backgroundColor = [UIColor clearColor];
        goalName.textColor = [UIColor yellowColor];
        goalName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        [goalName setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:goalName];
        
        subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,38,320,16)];
        subtitle.numberOfLines = 0;
        subtitle.text = @"* Total monthly scores and average daily rating.";
        subtitle.backgroundColor = [UIColor clearColor];
        subtitle.textColor = [UIColor yellowColor];
        subtitle.font = [UIFont fontWithName:@"Helvetica" size:13];
        [subtitle setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:subtitle];
        
        datetitle = [[UILabel alloc] initWithFrame:CGRectMake(11,64,69,22)];
        datetitle.numberOfLines = 0;
        datetitle.text = @"Month:";
        datetitle.backgroundColor = [UIColor clearColor];
        datetitle.textColor = [UIColor yellowColor];
        datetitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [datetitle setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:datetitle];
        
        scoreLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(86,64,75,22)];
        scoreLabel1.numberOfLines = 0;
        scoreLabel1.backgroundColor = [UIColor clearColor];
        scoreLabel1.textColor = [UIColor yellowColor];
        scoreLabel1.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [scoreLabel1 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel1];
        
        scoreLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(170,64,75,22)];
        scoreLabel2.numberOfLines = 0;
        scoreLabel2.backgroundColor = [UIColor clearColor];
        scoreLabel2.textColor = [UIColor yellowColor];
        scoreLabel2.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [scoreLabel2 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel2];
        
        rating = [[UILabel alloc] initWithFrame:CGRectMake(265,64,42,22)];
        rating.numberOfLines = 0;
        rating.backgroundColor = [UIColor clearColor];
        rating.textColor = [UIColor yellowColor];
        rating.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [rating setTextAlignment:UITextAlignmentCenter];
        rating.text = @"Rating";
        [self.view  addSubview:rating];
        
        goalDate1 = [[UILabel alloc] initWithFrame:CGRectMake(11,101,69,22)];
        goalDate1.numberOfLines = 0;
        goalDate1.backgroundColor = [UIColor clearColor];
        goalDate1.textColor = [UIColor whiteColor];
        goalDate1.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [goalDate1 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate1];
        
        scoreLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(86,101,76,22)];
        scoreLabel11.numberOfLines = 0;
        scoreLabel11.backgroundColor = [UIColor clearColor];
        scoreLabel11.textColor = [UIColor whiteColor];
        scoreLabel11.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel11 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel11];
        
        scoreLabel21 = [[UILabel alloc] initWithFrame:CGRectMake(170,101,76,22)];
        scoreLabel21.numberOfLines = 0;
        scoreLabel21.backgroundColor = [UIColor clearColor];
        scoreLabel21.textColor = [UIColor whiteColor];
        scoreLabel21.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel21 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel21];
        
        rating1 = [[UILabel alloc] initWithFrame:CGRectMake(265,101,42,22)];
        rating1.numberOfLines = 0;
        rating1.backgroundColor = [UIColor clearColor];
        rating1.textColor = [UIColor whiteColor];
        rating1.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [rating1 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating1];
        
        goalDate2 = [[UILabel alloc] initWithFrame:CGRectMake(11,138,69,22)];
        goalDate2.numberOfLines = 0;
        goalDate2.backgroundColor = [UIColor clearColor];
        goalDate2.textColor = [UIColor whiteColor];
        goalDate2.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [goalDate2 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate2];
        
        scoreLabel12 = [[UILabel alloc] initWithFrame:CGRectMake(86,138,76,22)];
        scoreLabel12.numberOfLines = 0;
        scoreLabel12.backgroundColor = [UIColor clearColor];
        scoreLabel12.textColor = [UIColor whiteColor];
        scoreLabel12.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel12 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel12];
        
        scoreLabel22 = [[UILabel alloc] initWithFrame:CGRectMake(170,138,76,22)];
        scoreLabel22.numberOfLines = 0;
        scoreLabel22.backgroundColor = [UIColor clearColor];
        scoreLabel22.textColor = [UIColor whiteColor];
        scoreLabel22.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel22 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel22];
        
        rating2 = [[UILabel alloc] initWithFrame:CGRectMake(265,138,42,22)];
        rating2.numberOfLines = 0;
        rating2.backgroundColor = [UIColor clearColor];
        rating2.textColor = [UIColor whiteColor];
        rating2.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [rating2 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating2];
        
        goalDate3 = [[UILabel alloc] initWithFrame:CGRectMake(11,175,69,22)];
        goalDate3.numberOfLines = 0;
        goalDate3.backgroundColor = [UIColor clearColor];
        goalDate3.textColor = [UIColor whiteColor];
        goalDate3.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [goalDate3 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate3];
        
        scoreLabel13 = [[UILabel alloc] initWithFrame:CGRectMake(86,175,76,22)];
        scoreLabel13.numberOfLines = 0;
        scoreLabel13.backgroundColor = [UIColor clearColor];
        scoreLabel13.textColor = [UIColor whiteColor];
        scoreLabel13.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel13 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel13];
        
        scoreLabel23 = [[UILabel alloc] initWithFrame:CGRectMake(170,175,76,22)];
        scoreLabel23.numberOfLines = 0;
        scoreLabel23.backgroundColor = [UIColor clearColor];
        scoreLabel23.textColor = [UIColor whiteColor];
        scoreLabel23.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel23 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel23];
        
        rating3 = [[UILabel alloc] initWithFrame:CGRectMake(265,175,42,22)];
        rating3.numberOfLines = 0;
        rating3.backgroundColor = [UIColor clearColor];
        rating3.textColor = [UIColor whiteColor];
        rating3.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [rating3 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating3];
        
        goalDate4 = [[UILabel alloc] initWithFrame:CGRectMake(11,212,69,22)];
        goalDate4.numberOfLines = 0;
        goalDate4.backgroundColor = [UIColor clearColor];
        goalDate4.textColor = [UIColor whiteColor];
        goalDate4.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [goalDate4 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate4];
        
        scoreLabel14 = [[UILabel alloc] initWithFrame:CGRectMake(86,212,76,22)];
        scoreLabel14.numberOfLines = 0;
        scoreLabel14.backgroundColor = [UIColor clearColor];
        scoreLabel14.textColor = [UIColor whiteColor];
        scoreLabel14.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel14 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel14];
        
        scoreLabel24 = [[UILabel alloc] initWithFrame:CGRectMake(170,212,76,22)];
        scoreLabel24.numberOfLines = 0;
        scoreLabel24.backgroundColor = [UIColor clearColor];
        scoreLabel24.textColor = [UIColor whiteColor];
        scoreLabel24.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel24 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel24];
        
        rating4 = [[UILabel alloc] initWithFrame:CGRectMake(265,212,42,22)];
        rating4.numberOfLines = 0;
        rating4.backgroundColor = [UIColor clearColor];
        rating4.textColor = [UIColor whiteColor];
        rating4.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [rating4 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating4];
        
        goalDate5 = [[UILabel alloc] initWithFrame:CGRectMake(11,249,69,22)];
        goalDate5.numberOfLines = 0;
        goalDate5.backgroundColor = [UIColor clearColor];
        goalDate5.textColor = [UIColor whiteColor];
        goalDate5.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [goalDate5 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate5];
        
        scoreLabel15 = [[UILabel alloc] initWithFrame:CGRectMake(86,249,76,22)];
        scoreLabel15.numberOfLines = 0;
        scoreLabel15.backgroundColor = [UIColor clearColor];
        scoreLabel15.textColor = [UIColor whiteColor];
        scoreLabel15.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel15 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel15];
        
        scoreLabel25 = [[UILabel alloc] initWithFrame:CGRectMake(170,249,76,22)];
        scoreLabel25.numberOfLines = 0;
        scoreLabel25.backgroundColor = [UIColor clearColor];
        scoreLabel25.textColor = [UIColor whiteColor];
        scoreLabel25.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel25 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel25];
        
        rating5 = [[UILabel alloc] initWithFrame:CGRectMake(265,249,42,22)];
        rating5.numberOfLines = 0;
        rating5.backgroundColor = [UIColor clearColor];
        rating5.textColor = [UIColor whiteColor];
        rating5.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [rating5 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating5];
        
        goalDate6 = [[UILabel alloc] initWithFrame:CGRectMake(11,286,69,22)];
        goalDate6.numberOfLines = 0;
        goalDate6.backgroundColor = [UIColor clearColor];
        goalDate6.textColor = [UIColor whiteColor];
        goalDate6.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [goalDate6 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate6];
        
        scoreLabel16 = [[UILabel alloc] initWithFrame:CGRectMake(86,286,76,22)];
        scoreLabel16.numberOfLines = 0;
        scoreLabel16.backgroundColor = [UIColor clearColor];
        scoreLabel16.textColor = [UIColor whiteColor];
        scoreLabel16.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel16 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel16];
        
        scoreLabel26 = [[UILabel alloc] initWithFrame:CGRectMake(170,286,76,22)];
        scoreLabel26.numberOfLines = 0;
        scoreLabel26.backgroundColor = [UIColor clearColor];
        scoreLabel26.textColor = [UIColor whiteColor];
        scoreLabel26.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel26 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel26];
        
        rating6 = [[UILabel alloc] initWithFrame:CGRectMake(265,286,42,22)];
        rating6.numberOfLines = 0;
        rating6.backgroundColor = [UIColor clearColor];
        rating6.textColor = [UIColor whiteColor];
        rating6.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [rating6 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating6];
        
        goalDate7 = [[UILabel alloc] initWithFrame:CGRectMake(11,323,69,22)];
        goalDate7.numberOfLines = 0;
        goalDate7.backgroundColor = [UIColor clearColor];
        goalDate7.textColor = [UIColor whiteColor];
        goalDate7.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
        [goalDate7 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate7];
        
        scoreLabel17 = [[UILabel alloc] initWithFrame:CGRectMake(86,323,76,22)];
        scoreLabel17.numberOfLines = 0;
        scoreLabel17.backgroundColor = [UIColor clearColor];
        scoreLabel17.textColor = [UIColor whiteColor];
        scoreLabel17.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel17 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel17];
        
        scoreLabel27 = [[UILabel alloc] initWithFrame:CGRectMake(170,323,76,22)];
        scoreLabel27.numberOfLines = 0;
        scoreLabel27.backgroundColor = [UIColor clearColor];
        scoreLabel27.textColor = [UIColor whiteColor];
        scoreLabel27.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [scoreLabel27 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel27];
        
        rating7 = [[UILabel alloc] initWithFrame:CGRectMake(265,323,42,22)];
        rating7.numberOfLines = 0;
        rating7.backgroundColor = [UIColor clearColor];
        rating7.textColor = [UIColor whiteColor];
        rating7.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [rating7 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating7];
    }
    else {
        iphone5Background = [[UIImageView alloc] initWithFrame:CGRectMake(0,65,320,455)];
        iphone5Background.image = [UIImage imageNamed:@"iphone5Background.png"];
        [self.view addSubview:iphone5Background];
        [iphone5Background release];
        
        goalName = [[UILabel alloc] initWithFrame:CGRectMake(11,100,280,21)];
        goalName.numberOfLines = 0;
        goalName.backgroundColor = [UIColor clearColor];
        goalName.textColor = [UIColor blackColor];
        goalName.font = [UIFont fontWithName:@"Helvetica" size:18];
        [goalName setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:goalName];
        
        subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0,131,320,16)];
        subtitle.numberOfLines = 0;
        subtitle.text = @"* Total monthly scores and average daily rating.";
        subtitle.backgroundColor = [UIColor clearColor];
        subtitle.textColor = [UIColor blackColor];
        subtitle.font = [UIFont fontWithName:@"Helvetica" size:13];
        [subtitle setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:subtitle];
        
        datetitle = [[UILabel alloc] initWithFrame:CGRectMake(11,167,69,22)];
        datetitle.numberOfLines = 0;
        datetitle.text = @"Month:";
        datetitle.backgroundColor = [UIColor clearColor];
        datetitle.textColor = [UIColor blackColor];
        datetitle.font = [UIFont fontWithName:@"Helvetica" size:11];
        [datetitle setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:datetitle];
        
        scoreLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(86,167,75,22)];
        scoreLabel1.numberOfLines = 0;
        scoreLabel1.backgroundColor = [UIColor clearColor];
        scoreLabel1.textColor = [UIColor blackColor];
        scoreLabel1.font = [UIFont fontWithName:@"Helvetica" size:11];
        [scoreLabel1 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel1];
        
        scoreLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(170,167,75,22)];
        scoreLabel2.numberOfLines = 0;
        scoreLabel2.backgroundColor = [UIColor clearColor];
        scoreLabel2.textColor = [UIColor blackColor];
        scoreLabel2.font = [UIFont fontWithName:@"Helvetica" size:11];
        [scoreLabel2 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel2];
        
        rating = [[UILabel alloc] initWithFrame:CGRectMake(265,167,42,22)];
        rating.numberOfLines = 0;
        rating.backgroundColor = [UIColor clearColor];
        rating.textColor = [UIColor blackColor];
        rating.font = [UIFont fontWithName:@"Helvetica" size:11];
        [rating setTextAlignment:UITextAlignmentCenter];
        rating.text = @"Rating";
        [self.view  addSubview:rating];
        
        goalDate1 = [[UILabel alloc] initWithFrame:CGRectMake(11,209,69,22)];
        goalDate1.numberOfLines = 0;
        goalDate1.backgroundColor = [UIColor clearColor];
        goalDate1.textColor = [UIColor blackColor];
        goalDate1.font = [UIFont fontWithName:@"Helvetica" size:11];
        [goalDate1 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate1];
        
        scoreLabel11 = [[UILabel alloc] initWithFrame:CGRectMake(86,209,76,22)];
        scoreLabel11.numberOfLines = 0;
        scoreLabel11.backgroundColor = [UIColor clearColor];
        scoreLabel11.textColor = [UIColor blackColor];
        scoreLabel11.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel11 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel11];
        
        scoreLabel21 = [[UILabel alloc] initWithFrame:CGRectMake(170,209,76,22)];
        scoreLabel21.numberOfLines = 0;
        scoreLabel21.backgroundColor = [UIColor clearColor];
        scoreLabel21.textColor = [UIColor blackColor];
        scoreLabel21.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel21 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel21];
        
        rating1 = [[UILabel alloc] initWithFrame:CGRectMake(265,209,42,22)];
        rating1.numberOfLines = 0;
        rating1.backgroundColor = [UIColor clearColor];
        rating1.textColor = [UIColor blackColor];
        rating1.font = [UIFont fontWithName:@"Helvetica" size:14];
        [rating1 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating1];
        
        goalDate2 = [[UILabel alloc] initWithFrame:CGRectMake(11,251,69,22)];
        goalDate2.numberOfLines = 0;
        goalDate2.backgroundColor = [UIColor clearColor];
        goalDate2.textColor = [UIColor blackColor];
        goalDate2.font = [UIFont fontWithName:@"Helvetica" size:11];
        [goalDate2 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate2];
        
        scoreLabel12 = [[UILabel alloc] initWithFrame:CGRectMake(86,251,76,22)];
        scoreLabel12.numberOfLines = 0;
        scoreLabel12.backgroundColor = [UIColor clearColor];
        scoreLabel12.textColor = [UIColor blackColor];
        scoreLabel12.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel12 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel12];
        
        scoreLabel22 = [[UILabel alloc] initWithFrame:CGRectMake(170,251,76,22)];
        scoreLabel22.numberOfLines = 0;
        scoreLabel22.backgroundColor = [UIColor clearColor];
        scoreLabel22.textColor = [UIColor blackColor];
        scoreLabel22.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel22 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel22];
        
        rating2 = [[UILabel alloc] initWithFrame:CGRectMake(265,251,42,22)];
        rating2.numberOfLines = 0;
        rating2.backgroundColor = [UIColor clearColor];
        rating2.textColor = [UIColor blackColor];
        rating2.font = [UIFont fontWithName:@"Helvetica" size:14];
        [rating2 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating2];
        
        goalDate3 = [[UILabel alloc] initWithFrame:CGRectMake(11,293,69,22)];
        goalDate3.numberOfLines = 0;
        goalDate3.backgroundColor = [UIColor clearColor];
        goalDate3.textColor = [UIColor blackColor];
        goalDate3.font = [UIFont fontWithName:@"Helvetica" size:11];
        [goalDate3 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate3];
        
        scoreLabel13 = [[UILabel alloc] initWithFrame:CGRectMake(86,293,76,22)];
        scoreLabel13.numberOfLines = 0;
        scoreLabel13.backgroundColor = [UIColor clearColor];
        scoreLabel13.textColor = [UIColor blackColor];
        scoreLabel13.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel13 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel13];
        
        scoreLabel23 = [[UILabel alloc] initWithFrame:CGRectMake(170,293,76,22)];
        scoreLabel23.numberOfLines = 0;
        scoreLabel23.backgroundColor = [UIColor clearColor];
        scoreLabel23.textColor = [UIColor blackColor];
        scoreLabel23.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel23 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel23];
        
        rating3 = [[UILabel alloc] initWithFrame:CGRectMake(265,293,42,22)];
        rating3.numberOfLines = 0;
        rating3.backgroundColor = [UIColor clearColor];
        rating3.textColor = [UIColor blackColor];
        rating3.font = [UIFont fontWithName:@"Helvetica" size:14];
        [rating3 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating3];
        
        goalDate4 = [[UILabel alloc] initWithFrame:CGRectMake(11,335,69,22)];
        goalDate4.numberOfLines = 0;
        goalDate4.backgroundColor = [UIColor clearColor];
        goalDate4.textColor = [UIColor blackColor];
        goalDate4.font = [UIFont fontWithName:@"Helvetica" size:11];
        [goalDate4 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate4];
        
        scoreLabel14 = [[UILabel alloc] initWithFrame:CGRectMake(86,335,76,22)];
        scoreLabel14.numberOfLines = 0;
        scoreLabel14.backgroundColor = [UIColor clearColor];
        scoreLabel14.textColor = [UIColor blackColor];
        scoreLabel14.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel14 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel14];
        
        scoreLabel24 = [[UILabel alloc] initWithFrame:CGRectMake(170,335,76,22)];
        scoreLabel24.numberOfLines = 0;
        scoreLabel24.backgroundColor = [UIColor clearColor];
        scoreLabel24.textColor = [UIColor blackColor];
        scoreLabel24.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel24 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel24];
        
        rating4 = [[UILabel alloc] initWithFrame:CGRectMake(265,335,42,22)];
        rating4.numberOfLines = 0;
        rating4.backgroundColor = [UIColor clearColor];
        rating4.textColor = [UIColor blackColor];
        rating4.font = [UIFont fontWithName:@"Helvetica" size:14];
        [rating4 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating4];
        
        goalDate5 = [[UILabel alloc] initWithFrame:CGRectMake(11,377,69,22)];
        goalDate5.numberOfLines = 0;
        goalDate5.backgroundColor = [UIColor clearColor];
        goalDate5.textColor = [UIColor blackColor];
        goalDate5.font = [UIFont fontWithName:@"Helvetica" size:11];
        [goalDate5 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate5];
        
        scoreLabel15 = [[UILabel alloc] initWithFrame:CGRectMake(86,377,76,22)];
        scoreLabel15.numberOfLines = 0;
        scoreLabel15.backgroundColor = [UIColor clearColor];
        scoreLabel15.textColor = [UIColor blackColor];
        scoreLabel15.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel15 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel15];
        
        scoreLabel25 = [[UILabel alloc] initWithFrame:CGRectMake(170,377,76,22)];
        scoreLabel25.numberOfLines = 0;
        scoreLabel25.backgroundColor = [UIColor clearColor];
        scoreLabel25.textColor = [UIColor blackColor];
        scoreLabel25.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel25 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel25];
        
        rating5 = [[UILabel alloc] initWithFrame:CGRectMake(265,377,42,22)];
        rating5.numberOfLines = 0;
        rating5.backgroundColor = [UIColor clearColor];
        rating5.textColor = [UIColor blackColor];
        rating5.font = [UIFont fontWithName:@"Helvetica" size:14];
        [rating5 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating5];
        
        goalDate6 = [[UILabel alloc] initWithFrame:CGRectMake(11,419,69,22)];
        goalDate6.numberOfLines = 0;
        goalDate6.backgroundColor = [UIColor clearColor];
        goalDate6.textColor = [UIColor blackColor];
        goalDate6.font = [UIFont fontWithName:@"Helvetica" size:11];
        [goalDate6 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate6];
        
        scoreLabel16 = [[UILabel alloc] initWithFrame:CGRectMake(86,419,76,22)];
        scoreLabel16.numberOfLines = 0;
        scoreLabel16.backgroundColor = [UIColor clearColor];
        scoreLabel16.textColor = [UIColor blackColor];
        scoreLabel16.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel16 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel16];
        
        scoreLabel26 = [[UILabel alloc] initWithFrame:CGRectMake(170,419,76,22)];
        scoreLabel26.numberOfLines = 0;
        scoreLabel26.backgroundColor = [UIColor clearColor];
        scoreLabel26.textColor = [UIColor blackColor];
        scoreLabel26.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel26 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel26];
        
        rating6 = [[UILabel alloc] initWithFrame:CGRectMake(265,419,42,22)];
        rating6.numberOfLines = 0;
        rating6.backgroundColor = [UIColor clearColor];
        rating6.textColor = [UIColor blackColor];
        rating6.font = [UIFont fontWithName:@"Helvetica" size:14];
        [rating6 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating6];
        
        goalDate7 = [[UILabel alloc] initWithFrame:CGRectMake(11,461,69,22)];
        goalDate7.numberOfLines = 0;
        goalDate7.backgroundColor = [UIColor clearColor];
        goalDate7.textColor = [UIColor blackColor];
        goalDate7.font = [UIFont fontWithName:@"Helvetica" size:11];
        [goalDate7 setTextAlignment:UITextAlignmentLeft];
        [self.view  addSubview:goalDate7];
        
        scoreLabel17 = [[UILabel alloc] initWithFrame:CGRectMake(86,461,76,22)];
        scoreLabel17.numberOfLines = 0;
        scoreLabel17.backgroundColor = [UIColor clearColor];
        scoreLabel17.textColor = [UIColor blackColor];
        scoreLabel17.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel17 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel17];
        
        scoreLabel27 = [[UILabel alloc] initWithFrame:CGRectMake(170,461,76,22)];
        scoreLabel27.numberOfLines = 0;
        scoreLabel27.backgroundColor = [UIColor clearColor];
        scoreLabel27.textColor = [UIColor blackColor];
        scoreLabel27.font = [UIFont fontWithName:@"Helvetica" size:14];
        [scoreLabel27 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:scoreLabel27];
        
        rating7 = [[UILabel alloc] initWithFrame:CGRectMake(265,461,42,22)];
        rating7.numberOfLines = 0;
        rating7.backgroundColor = [UIColor clearColor];
        rating7.textColor = [UIColor blackColor];
        rating7.font = [UIFont fontWithName:@"Helvetica" size:14];
        [rating7 setTextAlignment:UITextAlignmentCenter];
        [self.view  addSubview:rating7];
    }
    
    // Clear the labels
    goalName.text = [NSString stringWithFormat:@""];
    scoreLabel1.text = [NSString stringWithFormat:@""];   
    scoreLabel2.text = [NSString stringWithFormat:@""];
    
    goalDate1.text = [NSString stringWithFormat:@""];
    scoreLabel11.text = [NSString stringWithFormat:@""];
    scoreLabel21.text = [NSString stringWithFormat:@""];
    rating1.text = [NSString stringWithFormat:@""];
    
    goalDate2.text = [NSString stringWithFormat:@""];
    scoreLabel12.text = [NSString stringWithFormat:@""];
    scoreLabel22.text = [NSString stringWithFormat:@""];
    rating2.text = [NSString stringWithFormat:@""];
    
    goalDate3.text = [NSString stringWithFormat:@""];
    scoreLabel13.text = [NSString stringWithFormat:@""];
    scoreLabel23.text = [NSString stringWithFormat:@""];
    rating3.text = [NSString stringWithFormat:@""];
    
    goalDate4.text = [NSString stringWithFormat:@""];
    scoreLabel14.text = [NSString stringWithFormat:@""];
    scoreLabel24.text = [NSString stringWithFormat:@""];
    rating4.text = [NSString stringWithFormat:@""];
    
    goalDate5.text = [NSString stringWithFormat:@""];
    scoreLabel15.text = [NSString stringWithFormat:@""];
    scoreLabel25.text = [NSString stringWithFormat:@""];
    rating5.text = [NSString stringWithFormat:@""];
    
    goalDate6.text = [NSString stringWithFormat:@""];
    scoreLabel16.text = [NSString stringWithFormat:@""];
    scoreLabel26.text = [NSString stringWithFormat:@""];
    rating6.text = [NSString stringWithFormat:@""];
    
    goalDate7.text = [NSString stringWithFormat:@""];
    scoreLabel17.text = [NSString stringWithFormat:@""];
    scoreLabel27.text = [NSString stringWithFormat:@""];
    rating7.text = [NSString stringWithFormat:@""];
    
    // Get the row carried forward from the last view
    newrownumber  = (int)[[Singleton sharedSingleton] getnewrownumber];
    
	//Open database
	if(sqlite3_open([[[Singleton sharedSingleton] dataFilePath] UTF8String], &database) != SQLITE_OK){
		sqlite3_close(database);
		NSAssert(0,@"Failed to open database");
	}
    
    // Get the goal chosen
	query = [[NSString alloc] initWithFormat: @"SELECT name, scoretitle1, scoretitle2 FROM goals where row = '%i'",newrownumber];   
    
    sqlite3_stmt *statement;    
    if(sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK){
        while(sqlite3_step(statement) == SQLITE_ROW){
            nameChosen = (char *)sqlite3_column_text(statement, 0);
            nameCheck = [[NSString alloc] initWithFormat:@"%s",nameChosen];
            char *scti1 = (char *)sqlite3_column_text(statement, 1);
            char *scti2 = (char *)sqlite3_column_text(statement, 2);
            
            capitalizedName = [[NSString stringWithFormat: @"%s",nameChosen] capitalizedString];
            capitalizedTitle1 = [[NSString stringWithFormat: @"%s",scti1] capitalizedString];
            capitalizedTitle2 = [[NSString stringWithFormat: @"%s",scti2] capitalizedString];
            
            //Fill out text fields
            goalName.text = [[NSString alloc] initWithFormat:@"%@",capitalizedName];
            scoreLabel1.text = [[NSString alloc] initWithFormat:@"%@",capitalizedTitle1];   
            scoreLabel2.text = [[NSString alloc] initWithFormat:@"%@",capitalizedTitle2]; 
        }
        sqlite3_finalize(statement);
    }
    
    // Create the formatter for date string.
    formatter = [[[NSDateFormatter alloc] init] autorelease]; 
    [formatter setDateFormat:@"MMMM dd yyyy"];
    
    // Get the saved data from the Singleton class.
    selectedMonthInt  = (int)[[Singleton sharedSingleton] getselectedmonth];
    selectedYearInt = (int)[[Singleton sharedSingleton] getselectedyear];
    
    // Count - to measure number of months.
    int count = 1;
    
    while (count <= 7) {
        
        // Change format of month int.
        if (selectedMonthInt < 10) {
            selectedMonString = [[NSString alloc] initWithFormat:@"0%i",selectedMonthInt];
        }
        else {
            selectedMonString = [[NSString alloc] initWithFormat:@"%i",selectedMonthInt];
        }
        
        // Convert the selected month int into the string name.
        selectedMonthString = [[Singleton sharedSingleton] getMonthString:selectedMonthInt]; 
        
        // Create the date string for display.
        selectedDateString = [[NSString alloc] initWithFormat:@"%@ %i",selectedMonthString,selectedYearInt];
        
        // Run the database search.
        query2 = [[NSString alloc] initWithFormat: @"SELECT SUM(score1),SUM(score2), AVG(rating) FROM goals where name = '%@' and monthstring = '%@' and  yearstring = '%i'", nameCheck, selectedMonString,selectedYearInt];
        //NSLog(@"query 2 - %@", query2);
        
        sqlite3_stmt *stmt;    
        if(sqlite3_prepare_v2(database, [query2 UTF8String],-1, &stmt, nil) == SQLITE_OK){
            while(sqlite3_step(stmt) == SQLITE_ROW){
                
                sumScore1 = sqlite3_column_int(stmt, 0);
                sumScore2 = sqlite3_column_int(stmt, 1);
                avgRating = sqlite3_column_int(stmt, 2);
                
                // Add the data to the corresponding row.
                switch (count) {
                    case 1:
                        goalDate1.text = selectedDateString;
                        rating1.text = [[NSString alloc] initWithFormat:@"%i",avgRating];
                        
                        //If there is no name for label 1.
                        if([scoreLabel1.text isEqualToString:@"N/A"]){
                            scoreLabel11.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel11.text = [[NSString alloc] initWithFormat:@"%i",sumScore1];
                        }
                        
                        //If there is no name for label 2.
                        if([scoreLabel2.text isEqualToString:@"N/A"]){
                            scoreLabel21.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel21.text = [[NSString alloc] initWithFormat:@"%i",sumScore2];
                        }
                        break;
                    case 2:
                        goalDate2.text = selectedDateString;
                        rating2.text = [[[NSString alloc] initWithFormat:@"%i",avgRating] autorelease];
                        
                        //If there is no name for label 1.
                        if([scoreLabel1.text isEqualToString:@"N/A"]){
                            scoreLabel12.text = @"-";
                        }
                        else{
                            scoreLabel12.text = [[[NSString alloc] initWithFormat:@"%i",sumScore1] autorelease];
                        }
                        
                        //If there is no name for label 2.
                        if([scoreLabel2.text isEqualToString:@"N/A"]){
                            scoreLabel22.text = @"-";
                        }
                        else{
                            scoreLabel22.text = [[[NSString alloc] initWithFormat:@"%i",sumScore2] autorelease];
                        }
                        break;  
                    case 3:
                        goalDate3.text = selectedDateString;
                        rating3.text = [[NSString alloc] initWithFormat:@"%i",avgRating];
                        
                        //If there is no name for label 1.
                        if([scoreLabel1.text isEqualToString:@"N/A"]){
                            scoreLabel13.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel13.text = [[NSString alloc] initWithFormat:@"%i",sumScore1];
                        }
                        
                        //If there is no name for label 2.
                        if([scoreLabel2.text isEqualToString:@"N/A"]){
                            scoreLabel23.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel23.text = [[NSString alloc] initWithFormat:@"%i",sumScore2];
                        }
                        break;
                    case 4:
                        goalDate4.text = selectedDateString;
                        rating4.text = [[NSString alloc] initWithFormat:@"%i",avgRating];
                        
                        //If there is no name for label 1.
                        if([scoreLabel1.text isEqualToString:@"N/A"]){
                            scoreLabel14.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel14.text = [[NSString alloc] initWithFormat:@"%i",sumScore1];
                        }
                        
                        //If there is no name for label 2.
                        if([scoreLabel2.text isEqualToString:@"N/A"]){
                            scoreLabel24.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel24.text = [[NSString alloc] initWithFormat:@"%i",sumScore2];
                        }
                        break;
                    case 5:
                        goalDate5.text = selectedDateString;
                        rating5.text = [[NSString alloc] initWithFormat:@"%i",avgRating];
                        
                        //If there is no name for label 1.
                        if([scoreLabel1.text isEqualToString:@"N/A"]){
                            scoreLabel15.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel15.text = [[NSString alloc] initWithFormat:@"%i",sumScore1];
                        }
                        
                        //If there is no name for label 2.
                        if([scoreLabel2.text isEqualToString:@"N/A"]){
                            scoreLabel25.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel25.text = [[NSString alloc] initWithFormat:@"%i",sumScore2];
                        }
                        break;
                    case 6:
                        goalDate6.text = selectedDateString;
                        rating6.text = [[NSString alloc] initWithFormat:@"%i",avgRating];
                        
                        //If there is no name for label 1.
                        if([scoreLabel1.text isEqualToString:@"N/A"]){
                            scoreLabel16.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel16.text = [[NSString alloc] initWithFormat:@"%i",sumScore1];
                        }
                        
                        //If there is no name for label 2.
                        if([scoreLabel2.text isEqualToString:@"N/A"]){
                            scoreLabel26.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel26.text = [[NSString alloc] initWithFormat:@"%i",sumScore2];
                        }
                        break;
                    case 7:
                        goalDate7.text = selectedDateString;
                        rating7.text = [[NSString alloc] initWithFormat:@"%i",avgRating];
                        
                        //If there is no name for label 1.
                        if([scoreLabel1.text isEqualToString:@"N/A"]){
                            scoreLabel17.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel17.text = [[NSString alloc] initWithFormat:@"%i",sumScore1];
                        }
                        
                        //If there is no name for label 2.
                        if([scoreLabel2.text isEqualToString:@"N/A"]){
                            scoreLabel27.text = [[NSString alloc] initWithFormat:@"-"];
                        }
                        else{
                            scoreLabel27.text = [[NSString alloc] initWithFormat:@"%i",sumScore2];
                        }
                        break;
                    default:
                        break;
                } 
                
            }
            sqlite3_finalize(stmt);        
        }

        // Get the next month data.
        if (selectedMonthInt == 1) {
            selectedMonthInt = 12;
            selectedYearInt = selectedYearInt -1;
        }
        else {
            selectedMonthInt = selectedMonthInt - 1;
        }

        // add 1 to count
        count++;
    }
    
    
    
    
    app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillTerminate:)
												 name:UIApplicationWillTerminateNotification
											   object:app];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  NSLocalizedString(@"Monthly Comparison", @"monthly comparison");	
}

-(void) viewWillDisappear:(BOOL)animated {
    
    // Clear the labels
    goalName.text = [NSString stringWithFormat:@""];
    scoreLabel1.text = [NSString stringWithFormat:@""];   
    scoreLabel2.text = [NSString stringWithFormat:@""];
    
    goalDate1.text = [NSString stringWithFormat:@""];
    scoreLabel11.text = [NSString stringWithFormat:@""];
    scoreLabel21.text = [NSString stringWithFormat:@""];
    rating1.text = [NSString stringWithFormat:@""];
    
    goalDate2.text = [NSString stringWithFormat:@""];
    scoreLabel12.text = [NSString stringWithFormat:@""];
    scoreLabel22.text = [NSString stringWithFormat:@""];
    rating2.text = [NSString stringWithFormat:@""];
    
    goalDate3.text = [NSString stringWithFormat:@""];
    scoreLabel13.text = [NSString stringWithFormat:@""];
    scoreLabel23.text = [NSString stringWithFormat:@""];
    rating3.text = [NSString stringWithFormat:@""];
    
    goalDate4.text = [NSString stringWithFormat:@""];
    scoreLabel14.text = [NSString stringWithFormat:@""];
    scoreLabel24.text = [NSString stringWithFormat:@""];
    rating4.text = [NSString stringWithFormat:@""];
    
    goalDate5.text = [NSString stringWithFormat:@""];
    scoreLabel15.text = [NSString stringWithFormat:@""];
    scoreLabel25.text = [NSString stringWithFormat:@""];
    rating5.text = [NSString stringWithFormat:@""];
    
    goalDate6.text = [NSString stringWithFormat:@""];
    scoreLabel16.text = [NSString stringWithFormat:@""];
    scoreLabel26.text = [NSString stringWithFormat:@""];
    rating6.text = [NSString stringWithFormat:@""];
    
    goalDate7.text = [NSString stringWithFormat:@""];
    scoreLabel17.text = [NSString stringWithFormat:@""];
    scoreLabel27.text = [NSString stringWithFormat:@""];
    rating7.text = [NSString stringWithFormat:@""];
	
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


- (void)dealloc
{
    [super dealloc];
    [query release];
    [query2 release];
    [nameCheck release];
    [capitalizedName release];
    [capitalizedTitle1 release];
    [capitalizedTitle2 release];
    [formatter release];
    [selectedMonString release];
    [selectedMonthString release];
    [selectedDateString release];
    [app release];
    [goalName release];
    [scoreLabel1 release];
    [scoreLabel2 release];
    [rating release];
    [goalDate1 release];
    [scoreLabel11 release];
    [scoreLabel21 release];
    [rating1 release];
    [goalDate2 release];
    [scoreLabel12 release];
    [scoreLabel22 release];
    [rating2 release];
    [goalDate3 release];
    [scoreLabel13 release];
    [scoreLabel23 release];
    [rating3 release];
    [goalDate4 release];
    [scoreLabel14 release];
    [scoreLabel24 release];
    [rating4 release];
    [goalDate5 release];
    [scoreLabel15 release];
    [scoreLabel25 release];
    [rating5 release];
    [goalDate6 release];
    [scoreLabel16 release];
    [scoreLabel26 release];
    [rating6 release];
    [goalDate7 release];
    [scoreLabel17 release];
    [scoreLabel27 release];
    [rating7 release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
