//
//  HMSCEmptyTableDataSource.h
//  WellxProviders
//
//  Created by John Grant on 2013-06-07.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGAEmptyTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *noDataDisplayText;

@end
