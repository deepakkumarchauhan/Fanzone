//
//  FFUserDetailSectionHeader.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 31/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "FFTextField.h"
@interface FFUserDetailSectionHeader : UIView

@property (nonatomic, weak) IBOutlet UIImageView * bannerView;
@property (nonatomic, weak) IBOutlet UIImageView * profileImageView;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UIButton * connectionBtn;
@property (nonatomic, weak) IBOutlet UILabel * noOfConnections;
@property (nonatomic, weak) IBOutlet UILabel * noOfFolloerws;
@property (nonatomic, weak) IBOutlet UILabel * noIfStypePoints;
@property (nonatomic, weak) IBOutlet UILabel * verifiedLabel;
@property (nonatomic, weak) IBOutlet FFTextField *userNameTextFeilds;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@property (nonatomic, weak) IBOutlet UIButton * editBtn;

@end
