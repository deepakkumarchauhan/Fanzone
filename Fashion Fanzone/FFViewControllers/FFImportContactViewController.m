//
//  FFImportContactViewController.m
//  Fashion Fanzone
//
//  Created by Shridhar Agarwal on 23/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFImportContactViewController.h"
#import "KTSContactsManager.h"
#import "FFContactTableCell.h"
#import "Macro.h"

@interface FFImportContactViewController ()

@property (weak, nonatomic) IBOutlet FFTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) KTSContactsManager        * contactsManager;
@property (strong, nonatomic) NSMutableArray            * contactsDataArray;
@property (strong, nonatomic) NSMutableArray            * searchedDataArray;
@property (strong, nonatomic) NSMutableArray            * dataSourceArray;
@property (strong, nonatomic) NSMutableArray            * phoneDataArray;
@property (nonatomic, assign) bool isFiltered;


@end

@implementation FFImportContactViewController

#pragma mark- UIView Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
}
#pragma mark - Helper Methods

-(void)initialMethod{
    _phoneDataArray = [[NSMutableArray alloc] init];
    _dataSourceArray  = [[NSMutableArray alloc] init];
    
    [self.contactTableView registerNib:[UINib nibWithNibName:@"FFContactTableCell" bundle:nil] forCellReuseIdentifier:@"FFContactTableCell"];
    self.contactTableView.tableHeaderView = self.headerView;
    
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    [self loadData];
    
    _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search your contacts" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.contactsDataArray = [NSMutableArray arrayWithArray:contacts];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             for (int i =0 ; i<self.contactsDataArray.count; i++)
             {
                 FFUserInfo *contactInfo = [[FFUserInfo alloc] init];
                 contactInfo.isSelected = NO;
                 NSDictionary *contact = [self.contactsDataArray objectAtIndex:i];
                 contactInfo.friendName = TRIM_SPACE([contact objectForKey:@"name" ]);
                 for (NSDictionary *dic in [contact objectForKey:@"emails"])
                 {
                     contactInfo.friendEmailAddress = [dic objectForKey:@"value"];
                     [_dataSourceArray addObject: contactInfo];
                     break;
                 }
             }
             
             [self.contactTableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
         });
     }];
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isFiltered ? self.searchedDataArray.count : self.dataSourceArray.count);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFContactTableCell *cell = (FFContactTableCell *)[tableView dequeueReusableCellWithIdentifier:@"FFContactTableCell"];
    FFUserInfo *obj = [(self.isFiltered ? self.searchedDataArray : self.dataSourceArray) objectAtIndex:indexPath.row];
   
    cell.nameLabel.text = obj.friendName;
    cell.emailLabel.text = obj.friendEmailAddress;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FFUserInfo *obj = [(self.isFiltered ? self.searchedDataArray : self.dataSourceArray) objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectionButtonClicked:)]) {
        [self.delegate selectionButtonClicked:obj.friendEmailAddress];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
#pragma mark - TextField Delegates Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString1 = [searchStr componentsSeparatedByString:@"."];
    
    if ([arrayOfString1 count] > 1 )
        return NO;
    self.searchedDataArray = [[NSMutableArray alloc] init];
    self.isFiltered = YES;
    for (FFUserInfo* item in self.dataSourceArray)
    {
        //case insensative search - way cool
        if ([item.friendName rangeOfString:searchStr options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [self.searchedDataArray addObject:item];
        }
        
    }
    if ([searchStr isEqualToString:@""]) {
        self.searchedDataArray = self.dataSourceArray;
    }
    [self.contactTableView reloadData];
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    self.searchTextField.text = @"";
    return YES;
}


#pragma mark- UIButton Action Method

- (IBAction)cancelButtonAction:(id)sender {
    
    self.isFiltered = NO;
    [self.view endEditing:YES];
    self.searchTextField.text = @"";
    [self.contactTableView reloadData];
}

#pragma mark- UIButton Action Method

-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Memory Management Handling
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
