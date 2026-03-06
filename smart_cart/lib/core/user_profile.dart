class UserProfile {
  final int age;
  final double heightCm;
  final String goal;
  final String sex;
  final String activityLevel;
  final String foodRestrictions;

  const UserProfile({
    required this.age,
    required this.heightCm,
    required this.goal,
    required this.sex,
    required this.activityLevel,
    required this.foodRestrictions,
  });

  const UserProfile.empty()
    : age = 25,
      heightCm = 170,
      goal = 'Maintain',
      sex = 'Prefer not to say',
      activityLevel = 'Moderate',
      foodRestrictions = '';

  UserProfile copyWith({
    int? age,
    double? heightCm,
    String? goal,
    String? sex,
    String? activityLevel,
    String? foodRestrictions,
  }) {
    return UserProfile(
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      goal: goal ?? this.goal,
      sex: sex ?? this.sex,
      activityLevel: activityLevel ?? this.activityLevel,
      foodRestrictions: foodRestrictions ?? this.foodRestrictions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'heightCm': heightCm,
      'goal': goal,
      'sex': sex,
      'activityLevel': activityLevel,
      'foodRestrictions': foodRestrictions,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      age: (json['age'] as num?)?.toInt() ?? 25,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 170,
      goal: (json['goal'] as String?) ?? 'Maintain',
      sex: (json['sex'] as String?) ?? 'Prefer not to say',
      activityLevel: (json['activityLevel'] as String?) ?? 'Moderate',
      foodRestrictions: (json['foodRestrictions'] as String?) ?? '',
    );
  }
}
