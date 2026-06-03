import 'package:flutter/material.dart';
import 'package:zikmuzik/features/auth/data/models/announcement.dart';
import 'package:zikmuzik/features/auth/data/repositories/announcement_repository.dart';
import 'package:zikmuzik/widgets/announcement_card_widget.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final scrollController = ScrollController();
  final List<Announcement> announcements = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
    scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadFirstPage,
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: announcements.length + (isLoadingMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index >= announcements.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final item = announcements[index];
                  return AnnouncementCard(announcement: item);
                },
              ),
            ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadFirstPage() async {
    setState(() => isLoading = true);

    try {
      final response = await AnnouncementRepository().getAnnouncements(page: 1);
      final data = response.data;

      final List<dynamic> adsJson = data["data"] ?? [];

      final List<Announcement> ads = adsJson
          .map((json) => Announcement.fromJson(json as Map<String, dynamic>))
          .toList();

      setState(() {
        announcements.clear();
        announcements.addAll(ads);
        currentPage = data["pagination"]["page"] ?? 1;
        totalPages = data["pagination"]["totalPages"] ?? 1;
      });
    } catch (e, stack) {
      print('Erreur: $e');
      print('Stack: $stack');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadNextPage() async {
    if (isLoadingMore || currentPage >= totalPages) return;

    setState(() => isLoadingMore = true);
    try {
      final nextPage = currentPage + 1;
      final res = await AnnouncementRepository().getAnnouncements(
        page: nextPage,
      );
      final data = res.data;
      setState(() {
        announcements.addAll(data["data"]);
        currentPage = data["pagination"]["page"];
        totalPages = data["pagination"]["totalPages"];
      });
    } finally {
      setState(() => isLoadingMore = false);
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 300) {
      _loadNextPage();
    }
  }
}
