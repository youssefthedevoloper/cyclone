// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      nationality: json['nationality'] as String?,
      passportNumber: json['passportNumber'] as String?,
      preferredLanguage: json['preferredLanguage'] as String?,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
      'nationality': instance.nationality,
      'passportNumber': instance.passportNumber,
      'preferredLanguage': instance.preferredLanguage,
      'biometricEnabled': instance.biometricEnabled,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
