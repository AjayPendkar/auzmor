import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/training_model.dart';
import '../../../data/training_data.dart';
import 'package:carousel_slider/carousel_controller.dart';

class HomeController extends GetxController {
  final List<Training> trainings = [];
  final CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;
  final RxList<String> locations = <String>[
    'West Des Moines',
    'Chicago, IL',
    'Phoenix, AZ',
    'Dallas, TX',
    'San Diego, CA',
    'San Francisco, CA',
    'New York, ZK',
  ].obs;

  final RxList<String> trainers = <String>[
    'Helen Gobble',
    'John Smith',
    'Sarah Johnson',
    'Mike Wilson',
  ].obs;

  final RxSet<String> selectedLocations = <String>{}.obs;
  final RxString searchQuery = ''.obs;
  RxList<Training> filteredTrainings = <Training>[].obs;
  final RxSet<String> selectedTrainers = <String>{}.obs;

  // Add sort options
  final RxList<String> sortOptions = <String>[
    'Date (Newest First)',
    'Date (Oldest First)',
    'Price (Low to High)',
    'Price (High to Low)',
    'Rating (High to Low)',
  ].obs;

  final RxString selectedSort = ''.obs;

  // Add this for filter section state
  final RxString selectedFilterSection = 'Location'.obs;

  // Add training names list
  final RxList<String> trainingNames = <String>[
    'Safe Scrum Master',
    'Agile Project Management',
    'DevOps Fundamentals',
    'Kubernetes Workshop',
    'Cloud Architecture',
    'Machine Learning Basics',
    'Data Science Workshop',
    'Blockchain Development',
  ].obs;

  // Add selected training names set
  final RxSet<String> selectedTrainingNames = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadTrainings();
    filteredTrainings.assignAll(trainings);
  }

  void loadTrainings() {
    trainings.clear();
    final data = trainingData['trainings'] as List;
    trainings.addAll(
      data.map((json) => Training.fromJson(json)).toList(),
    );
    update();
  }

  void nextSlide() {
    carouselController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousSlide() {
    carouselController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void filterTrainings() {
    if (selectedLocations.isEmpty && 
        selectedTrainers.isEmpty && 
        selectedTrainingNames.isEmpty && 
        searchQuery.isEmpty) {
      filteredTrainings.assignAll(trainings);
    } else {
      filteredTrainings.assignAll(trainings.where((training) {
        final matchesLocation = selectedLocations.isEmpty || 
          selectedLocations.contains(training.location);
        final matchesTrainer = selectedTrainers.isEmpty ||
          selectedTrainers.contains(training.trainerName);
        final matchesTrainingName = selectedTrainingNames.isEmpty ||
          selectedTrainingNames.contains(training.title);
        final matchesSearch = searchQuery.isEmpty ||
          training.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          training.trainerName.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesLocation && matchesTrainer && matchesTrainingName && matchesSearch;
      }));
    }
    // Apply current sort after filtering
    if (selectedSort.value.isNotEmpty) {
      sortTrainings(selectedSort.value);
    }
    update();
  }

  void toggleLocation(String location) {
    if (selectedLocations.contains(location)) {
      selectedLocations.remove(location);
    } else {
      selectedLocations.add(location);
    }
    filterTrainings();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterTrainings();
  }

  void toggleTrainer(String trainer) {
    if (selectedTrainers.contains(trainer)) {
      selectedTrainers.remove(trainer);
    } else {
      selectedTrainers.add(trainer);
    }
    filterTrainings();
  }

  void sortTrainings(String sortOption) {
    selectedSort.value = sortOption;
    
    // Create a new list to avoid reference issues
    List<Training> sortedList = List<Training>.from(trainings);
    
    switch (sortOption) {
      case 'Date (Newest First)':
        sortedList.sort((a, b) {
          DateTime dateA = _parseDate(a.date);
          DateTime dateB = _parseDate(b.date);
          return dateB.compareTo(dateA);
        });
        break;
        
      case 'Date (Oldest First)':
        sortedList.sort((a, b) {
          DateTime dateA = _parseDate(a.date);
          DateTime dateB = _parseDate(b.date);
          return dateA.compareTo(dateB);
        });
        break;
        
      case 'Price (Low to High)':
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
        
      case 'Price (High to Low)':
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
        
      case 'Rating (High to Low)':
        sortedList.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    
    // Apply filters to sorted list if needed
    if (selectedLocations.isNotEmpty || selectedTrainers.isNotEmpty || searchQuery.isNotEmpty) {
      sortedList = sortedList.where((training) {
        final matchesLocation = selectedLocations.isEmpty || 
          selectedLocations.contains(training.location);
        final matchesTrainer = selectedTrainers.isEmpty ||
          selectedTrainers.contains(training.trainerName);
        final matchesSearch = searchQuery.isEmpty ||
          training.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          training.trainerName.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesLocation && matchesTrainer && matchesSearch;
      }).toList();
    }
    
    // Update the filtered list
    filteredTrainings.clear();
    filteredTrainings.addAll(sortedList);
    update();
  }

  DateTime _parseDate(String date) {
    // Convert date string like "Oct 11 - 13, 2019" to DateTime
    final parts = date.split(' - ')[0].split(', ');
    final year = int.parse(parts[1]);
    final monthDay = parts[0].split(' ');
    final month = _getMonthNumber(monthDay[0]);
    final day = int.parse(monthDay[1]);
    return DateTime(year, month, day);
  }

  int _getMonthNumber(String month) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    return months[month] ?? 1;
  }

  // Add this method to change filter section
  void changeFilterSection(String section) {
    selectedFilterSection.value = section;
  }

  // Add toggle method for training names
  void toggleTrainingName(String trainingName) {
    if (selectedTrainingNames.contains(trainingName)) {
      selectedTrainingNames.remove(trainingName);
    } else {
      selectedTrainingNames.add(trainingName);
    }
    filterTrainings();
  }
} 