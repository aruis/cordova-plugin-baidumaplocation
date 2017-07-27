//
//  BaiduMapLocation.h
//
//  Created by LiuRui on 2017/2/25.
//

#import <Cordova/CDV.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface BaiduMapLocation : CDVPlugin<BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate> {
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geoCodeSerch;
    CDVInvokedUrlCommand* _execCommand;
    NSMutableDictionary* _data;
}


- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command;
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation;

@end