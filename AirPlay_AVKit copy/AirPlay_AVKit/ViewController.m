//
//  ViewController.m
//  AirPlay_AVKit
//
//  Created by Dipak on 10/18/16.
//  Copyright © 2016 Dipak. All rights reserved.
//

#import "ViewController.h"
#import "PlayerWithExternalDisplayVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchPlayer:(id)sender {
    PlayerWithExternalDisplayVC *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerWithExternalDisplayVC"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
