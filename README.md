# 百度地图定位Cordova插件，支持Android，IOS，ionic 1x 2x 均可使用

### UPDATE:
* v4.0.2 修复Android Studio项目或新版本Cordova找不到so文件的问题
* v4.0.1 优化了ionic3x的兼容性，升级对应百度定位依赖库（v7.5@Android）
* v3.2.0 升级对应百度定位依赖库（v7.2@Android,v3.3.4@IOS）

### 可以在此地址查看[ionic3_example](https://github.com/aruis/testbmap-cordova-ionic3)

__致谢: 本插件Android开发主要参考 [cordova-qdc-baidu-location](https://github.com/liangzhenghui/cordova-qdc-baidu-location),感谢[liangzhenghui](https://github.com/liangzhenghui)；IOS开发主要参考[cordova-plugin-bdlocation](https://github.com/wilhantian/cordova-plugin-bdlocation)，感谢[wilhantian](https://github.com/wilhantian)__


__由于[cordova-qdc-baidu-location](https://github.com/liangzhenghui/cordova-qdc-baidu-location)明确表示没有IOS版，所以才有了重新开发一版兼容Android与IOS的想法。这样才能保证不同平台获取的坐标系是基于同一编码的，方便逻辑的统一性。__

__Android 版原作者[mrwutong](https://github.com/mrwutong)的话__

>#### Android版为什么不使用官方的_cordova-plugin-geolocation_插件
>最新版的插件已经删除掉的Android版定位的代码，改为基于系统浏览器(chrome内核)进行定位。
>
>为什么这样做，也有人问过同样的问题，作者的回答是这样比原生定位更快更准确。
>
>但经过测试后，发现根本无法定位，几经调查发现跟貌似国内网络有关系，原因相信大家都懂的，此过省略好几个字。。。。
>
>__此插件就这么诞生了__

#### 零，版本
基于百度地图Android版定位SDK（v7.2）以及百度地图IOS SDK （v3.3.4）

#### 一，申请Android及IOS版密钥
[申请密钥Android定位SDK](http://developer.baidu.com/map/index.php?title=android-locsdk/guide/key)

>每一个AndroidManifest.xml 中的package属性 对应一个AK，不可混用

[iOS SDK开发密钥](http://lbsyun.baidu.com/index.php?title=iossdk/guide/key)

>每一个Bundle Identifier 对应一个AK，不可混用
  
#### 二，安装插件

```shell
cordova plugin add cordova-plugin-baidumaplocation --variable ANDROID_KEY="<API_KEY_ANDROID>" --variable IOS_KEY="<API_KEY_IOS>"
# 此处的API_KEY_XX来自于第一步，直接替换<API_KEY_XX>，也可以最后跟 --save 参数，将插件信息保存到config.xml中
# 如果只需要Android端或者IOS端，可以只填写一个相应的AK，但是都不填肯定不行
```

#### 三，使用方法

```javascript
// 进行定位
baidumap_location.getCurrentPosition(function (result) {
    console.log(JSON.stringify(result, null, 4));
}, function (error) {

});
```

获得定位信息，返回JSON格式数据:

```javascript
{
    "time": "2017-02-25 17:30:00",//获取时间
    "latitude": 34.6666666,//纬度
    "longitude": 117.8888,//经度
    "radius": 61.9999999,//半径
 
    //--------Android 独享 begin
    "locType": 161,//定位类型                                            
    "locTypeDescription": "NetWork location successful!",//定位类型解释   
    "userIndoorState": 1,//是否室内                                     
    //--------Android 独享 end
    
    //--------IOS 独享 begin
    "title": "我的位置",//定位标注点标题信息
    "subtitle": "我的位置",//定位标注点子标题信息
    //--------IOS 独享 end
}
```


具体可参考如下截图


![Android Screenshot](https://github.com/aruis/cordova-plugin-baidumaplocation/raw/master/android.jpg)
![IOS Screenshot](https://github.com/aruis/cordova-plugin-baidumaplocation/raw/master/ios.PNG)


具体字段内容请参照：
>[Android版 BDLocation v7.2](http://wiki.lbsyun.baidu.com/cms/androidloc/doc/v7.2/index.html)

>[IOS版 BMKUserLocation v3.3.4](http://wiki.lbsyun.baidu.com/cms/iossdk/doc/v3_3_4/html/interface_b_m_k_user_location.html#aba4b76e55f4605c5554fe16aca1b4fbf) 

如果Android版获取到的信息是：

```json
{
    "locType": 505,
    "locTypeDescription": "NetWork location failed because baidu location service check the key is unlegal, please check the key in AndroidManifest.xml !",
    "latitude": 5e-324,
    "longitude": 5e-324,
    "radius": 0,
    "userIndoorState": -1,
    "direction": -1
}
```

说明Key有问题，可以检查下生成的AndroidManifest.xml文件里面是否有如下信息

```xml
<service android:enabled="true" android:name="com.baidu.location.f" android:process=":remote">
</service>
<meta-data android:name="com.baidu.lbsapi.API_KEY" android:value="abcdefghijklmn" />
```

如果没有，说明插件使用不当，尝试重新安装，如果有这些信息，说明Key与当前程序AndroidManifest.xml 中的package名不一致，请检查Key的申请信息是否正确

#### 四，查看当前安装了哪些插件

```shell
cordova plugin ls
```

#### 五，删除本插件

```shell
cordova plugin rm cordova-plugin-baidumaplocation
```
#### 至ionic3用户，如何在ionic3项目中使用非ionic维护的cordova插件，可以参考：[https://stackoverflow.com/questions/37942202/using-a-third-party-cordova-plugin-in-ionic-2-with-typescript](https://stackoverflow.com/questions/37942202/using-a-third-party-cordova-plugin-in-ionic-2-with-typescript)