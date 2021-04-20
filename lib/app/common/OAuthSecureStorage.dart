import 'package:apnapp/app/data/security/OAuth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class OAuthSecureStorage extends OAuthStorage {
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  final accessTokenKey = 'accessToken';
  final refreshTokenKey = 'refreshToken';

  @override
  Future<OAuthToken> fetch() async {
    return OAuthToken(
        accessToken: await storage.read(key: accessTokenKey),
        refreshToken: await storage.read(key: refreshTokenKey)
    );
  }

  @override
  Future<OAuthToken> save(OAuthToken token) async {
    await storage.write(key: accessTokenKey, value: token.accessToken);
    await storage.write(key: refreshTokenKey, value: token.refreshToken);
    return token;
  }

  Future<void> clear() async {
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
  }

  Future<void> clearToken() async {
    await storage.delete(key: accessTokenKey);
  }
}