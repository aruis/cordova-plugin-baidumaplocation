#百度地图定位Cordova插件
__Android版可用，IOS版开发中...__


##致谢: 本插件的开发主要参考 [cordova-qdc-baidu-location](https://github.com/liangzhenghui/cordova-qdc-baidu-location),感谢[liangzhenghui](https://github.com/liangzhenghui)
##由于[cordova-qdc-baidu-location](https://github.com/liangzhenghui/cordova-qdc-baidu-location)明确表示没有IOS版，所以才有了重新开发一版兼容Android与IOS的想法。这样才能保证不同平台获取的坐标系是基于同一编码的，方便逻辑的统一性。

###Android 版原作者[mrwutong](https://github.com/mrwutong)的话

>>>####Android版为什么不使用官方的_cordova-plugin-geolocation_插件
>>>最新版的插件已经删除掉的Android版定位的代码，改为基于系统浏览器(chrome内核)进行定位。
>>>
>>>为什么这样做，也有人问过同样的问题，作者的回答是这样比原生定位更快更准确。
>>>
>>>但经过测试后，发现根本无法定位，几经调查发现跟貌似国内网络有关系，原因相信大家都懂的，此过省略好几个字。。。。
>>>
>>>__此插件就这么诞生了__

####版本
基于百度地图Android版定位SDK（v7.1）

####一，申请密钥
请参照：[申请密钥Android定位SDK](http://developer.baidu.com/map/index.php?title=android-locsdk/guide/key)

>>每一个独立包名的App 对应一个AK，不可混用

####二，安装插件````

```shell
ionic plugin add https://github.com/aruis/cordova-plugin-baidumaplocation --variable ANDROID_KEY="<API_KEY>"
//此处的API_KEY来自于第一步，直接替换<API_KEY>，也可以最后跟 --save 参数，将插件信息保存到config.xml中
```

####三，使用方法

```javascript
// 进行定位
baidumap_location.getCurrentPosition(function (result) {
    console.log("================")
    console.log(JSON.stringify(result, null, 4));
}, function (error) {

});
```

获得定位信息，返回JSON格式数据:

```javascript
{
    "time": "2017-02-25 17:30:00",//获取时间
    "locType": 161,//定位类型
    "locTypeDescription": "NetWork location successful!",//定位类型解释
    "latitude": 34.6666666,//纬度
    "lontitude": 117.8888,//经度
    "radius": 61.9999999,//半径
    "userIndoorState": 1,//是否室内
    "direction": -1//方向
}
```
具体字段内容请参照：[BDLocation v7.1](http://wiki.lbsyun.baidu.com/cms/androidloc/doc/v7.1/index.html)

如果获取到的信息是：

```javascript
{
    "locType": 505,
    "locTypeDescription": "NetWork location failed because baidu location service check the key is unlegal, please check the key in AndroidManifest.xml !",
    "latitude": 5e-324,
    "lontitude": 5e-324,
    "radius": 0,
    "userIndoorState": -1,
    "direction": -1
}
```

说明Key有问题，可以检查下生成的AndroidManifest.xml文件里面是否有如下信息

```xml
  <service android:enabled="true" android:name="com.baidu.location.f" android:process=":remote">
            <intent-filter>
                <action android:name="com.baidu.location.service_v2.2" />
            </intent-filter>
        </service>
  <meta-data android:name="com.baidu.lbsapi.API_KEY" android:value="Ybl59x5hTw5IOlSjUnUuBsihrb4C1eQQ" />
```

如果没有，说明插件使用不当，尝试重新安装，如果有这些信息，说明Key与当前程序的包名不一致，请检查Key的申请信息是否正确

####四，查看当前安装了哪些插件

```shell
ionic plugin ls
```

####五，删除本插件

```shell
ionic plugin rm cordova-plugin-baidumaplocation
```







