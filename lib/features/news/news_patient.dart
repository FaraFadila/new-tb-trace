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
      backgroundColor: const Color(0xFFF4FBF1),
      appBar: const AppUserHeader(profileRoute: '/profile-patient'),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterChips(),
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

                    return _buildNewsList(articles);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const PatientBottomNavbar(currentIndex: 2),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBCCABC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search medical news...',
          hintStyle: const TextStyle(color: Color(0xFF3D4A3F), fontSize: 16),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF3D4A3F)),
          suffixIcon:
              _searchQuery.trim().isEmpty
                  ? null
                  : IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    icon: const Icon(Icons.close, color: Color(0xFF3D4A3F)),
                  ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('All'),
          _buildChip('Pencegahan'),
          _buildChip('Pengobatan'),
          _buildChip('Nutrisi'),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    final isActive = _selectedCategory == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _selectedCategory = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF006D37) : const Color(0xFFDDE5DB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF3D4A3F),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewsList(List<NewsApiArticle> articles) {
    return Column(
      children: [
        for (final article in articles) ...[
          _buildNewsCard(article: article),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildNewsCard({required NewsApiArticle article}) {
    return GestureDetector(
      onTap: () {
        context.push('/patient-news-detail', extra: article);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBCCABC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6E6DF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    article.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF596862),
                    ),
                  ),
                ),
                Text(
                  article.publishedAt,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF596862),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF171D17),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.summary,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF3D4A3F),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFFDDE5DB)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 12,
                  color: Color(0xFF006D37),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'VERIFIED SOURCE: ${article.verifiedBy.toUpperCase()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF006D37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Color(0xFF006D37),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBCCABC)),
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
