//
//  HMSCBasicTableViewController.m
//  WellxProviders
//
//  Created by John Grant on 2013-06-20.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import "JGABasicTableViewController.h"
#import "JGAFetchedTableDataSource.h"
#import "JGAEmptyTableDataSource.h"
#import "JGALoadingTableDataSource.h"
#import "SSPullToRefresh.h"

@interface JGABasicTableViewController ()

@property (nonatomic, strong) id<UITableViewDataSource, UITableViewDelegate>currentDataSource;
@property (nonatomic, strong) NSMutableDictionary *requests;
@property (nonatomic, strong) NSOperation *currentRequest;
@property (nonatomic, assign) BOOL userDidTriggerRefreshByPulling;
@property (nonatomic, assign) BOOL shouldIgnorePullToRefreshCall;

@end

@implementation JGABasicTableViewController
- (void)dealloc {
    [self stopObservingApplicationNotifications];
    [self cancelAllExistingRequests];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.requests = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)loadView {
    [super loadView];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.scrollsToTop = YES;
    
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    [self addConstraints];
}

- (void)addConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    NSString *format = [NSString stringWithFormat:@"V:|[_tableView]|"];
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:0 views:views];
    [self.view addConstraints:constraints];
    
    format = [NSString stringWithFormat:@"|[_tableView]|"];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:0 views:views];
    [self.view addConstraints:constraints];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self shouldAllowPullToRefresh]) {
        [self addPullToRefresh];
    }
    
    [self observeApplicationNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self cancelAllExistingRequests];
}

- (void)registerFetchedDataSource:(JGAFetchedTableDataSource *)dataSource {
    self.dataSource = dataSource;
    dataSource.delegate = self;
    dataSource.tableView = self.tableView;
    [self showDataSource:dataSource];
}

- (void)showDataSource:(id<UITableViewDataSource, UITableViewDelegate>)dataSource {
    if (self.currentDataSource != dataSource) {
        self.tableView.dataSource = dataSource;
        self.tableView.delegate = dataSource;
        [self.tableView reloadData];
        self.currentDataSource = dataSource;
    }
}

- (NSString *)emptyDataSourceText {
    return NSLocalizedString(@"Nothing to display", @"");
}

#pragma mark - SSPullToRefresh
- (BOOL)shouldAllowPullToRefresh {
    return YES;
}
- (UIView <SSPullToRefreshContentView> *)pullToRefreshContentView {
    SSPullToRefreshSimpleContentView *view = [[SSPullToRefreshSimpleContentView alloc] init];
//    view.statusLabel.font = [UIFont HMSDemiBoldFontOfSize:view.statusLabel.font.pointSize];
    return view;
}

- (void)addPullToRefresh {
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
    self.pullToRefreshView.contentView = [self pullToRefreshContentView];
}

#pragma mark - SSPullToRefreshViewDelegate
- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    if (!self.shouldIgnorePullToRefreshCall) {
        self.userDidTriggerRefreshByPulling = YES;
        [self refresh];
    }
}

#pragma mark - Refresh

- (NSDate *)refresh {
    [self willStartRefreshing];

    __weak __typeof(&*self)weakSelf = self;
    NSDate *date = [NSDate date];
    self.currentRequest = [self didRequestRefreshRequestWithCompletion:^(NSError *error) {
        [weakSelf didFinishRefreshing:error requestIdentifier:date];
    }];

    if (self.currentRequest) {
        [self.requests setObject:self.currentRequest forKey:date];
    }
    return date;
}

- (void)willStartRefreshing {
    [self showNavLoadingIfNecessary];
    [self showLoadingViewIfNecessary];
    [self cancelAllExistingRequests];
    
    // The ignore must be set or we end up with the refresh being called twice
    self.shouldIgnorePullToRefreshCall = YES;
    [self.pullToRefreshView startLoading];
}

- (void)cancelAllExistingRequests {
    [self.requests enumerateKeysAndObjectsUsingBlock:^(id key, NSOperation *operation, BOOL *stop) {
        [operation cancel];
    }];
}

- (NSOperation *)didRequestRefreshRequestWithCompletion:(void (^)(NSError *))refreshCompletion {
    if (refreshCompletion) {
        refreshCompletion(nil);
    }
    return nil;
}

- (void)didFinishRefreshing:(NSError *)error requestIdentifier:(NSDate *)date {
    NSOperation *op = self.requests[date];
    
    if (op == self.currentRequest) {
        self.shouldIgnorePullToRefreshCall = NO;
        self.userDidTriggerRefreshByPulling = NO;

        if ([self anyObjectsToDisplay]) {
            [self showDataSource:self.dataSource];
        }else{
            [self showDataSource:self.emptyDataSource];
        }
        
        [self.pullToRefreshView finishLoading];
//        [self HMS_hideActivityIndicator];
        [self showError:error withRequestIdentifier:date];

        self.currentRequest = nil;
    }

    if (date) {
        [self.requests removeObjectForKey:date];
    }
}

- (void)showError:(NSError *)error withRequestIdentifier:(NSDate *)date {
    NSOperation *operation = self.requests[date];
    if ([operation isCancelled]) {
        return;
    }
//    if (error) {
//        [TSMessage showNotificationInViewController:self withTitle:NSLocalizedString(@"Error", @"") withMessage:[error localizedDescription] withType:TSMessageNotificationTypeError];
//    }
}

- (BOOL)anyObjectsToDisplay {
    return [self.dataSource countOfObjects] > 0;
}

- (void)showNavLoadingIfNecessary {
    if ([self anyObjectsToDisplay] && !self.userDidTriggerRefreshByPulling) {
//        [self HMS_showActivityIndicatorInNavBar];
    }
}

- (void)showLoadingViewIfNecessary {
    if (![self anyObjectsToDisplay] && !self.userDidTriggerRefreshByPulling) {
        [self showDataSource:self.loadingDataSource];
    }
}

#pragma mark - Lazy Properties

- (JGALoadingTableDataSource *)loadingDataSource {
    if (!_loadingDataSource) {
        JGALoadingTableDataSource *loadingDataSource = [[JGALoadingTableDataSource alloc] init];
        self.loadingDataSource = loadingDataSource;
    }
    return _loadingDataSource;
}

- (JGAEmptyTableDataSource *)emptyDataSource {
    if (!_emptyDataSource) {
        JGAEmptyTableDataSource *emptyDataSource = [[JGAEmptyTableDataSource alloc] init];
        self.emptyDataSource = emptyDataSource;
    }
    [_emptyDataSource setNoDataDisplayText:self.emptyDataSourceText];
    return _emptyDataSource;
}

#pragma mark - Nav Buttons
//- (void)addMenuButton {
//    HMSCFlatNavButton *button = [HMSCFlatNavButton buttonWithFAIcon:FAIconReorder];
//    
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    [button addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = barButton;
//}
//
//- (void)menuButtonPressed:(id)sender {
//    [[self mm_drawerController] openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//}

#pragma mark - HMSFetchedTableDataSourceDelegate
- (void)fetchedDataSourceDidFindResults:(JGAFetchedTableDataSource *)dataSource {
    if (self.tableView.dataSource == self.emptyDataSource){
        [self showDataSource:self.dataSource];
    }
}
- (void)fetchedDataSourceDidReturnNoResults:(JGAFetchedTableDataSource *)dataSource {
    [self showDataSource:self.emptyDataSource];
}

- (void)fetchedDataSource:(JGAFetchedTableDataSource *)dataSource didSelectObject:(id)object {
    // noop
    // Override in subclass
}

#pragma mark - ApplicationNotifications
- (void)observeApplicationNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:HMSEventUserDidLogin object:nil];
}
- (void)stopObservingApplicationNotifications {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:HMSEventUserDidLogin object:nil];
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    [self refresh];
}

@end
