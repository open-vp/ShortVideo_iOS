//
//  MainTableViewCell.h
//  RTMPiOSDemo
//
//  Created by rushanting on 2017/5/3.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellInfo : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* iconName;
@property (nonatomic, copy) NSString* navigateToController;

@end



@interface MainTableViewCell : UITableViewCell

- (void)setCellData:(CellInfo*)cellInfo;

@end
