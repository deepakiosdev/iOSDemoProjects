//
//  BreakPointsVC.m
//  iOSDemoProjects
//
//  Created by Deepak on 29/06/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

/**
 * References
 * http://jeffreysambells.com/2014/01/14/using-breakpoints-in-xcode
 * https://www.bignerdranch.com/blog/xcode-breakpoint-wizardry/
 */


#import "BreakPointsVC.h"

@interface BreakPointsVC ()

@end

@implementation BreakPointsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)conditionalBreakpointAction:(id)sender
{
    NSLog(@"Demo: conditional Breakpoint (%s)" , __PRETTY_FUNCTION__ );
  
    NSArray *names = @[@"Damodar", @"Maria", @"Raj", @"Nishant", @"Vinoth", @"Sharad"];
    for (NSString *name in names) {
        // <- This conditional breakpoint will only work if name = @"Raj"
        NSLog(@"name:%@",name);
    }
}

- (IBAction)ignoredBreakpointAction:(id)sender
{
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    int i = 0;
    while (++i <= 6) {
        NSLog(@"i = %d", i);
        // <- This breakpoint is ignored 3 times before stopping
    }
}

- (IBAction)logMessageAndContinueBreakpointAction:(id)sender
{
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    // A new message will be in you debug log
}


- (IBAction)soundBreakpointAction:(id)sender
{
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
}

- (IBAction)logMessageWithValuesAndContinueBreakpointAction:(id)sender
{
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    // A new message will be in you debug log
}

- (IBAction)multipleActionBreakpointAction:(id)sender
{
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    // A new message will be in you debug log
    //Using memory address chnage value run time
    // expr (void)[0x00007f8d3bf63630 setBackgroundColor:[UIColor redColor]]
}


- (IBAction)exceptionBreakpointAction:(id)sender
{
    @try {
        // The Breakpoint Navigation has an Exception Breakpoint which will stop here.
        @throw [NSException exceptionWithName:@"Example" reason:@"Testing Breakpoints" userInfo:nil];
    } @catch (NSException *e) {
        // Nothing since this is an example.
    }
}

- (IBAction)symbolicBreakpointAction:(id)sender
{
    // The symbolic breakpoint will stop at the beginning of this method
    // There's also a symbolic breakpoint for
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    
    // This is bad. don't send syncronous requests on teh main thread
    // as it will block the UI.
    // The conditional symbolic breakpoint will stop here.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://jeffreysambells.com"]];
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSLog(@"Main Thread Request Complete");
    
    
    // This is better, running in a different queue.
    // The conditional symbolic breakpoint will not stop here.
    dispatch_async(dispatch_queue_create("Non Main Queue",NULL), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://jeffreysambells.com"]];
        NSURLResponse *response;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSLog(@"Non Main Thread Request Complete");
    });
    
    
}


@end
