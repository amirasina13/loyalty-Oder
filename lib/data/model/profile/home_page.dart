import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR HOMEPAGE DETAILS
*/

class HomePage extends Equatable {
  final Profile? profile;
  final Banners? banners;
  final List<Slideshow>? slideshow;
  final List<Merchant>? merchants;
  final List<CategoryVoucher>? categories;
  final List<MiniProgram>? mini;
  final String? announcements;
  final List<Highlight>? highlight;
  final List<Upcoming>? upcoming;

  const HomePage({
    this.profile,
    this.banners,
    this.slideshow,
    this.merchants,
    this.categories,
    this.mini,
    this.announcements,
    this.highlight,
    this.upcoming,
  });

  @override
  List<Object?> get props => [
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

  @override
  factory HomePage.fromEntity(Entity entity) {
    if (entity is HomePageEntity) {
      List<Slideshow> slideshow = [];
      entity.slideshow?.forEach((s) {
        // slideshow.add(Slideshow.fromEntity(s));
        if (s is String) {
          // If backend returns a raw URL string
          slideshow.add(Slideshow(path: s.toString(), url: ''));
        } else {
          // If backend returns an object
          slideshow.add(Slideshow.fromEntity(s));
        }
      });

      List<Merchant> merchants = [];
      entity.merchants?.forEach((s) {
        merchants.add(Merchant.fromEntity(s));
      });

      List<CategoryVoucher> categories = [];
      entity.categories?.forEach((s) {
        categories.add(CategoryVoucher.fromEntity(s));
      });

      List<MiniProgram> mini = [];
      entity.mini?.forEach((s) {
        mini.add(MiniProgram.fromEntity(s));
      });

      List<Highlight> highlight = [];
      entity.highlight?.forEach((s) {
        highlight.add(Highlight.fromEntity(s));
      });

      List<Upcoming> upcoming = [];
      entity.upcoming?.forEach((s) {
        upcoming.add(Upcoming.fromEntity(s));
      });

      return HomePage(
        profile: Profile.fromEntity(entity.profile!),
        banners: Banners.fromEntity(entity.banners!),
        slideshow: slideshow,
        merchants: merchants,
        categories: categories,
        mini: mini,
        announcements: entity.announcements,
        highlight: highlight,
        upcoming: upcoming,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type HomePageEntity',
      );
    }
  }
}
