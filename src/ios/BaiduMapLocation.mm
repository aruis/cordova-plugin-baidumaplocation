//
//  BaiduMapLocation.m
//
//  Created by LiuRui on 2017/2/25.
//

#import "BaiduMapLocation.h"

@implementation BaiduMapLocation

- (void)pluginInitialize
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSString* IOS_KEY = [[plistDic objectForKey:@"BaiduMapLocation"] objectForKey:@"IOS_KEY"];

    [[[BMKMapManager alloc] init] start:IOS_KEY generalDelegate:nil];

    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
}

- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command
{
    _execCommand = command;

    NSArray* args = [command arguments];
    NSString* mode = args[0];
    double distanceFilter = [args[6] doubleValue];

    if([mode isEqualToString:@"Battery_Saving"]){
        _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    else if([mode isEqualToString:@"Battery_Saving"]){
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
    }
    else{
        _locService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    }

    _locService.distanceFilter = distanceFilter;

    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(_execCommand != nil)
    {
        NSDate* time = userLocation.location.timestamp;
        NSNumber* latitude = [NSNumber numberWithDouble:userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithDouble:userLocation.location.coordinate.longitude];
        NSNumber* altitude = [NSNumber numberWithDouble:userLocation.location.altitude];
        NSNumber* radius = [NSNumber numberWithDouble:userLocation.location.horizontalAccuracy];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
        [data setValue:[dateFormatter stringFromDate:time] forKey:@"time"];
        [data setValue:latitude forKey:@"latitude"];
        [data setValue:longitude forKey:@"longitude"];
        [data setValue:altitude forKey:@"altitude"];
        [data setValue:radius forKey:@"radius"];

        NSMutableDictionary* json = [[NSMutableDictionary alloc] init];
        [json setValue:[NSNumber numberWithInt:0] forKey:@"code"];
        [json setValue:@"success" forKey:@"msg"];
        [json setValue:data forKey:@"data"];

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:json];
        [result setKeepCallbackAsBool:TRUE];
        [_locService stopUserLocationService];
        [self.commandDelegate sendPluginResult:result callbackId:_execCommand.callbackId];
        _execCommand = nil;
    }
}