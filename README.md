#APLCalendar

First include the header file
	#import "APLCalendar.h"

Then add the APLCalendarDelegate
	@interface ViewController : UIViewController <APLCalendarDelegate> {
    
	    APLCalendar *cal; // create a calendar object
    
	}

@end

Initialize the calendar and add it the view.
	- (void)viewDidLoad
	{
	    cal = [[APLCalendar alloc] initWithFrame:CGRectMake(5, 50, self.view.frame.size.width, self.view.frame.size.width)];
	    [cal setDelegate:self];
	    [self.view addSubview:cal];
    
	    [super viewDidLoad];
	}

Optionally implement the delegate method, this is called when a day is clicked

	-(void) didSelectCalendarDay:(NSInteger)day {
    
	    NSLog(@"Day: %i", day);

	}