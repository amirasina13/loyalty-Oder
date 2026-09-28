import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'data/data.dart';
import 'domain/domain.dart';
import 'presentation/navigation_service.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<NavigationService>(() => NavigationService());

  /*---------------------------------------------------------------------------*/

  // Global
  sl.registerLazySingleton<RemoteGlobalRepository>(
    () => RemoteGlobalRepository(),
  );
  sl.registerLazySingleton<GlobalCountriesGetUseCase>(
    () => GlobalCountriesGetUseCaseImpl(),
  );
  sl.registerLazySingleton<GlobalRepository>(
    () => GlobalRepositoryImpl(remoteGlobalRepository: sl()),
  );

  /*---------------------------------------------------------------------------*/

  //Singleton for HTTP request
  sl.registerLazySingleton(() => http.Client);

  sl.registerLazySingleton<RemoteUserRepository>(() => RemoteUserRepository());
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteUserRepository: sl()),
  );

  /*---------------------------------------------------------------------------*/

  // Reward
  sl.registerLazySingleton<RewardMerchantGetUseCase>(
    () => RewardMerchantGetUseCaseImpl(),
  );
  sl.registerLazySingleton<RewardListGetUseCase>(
    () => RewardListGetUseCaseImpl(),
  );
  sl.registerLazySingleton<RewardDetailsGetUseCase>(
    () => RewardDetailsGetUseCaseImpl(),
  );
  sl.registerLazySingleton<RewardDetailsDynamicGetUseCase>(
    () => RewardDetailsDynamicGetUseCaseImpl(),
  );
  sl.registerLazySingleton<RewardDownloadGetUseCase>(
    () => RewardDownloadGetUseCaseImpl(),
  );
  sl.registerLazySingleton<RewardPurchaseGetUseCase>(
    () => RewardPurchaseGetUseCaseImpl(),
  );
  sl.registerLazySingleton<RewardRedeemQrGetUseCase>(
    () => RewardRedeemQrGetUseCaseImpl(),
  );
  sl.registerLazySingleton<FilterCategoryGetUseCase>(
    () => FilterCategoryGetUseCaseImpl(),
  );

  sl.registerLazySingleton<RemoteRewardRepository>(
    () => RemoteRewardRepository(),
  );
  sl.registerLazySingleton<RewardRepository>(
    () => RewardRepositoryImpl(remoteRewardRepository: sl()),
  );

  /*---------------------------------------------------------------------------*/

  // Voucher
  // sl.registerLazySingleton<VoucherTransactionsGetUseCase>(
  //     () => VoucherTransactionsGetUseCaseImpl());
  sl.registerLazySingleton<VoucherPastTransactionsGetUseCase>(
    () => VoucherPastTransactionsGetUseCaseImpl(),
  );
  sl.registerLazySingleton<VoucherDetailsGetUseCase>(
    () => VoucherDetailsGetUseCaseImpl(),
  );
  sl.registerLazySingleton<VoucherCategoriesGetUseCase>(
    () => VoucherCategoriesGetUseCaseImpl(),
  );
  sl.registerLazySingleton<RedeemVoucherGetUseCase>(
    () => RedeemVoucherGetUseCaseImpl(),
  );
  sl.registerLazySingleton<VoucherPastDetailsGetUseCase>(
    () => VoucherPastDetailsGetUseCaseImpl(),
  );
  sl.registerLazySingleton<RatingVoucherGetUseCase>(
    () => RatingVoucherGetUseCaseImpl(),
  );

  sl.registerLazySingleton<RemoteVoucherRepository>(
    () => RemoteVoucherRepository(),
  );
  sl.registerLazySingleton<VoucherRepository>(
    () => VoucherRepositoryImpl(remoteVoucherRepository: sl()),
  );

  /*---------------------------------------------------------------------------*/

  // History Transaction
  sl.registerLazySingleton<HistoryTransactionsGetUseCase>(
    () => HistoryTransactionsGetUseCaseImpl(),
  );
  sl.registerLazySingleton<CreditHistoryTransactionsGetUseCase>(
    () => CreditHistoryTransactionsGetUseCaseImpl(),
  );
  sl.registerLazySingleton<WalletCreditHistoryTransactionsGetUseCase>(
    () => WalletCreditHistoryTransactionsGetUseCaseImpl(),
  );

  sl.registerLazySingleton<RemoteHistoryRepository>(
    () => RemoteHistoryRepository(),
  );
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(remoteHistoryRepository: sl()),
  );

  /*---------------------------------------------------------------------------*/

  // Credits
  sl.registerLazySingleton<CreditPaymentGetUseCase>(
    () => CreditPaymentGetUseCaseImpl(),
  );
  sl.registerLazySingleton<CreditOnlineGetUseCase>(
    () => CreditOnlineGetUseCaseImpl(),
  );

  sl.registerLazySingleton<RemoteCreditRepository>(
    () => RemoteCreditRepository(),
  );
  sl.registerLazySingleton<CreditRepository>(
    () => CreditRepositoryImpl(remoteCreditRepository: sl()),
  );

  /*---------------------------------------------------------------------------*/

  // Bulletin Boards - List
  sl.registerLazySingleton<BulletinListGetUseCase>(
    () => BulletinListGetUseCaseImpl(),
  );
  // Bulletin Boards - Details
  sl.registerLazySingleton<BulletinDetailsGetUseCase>(
    () => BulletinDetailsGetUseCaseImpl(),
  );

  sl.registerLazySingleton<RemoteBulletinRepository>(
    () => RemoteBulletinRepository(),
  );
  sl.registerLazySingleton<BulletinRepository>(
    () => BulletinRepositoryImpl(remoteBulletinRepository: sl()),
  );

  /*---------------------------------------------------------------------------*/

  // Security
  sl.registerLazySingleton<RemoteSecurityRepository>(
    () => RemoteSecurityRepository(),
  );
  sl.registerLazySingleton<SecurityRepository>(
    () => SecurityRepositoryImpl(remoteSecurityRepository: sl()),
  );

  // Security check
  sl.registerLazySingleton<SecurityGetUseCase>(() => SecurityGetUseCaseImpl());

  // Security otp
  sl.registerLazySingleton<SecurityStartGetUseCase>(
    () => SecurityStartGetUseCaseImpl(),
  );

  // Security otp verify
  sl.registerLazySingleton<SecurityVerifyOtpGetUseCase>(
    () => SecurityVerifyOtpGetUseCaseImpl(),
  );

  // Security create pin
  sl.registerLazySingleton<SecurityCreatePinGetUseCase>(
    () => SecurityCreatePinGetUseCaseImpl(),
  );

  // Security pin verify
  sl.registerLazySingleton<SecurityVerifyPinGetUseCase>(
    () => SecurityVerifyPinGetUseCaseImpl(),
  );

  /*---------------------------------------------------------------------------*/

  // Ordering
  sl.registerLazySingleton<RemoteOrderingRepository>(
    () => RemoteOrderingRepository(),
  );
  sl.registerLazySingleton<OrderingRepository>(
    () => OrderingRepositoryImpl(remoteOrderingRepository: sl()),
  );

  // Nearby outlet list
  sl.registerLazySingleton<NearbyOutletGetUseCase>(
    () => NearbyOutletGetUseCaseImpl(),
  );
  // Brands list
  sl.registerLazySingleton<BrandsListGetUseCase>(
    () => BrandsListGetUseCaseImpl(),
  );
  // Outlet list
  sl.registerLazySingleton<OutletListGetUseCase>(
    () => OutletListGetUseCaseImpl(),
  );
  // Outlet details
  sl.registerLazySingleton<OutletDetailsGetUseCase>(
    () => OutletDetailsGetUseCaseImpl(),
  );

  // /*---------------------------------------------------------------------------*/

  // // Transfer Credit
  // sl.registerLazySingleton<RemoteTransferRepository>(
  //   () => RemoteTransferRepository(),
  // );
  // sl.registerLazySingleton<TransferRepository>(
  //   () => TransferRepositoryImpl(remoteTransferRepository: sl()),
  // );

  // sl.registerLazySingleton<TransferCreditGetUseCase>(
  //   () => TransferCreditGetUseCaseImpl(),
  // );
}
