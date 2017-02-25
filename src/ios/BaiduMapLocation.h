//
//  BaiduMapLocation.h
//
//  Created by LiuRui on 2017/2/25.
//

#import <Cordova/CDV.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface BaiduMapLocation : CDVPlugin<BMKLocationServiceDelegate> {
    BMKLocationService* _locService;
    CDVInvokedUrlCommand* _execCommand;
}


- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command;
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;

@end