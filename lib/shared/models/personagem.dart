class Personagem {
  final String character;
  final String image;
  final String quote;

  Personagem({required this.character, required this.image, required this.quote});

  factory Personagem.fromJson(Map<String, dynamic> json) {
    return Personagem(character: json["character"], image: json['image'], quote: json["quote"]);
  }
}