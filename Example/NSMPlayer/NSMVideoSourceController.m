//
//  NSMVideoSourceController.m
//  NSMPlayer
//
//  Created by chengqihan on 2017/2/15.
//  Copyright © 2017年 migrant. All rights reserved.
//

#import "NSMVideoSourceController.h"
@import NSMPlayer;

@interface NSMVideoSourceController ()

@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation NSMVideoSourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.urls = [NSMutableArray arrayWithObjects:@"http://qiniu.vmagic.molihecdn.com/57ad9537b84b2_lower.mp4", @"http://qiniu.vmagic.molihecdn.com/5773a2b9c5d2d.mp4", @"http://qiniu.vmagic.molihecdn.com/577390db6eefd.mp4", @"http://qiniu.vmagic.vmoviercdn.com/55d1eb3b575fe.mp4", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.urls.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourceCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"# %@",self.urls[indexPath.row]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(videoSourceControllerDidSelectedPlayerItem:)]) {
        NSString *urlstring = self.urls[indexPath.row];
        NSMPlayerAsset *playerAsset = [[NSMPlayerAsset alloc] init];
        playerAsset.assetURL = [NSURL URLWithString:urlstring];
        [self.delegate videoSourceControllerDidSelectedPlayerItem:playerAsset];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
