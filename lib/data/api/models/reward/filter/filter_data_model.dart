import '../../../../../domain/domain.dart';
import '../../../../data.dart';

// Reward data details model

class FilterDataModel extends FilterDataEntity {
  const FilterDataModel({
    required super.id,
    super.title,
    super.options,
    super.input,
  });

  factory FilterDataModel.fromJson(Map<String, dynamic> json) {
    List<OptionsCategoryModel> options = [];
    if (json['options'] != null) {
      for (var s in (json['options'] as List)) {
        {
          options.add(OptionsCategoryModel.fromJson(s));
        }
      }
    }

    return FilterDataModel(
      id: json['id'].toString(),
      title: json['title'],
      options: options,
      input: json['input'],
    );
  }
}
