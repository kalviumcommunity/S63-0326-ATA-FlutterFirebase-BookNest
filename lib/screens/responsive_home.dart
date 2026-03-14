import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Determine screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    
    // 2. Define breakpoint for responsive adjustments
    bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BookNest Responsive UI'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      // 3. LayoutBuilder provides additional layout constraints dynamically
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isTablet) {
            // Adaptive Layout: Two-column layout for tablets and larger screens
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildSidebar(),
                ),
                Expanded(
                  flex: 5,
                  child: _buildMainContent(constraints),
                ),
              ],
            );
          } else {
            // Adaptive Layout: Single-column layout for phones
            return Column(
              children: [
                Expanded(
                  child: _buildMainContent(constraints),
                ),
                _buildFooterArea(),
              ],
            );
          }
        },
      ),
    );
  }

  // Sidebar for large screens replacing the bottom tab bar navigation
  Widget _buildSidebar() {
    return Container(
      color: Colors.blue[50],
      child: Column(
        children: const [
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.home, color: Colors.blueAccent),
            title: Text('Home'),
          ),
          ListTile(
            leading: Icon(Icons.book, color: Colors.blueAccent),
            title: Text('Catalogue'),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }

  // Flexible and adaptive main content logic using constraints
  Widget _buildMainContent(BoxConstraints constraints) {
    // Adjust crossAxisCount dynamically based on max width to ensure natural resizing scaling
    int crossAxisCount = constraints.maxWidth > 800 ? 5 : constraints.maxWidth > 500 ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Library Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: List.generate(
                12,
                (index) => Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        flex: 3,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Icon(Icons.menu_book, size: 40, color: Colors.blueAccent),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          'Book ${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Footer serving as mobile Navigation
  Widget _buildFooterArea() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.blueAccent,
      child: SafeArea( // Adaptive widget to avoid system UI overlap
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: const Icon(Icons.home, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
            IconButton(icon: const Icon(Icons.bookmark, color: Colors.white), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
