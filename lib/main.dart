import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/auth/forget_password/forget_password_binding.dart';
import 'features/auth/forget_password/forget_password_view.dart';
import 'features/auth/otp/otp_binding.dart';
import 'features/auth/otp/otp_view.dart';
import 'features/auth/reset_password/reset_password_binding.dart';
import 'features/auth/reset_password/reset_password_view.dart';
import 'features/auth/login/login_binding.dart';
import 'features/auth/login/login_view.dart';
import 'features/auth/register/register_binding.dart';
import 'features/auth/register/register_view.dart';
import 'features/customer dashboard/navigation/bottom_nav_binding.dart';
import 'features/customer dashboard/navigation/bottom_nav_view.dart';
import 'features/customer dashboard/chat_detail/chat_detail_binding.dart';
import 'features/customer dashboard/chat_detail/chat_detail_view.dart';
import 'features/customer dashboard/call/call_binding.dart';
import 'features/customer dashboard/call/call_view.dart';
import 'features/customer dashboard/search/search_binding.dart';
import 'features/customer dashboard/search/search_view.dart';
import 'features/customer dashboard/wallet/wallet_binding.dart';
import 'features/customer dashboard/wallet/wallet_view.dart';
import 'features/customer dashboard/wallet/buy_coins_view.dart';
import 'features/customer dashboard/settings/settings_binding.dart';
import 'features/customer dashboard/settings/settings_view.dart';
import 'features/customer dashboard/notifications/notifications_binding.dart';
import 'features/customer dashboard/notifications/notifications_view.dart';
import 'features/customer dashboard/rewards/rewards_binding.dart';
import 'features/customer dashboard/rewards/rewards_view.dart';
import 'features/customer dashboard/favorites/favorites_binding.dart';
import 'features/customer dashboard/favorites/favorites_view.dart';
import 'features/creator_dashboard/creator_ashboard/creator_dashboard_binding.dart';
import 'features/creator_dashboard/creator_ashboard/creator_dashboard_view.dart';
import 'features/creator_dashboard/creator_profile/profile_setup_binding.dart';
import 'features/creator_dashboard/creator_profile/profile_setup_view.dart';
import 'features/creator_dashboard/kyc_verify/kyc_verify_binding.dart';
import 'features/creator_dashboard/kyc_verify/kyc_verify_view.dart';
import 'features/creator_dashboard/creator_gallery/creator_gallery_binding.dart';
import 'features/creator_dashboard/creator_gallery/creator_gallery_view.dart';
import 'features/creator_dashboard/creator_pricing/creator_pricing_binding.dart';
import 'features/creator_dashboard/creator_pricing/creator_pricing_view.dart';
import 'features/creator_dashboard/creator_earnings/creator_earnings_binding.dart';
import 'features/creator_dashboard/creator_earnings/creator_earnings_view.dart';
import 'features/creator_dashboard/gifts_received/gifts_received_binding.dart';
import 'features/creator_dashboard/gifts_received/gifts_received_view.dart';
import 'features/creator_dashboard/inbox/inbox_binding.dart';
import 'features/creator_dashboard/inbox/inbox_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VeloraLive',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8D32F0)),
        scaffoldBackgroundColor: const Color(0xFF0F0B21),
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: RegisterBinding(),
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgetPasswordView(),
          binding: ForgetPasswordBinding(),
        ),
        GetPage(
          name: '/otp',
          page: () => const OtpView(),
          binding: OtpBinding(),
        ),
        GetPage(
          name: '/reset-password',
          page: () => const ResetPasswordView(),
          binding: ResetPasswordBinding(),
        ),
        GetPage(
          name: '/home',
          page: () => const BottomNavView(),
          binding: BottomNavBinding(),
        ),
        GetPage(
          name: '/chat-detail',
          page: () => const ChatDetailView(),
          binding: ChatDetailBinding(),
        ),
        GetPage(
          name: '/call',
          page: () => const CallView(),
          binding: CallBinding(),
        ),
        GetPage(
          name: '/search',
          page: () => const SearchView(),
          binding: SearchBinding(),
        ),
        GetPage(
          name: '/wallet',
          page: () => const WalletView(),
          binding: WalletBinding(),
        ),
        GetPage(
          name: '/buy-coins',
          page: () => const BuyCoinsView(),
          binding: WalletBinding(),
        ),
        GetPage(
          name: '/settings',
          page: () => const SettingsView(),
          binding: SettingsBinding(),
        ),
        GetPage(
          name: '/notifications',
          page: () => const NotificationsView(),
          binding: NotificationsBinding(),
        ),
        GetPage(
          name: '/rewards',
          page: () => const RewardsView(),
          binding: RewardsBinding(),
        ),
        GetPage(
          name: '/favorites',
          page: () => const FavoritesView(),
          binding: FavoritesBinding(),
        ),
        GetPage(
          name: '/creator-dashboard',
          page: () => const CreatorDashboardView(),
          binding: CreatorDashboardBinding(),
        ),
        GetPage(
          name: '/profile-setup',
          page: () => const ProfileSetupView(),
          binding: ProfileSetupBinding(),
        ),
        GetPage(
          name: '/kyc-verify',
          page: () => const KycVerifyView(),
          binding: KycVerifyBinding(),
        ),
        GetPage(
          name: '/creator-gallery',
          page: () => const CreatorGalleryView(),
          binding: CreatorGalleryBinding(),
        ),
        GetPage(
          name: '/creator-pricing',
          page: () => const CreatorPricingView(),
          binding: CreatorPricingBinding(),
        ),
        GetPage(
          name: '/creator-earnings',
          page: () => const CreatorEarningsView(),
          binding: CreatorEarningsBinding(),
        ),
        GetPage(
          name: '/gifts-received',
          page: () => const GiftsReceivedView(),
          binding: GiftsReceivedBinding(),
        ),
        GetPage(
          name: '/inbox',
          page: () => const InboxView(),
          binding: InboxBinding(),
        ),
      ],
    );
  }
}
