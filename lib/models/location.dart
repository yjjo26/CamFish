class Location {
  final String id;
  final String name;
  final Coordinates coordinates;
  final double distance; // km
  final CampingInfo camping;
  final FishingInfo fishing;
  final ReservationInfo? reservation;
  final WeatherInfo weather;
  final String thumbnail;

  Location({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.distance,
    required this.camping,
    required this.fishing,
    this.reservation,
    required this.weather,
    required this.thumbnail,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      coordinates: Coordinates.fromJson(json['coordinates']),
      distance: json['distance'].toDouble(),
      camping: CampingInfo.fromJson(json['camping']),
      fishing: FishingInfo.fromJson(json['fishing']),
      reservation: json['reservation'] != null
          ? ReservationInfo.fromJson(json['reservation'])
          : null,
      weather: WeatherInfo.fromJson(json['weather']),
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coordinates': coordinates.toJson(),
      'distance': distance,
      'camping': camping.toJson(),
      'fishing': fishing.toJson(),
      'reservation': reservation?.toJson(),
      'weather': weather.toJson(),
      'thumbnail': thumbnail,
    };
  }
}

class Coordinates {
  final double lat;
  final double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class CampingInfo {
  final bool available;
  final List<String> facilities;
  final double? price;

  CampingInfo({
    required this.available,
    required this.facilities,
    this.price,
  });

  factory CampingInfo.fromJson(Map<String, dynamic> json) {
    return CampingInfo(
      available: json['available'],
      facilities: List<String>.from(json['facilities']),
      price: json['price']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'facilities': facilities,
      'price': price,
    };
  }
}

class FishingInfo {
  final bool available;
  final List<FishType>? fishTypes;
  final String? bestSeason;
  final List<String>? regulations;

  FishingInfo({
    required this.available,
    this.fishTypes,
    this.bestSeason,
    this.regulations,
  });

  factory FishingInfo.fromJson(Map<String, dynamic> json) {
    return FishingInfo(
      available: json['available'],
      fishTypes: json['fishTypes'] != null
          ? (json['fishTypes'] as List)
              .map((e) => FishType.fromJson(e))
              .toList()
          : null,
      bestSeason: json['bestSeason'],
      regulations: json['regulations'] != null
          ? List<String>.from(json['regulations'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'fishTypes': fishTypes?.map((e) => e.toJson()).toList(),
      'bestSeason': bestSeason,
      'regulations': regulations,
    };
  }
}

class FishType {
  final String name;
  final String season;
  final String size;
  final String difficulty; // 'easy' | 'medium' | 'hard'

  FishType({
    required this.name,
    required this.season,
    required this.size,
    required this.difficulty,
  });

  factory FishType.fromJson(Map<String, dynamic> json) {
    return FishType(
      name: json['name'],
      season: json['season'],
      size: json['size'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'season': season,
      'size': size,
      'difficulty': difficulty,
    };
  }
}

class ReservationInfo {
  final bool required;
  final int? availableSpots;
  final int? totalSpots;
  final String? bookingUrl;

  ReservationInfo({
    required this.required,
    this.availableSpots,
    this.totalSpots,
    this.bookingUrl,
  });

  factory ReservationInfo.fromJson(Map<String, dynamic> json) {
    return ReservationInfo(
      required: json['required'],
      availableSpots: json['availableSpots'],
      totalSpots: json['totalSpots'],
      bookingUrl: json['bookingUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'availableSpots': availableSpots,
      'totalSpots': totalSpots,
      'bookingUrl': bookingUrl,
    };
  }
}

class WeatherInfo {
  final double temperature;
  final double windSpeed;
  final double precipitation;
  final String condition;
  final String icon;

  WeatherInfo({
    required this.temperature,
    required this.windSpeed,
    required this.precipitation,
    required this.condition,
    required this.icon,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      temperature: json['temperature'].toDouble(),
      windSpeed: json['windSpeed'].toDouble(),
      precipitation: json['precipitation'].toDouble(),
      condition: json['condition'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'windSpeed': windSpeed,
      'precipitation': precipitation,
      'condition': condition,
      'icon': icon,
    };
  }
}
