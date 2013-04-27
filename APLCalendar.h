//
//  APLCalendar.h
//  MyPortableLife
//
//  Created by Tim Perry on 13/03/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuartzCore/QuartzCore.h" // for CALayer

// REMEMBER TO INCLUDE QUATZ CORE TO YOUR PROJECT

@protocol APLCalendarDelegate <NSObject>
@optional
- (void) didSelectCalendarDay:(NSInteger)day;
- (void) didDeselectCalendarDay:(NSInteger)day;

@end

@interface APLCalendar : UIView {
    
    UILabel *lblMonth;
    NSInteger _day;
    NSInteger _month;
    NSInteger _year;
    NSInteger _cellSize;
    NSInteger _fontSize;
    NSInteger _titleTextSize;
    NSInteger _today;
    NSInteger _borderWidth;
    
    UISwipeGestureRecognizer *_recognizer;
    
}

@property (nonatomic, weak) id <APLCalendarDelegate> delegate;

-(void) drawDays;
-(void) drawHeader;
-(void) nextMonth;
-(void) prevMonth;
-(void) selectDay:(id)sender;
-(void) goOneMonthBack;
-(void) goOneMonthForward;
-(void) clearViews;

@end