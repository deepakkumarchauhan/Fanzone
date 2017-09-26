//
//  AppDelegate.h
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/10/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Macro.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CLLocationManager *locationManager;

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController     *navigationController;
@property (assign, nonatomic) BOOL isReachable;

@property(strong,nonatomic)   NSString                * currentLatitude;
@property(strong,nonatomic)   NSString                * currentLongitude;
@property (strong, nonatomic) NSString                * currentLocation;

-(void)initiatelogoutView;
@end

