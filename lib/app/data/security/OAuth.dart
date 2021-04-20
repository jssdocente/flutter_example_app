
class OAuthToken {
  String accessToken;
  String refreshToken;

  OAuthToken({this.accessToken, this.refreshToken});
}

abstract class OAuthStorage {
  Future<OAuthToken> fetch();
  Future<OAuthToken> save(OAuthToken token);
  Future<void> clear();
}

