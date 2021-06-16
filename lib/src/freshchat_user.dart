part of freshchat;

/// [FreshchatUser] is a User object that provides basic user informtation.
///
/// You can send basic user information at any point to give you more context
/// on the user when your support agents are messaging back and forth with them.
class FreshchatUser {
  FreshchatUser.initial()
      : id = '',
        email = '',
        referenceId = '',
        createdTime = DateTime.now(),
        phone = '',
        firstName = '',
        lastName = '',
        phoneCountryCode = '';

  FreshchatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    email = json['email'] as String?;
    referenceId = json['reference_id'] as String?;
    firstName = json['first_name'] as String?;
    lastName = json['last_name'] as String?;
    phone = json['phone'] as String?;
    createdTime = (json['createdTime'] as String?) != null
        ? DateTime.parse(json['createdTime'] as String)
        : null;
    phoneCountryCode = json['phone_country_code'] as String?;
  }

  String? id;
  String? email;
  String? referenceId;
  DateTime? createdTime;
  String? phone;
  String? firstName;
  String? lastName;
  String? phoneCountryCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = <String, dynamic>{};

    result['id'] = id;
    result['email'] = email;
    result['first_name'] = firstName;
    result['last_name'] = lastName;
    result['phone'] = phone;
    result['reference_id'] = referenceId;
    result['created_time'] = createdTime.toString();
    result['phone_country_code'] = phoneCountryCode;

    return result;
  }
}
