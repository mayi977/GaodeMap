//
//  CustomAnnotationView.h
//  GaoDeDemo
//
//  Created by Zilu.Ma on 16/3/28.
//  Copyright © 2016年 VSI. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CsutomCalloutView.h"

@interface CustomAnnotationView : MAPinAnnotationView

@property (nonatomic, readonly) CsutomCalloutView *calloutView;

@end
