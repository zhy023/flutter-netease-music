import 'dart:convert';
import 'dart:io';

import 'package:tencentcloud_cos_sdk_plugin/cos.dart';
import 'package:tencentcloud_cos_sdk_plugin/fetch_credentials.dart';
import 'package:tencentcloud_cos_sdk_plugin/pigeon.dart';

class FetchCredentials implements IFetchCredentials {
  @override
  Future<SessionQCloudCredentials> fetchSessionCredentials() async {
    // 首先从您的临时密钥服务器获取包含了密钥信息的响应，例如：
    var httpClient = HttpClient();
    try {
      // 临时密钥服务器 url
      var stsUrl = "http://stsservice.com/sts";
      var request = await httpClient.getUrl(Uri.parse(stsUrl));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        print(json);

        // 然后解析响应，获取临时密钥信息
        var data = jsonDecode(json);
        // 最后返回临时密钥信息对象
        return SessionQCloudCredentials(
            secretId: data['credentials']['tmpSecretId'], // 临时密钥 SecretId
            secretKey: data['credentials']['tmpSecretKey'], // 临时密钥 SecretKey
            token: data['credentials']['sessionToken'], // 临时密钥 Token
            startTime: data['startTime'], //临时密钥有效起始时间，单位是秒
            expiredTime: data['expiredTime'] //临时密钥有效截止时间戳，单位是秒
            );
      } else {
        throw ArgumentError();
      }
    } catch (exception) {
      throw ArgumentError();
    }
  }
}
