import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_trace/core/services/news_api_service.dart';
import 'package:tb_trace/core/widgets/app_user_header.dart';

import '../../core/widgets/patient_bottom_navbar.dart';

class NewsPatientPage extends StatefulWidget {
  const NewsPatientPage({super.key});

  @override
  State<NewsPatientPage> createState() => _NewsPatientPageState();
}

class _NewsPatientPageState extends State<NewsPatientPage> {
  final NewsApiService _newsService = NewsApiService();
  final TextEditingController _searchController = TextEditingController();
  late Future<List<NewsApiArticle>> _newsFuture;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _newsFuture = _newsService.fetchTuberculosisNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshNews() async {
    setState(() {
      _newsFuture = _newsService.fetchTuberculosisNews();
    });

    await _newsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppUserHeader(profileRoute: '/profile-patient'),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  "Berita TBC",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF019784),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _searchBar(),
              const SizedBox(height: 20),
              _categoryList(),
              const SizedBox(height: 24),
              FutureBuilder<List<NewsApiArticle>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return _messageState(
                      title: 'Gagal memuat berita',
                      subtitle: 'Tarik layar ke bawah untuk mencoba lagi.',
                    );
                  }

                  final articles = _visibleArticles(snapshot.data ?? []);

                  if (articles.isEmpty) {
                    return _messageState(
                      title: 'Berita tidak ditemukan',
                      subtitle:
                          'Coba ubah kata pencarian atau pilih kategori lain.',
                    );
                  }

                  return Column(
                    children: [
                      for (final article in articles) ...[
                        ArticleCard(article: article),
                        const SizedBox(height: 16),
                      ],
                      const SizedBox(height: 100),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const PatientBottomNavbar(currentIndex: 2),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Cari Berita",
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF006D37), Color(0xFF27AE60)],
                ),
              ),
              child: Icon(
                _searchQuery.trim().isEmpty ? Icons.arrow_forward : Icons.close,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryList() {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CategoryChip(
            title: "All",
            isActive: _selectedCategory == 'All',
            onTap: () => _selectCategory('All'),
          ),
          const SizedBox(width: 10),
          CategoryChip(
            title: "Pengobatan",
            isActive: _selectedCategory == 'Pengobatan',
            onTap: () => _selectCategory('Pengobatan'),
          ),
          const SizedBox(width: 10),
          CategoryChip(
            title: "Pencegahan",
            isActive: _selectedCategory == 'Pencegahan',
            onTap: () => _selectCategory('Pencegahan'),
          ),
          const SizedBox(width: 10),
          CategoryChip(
            title: "Nutrisi",
            isActive: _selectedCategory == 'Nutrisi',
            onTap: () => _selectCategory('Nutrisi'),
          ),
        ],
      ),
    );
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  List<NewsApiArticle> _visibleArticles(List<NewsApiArticle> articles) {
    final query = _searchQuery.trim().toLowerCase();

    return articles.where((article) {
      final matchesCategory =
          _selectedCategory == 'All' || article.category == _selectedCategory;
      final matchesSearch =
          query.isEmpty ||
          article.title.toLowerCase().contains(query) ||
          article.summary.toLowerCase().contains(query) ||
          article.source.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Widget _messageState({required String title, required String subtitle}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDE5DB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF171D17),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF3D4A3F)),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          gradient:
              isActive
                  ? const LinearGradient(
                    colors: [Color(0xFF006D37), Color(0xFF27AE60)],
                  )
                  : null,
          color: isActive ? null : const Color(0xFF171616),
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[400],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.article});

  final NewsApiArticle article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/patient-news-detail', extra: article);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE5F4EA), Color(0xFFBFE5CE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.article_outlined,
                color: Color(0xFF006D37),
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF006D37),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${article.source} | ${article.publishedAt}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
