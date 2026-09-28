import '../../../../domain/domain.dart';
import '../../../data.dart';

// Home page model

class HomePageModel extends HomePageEntity {
  const HomePageModel({
    required super.id,
    ProfileModel? super.profile,
    BannersModel? super.banners,
    List<SlideshowModel>? super.slideshow,
    List<MerchantModel>? super.merchants,
    List<CategoryVoucherModel>? super.categories,
    List<MiniProgramModel>? super.mini,
    super.announcements,
    List<HighlightModel>? super.highlight,
    List<UpcomingModel>? super.upcoming,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) {
    var index = 0;
    var banner = BannersModel.fromJson(json['banners']);

    List<SlideshowModel> slideshow = [];
    if (json['slideshow'] != null) {
      for (var s in (json['slideshow'] as List)) {
        if (s is String) {
          // Wrap raw String URL in a SlideshowModel
          slideshow.add(SlideshowModel(id: '', path: s, url: ''));
        } else if (s is Map<String, dynamic>) {
          // Normal JSON Object
          slideshow.add(SlideshowModel.fromJson(s));
        }
      }
    }

    // List<SlideshowModel> slideshow = [];
    // if (json['slideshow'] != null) {
    //   for (var s in (json['slideshow'] as List)) {
    //     {
    //       slideshow.add(SlideshowModel.fromJson(s));
    //     }
    //   }
    // }

    List<MerchantModel> merchants = [];
    if (json['merchants'] != null) {
      for (var s in (json['merchants'] as List)) {
        {
          merchants.add(MerchantModel.fromJson(s));
        }
      }
    }

    List<CategoryVoucherModel> categories = [];
    if (json['categories'] != null) {
      for (var s in (json['categories'] as List)) {
        {
          categories.add(CategoryVoucherModel.fromJson(s));
        }
      }
    }

    List<MiniProgramModel> mini = [];
    if (json['mini'] != null) {
      for (var s in (json['mini'] as List)) {
        {
          mini.add(MiniProgramModel.fromJson(s));
        }
      }
    }

    List<HighlightModel> highlight = [];
    if (json['highlight'] != null) {
      for (var s in (json['highlight'] as List)) {
        {
          highlight.add(HighlightModel.fromJson(s));
        }
      }
    }

    List<UpcomingModel> upcoming = [];
    if (json['upcoming'] != null) {
      for (var s in (json['upcoming'] as List)) {
        {
          upcoming.add(UpcomingModel.fromJson(s));
        }
      }
    }

    return HomePageModel(
      id: (index++).toString(),
      profile: ProfileModel.fromJson(json['profile']),
      banners: banner,
      slideshow: slideshow,
      merchants: merchants,
      categories: categories,
      mini: mini,
      announcements: json['announcements'] ?? '',
      highlight: highlight,
      upcoming: upcoming,
    );
  }
}
