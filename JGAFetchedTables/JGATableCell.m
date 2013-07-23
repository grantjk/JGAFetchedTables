//
//  HMSCMessagesLoadingTableCell.m
//  WellxProviders
//
//  Created by John Grant on 2013-05-28.
//  Copyright (c) 2013 Healthcare Made Simple. All rights reserved.
//

#import "JGATableCell.h"

@implementation JGATableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textColor = [UIColor darkGrayColor];
        self.statusLabel.shadowColor = [UIColor whiteColor];
        self.statusLabel.shadowOffset = CGSizeMake(0, 1);
//        self.statusLabel.font = [UIFont HMSFontOfSize:14];
        self.statusLabel.font = [UIFont systemFontOfSize:14];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityView.hidesWhenStopped = YES;
        self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.activityView];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    NSString *format;
    NSArray *constraints;
    NSDictionary *views = NSDictionaryOfVariableBindings(_statusLabel, _activityView);
    
    CGFloat padding = 6;
    format = [NSString stringWithFormat:@"V:[_statusLabel]-(%f)-[_activityView]", padding];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatAlignAllCenterX metrics:0 views:views];
    [self.contentView addConstraints:constraints];

    NSLayoutConstraint *constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self.statusLabel
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.contentView
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1 constant:0];
    [self.contentView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.statusLabel
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.contentView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1
                                               constant:-padding/2];
    [self.contentView addConstraint:constraint];
    
}

@end
