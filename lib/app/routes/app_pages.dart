import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/training_details/views/training_details_view.dart';

class AppPages {
  static const INITIAL = '/home';

  static final routes = [
    GetPage(
      name: '/home',
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: '/training-details',
      page: () => TrainingDetailsView(
        training: Get.arguments,
      ),
    ),
  ];
} 