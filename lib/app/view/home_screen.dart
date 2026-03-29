import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/auth_provider.dart';
import 'category_selection_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Welcome, ${currentUser?.fullName ?? "User"}',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 20),
                    const SizedBox(width: 8),
                    Text('Profile', style: GoogleFonts.poppins()),
                  ],
                ),
                onTap: () {
                  // TODO: Navigate to profile screen
                },
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 20, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Logout', 
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  ],
                ),
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();
                },
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MindGuard',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your wellness journey starts here',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildActionCard(
                      icon: Icons.psychology,
                      title: 'PTSD Assessment',
                      subtitle: 'Take assessment',
                      color: Colors.purple.shade600,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CategorySelectionScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.timeline,
                      title: 'Progress',
                      subtitle: 'View your progress',
                      color: Colors.green.shade600,
                      onTap: () {
                        // TODO: Navigate to progress screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Progress tracking coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.book,
                      title: 'Resources',
                      subtitle: 'Helpful resources',
                      color: Colors.orange.shade600,
                      onTap: () {
                        // TODO: Navigate to resources screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Resources coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.support,
                      title: 'Support',
                      subtitle: 'Get help',
                      color: Colors.blue.shade600,
                      onTap: () {
                        // TODO: Navigate to support screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Support coming soon!'),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.camera_alt,
                      title: 'Mood Camera',
                      subtitle: 'AI mood analysis',
                      color: Colors.purple.shade600,
                      isPremium: true,
                      onTap: () {
                        Navigator.of(context).pushNamed('/camera');
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.psychology_outlined,
                      title: 'Mindfulness',
                      subtitle: 'Guided meditation',
                      color: Colors.teal.shade600,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Mindfulness coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isPremium = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // Premium Badge
            if (isPremium)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber.shade600, Colors.orange.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.diamond,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'PRO',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
