class Training {
  final String id;
  final String title;
  final String type;
  final String location;
  final String city;
  final String date;
  final String time;
  final String venue;
  final int price;
  final double rating;
  final String trainerName;
  final String trainerImage;
  final String imageUrl;

  Training({
    required this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.city,
    required this.date,
    required this.time,
    required this.venue,
    required this.price,
    required this.rating,
    required this.trainerName,
    required this.trainerImage,
    required this.imageUrl,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      city: json['city'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      venue: json['venue'] as String,
      price: json['price'] as int,
      rating: json['rating'].toDouble(),
      trainerName: json['trainerName'] as String,
      trainerImage: json['trainerImage'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'location': location,
      'city': city,
      'date': date,
      'time': time,
      'venue': venue,
      'price': price,
      'rating': rating,
      'trainerName': trainerName,
      'trainerImage': trainerImage,
      'imageUrl': imageUrl,
    };
  }
} 