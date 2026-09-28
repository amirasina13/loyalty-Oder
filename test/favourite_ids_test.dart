import 'package:flutter_test/flutter_test.dart';
import 'package:oder_staging/app_setting/storage.dart';
import 'package:oder_staging/data/data.dart';
import 'package:oder_staging/locator.dart' as locator;
import 'package:oder_staging/presentation/features/ordering/ordering.dart';
import 'package:oder_staging/presentation/features/rewards/reward.dart';

class FavouriteRepository {
  String? savedId;
  bool favourite = false;
  Map<String, dynamic> save(String id) {
    savedId = id;
    favourite = !favourite;
    return {
      'isMaintenance': false,
      'status': true,
      'data': {'isFavourite': favourite},
    };
  }

  Future<dynamic> addRemoveFavourite({
    required String token,
    required String voucherId,
  }) async => save(voucherId);
  Future<dynamic> addRemoveFavOutlet({
    required String token,
    required String outletId,
  }) async => save(outletId);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class RewardFavourites extends FavouriteRepository
    implements RewardRepository {}

class OutletFavourites extends FavouriteRepository
    implements OrderingRepository {}

class OnlineRewards extends RewardBloc {
  OnlineRewards(RewardFavourites repository)
    : super(context: null, rewardRepository: repository);
  @override
  Future<bool> checkInternet() async => false;
  @override
  void add(RewardEvent event) {
    // Keep follow-up list/location loads outside this mutation test.
    if (event is RewardAddRemoveFavouriteLoad) super.add(event);
  }
}

class OnlineOutlets extends OrderingBloc {
  OnlineOutlets(OutletFavourites repository)
    : super(orderingRepository: repository);
  @override
  Future<bool> checkInternet() async => false;
  @override
  void add(OrderingEvent event) {
    if (event is OutletAddRemoveFavouriteLoad) super.add(event);
  }
}

void main() {
  setUp(() async {
    await locator.sl.reset();
    await locator.init();
  });
  tearDown(() async {
    Storage().page = '';
    await locator.sl.reset();
  });
  for (final id in ['123', '01a077de-f5c0-796b-95cf-7815c47c51df']) {
    test('deal favourite toggles with unchanged ID $id', () async {
      final repo = RewardFavourites();
      final bloc = OnlineRewards(repo);
      addTearDown(bloc.close);
      Storage().page = 'reward_wishlist';
      for (final expected in [true, false]) {
        final result = bloc.stream.first;
        bloc.add(
          RewardAddRemoveFavouriteLoad(
            voucherId: id,
            filterBy: 'all',
            filterValue: 'all',
          ),
        );
        final state = await result.timeout(const Duration(seconds: 3));
        expect(state, isA<RewardAddRemoveFavouriteLoaded>());
        expect((state as RewardAddRemoveFavouriteLoaded).voucherId, id);
        expect(state.isFavourite, expected);
        expect(repo.savedId, id);
      }
    });
    test('outlet favourite toggles with unchanged ID $id', () async {
      final repo = OutletFavourites();
      final bloc = OnlineOutlets(repo);
      addTearDown(bloc.close);
      Storage().page = 'outletFav_merchant';
      for (final expected in [true, false]) {
        final result = bloc.stream.first;
        bloc.add(OutletAddRemoveFavouriteLoad(outletId: id, merchantId: id));
        final state = await result.timeout(const Duration(seconds: 3));
        expect(state, isA<OutletAddRemoveFavouriteLoaded>());
        expect((state as OutletAddRemoveFavouriteLoaded).outletId, id);
        expect(state.merchantId, id);
        expect(state.isFavourite, expected);
        expect(repo.savedId, id);
      }
    });
  }
}
