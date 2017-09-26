//
//  AppDelegate.m
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/10/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "IQKeyboardManager.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate,CLLocationManagerDelegate>

@end

@implementation AppDelegate



-(void)manageKeyBoradmanager
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    //(Optional)Set Distance between keyboard & textField, Default is 10.
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    
    //(Optional)Enable autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard. Default is NO.
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    //(Optional)Setting toolbar behaviour to IQAutoToolbarBySubviews to manage previous/next according to UITextField's hierarchy in it's SuperView. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order. Default is `IQAutoToolbarBySubviews`.
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    
    //(Optional)Resign textField if touched outside of UITextField/UITextView. Default is NO.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    //(Optional)Giving permission to modify TextView's frame. Default is NO.
  //  [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    
    //(Optional)Show TextField placeholder texts on autoToolbar. Default is NO.
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //to check for internet connection
    [self checkReachability];
    
    //to get user location
    [self getUserLocation];

    //Register for push notificationq
    [self registerForPushNotification];

    NSInteger appStartCount = [[NSUserDefaults standardUserDefaults] integerForKey:KAppStartCount];
    appStartCount = appStartCount+1;
    [[NSUserDefaults standardUserDefaults] setInteger:appStartCount forKey:KAppStartCount];
    [[NSUserDefaults  standardUserDefaults] synchronize];
    [self manageKeyBoradmanager];
    
    // manage one time login
    NSString * userID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    if (userID.length && ![userID isEqualToString:@"(null)"]) {
        UIStoryboard * storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * landingPage = [storyborad instantiateViewControllerWithIdentifier:@"FFFashionViewController"];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:landingPage];
        navController.navigationBarHidden = YES;
        self.window.rootViewController = navController;
    }
    
    return YES;
}

-(void)initiatelogoutView
{
    UIStoryboard * storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * landingPage = [storyborad instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:landingPage];
    navController.navigationBarHidden = YES;
    self.window.rootViewController = navController;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


#pragma mark - Get User Location Method
-(void)getUserLocation {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
    
}


// Location menager delegate method-
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    self.currentLatitude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude];
    self.currentLongitude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude];
    
    
    [NSUSERDEFAULT setValue:self.currentLatitude forKey:KDefaultlatitude];
    [NSUSERDEFAULT setValue:self.currentLongitude forKey:KDefaultlongitude];  // save user curet location locally

    [locationManager stopUpdatingLocation];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:[self.currentLatitude floatValue] longitude:[self.currentLongitude floatValue]];
    
    [ceo reverseGeocodeLocation: loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //CLPlacemark *placemark = [placemarks objectAtIndex:0];
      //  self.currentLocation = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        
       // self.countryCode = placemark.ISOcountryCode;
        
        [NSUSERDEFAULT setValue:self.currentLocation forKey:KDefaultLocation];

    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            
          //  [NSUSERDEFAULT setBool:YES forKey:@"isDontAllowPopUp"];
            //self.isDontAllowPopUp = YES;
            
            //            [SLUtility alertWithTitle:@"App Permission Denied" andMessage:@"To re-enable, please go to Settings and turn on Location Services for this app." andController:self];
        }
    }
}



#pragma mark - Check Reachability

-(void)checkReachability {
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    self.isReachable = [reach isReachable];
    reach.reachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = YES;
        });
    };
    reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = NO;
        });
    };
    [reach startNotifier];
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

#pragma mark - methods for push notification
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //    NSLog(@"register %@",error.localizedDescription);
    [NSUSERDEFAULT setObject:@"deviceToken" forKey:KDeviceToken];
    [NSUSERDEFAULT synchronize];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Store the deviceToken in the current installation and save it to Parse.
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [NSUSERDEFAULT setValue:token forKey:KDeviceToken];
    [NSUSERDEFAULT synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"notification info = %@", userInfo );
    
}

-(void)registerForPushNotification {
    
    // Register for Push Notitications
    //For iOS version 10 and above
    if ([UIDevice currentDevice].systemVersion.floatValue  >= 10.0) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                                  if (granted) {
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  }
                              }];
    }else{
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                            UIUserNotificationTypeBadge |
                                                            UIUserNotificationTypeSound);
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    //call when app in background
     NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    //call when app in forground
    
    NSLog(@"notification info = %@", response.notification.request.content.userInfo);
}


@end
