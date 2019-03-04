//
//  BaiduMapLocation.h
//
//  Created by LiuRui on 2017/2/25.
//

#import <Cordova/CDV.h>

#import <BMKLocationKit/BMKLocationComponent.h>

@interface BaiduMapLocation : CDVPlugin<BMKLocationManagerDelegate> {
    BMKLocationManager* _localManager;
    CDVInvokedUrlCommand* _execCommand;
}


- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command;
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)userLocation orError:(NSError *)error;

@end
