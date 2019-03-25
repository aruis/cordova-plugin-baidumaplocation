//
//  BaiduMapLocation.mm
//
//  Created by LiuRui on 2017/2/25.
//

#import "BaiduMapLocation.h"

@implementation BaiduMapLocation


- (void)pluginInitialize
{
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    NSString* IOS_KEY = [[plistDic objectForKey:@"BaiduMapLocation"] objectForKey:@"IOS_KEY"];
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:IOS_KEY authDelegate:nil];
    
    
    _localManager = [[BMKLocationManager alloc] init];
    _localManager.delegate = self;
}

- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command
{
    _execCommand = command;
    [_localManager setLocatingWithReGeocode:YES];
    [_localManager startUpdatingLocation];
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)userLocation orError:(NSError * _Nullable)error
{
    if(_execCommand != nil)
    {
        NSMutableDictionary* _data = [[NSMutableDictionary alloc] init];
        
        if(error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            NSNumber* errorCode = [NSNumber numberWithInteger: error.code];
            NSString* errorDesc = error.localizedDescription;
            
            [_data setValue:errorCode forKey:@"errorCode"];
            [_data setValue:errorDesc forKey:@"errorDesc"];
        }if(userLocation){
            if(userLocation.location){
                NSDate* time = userLocation.location.timestamp;
                NSNumber* latitude = [NSNumber numberWithDouble:userLocation.location.coordinate.latitude];
                NSNumber* longitude = [NSNumber numberWithDouble:userLocation.location.coordinate.longitude];
                NSNumber* radius = [NSNumber numberWithDouble:userLocation.location.horizontalAccuracy];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                [_data setValue:[dateFormatter stringFromDate:time] forKey:@"time"];
                [_data setValue:latitude forKey:@"latitude"];
                [_data setValue:longitude forKey:@"longitude"];
                [_data setValue:radius forKey:@"radius"];
            }
            if(userLocation.rgcData){
                NSString* country = userLocation.rgcData.country;
                NSString* countryCode = userLocation.rgcData.countryCode;
                NSString* city = userLocation.rgcData.city;
                NSString* cityCode = userLocation.rgcData.cityCode;
                NSString* district = userLocation.rgcData.district;
                NSString* street = userLocation.rgcData.street;
                NSString* province = userLocation.rgcData.province;
                NSString* locationDescribe = userLocation.rgcData.locationDescribe;
                NSString* streetNumber = userLocation.rgcData.streetNumber;
                NSString* adCode = userLocation.rgcData.adCode;
                
                [_data setValue:countryCode forKey:@"countryCode"];
                [_data setValue:country forKey:@"country"];
                [_data setValue:cityCode forKey:@"citycode"];
                [_data setValue:city forKey:@"city"];
                [_data setValue:district forKey:@"district"];
                [_data setValue:street forKey:@"street"];
                [_data setValue:streetNumber forKey:@"street"];
                [_data setValue:province forKey:@"province"];
                [_data setValue:adCode forKey:@"adCode"];
                [_data setValue:locationDescribe forKey:@"locationDescribe"];
            }
        }
        
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:_data];
        [result setKeepCallbackAsBool:TRUE];
        [self.commandDelegate sendPluginResult:result callbackId:_execCommand.callbackId];
        
        [_localManager stopUpdatingLocation];
        _execCommand = nil;
    }
}

@end
