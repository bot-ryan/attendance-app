import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = 'Home';
  static String routePath = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  // ---- Mock data (replace with your backend later)
  final List<ClassItem> _classes = [
    ClassItem(
      name: 'Math 101',
      category: 'Mathematics',
      imageUrl: 'https://picsum.photos/seed/math/1200/600',
      start: DateTime.now().add(const Duration(hours: 3)),
      end: DateTime.now().add(const Duration(hours: 4)),
    ),
    ClassItem(
      name: 'Physics Lab',
      category: 'Science',
      imageUrl: 'https://picsum.photos/seed/physics/1200/600',
      start: DateTime.now().subtract(const Duration(minutes: 30)),
      end: DateTime.now().add(const Duration(hours: 1)),
    ),
    ClassItem(
      name: 'History',
      category: 'Humanities',
      imageUrl: 'https://picsum.photos/seed/history/1200/600',
      start: DateTime.now().subtract(const Duration(hours: 3)),
      end: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final now = DateTime.now();
    final upcoming = _classes.where((c) => c.start.isAfter(now)).toList();
    final ongoing =
        _classes.where((c) => !c.start.isAfter(now) && c.end.isAfter(now)).toList();
    final past = _classes.where((c) => !c.end.isAfter(now)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: cs.primary,
        elevation: 2,
        title: const Text('Classes', style: TextStyle(color: Colors.white)),
        actions: [
          // UI-only create button (shows always for now)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF398F36),
                foregroundColor: Colors.white,
                minimumSize: const Size(110, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // TODO: route to create class page later
              },
              icon: const Icon(Icons.add_circle, size: 18),
              label: const Text('Create'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          TabBar(
            controller: _tabs,
            labelColor: cs.primary,
            indicatorColor: cs.primary,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Ongoing'),
              Tab(text: 'Past'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _ClassesList(items: upcoming, status: ClassStatus.upcoming),
                _ClassesList(items: ongoing, status: ClassStatus.ongoing),
                _ClassesList(items: past, status: ClassStatus.past),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Models & UI bits =====

enum ClassStatus { upcoming, ongoing, past }

class ClassItem {
  final String name;
  final String category;
  final String imageUrl;
  final DateTime start;
  final DateTime end;

  ClassItem({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.start,
    required this.end,
  });
}

class _ClassesList extends StatelessWidget {
  const _ClassesList({required this.items, required this.status});
  final List<ClassItem> items;
  final ClassStatus status;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      final msg = {
        ClassStatus.upcoming: 'No upcoming classes',
        ClassStatus.ongoing: 'No classes are running right now',
        ClassStatus.past: 'No past classes',
      }[status]!;
      return Center(child: Text(msg));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _ClassCard(item: items[i], status: status),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({required this.item, required this.status});
  final ClassItem item;
  final ClassStatus status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final badge = _badgeFor(status, cs);

    return InkWell(
      onTap: () {
        // TODO: navigate to details
      },
      child: Container(
        height: 184,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(blurRadius: 6, color: Color(0x33000000), offset: Offset(0, 2))],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(item.imageUrl),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0x65090F13),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  badge,
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.category,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _formatRange(item.start, item.end),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _badgeFor(ClassStatus s, ColorScheme cs) {
    final (label, bg) = switch (s) {
      ClassStatus.upcoming => ('Upcoming', cs.tertiary.withValues(alpha: 0.9)),
      ClassStatus.ongoing  => ('Ongoing',  cs.secondary.withValues(alpha: 0.9)),
      ClassStatus.past     => ('Past',     Colors.black.withValues(alpha: 0.55)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }

  static String _formatRange(DateTime s, DateTime e) {
    String two(int n) => n.toString().padLeft(2, '0');
    String hm(DateTime d) {
      final h = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
      final ampm = d.hour >= 12 ? 'PM' : 'AM';
      return '${two(h)}:${two(d.minute)} $ampm';
    }
    return '${s.day}/${s.month} ${hm(s)} - ${hm(e)}';
  }
}
