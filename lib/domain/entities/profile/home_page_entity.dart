import '../../domain.dart';

// HomePage entity

class HomePageEntity extends Entity<String> {
  final ProfileEntity? profile;
  final BannersEntity? banners;
  final List<SlideshowEntity>? slideshow;
  final List<MerchantEntity>? merchants;
  final List<CategoryVoucherEntity>? categories;
  final List<MiniProgramEntity>? mini;
  final String? announcements;
  final List<HighlightEntity>? highlight;
  final List<UpcomingEntity>? upcoming;

  const HomePageEntity({
    required String id,
    this.profile,
    this.banners,
    this.slideshow,
    this.merchants,
    this.categories,
    this.mini,
    this.announcements,
    this.highlight,
    this.upcoming,
  }) : super(id);

  @override
  List<Object?> get props => [
    id,
    profile,
    banners,
    slideshow,
    merchants,
    categories,
    mini,
    announcements,
    highlight,
    upcoming,
  ];
}
