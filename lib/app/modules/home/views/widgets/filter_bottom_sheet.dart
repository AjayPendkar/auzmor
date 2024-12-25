import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class FilterBottomSheet extends GetView<HomeController> {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final locationSearchController = TextEditingController();
    final trainerSearchController = TextEditingController();
    final trainingSearchController = TextEditingController();
    final RxString locationSearch = ''.obs;
    final RxString trainerSearch = ''.obs;
    final RxString trainingSearch = ''.obs;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sort and Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),

          // Main content
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Sidebar
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      right: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSidebarItem('Sort by'),
                      _buildSidebarItem('Location'),
                      _buildSidebarItem('Training Name'),
                      _buildSidebarItem('Trainer'),
                    ],
                  ),
                ),

                // Right Content Panel
                Expanded(
                  child: Obx(() {
                    switch (controller.selectedFilterSection.value) {
                      case 'Sort by':
                        return _buildSortSection();
                      case 'Location':
                        return _buildLocationSection(locationSearch, locationSearchController);
                      case 'Training Name':
                        return _buildTrainingNameSection(trainingSearch, trainingSearchController);
                      case 'Trainer':
                        return _buildTrainerSection(trainerSearch, trainerSearchController);
                      default:
                        return const SizedBox.shrink();
                    }
                  }),
                ),
              ],
            ),
          ),

          // Add Apply button at bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4B55),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title) {
    return Obx(() {
      final isSelected = controller.selectedFilterSection.value == title;
      return GestureDetector(
        onTap: () => controller.changeFilterSection(title),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : null,
            border: Border(
              left: BorderSide(
                color: isSelected ? const Color(0xFFFF4B55) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              color: isSelected ? Colors.black87 : Colors.grey[600],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLocationSection(RxString locationSearch, TextEditingController searchController) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search TextField
          TextField(
            controller: searchController,
            onChanged: (value) => locationSearch.value = value.toLowerCase(),
            decoration: InputDecoration(
              hintText: 'Search location',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Locations List
          Expanded(
            child: Obx(() {
              final filteredLocations = controller.locations
                  .where((location) => location
                      .toLowerCase()
                      .contains(locationSearch.value))
                  .toList();

              return ListView.builder(
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = filteredLocations[index];
                  return Obx(() => CheckboxListTile(
                    value: controller.selectedLocations.contains(location),
                    onChanged: (value) => controller.toggleLocation(location),
                    title: Text(location),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ));
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerSection(RxString trainerSearch, TextEditingController searchController) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search TextField
          TextField(
            controller: searchController,
            onChanged: (value) => trainerSearch.value = value.toLowerCase(),
            decoration: InputDecoration(
              hintText: 'Search trainer',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Trainers List
          Expanded(
            child: Obx(() {
              final filteredTrainers = controller.trainers
                  .where((trainer) => trainer
                      .toLowerCase()
                      .contains(trainerSearch.value))
                  .toList();

              return ListView.builder(
                itemCount: filteredTrainers.length,
                itemBuilder: (context, index) {
                  final trainer = filteredTrainers[index];
                  return Obx(() => CheckboxListTile(
                    value: controller.selectedTrainers.contains(trainer),
                    onChanged: (value) => controller.toggleTrainer(trainer),
                    title: Text(trainer),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ));
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingNameSection(RxString trainingSearch, TextEditingController searchController) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search TextField
          TextField(
            controller: searchController,
            onChanged: (value) => trainingSearch.value = value.toLowerCase(),
            decoration: InputDecoration(
              hintText: 'Search training',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Training Names List
          Expanded(
            child: Obx(() {
              final filteredTrainingNames = controller.trainingNames
                  .where((name) => name
                      .toLowerCase()
                      .contains(trainingSearch.value))
                  .toList();

              return ListView.builder(
                itemCount: filteredTrainingNames.length,
                itemBuilder: (context, index) {
                  final trainingName = filteredTrainingNames[index];
                  return Obx(() => CheckboxListTile(
                    value: controller.selectedTrainingNames.contains(trainingName),
                    onChanged: (value) => controller.toggleTrainingName(trainingName),
                    title: Text(trainingName),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ));
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sort Trainings By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.sortOptions.length,
                itemBuilder: (context, index) {
                  final option = controller.sortOptions[index];
                  return Obx(() => RadioListTile<String>(
                    value: option,
                    groupValue: controller.selectedSort.value,
                    onChanged: (value) {
                      if (value != null) {
                        controller.sortTrainings(value);
                      }
                    },
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    activeColor: const Color(0xFFFF4B55),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ));
                },
              );
            }),
          ),
        ],
      ),
    );
  }
} 