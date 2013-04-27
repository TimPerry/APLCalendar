//
//  APLCalendar.m
//  MyPortableLife
//
//  Created by Tim Perry on 13/03/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "APLCalendar.h"


@implementation APLCalendar

@synthesize delegate;

#define COLUMNS 7
#define ROWS 6
#define TOTAL_MONTHS_IN_YEAR 12 

-(APLCalendar*) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        _day = _today = [components day];
        _month = [components month];
        _year = [components year];
        _cellSize = self.frame.size.width/COLUMNS;
        _borderWidth = _cellSize*0.023;
        _fontSize = _cellSize/3.5;
        _titleTextSize = _cellSize/2.5;
        
        _recognizer.cancelsTouchesInView = YES;
        _recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePerformed:)];
        [_recognizer setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionUp)];
        [self addGestureRecognizer:_recognizer];
        [self drawHeader];
        [self drawDays];
        
    }    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

-(void)swipePerformed:(UISwipeGestureRecognizer *)recognizer {
    
    NSLog(@"Swipe!");
    
    switch ([recognizer direction]) {
        case UISwipeGestureRecognizerDirectionRight:
            [self nextMonth];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self prevMonth];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            [self prevYear];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self nextYear];
            break;
            
    }
    
}

-(APLCalendar*) init {
    
    self = [self initWithFrame:CGRectMake(0, 0, 320, 320)]; 
    return self;
}

-(void) drawHeader {
    
    UIButton *prev = [UIButton buttonWithType:UIButtonTypeCustom];
    [prev setTitle:@"<<" forState:UIControlStateNormal];
    prev.frame = CGRectMake(0, 0, _cellSize, _cellSize);
    [prev setTitleColor:[UIColor colorWithWhite:.2 alpha:.8] forState:UIControlStateNormal];
    [[prev titleLabel] setFont:[UIFont fontWithName:@"Verdana-Bold" size:_titleTextSize]];
    [prev addTarget:self action:@selector(prevMonth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:prev];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@">>" forState:UIControlStateNormal];
    [next setTitleColor:[UIColor colorWithWhite:.2 alpha:.8] forState:UIControlStateNormal];
    next.frame = CGRectMake((COLUMNS-1)*_cellSize, 0, _cellSize, _cellSize);
    [next addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
    [[next titleLabel] setFont:[UIFont fontWithName:@"Verdana-Bold" size:_titleTextSize]];
    [self addSubview:next];
    
    lblMonth = [[UILabel alloc] initWithFrame:CGRectMake(_cellSize, 0, self.frame.size.width-(2*_cellSize), _cellSize)];
    [lblMonth setFont:[UIFont fontWithName:@"Verdana-Bold" size:_titleTextSize]];
    [lblMonth setTextAlignment:UITextAlignmentCenter];
    
    NSString *dateString = [NSString stringWithFormat:@"%i %i", _month, _year];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"MM yyyy"];
    NSDate *date = [fmt dateFromString:dateString];
    [fmt setDateFormat:@"MMMM yyyy"];
    NSString *dateStr = [fmt stringFromDate:date];
        
    [lblMonth setText:dateStr];
    [lblMonth setTextColor:[UIColor colorWithWhite:.1 alpha:.8]];
    [lblMonth setBackgroundColor:[UIColor clearColor]];

    [self addSubview:lblMonth];
    
    NSArray *array = [NSArray arrayWithObjects:@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun", nil];
    
    int x = 0;
    for(int i=0; i<COLUMNS; i++) {
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(x, _cellSize, _cellSize, _cellSize/2)];
        [lbl setText: [array objectAtIndex:i]];
        [lbl setTextAlignment:UITextAlignmentCenter];
        [lbl setFont:[UIFont fontWithName:@"Verdana-Bold" size:_fontSize]];
        [lbl setTextColor:[UIColor grayColor]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:lbl];
        x += (_cellSize-1);
    }
    
}

-(void) plotCellAtX:(NSInteger)x Y:(NSInteger)y Day:(NSInteger) day isGreyDay:(BOOL)isGreyDay{
    
    CGRect frame = CGRectMake(x, y, _cellSize, _cellSize);
    UIButton *cell = [UIButton buttonWithType:UIButtonTypeCustom];
    [cell setFrame:frame];
    
    UIColor *highColor = [UIColor colorWithWhite:.8 alpha:.8];
    UIColor *lowColor = [UIColor colorWithWhite:.9 alpha:.8];
    CAGradientLayer * gradient = [CAGradientLayer layer];

    [cell setTitleColor:[UIColor colorWithWhite:.3 alpha:.7] forState:UIControlStateNormal];
    [[cell titleLabel] setFont:[UIFont fontWithName:@"Verdana" size:_fontSize]];
    [cell setTitle:[NSString stringWithFormat:@"%i", day] forState:UIControlStateNormal];

    if (!isGreyDay){
        [cell setTag:day];
        [cell addTarget:self action:@selector(selectDay:) forControlEvents:UIControlEventTouchDown]; 
        [cell addTarget:self action:@selector(deselectDay:) forControlEvents:UIControlEventTouchUpInside];  
        [cell addTarget:self action:@selector(deselectDay:) forControlEvents:UIControlEventTouchUpOutside];  
        [cell.layer setBorderColor:[UIColor colorWithWhite:.1 alpha:.2].CGColor];
        if (day == _today) {
            [cell setTitleColor:[UIColor colorWithWhite:.9 alpha:1.0] forState:UIControlStateNormal];
            highColor = [UIColor colorWithRed:0.0 green:0.0 blue:.6 alpha:.7];
            lowColor = [UIColor colorWithRed:0.1 green:0.1 blue:.8 alpha:.7];
            [[cell titleLabel] setFont:[UIFont fontWithName:@"Verdana-Bold" size:_fontSize]];
        }
    } else {
        [cell setEnabled:FALSE];
        [cell setTitleColor:[UIColor colorWithWhite:.7 alpha:.8] forState:UIControlStateNormal];
        highColor = [UIColor colorWithWhite:.2 alpha:.1];
        lowColor = [UIColor colorWithWhite:.2 alpha:.1];
        [cell.layer setBorderColor:[UIColor colorWithWhite:.6 alpha:.1].CGColor];

    }
    
    [gradient setFrame:CGRectMake(0, 0, _cellSize, _cellSize)];
    [gradient setColors:[NSArray arrayWithObjects:(id)[highColor CGColor], (id)[lowColor CGColor], nil]];
    
    [cell.layer insertSublayer:gradient atIndex:0];
    [cell.layer setBorderWidth:_borderWidth];
    
    [self addSubview:cell];
    
}

-(NSInteger) getTotalDaysInCurrentMonth {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSString *dateString = [NSString stringWithFormat:@"%i-%i-%i", _day, _month, _year];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [fmt dateFromString:dateString];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];    
    return rng.length;
    
}

-(NSInteger) getOffsetDays {
        
    NSString *dateString = [NSString stringWithFormat:@"%i-%i-%i", 1, _month, _year];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"dd-MM-yyyy"];
    NSDate *date = [fmt dateFromString:dateString];

    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"e"];
    NSString *weekDay =  [theDateFormatter stringFromDate:date];
    
    
    // convert from week starting on a sunday to a monday
    if ([weekDay intValue] == 1){
        return 7; // should be sunday but it will be monday now 
    }
    
    return [weekDay intValue]-1; // as we start a day early minus one from the day of the week
    
}

-(void) drawDays {
    
    int x=0;
    int y=_cellSize+(_cellSize/2);
    int day=1;
    
    int totalDaysThisMonth = [self getTotalDaysInCurrentMonth];
    int dayOfWeek = [self getOffsetDays]-1; // convert to zero based index
    
    [self goOneMonthBack];
    int totalDaysLastMonth = [self getTotalDaysInCurrentMonth];
    [self goOneMonthForward];
    
    int greyDay = totalDaysLastMonth-dayOfWeek;
    
    if (dayOfWeek > 6) {
        greyDay += 7;
    } else if (dayOfWeek == 6) {
        greyDay = 99;
    }
    
    NSLog(@"dayOfWeek: %i", dayOfWeek);
    BOOL drawGrey = false;
    
    for(int i=0; i<ROWS; i++) {
        for(int j=0; j<COLUMNS; j++){
            if (greyDay > totalDaysLastMonth) {
                if (day > totalDaysThisMonth) {
                    day=1;
                    drawGrey = YES;
                }
                [self plotCellAtX:x Y:y Day:day isGreyDay:drawGrey];
                day++;
            } else {
                [self plotCellAtX:x Y:y Day:greyDay isGreyDay:YES];
                greyDay++;
            }
            x += _cellSize-1;
        }
        y += _cellSize-1;
        x = 0;
    }
    
}

-(void) nextMonth {
    @synchronized(self) {
        [self clearViews];
        [self goOneMonthForward];
        [self drawDays];
        [self drawHeader];
    }
}

-(void) prevMonth {
    @synchronized(self) {
        [self clearViews];
        [self goOneMonthBack];
        [self drawDays];
        [self drawHeader];
    }
}

-(void) nextYear {
    @synchronized(self) {
        [self clearViews];
        [self goOneYearForward];
        [self drawDays];
        [self drawHeader];
    }
}

-(void) prevYear {
    @synchronized(self) {
        [self clearViews];
        [self goOneYearBack];
        [self drawDays];
        [self drawHeader];
    }
}

-(void) goOneYearBack {
    
    _year--;
    
}

-(void) goOneMonthBack {
    
    _month--;
    
    if (_month < 1){
        _month = 12;
        _year--;
    }
    
}

-(void) goOneYearForward {
    
    _year++;
    
}

-(void) goOneMonthForward {
    
    _month++;
    
    if(_month > TOTAL_MONTHS_IN_YEAR){
        _month=1;
        _year++;
    }
        
}


-(void) clearViews {
    
    for(UIView* view in [self subviews]) {
        [view removeFromSuperview];
    }
    
}

-(void) deselectDay:(id) sender {
    
    UIButton *cell = (UIButton*)sender;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if([[self delegate] respondsToSelector:@selector(didDeselectCalendarDay:)]) {
        [[self delegate] didDeselectCalendarDay:[sender tag]];
    }
    
}

-(void) selectDay:(id) sender {
    
    UIButton *cell = (UIButton*)sender;
    
    [cell setBackgroundColor:[UIColor greenColor]];
    
    if([[self delegate] respondsToSelector:@selector(didSelectCalendarDay:)]) {
        [[self delegate] didSelectCalendarDay:[sender tag]];
    }
    
}

@end
