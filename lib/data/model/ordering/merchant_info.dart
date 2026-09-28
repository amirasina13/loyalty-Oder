import 'package:equatable/equatable.dart';

import '../../../domain/domain.dart';
import '../../data.dart';

/* 
  Equatable overrides == and hashCode for you so you don't have to waste your time writing lots of boilerplate code. 
  With Equatable there is no code generation needed.
  
  CLASS FOR MERCHANT Info
*/

class MerchantInfo extends Equatable {
  final String? id;
  final String? name;
  final String? color;
  final String? image;
  final bool? isMuslim;
  final String? muslimCategory;
  final bool? isFavourite;
  final String? merchantDesc;
  final List<String>? menus;
  final List<SocialList>? socials;
  // final List<DeliveryLink>? external;

  const MerchantInfo({
    this.id,
    this.name,
    this.color,
    this.image,
    this.isMuslim,
    this.muslimCategory,
    this.isFavourite,
    this.merchantDesc,
    this.menus,
    this.socials,
    // this.external,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    color,
    image,
    isMuslim,
    muslimCategory,
    isFavourite,
    merchantDesc,
    menus,
    socials,
    // external,
  ];

  @override
  factory MerchantInfo.fromEntity(Entity entity) {
    if (entity is MerchantInfoEntity) {
      List<String> menus = [];
      entity.menus?.forEach((s) {
        menus.add(s);
      });

      List<SocialList> socials = [];
      entity.socials?.forEach((s) {
        socials.add(SocialList.fromEntity(s));
      });

      return MerchantInfo(
        id: entity.id,
        name: entity.name,
        color: entity.color,
        image: entity.image,
        isMuslim: entity.isMuslim,
        muslimCategory: entity.muslimCategory,
        isFavourite: entity.isFavourite,
        merchantDesc: entity.merchantDesc,
        menus: menus,
        socials: socials,
        // external: external,
      );
    } else {
      throw EntityModelMapperException(
        message: 'Entity should be of type MerchantInfoEntity',
      );
    }
  }
}
