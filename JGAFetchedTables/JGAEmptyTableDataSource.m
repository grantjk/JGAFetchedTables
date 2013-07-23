//
//  HMSCEmptyTableDataSource.m
//  WellxProviders
//
//  Created by John Grant on 2013-06-07.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import "JGAEmptyTableDataSource.h"
#import "JGATableCell.h"

@interface JGAEmptyTableDataSource ()
@property (nonatomic, weak) JGATableCell *cell;
@end

@implementation JGAEmptyTableDataSource

- (void)setNoDataDisplayText:(NSString *)noDataDisplayText {
    _noDataDisplayText = noDataDisplayText;
    self.cell.statusLabel.text = noDataDisplayText;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ca.wellx.emptyTableDataSource";
    
    JGATableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[JGATableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.statusLabel.text = self.noDataDisplayText;
    
    self.cell = cell;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.height;
}
@end
