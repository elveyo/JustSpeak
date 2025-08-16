class Tag {
  final int id;
  final String name;
  final String color;

  Tag({required this.id, required this.name, required this.color});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'color': color};
  }
}
