import 'package:meta/meta.dart';

class CachePayload {
  final DateTime updatedAt;
  final int ttlInSeconds;
  final String serializedData;

  CachePayload({
    this.updatedAt,
    this.ttlInSeconds,
    @required this.serializedData,
  });

  static final String dateTimeKey = 'dateTime';
  static final String ttlKey = 'ttl';
  static final String dataKey = 'data';

  Map<String, dynamic> toJson() => {
        dateTimeKey: DateTime.now().toIso8601String(),
        ttlKey: ttlInSeconds.toString(),
        dataKey: serializedData,
      };

  CachePayload.fromJson(Map<String, dynamic> json)
      : updatedAt = DateTime.parse(json[dateTimeKey]),
        ttlInSeconds =
            json[ttlKey] == null ? null : int.tryParse(json[ttlKey]) ?? null,
        serializedData = json[dataKey];

  CachePayload.fakeExpiredPayload(String serializedData)
      : serializedData = serializedData,
        ttlInSeconds = 180,
        updatedAt = DateTime.now().subtract(Duration(hours: 1));

  CachePayload.fakeValidPayload(String serializedData)
      : serializedData = serializedData,
        ttlInSeconds = 180,
        updatedAt = DateTime.now().subtract(Duration(seconds: 1));

  bool get isValid {
    if (ttlInSeconds == null || updatedAt == null) return true;

    final now = DateTime.now();
    final expiresAt = updatedAt.add(Duration(seconds: ttlInSeconds));
    return now.isBefore(expiresAt);
  }
}
