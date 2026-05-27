import 'package:dio/dio.dart';

class NewsApiArticle {
  const NewsApiArticle({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.author,
    required this.source,
    required this.verifiedBy,
    required this.publishedAt,
    required this.sourceUrl,
    this.readTime = '5 min read',
  });

  final String id;
  final String category;
  final String title;
  final String summary;
  final String author;
  final String source;
  final String verifiedBy;
  final String publishedAt;
  final String sourceUrl;
  final String readTime;
}

class NewsApiService {
  NewsApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://www.who.int/api/newsroom',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 12),
            ),
          );

  final Dio _dio;

  Future<List<NewsApiArticle>> fetchTuberculosisNews() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/newsitems',
      queryParameters: {
        r'$filter':
            "contains(Title,'tuberculosis') or contains(Title,'TB') or contains(OpenGraphDescription,'tuberculosis')",
        r'$orderby': 'PublicationDate desc',
        r'$top': 20,
      },
    );

    final data = response.data;
    final results = data?['value'];

    if (results is! List) return const [];

    return results
        .whereType<Map<String, dynamic>>()
        .map(_articleFromJson)
        .where((article) => article.title.trim().isNotEmpty)
        .toList();
  }

  NewsApiArticle _articleFromJson(Map<String, dynamic> json) {
    final title = _cleanText(_stringValue(json['Title']));
    final summary = _cleanText(
      _firstNonEmpty([
        json['Summary'],
        json['OpenGraphDescription'],
        json['MetaDescription'],
        json['Description'],
      ]),
    );
    final publishedAt = _dateLabel(
      _firstNonEmpty([
        json['PublicationDate'],
        json['PublicationDateAndTime'],
        json['LastModified'],
      ]),
    );
    const source = 'WHO';

    return NewsApiArticle(
      id: _stringValue(json['Id']),
      category: _categoryFor(title, summary),
      title: title,
      summary:
          summary.isEmpty
              ? 'Informasi terbaru tentang tuberkulosis dari sumber kesehatan publik.'
              : summary,
      author: source,
      source: source,
      verifiedBy: source,
      publishedAt: publishedAt,
      sourceUrl:
          _stringValue(json['ItemDefaultUrl']).startsWith('http')
              ? _stringValue(json['ItemDefaultUrl'])
              : 'https://www.who.int${_stringValue(json['ItemDefaultUrl'])}',
    );
  }

  String _categoryFor(String title, String summary) {
    final haystack = '$title $summary'.toLowerCase();

    if (haystack.contains('nutrition') ||
        haystack.contains('food') ||
        haystack.contains('diet')) {
      return 'Nutrisi';
    }

    if (haystack.contains('treatment') ||
        haystack.contains('medicine') ||
        haystack.contains('drug') ||
        haystack.contains('therapy')) {
      return 'Pengobatan';
    }

    return 'Pencegahan';
  }

  String _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = _stringValue(value);
      if (text.isNotEmpty) return text;
    }

    return '';
  }

  String _dateLabel(String rawDate) {
    final date = DateTime.tryParse(rawDate);
    if (date == null) return 'Recently';

    final localDate = date.toLocal();
    final month = _monthNames[localDate.month] ?? '';
    return '${localDate.day} $month ${localDate.year}';
  }

  String _cleanText(String value) {
    return value
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _stringValue(dynamic value) {
    if (value == null) return '';
    return value.toString().trim();
  }

  static const Map<int, String> _monthNames = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'Mei',
    6: 'Jun',
    7: 'Jul',
    8: 'Agu',
    9: 'Sep',
    10: 'Okt',
    11: 'Nov',
    12: 'Des',
  };
}
