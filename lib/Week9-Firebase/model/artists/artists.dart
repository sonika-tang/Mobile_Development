class Artists {
  final String id;
  final String name;
  final String genre;
  final Uri imageUrl;

  Artists({
    required this.id,
    required this.name,
    required this.genre,
    required this.imageUrl,
  });

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, genre: $genre)';
  }
}
