//
//  ViewController.m
//  GaoDeDemo
//
//  Created by Zilu.Ma on 16/3/28.
//  Copyright © 2016年 VSI. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotationView.h"//自定义气泡

@interface ViewController ()<MAMapViewDelegate>

{
    MAMapView *_mapView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [MAMapServices sharedServices].apiKey = @"7477cbdf53be41705443a32e97daec96";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mapView.delegate = self;
    
    //此为指南针的默认位置
    _mapView.showsCompass = YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22); //设置指南针位置
    _mapView.showsScale = YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);  //设置比例尺位置
    
    //手势
    _mapView.zoomEnabled = YES;    //NO表示禁用缩放手势，YES表示开启
    _mapView.scrollEnabled = YES;    //NO表示禁用滑动手势，YES表示开启
//    [_mapView setCenterCoordinate:center animated:YES];//地图平移时，缩放级别不变，可通过改变地图的中心点来移动地图
    
    //英文显示
//    _mapView.language = MAMapLanguageEn;
    
    //定位
    _mapView.showsUserLocation = YES;
    
    //MAUserTrackingModeFollowWithHeading:跟随用户的位置和角度移动
    //MAUserTrackingModeFollow:跟随用户位置移动，并将定位点设置成地图中心点。
    //MAUserTrackingModeNone:仅在地图上显示,不跟随用户位置
    [_mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];
    
    //MAMapTypeStandard 普通地图
    //MAMapTypeSatellite 卫星地图
    _mapView.mapType = MAMapTypeStandard;
    
    //地图的缩放级别,有效值的范围为从 3 到 19
    [_mapView setZoomLevel:17.5 animated:YES];
    
    //实时交通路况?????
//    _mapView.showTraffic = YES;
    
    [self.view addSubview:_mapView];
    
    //添加图片覆盖物??????
//    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake
//                                                                 (31.250966, 121.438621),CLLocationCoordinate2DMake(31.252970, 121.438630));
//    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"GWF"]];
//    [_mapView addOverlay:groundOverlay];
//    _mapView.visibleMapRect = groundOverlay.boundingMapRect;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //实现大头针标注
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(31.250966, 121.438621);
    pointAnnotation.title = @"203";
    pointAnnotation.subtitle = @"中潭路99弄79号";
    [_mapView addAnnotation:pointAnnotation];
}

//添加图片覆盖物
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc]
                                                  initWithGroundOverlay:overlay];
        
        return groundOverlayView;
    }
    return nil;
}

//大头针标注
//iOS SDK可自定义标注（包括 自定义标注图标 和 自定义气泡图标），均通过MAAnnotationView来实现。
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    /*
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout = YES;//设置气泡可以弹出
        annotationView.animatesDrop = YES;//设置标注动画显示
        annotationView.draggable = YES;//设置标注可以拖动
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        //自定义标注
//        annotationView.image = [UIImage imageNamed:@"restaurant"];//自定义标注的图标,图片名必须为restauant.png
//        annotationView.centerOffset = CGPointMake(0, -18);//设置中心点偏移,使得标注底部中间点成为经纬度对应点//
     
        return annotationView;
    }
    
    return nil;
     */
    
    //自定义气泡
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"restaurant"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        annotationView.animatesDrop = YES;//设置标注动画显示
        annotationView.draggable = YES;//设置标注可以拖动
        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}

//获取当前位置坐标
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (updatingLocation) {
        //获取当前位置坐标
        NSLog(@"latitude:%f.longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}

//自定义定位标注和精度圈的样式
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
}

//3D
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
//    
//    /* 自定义userLocation对应的annotationView. */
//    if ([annotation isKindOfClass:[MAUserLocation class]])
//    {
//        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
//        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
//        }
//        annotationView.image = [UIImage imageNamed:@"userPosition"];
//        
//        return annotationView;
//    }
//    return nil;
//}

//3D
//- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay{
//    
//    /* 自定义定位精度对应的MACircleView. */
//    if (overlay == mapView.userLocationAccuracyCircle)
//    {
//        MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
//        
//        accuracyCircleRenderer.lineWidth    = 2.f;
//        accuracyCircleRenderer.strokeColor  = [UIColor lightGrayColor];
//        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
//        
//        return accuracyCircleRenderer;
//    }
//    
//    return nil;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
