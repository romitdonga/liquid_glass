/// A data model representing a rental property
///
/// This class encapsulates all the essential information about a rental property,
/// including location details, amenities, pricing, and associated imagery.
class HomeData {
  /// The name/title of the property
  final String name;

  /// The location/address of the property
  final String location;

  /// Number of rooms/bedrooms in the property
  final int numberOfRooms;

  /// Number of bathrooms in the property
  final int numberOfBathrooms;

  /// Price per night for renting the property
  final double pricePerNight;

  /// Asset path to the property's image
  final String image;

  /// Creates a new HomeData instance
  ///
  /// All parameters are required to ensure complete property information.
  HomeData({
    required this.name,
    required this.location,
    required this.numberOfRooms,
    required this.numberOfBathrooms,
    required this.pricePerNight,
    required this.image,
  });
}

/// Sample rental property data for demonstration purposes
///
/// This list contains curated property listings from various US locations
/// to showcase the application's features and glass morphism effects.
final List<HomeData> sampleHomes = [
  HomeData(
    name: "Modern Downtown Loft",
    location: "Manhattan, New York",
    numberOfRooms: 2,
    numberOfBathrooms: 1,
    pricePerNight: 285.0,
    image: 'assets/home_1.jpeg',
  ),
  HomeData(
    name: "Cozy Beachfront Cottage",
    location: "Santa Monica, California",
    numberOfRooms: 3,
    numberOfBathrooms: 2,
    pricePerNight: 420.0,
    image: 'assets/home_2.jpeg',
  ),
  HomeData(
    name: "Historic Victorian Home",
    location: "Savannah, Georgia",
    numberOfRooms: 4,
    numberOfBathrooms: 3,
    pricePerNight: 195.0,
    image: 'assets/home_3.jpeg',
  ),
  HomeData(
    name: "Mountain Cabin Retreat",
    location: "Aspen, Colorado",
    numberOfRooms: 5,
    numberOfBathrooms: 4,
    pricePerNight: 650.0,
    image: 'assets/home_4.jpeg',
  ),
  HomeData(
    name: "Urban Studio Apartment",
    location: "Seattle, Washington",
    numberOfRooms: 1,
    numberOfBathrooms: 1,
    pricePerNight: 125.0,
    image: 'assets/home_5.jpeg',
  ),
];
