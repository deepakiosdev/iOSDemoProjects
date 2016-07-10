//
//  CrashTestVC.m
//  iOSDemoProjects
//
//  Created by Deepak on 09/07/16.
//  Copyright © 2016 Deepak. All rights reserved.
//

#import "CrashTestVC.h"

#import "FirstVC.h"
#import "SecondVC.h"

@interface CrashTestVC ()

@end

@implementation CrashTestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //CrashTest
   // SecondVC *secondVC = [[SecondVC alloc] init];
    
   //Case 1: App beacome carsh because of |methodWithOutDef| do not have definition
    //FirstVC *firstVC = [[FirstVC alloc] init];
    
    //Case 2: App beacome carsh because of firstVC contain object of  |SecondVC| do not know about |testMethod| and |methodWithOutDef|
    FirstVC *firstVC = [[SecondVC alloc] init];

    [firstVC testMethod];
    [firstVC methodWithOutDef];
    
}
@end
