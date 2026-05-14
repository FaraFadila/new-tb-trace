import 'package:flutter/material.dart';

class NewsPatientPage extends StatelessWidget {
  const NewsPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APP BAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                const Icon(Icons.notifications_none_rounded),

                const Spacer(),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Hello,",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Jade West",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFEEF2F3),
                  child: Icon(Icons.person, color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 24),

            // TITLE
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

            // SEARCH BAR
            Container(
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

                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari Berita",
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF006D37),
                          Color(0xFF27AE60),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CATEGORY
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryChip(
                    title: "All",
                    isActive: true,
                  ),
                  SizedBox(width: 10),
                  CategoryChip(title: "Pengobatan"),
                  SizedBox(width: 10),
                  CategoryChip(title: "Pencegahan"),
                  SizedBox(width: 10),
                  CategoryChip(title: "Nutrisi"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ARTICLES
            const ArticleCard(
              image:
                  "assets/images/article1.jpg",
              title: "Bahaya Putus Obat (TBC RO)",
              category: "Pengobatan",
              author: "Dr. Patrick",
            ),

            const SizedBox(height: 16),

            const ArticleCard(
              image:
                  "assets/images/article2.jpg",
              title: "Waspada TBC pada Anak",
              category: "Pencegahan",
              author: "Dr. Stanzel",
            ),

            const SizedBox(height: 16),

            const ArticleCard(
              image:
                  "assets/images/article3.jpg",
              title: "Mitos dan Fakta Seputar TBC",
              category: "Pencegahan",
              author: "Dr. Stanpat",
            ),

            const SizedBox(height: 16),

            const ArticleCard(
              image:
                  "assets/images/article4.jpg",
              title: "Atasi Stigma Pasien TBC",
              category: "Pencegahan",
              author: "Dr. Panpan",
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // BOTTOM NAVBAR
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [

            BottomItem(
              icon: Icons.home,
              label: "HOME",
              isActive: true,
            ),

            BottomItem(
              icon: Icons.map,
              label: "MAP",
            ),

            BottomItem(
              icon: Icons.article,
              label: "NEWS",
            ),

            BottomItem(
              icon: Icons.person_outline,
              label: "PROFILE",
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final bool isActive;

  const CategoryChip({
    super.key,
    required this.title,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [
                  Color(0xFF006D37),
                  Color(0xFF27AE60),
                ],
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
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String image;
  final String title;
  final String category;
  final String author;

  const ArticleCard({
    super.key,
    required this.image,
    required this.title,
    required this.category,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 137,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [

          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              width: 144,
              height: 137,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "$author | 5 min read",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const BottomItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          icon,
          color: isActive
              ? const Color(0xFF059669)
              : Colors.blueGrey,
          size: 22,
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            color: isActive
                ? const Color(0xFF059669)
                : Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}