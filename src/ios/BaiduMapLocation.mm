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
    

    [[[BMKMapManager alloc] init] start:IOS_KEY generalDelegate:nil];

    _data = [[NSMutableDictionary alloc] init];

    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;

    _geoCodeSerch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSerch.delegate = self;
}

- (void)getCurrentPosition:(CDVInvokedUrlCommand*)command
{
    _execCommand = command;
    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if(_execCommand != nil)
    {
        NSDate* time = userLocation.location.timestamp;
        NSNumber* latitude = [NSNumber numberWithDouble:userLocation.location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithDouble:userLocation.location.coordinate.longitude];        
        NSNumber* radius = [NSNumber numberWithDouble:userLocation.location.horizontalAccuracy];
        NSString* title = userLocation.title;
        NSString* subtitle = userLocation.subtitle;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [_data setValue:[dateFormatter stringFromDate:time] forKey:@"time"];
        [_data setValue:latitude forKey:@"latitude"];
        [_data setValue:longitude forKey:@"longitude"];        
        [_data setValue:radius forKey:@"radius"];
        [_data setValue:title forKey:@"title"];
        [_data setValue:subtitle forKey:@"subtitle"];

        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
        if (latitude!= 0  && longitude!= 0){
            pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
        }

        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = pt;
        BOOL flag = [_geoCodeSerch reverseGeoCode:reverseGeocodeSearchOption];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {        

         BMKAddressComponent *component=[[BMKAddressComponent alloc]init];
         component=result.addressDetail;
                  
         NSString* countryCode = component.countryCode;
         NSString* country = component.country;
         //NSString* adCode = component.adCode;
         NSString* city = component.city;
         NSString* district = component.district;
         NSString* streetName = component.streetName;
         NSString* province = component.province;
         NSString* addr = result.address;
         NSString* sematicDescription = result.sematicDescription;
 
        [_data setValue:countryCode forKey:@"countryCode"];
        [_data setValue:country forKey:@"country"];
        //[_data setValue:adCode forKey:@"citycode"];
        [_data setValue:city forKey:@"city"];
        [_data setValue:district forKey:@"district"];
        [_data setValue:streetName forKey:@"street"];
        [_data setValue:province forKey:@"province"];
        [_data setValue:addr forKey:@"addr"];
        [_data setValue:sematicDescription forKey:@"locationDescribe"];

        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:_data];
        [result setKeepCallbackAsBool:TRUE];
        [_locService stopUserLocationService];
        [self.commandDelegate sendPluginResult:result callbackId:_execCommand.callbackId];
        _execCommand = nil;
    }
}

@end