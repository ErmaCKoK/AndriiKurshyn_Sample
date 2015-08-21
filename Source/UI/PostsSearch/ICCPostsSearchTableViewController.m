//
//  ICCPostsSearchTableViewController.m
//  AndriiKurshyn_iOSCodeChallenge
//
//  Created by Andrii Kurshyn on 7/24/15.
//  Copyright (c) 2015 Andrii Kurshyn. All rights reserved.
//

#import "ICCPostsSearchTableViewController.h"

#import "ICCMailActivityItemProvider.h"
#import "ICCPost.h"
#import "ICCPostsStore.h"
#import "ICCPostTableViewCell.h"

@interface ICCPostsSearchTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSString* currentCategory;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) NSArray* posts;

@end

@implementation ICCPostsSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg@2x.png"]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 105.0;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ICCPostTableViewCell" bundle:nil] forCellReuseIdentifier:@"PostTableViewCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(refreshControlActivated:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self addTitleView];
    
    self.searchBar.text = @"Funny";
    [self getPostsByCategory:self.searchBar.text];
}

- (void) addTitleView {
    
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    
    UIButton* searchButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width-100, titleView.frame.size.height/2-(27.5f/2), 100, 27.5f)];
    [searchButton setTitle:@"SEARCH" forState:UIControlStateNormal];
    [searchButton setBackgroundImage:[[UIImage imageNamed:@"search-btn-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 10, 0)] forState:UIControlStateNormal];
    searchButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin  | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
    searchButton.layer.cornerRadius = 5.0f;
    searchButton.clipsToBounds = YES;
    searchButton.titleLabel.font = [UIFont fontWithName:@"BebasNeue" size:20];
    [searchButton addTarget:self action:@selector(handleSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchButton];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, titleView.bounds.size.width-107, titleView.bounds.size.height)];
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    self.searchBar.delegate = self;
    searchField.backgroundColor = [UIColor colorWithRed:229/255.0f green:230/255.0f blue:233/255.0f alpha:1.0f];
    
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleLeftMargin;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.translucent = NO;
    [titleView addSubview:self.searchBar];
    self.navigationItem.titleView = titleView;
    
}

- (void) getPostsByCategory:(NSString*)category {
    self.currentCategory = category;
    
    [[ICCPostsStore sharedInstance] fetchPostsByCategory:category completion:^(NSArray *posts, NSError *error) {
        if (error == nil) {
            self.posts = posts;
            [self.tableView reloadData];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:error.localizedDescription
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Action
- (void) handleSearchButton:(UIButton*)sender {
    [self getPostsByCategory:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}

- (void) refreshControlActivated:(UIRefreshControl*)refreshControl {
    [self getPostsByCategory:self.currentCategory];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [self getPostsByCategory:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ICCPostTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostTableViewCell" forIndexPath:indexPath];
    [cell setPost:self.posts[indexPath.row]];
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat {
    
    cell.alpha = 0.0;
    cell.frame = CGRectOffset(cell.frame, tableView.frame.size.width/2, 0);
    
    [UIView animateWithDuration:0.4 animations:^{
        cell.alpha = 1.0;
        cell.frame = CGRectOffset(cell.frame, -tableView.frame.size.width/2, 0);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ICCMailActivityItemProvider *mailItem = [ICCMailActivityItemProvider itemByPost:self.posts[indexPath.item]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[mailItem] applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeCopyToPasteboard,
                                                     UIActivityTypeAssignToContact,
                                                     UIActivityTypeAddToReadingList,
                                                     UIActivityTypeAirDrop,
                                                     UIActivityTypeMessage,
                                                     UIActivityTypePostToFacebook,
                                                     UIActivityTypePostToTwitter];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

@end
