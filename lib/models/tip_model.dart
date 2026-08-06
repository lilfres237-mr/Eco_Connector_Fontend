class TipModel {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String date;
  final String readingTime;
  final String content;
  final List<String> relatedTipIds;

  const TipModel({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.date,
    required this.readingTime,
    required this.content,
    this.relatedTipIds = const [],
  });
}
