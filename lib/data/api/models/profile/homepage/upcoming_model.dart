import '../../../../../domain/domain.dart';

// Upcoming model (will call in home_page_model.dart)

class UpcomingModel extends UpcomingEntity {
  const UpcomingModel({
    required super.id,
    super.name,
    super.image,
    super.isClickable,
  });

  factory UpcomingModel.fromJson(Map<String, dynamic> json) {
    return UpcomingModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isClickable: json['isClickable'] ?? '',
    );
  }
}
