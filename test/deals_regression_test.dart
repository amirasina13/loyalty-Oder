import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oder_staging/data/data.dart';
import 'package:oder_staging/domain/domain.dart';
import 'package:oder_staging/locator.dart' as locator;
import 'package:oder_staging/presentation/features/rewards/reward.dart';
import 'package:oder_staging/presentation/features/voucher/widget/voucher_view/voucher_rewards_tab.dart';
import 'package:oder_staging/presentation/widgets/independent/size.dart';

class DealsBloc extends RewardBloc {
  DealsBloc() : super(context: null, rewardRepository: null);

  int categoryRequests = 0;
  int listRequests = 0;
  bool finalPage = false;
  bool favourite = false;

  @override
  void add(RewardEvent event) {
    if (event is RewardAddRemoveFavouriteLoad) {
      favourite = !favourite;
      scheduleMicrotask(() {
        emit(
          RewardAddRemoveFavouriteLoaded(
            voucherId: event.voucherId,
            isFavourite: favourite,
          ),
        );
        add(
          RewardListLoad(
            filterBy: event.filterBy,
            filterValue: event.filterValue,
          ),
        );
      });
    } else if (event is FilterCategoryLoad) {
      categoryRequests++;
      scheduleMicrotask(
        () => emit(
          FilterCategoryLoaded(filterData: const FilterData(options: [])),
        ),
      );
    } else if (event is RewardListLoad) {
      listRequests++;
      scheduleMicrotask(
        () => emit(
          RewardListLoaded(
            voucherRewards: RewardData(
              vouchers: List.generate(
                12,
                (index) => VoucherReward(
                  id: '$index',
                  name: 'Deal $index',
                  desc: 'Test deal',
                  image: '',
                  purchaseText: 'Buy',
                  faceAmount: '0',
                  isSoldOut: false,
                  isFavourite: index == 0 && favourite,
                  purchaseMethod: 'purchasable',
                ),
              ),
            ),
            hasMore: !finalPage,
          ),
        ),
      );
    }
  }

  void finishPagination() => emit(RewardListStop());
}

class OnlineRewardBloc extends RewardBloc {
  OnlineRewardBloc() : super(context: null, rewardRepository: null);

  @override
  Future<bool> checkInternet() async => false;
}

class PageUseCase extends RewardListGetUseCase {
  PageUseCase(this.next);
  final String? next;

  @override
  Future<RewardListGetResult> execute(RewardListGetParams params) async =>
      RewardListGetResult(
        rewards: RewardData(
          vouchers: const [VoucherReward(id: '1')],
          next: next,
        ),
      );
}

Widget tabHarness(DealsBloc bloc, {Key? dealsKey}) => MaterialApp(
  home: Builder(
    builder: (context) {
      ScreenSize.init(context);
      return BlocProvider<RewardBloc>.value(
        value: bloc,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Deals'),
                  Tab(text: 'My Vouchers'),
                  Tab(text: 'History'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                VoucherRewardsTab(
                  key: dealsKey,
                  filterBy: 'all',
                  filterValue: 'all',
                ),
                const Text('My Vouchers page'),
                const Text('History page'),
              ],
            ),
          ),
        ),
      );
    },
  ),
);

Future<void> renderDeals(WidgetTester tester, DealsBloc bloc) async {
  await tester.pumpWidget(tabHarness(bloc));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  setUp(() async {
    await locator.sl.reset();
    await locator.init();
  });
  tearDown(() => locator.sl.reset());

  testWidgets('History to Deals preserves loaded content without refetching', (
    tester,
  ) async {
    final bloc = DealsBloc();
    addTearDown(bloc.close);
    await renderDeals(tester, bloc);
    expect(find.text('Deal 0'), findsOneWidget);
    await tester.tap(find.text('History'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('History page'), findsOneWidget);
    await tester.tap(find.text('Deals'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Deal 0'), findsOneWidget);
    expect(bloc.categoryRequests, 1);
    expect(bloc.listRequests, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'a recreated Deals tab loads even if the bloc previously loaded',
    (tester) async {
      final bloc = DealsBloc();
      addTearDown(bloc.close);
      await renderDeals(tester, bloc);
      await tester.pumpWidget(tabHarness(bloc, dealsKey: UniqueKey()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(bloc.categoryRequests, 2);
      expect(find.text('For You'), findsOneWidget);
      expect(find.text('Deal 0'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('saving and removing a deal favourite updates the heart', (
    tester,
  ) async {
    final bloc = DealsBloc();
    addTearDown(bloc.close);
    await renderDeals(tester, bloc);
    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('scrolling still requests the next page when more deals exist', (
    tester,
  ) async {
    final bloc = DealsBloc();
    addTearDown(bloc.close);
    await renderDeals(tester, bloc);
    for (var i = 0; i < 4 && bloc.listRequests == 1; i++) {
      await tester.drag(find.byType(ListView).first, const Offset(0, -500));
      await tester.pump(const Duration(seconds: 1));
    }
    final position =
        tester
            .widget<ListView>(find.byType(ListView).first)
            .controller!
            .position;
    expect(
      bloc.listRequests,
      greaterThan(1),
      reason:
          'Scroll ${position.pixels}/${position.maxScrollExtent}, fetching=${bloc.isRewardFetching}',
    );
    final requestsAfterScroll = bloc.listRequests;
    await tester.pump(const Duration(seconds: 2));
    expect(bloc.listRequests, requestsAfterScroll);
    expect(tester.takeException(), isNull);
  });

  for (final serverStop in [false, true]) {
    testWidgets(
      'no repeated requests after ${serverStop ? 'empty next page' : 'final page'}',
      (tester) async {
        final bloc = DealsBloc()..finalPage = !serverStop;
        addTearDown(bloc.close);
        await renderDeals(tester, bloc);
        if (serverStop) {
          bloc.finishPagination();
          await tester.pump();
        }
        for (var i = 0; i < 4; i++) {
          await tester.drag(find.byType(ListView).first, const Offset(0, -500));
          await tester.pump(const Duration(seconds: 1));
        }
        expect(bloc.listRequests, 1);
        expect(find.byType(ListView), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final next in <String?>[
    null,
    '',
    '?offset=20',
    '?filterBy=all&offset=20',
    '?offset=0&filterBy=all',
  ]) {
    test('pagination handles next link $next without dropping deals', () async {
      await locator.sl.unregister<RewardListGetUseCase>();
      locator.sl.registerSingleton<RewardListGetUseCase>(PageUseCase(next));
      final bloc = OnlineRewardBloc();
      addTearDown(bloc.close);
      final result = bloc.stream.firstWhere(
        (state) => state is RewardListLoaded || state is RewardError,
      );
      bloc.add(RewardListLoad(filterBy: 'all', filterValue: 'all'));
      final state = await result.timeout(const Duration(seconds: 3));
      expect(state, isA<RewardListLoaded>());
      final loaded = state as RewardListLoaded;
      expect(loaded.voucherRewards.vouchers, hasLength(1));
      expect(loaded.hasMore, next?.contains('offset=20') ?? false);
    });
  }
}
