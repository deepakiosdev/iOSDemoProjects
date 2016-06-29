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
{
    int clickCount;

}
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSMutableArray *namesArray;

@end

@implementation BreakPointsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstName  = @"Deepak";
    clickCount = 100;
    self.namesArray = [[NSMutableArray alloc] initWithObjects:@"Damodar", @"Maria", @"Raj", @"Nishant", @"Vinoth", @"Sharad", nil];
#warning Add watchpoint for firstName and clickCount

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)conditionalBreakpointAction:(id)sender
{
    ++clickCount;
    [self.namesArray addObject:@"Ujjwal"];
    self.firstName  = @"Zoeb";
    NSLog(@"Demo: conditional Breakpoint (%s)" , __PRETTY_FUNCTION__ );
  
    for (NSString *name in self.namesArray) {
        // <- This conditional breakpoint will only work if name = @"Raj"
        NSLog(@"name:%@",name);
    }
}

- (IBAction)ignoredBreakpointAction:(id)sender
{
    self.firstName  = @"Naveen";
    [self.namesArray addObject:@"Hemanth"];
    ++clickCount;
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    int i = 0;
    while (++i <= 6) {
        NSLog(@"i = %d", i);
        // <- This breakpoint is ignored 3 times before stopping
    }
}

- (IBAction)logMessageAndContinueBreakpointAction:(id)sender
{
    ++clickCount;
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    // A new message will be in you debug log
}


- (IBAction)soundBreakpointAction:(id)sender
{
    ++clickCount;
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
}

- (IBAction)logMessageWithValuesAndContinueBreakpointAction:(id)sender
{
    ++clickCount;
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    // A new message will be in you debug log
}

- (IBAction)multipleActionBreakpointAction:(id)sender
{
    ++clickCount;
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    // A new message will be in you debug log
    //Using memory address chnage value run time
    // expr (void)[0x00007f8d3bf63630 setBackgroundColor:[UIColor redColor]]
    // expr (void)[sender setBackgroundColor:[UIColor greenColor]]
    // OR   po (void)[sender setBackgroundColor:[UIColor redColor]]
    // expr (void)[sender setTitle:@"Deepak" forState:0] // Set Title
    // OR expr (void)[0x00007f8d3bf63630 setTitle:@"Deepak" forState:0]
    // Note you can interchange po and expr. you can also interchange object |sender| and memory address |0x00007f8d3bf63630|
}


- (IBAction)exceptionBreakpointAction:(id)sender
{
    ++clickCount;
    @try {
        // The Breakpoint Navigation has an Exception Breakpoint which will stop here.
        @throw [NSException exceptionWithName:@"Example" reason:@"Testing Breakpoints" userInfo:nil];
    } @catch (NSException *e) {
        // Nothing since this is an example.
    }
}

- (IBAction)symbolicBreakpointAction:(id)sender
{
    ++clickCount;
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

- (IBAction)backTraceAction:(id)sender {
    ++clickCount;
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    [self testBreakPoints];

}


-(void)testBreakPoints {
    NSLog(@"Demo: (%s)" , __PRETTY_FUNCTION__ );
    
}

@end
