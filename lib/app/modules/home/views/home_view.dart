import 'package:auzmor/app/modules/home/views/widgets/training_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/carousel_section.dart';
import 'widgets/filter_bottom_sheet.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF4B55),
        elevation: 0,
        title: const Text(
          'Trainings',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle menu button tap
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter, // Stop at center
            colors: [
              Color(0xFFFF4B55),  // Red at top
              Color(0xFFFF4B55),  // Red continues
              Colors.white,       // Transition to white
              Colors.white,       // White at bottom
            ],
            stops: [0.0, 0.18, 0.18, 0.42], // Sharp transition at center
          ),
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Highlights',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const CarouselSection(),
                const SizedBox(height: 16),
              ],
            ),
            
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    const FilterBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: Container(
                  height: 48,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.tune,
                        size: 20,
                        color: Colors.grey[800],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                color: Colors.grey, // Light grey background
                child: GetBuilder<HomeController>(
                  builder: (_) => Obx(() => ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: controller.filteredTrainings.length,
                    itemBuilder: (context, index) {
                      return TrainingCard(
                        training: controller.filteredTrainings[index]
                      );
                    },
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 