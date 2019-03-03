//
//  TestTableViewCell.m
//  CJWBaseObject_OC
//
//  Created by 陈经伟 on 2019/3/3.
//  Copyright © 2019 陈经伟. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell

- (void)configWithModel:(id)model{
    NSString *title = model;
    self.textLabel.text = title;
}

@end
