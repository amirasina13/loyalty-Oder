// Abstract repository for bulletin

abstract class BulletinRepository {
  Future<dynamic> listBulletin(String token, String type);
  Future<dynamic> getDetails(String token, String bulletinId);
}
