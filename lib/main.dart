dependencies:
  flutter_webrtc: ^1.6.2+hotfix.1import 'package:flutter/material.dart';

void main() {
  runApp(const JigriYaarApp());
}

class JigriYaarApp extends StatelessWidget {
  const JigriYaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jigri Yaar',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090A10),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF1744),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    RoomsPage(),
    ChatPage(),
    FriendsPage(),
    ProfilePage(),
  ];

  void openRooms() {
    setState(() {
      selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF11131D),
        selectedIndex: selectedIndex,
        indicatorColor: const Color(0x33FF1744),
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_none),
            selectedIcon: Icon(Icons.mic),
            label: 'Rooms',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Friends',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ================= HOME =================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainState =
        context.findAncestorStateOfType<_MainScreenState>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Jigri Yaar',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showMessage(context, 'Notifications');
                  },
                  icon: const Icon(Icons.notifications_none),
                ),
                IconButton(
                  onPressed: () {
                    showMessage(context, 'Settings');
                  },
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),

            Text(
              'Apne jigri yaaro ke saath connect karo 👋',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF1744),
                    Color(0xFF7B1FA2),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.mic_rounded,
                    size: 44,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Voice Rooms',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Naye logo se milo, baat karo aur masti karo.',
                  ),
                  const SizedBox(height: 18),

                  // WORKING BUTTON
                  ElevatedButton(
                    onPressed: () {
                      mainState?.openRooms();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Explore Rooms'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Popular Rooms',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            RoomCard(
              title: 'Jigri Yaar Lounge',
              subtitle: '128 people online',
              icon: Icons.groups_rounded,
              onTap: () {
                mainState?.openRooms();
              },
            ),

            RoomCard(
              title: 'Gaming Zone 🎮',
              subtitle: '86 people online',
              icon: Icons.sports_esports_rounded,
              onTap: () {
                mainState?.openRooms();
              },
            ),

            RoomCard(
              title: 'Music & Masti 🎵',
              subtitle: '64 people online',
              icon: Icons.music_note_rounded,
              onTap: () {
                mainState?.openRooms();
              },
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: FeatureCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'Chat',
                    onTap: () {
                      mainState?.setState(() {
                        mainState.selectedIndex = 2;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FeatureCard(
                    icon: Icons.card_giftcard,
                    title: 'Gifts',
                    onTap: () {
                      showMessage(context, 'Gifts page coming soon 🎁');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ROOMS =================

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PageHeader(
            title: 'Voice Rooms',
            subtitle: 'Live rooms mein join karo',
          ),
          const SizedBox(height: 18),

          RoomCard(
            title: 'Jigri Yaar Lounge',
            subtitle: '128 people online',
            icon: Icons.groups_rounded,
            onTap: () {
              showMessage(context, 'Jigri Yaar Lounge selected');
            },
          ),

          RoomCard(
            title: 'Gaming Zone 🎮',
            subtitle: '86 people online',
            icon: Icons.sports_esports_rounded,
            onTap: () {
              showMessage(context, 'Gaming Zone selected');
            },
          ),

          RoomCard(
            title: 'Music & Masti 🎵',
            subtitle: '64 people online',
            icon: Icons.music_note_rounded,
            onTap: () {
              showMessage(context, 'Music & Masti selected');
            },
          ),

          RoomCard(
            title: 'Chill & Talk',
            subtitle: '42 people online',
            icon: Icons.forum_rounded,
            onTap: () {
              showMessage(context, 'Chill & Talk selected');
            },
          ),
        ],
      ),
    );
  }
}

// ================= CHAT =================

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PageHeader(
            title: 'Chat',
            subtitle: 'Apne friends se baat karo',
          ),
          SizedBox(height: 18),
          ChatCard(
            name: 'Jigri Yaar',
            message: 'Welcome to Jigri Yaar 👋',
            time: 'Now',
            icon: Icons.person,
          ),
          ChatCard(
            name: 'Gaming Friends',
            message: 'Room mein aao 🎮',
            time: '5m',
            icon: Icons.sports_esports,
          ),
          ChatCard(
            name: 'Music Group',
            message: 'Aaj music night hai 🎵',
            time: '12m',
            icon: Icons.music_note,
          ),
        ],
      ),
    );
  }
}

// ================= FRIENDS =================

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PageHeader(
            title: 'Friends',
            subtitle: 'Apne jigri friends manage karo',
          ),
          const SizedBox(height: 18),

          FriendCard(
            name: 'Jigri Friend',
            status: 'Online',
            icon: Icons.person,
          ),

          FriendCard(
            name: 'Gaming Buddy',
            status: 'In a room',
            icon: Icons.gamepad,
          ),

          FriendCard(
            name: 'Music Friend',
            status: 'Offline',
            icon: Icons.music_note,
          ),
        ],
      ),
    );
  }
}

// ================= PROFILE =================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PageHeader(
            title: 'Profile',
            subtitle: 'Apna Jigri Yaar profile',
          ),

          const SizedBox(height: 22),

          Center(
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF1744),
                        Color(0xFF7B1FA2),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 52,
                  ),
                ),

                const SizedBox(height: 14),

                const Text(
                  'Jigri Yaar User',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '@jigriyaar',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          ProfileOption(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: () {
              showMessage(context, 'Edit Profile');
            },
          ),

          ProfileOption(
            icon: Icons.card_giftcard,
            title: 'My Gifts',
            onTap: () {
              showMessage(context, 'My Gifts');
            },
          ),

          ProfileOption(
            icon: Icons.monetization_on_outlined,
            title: 'Coins',
            onTap: () {
              showMessage(context, 'Coins');
            },
          ),

          ProfileOption(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              showMessage(context, 'Settings');
            },
          ),
        ],
      ),
    );
  }
}

// ================= ROOM CARD =================

class RoomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF151722),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF252837),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0x33FF1744),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF1744),
                size: 29,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ================= FEATURE CARD =================

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: const Color(0xFF151722),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFFFF1744),
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CHAT CARD =================

class ChatCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final IconData icon;

  const ChatCard({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151722),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: const Color(0x33FF1744),
            child: Icon(
              icon,
              color: const Color(0xFFFF1744),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          Text(
            time,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= FRIEND CARD =================

class FriendCard extends StatelessWidget {
  final String name;
  final String status;
  final IconData icon;

  const FriendCard({
    super.key,
    required this.name,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151722),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: const Color(0x33FF1744),
            child: Icon(
              icon,
              color: const Color(0xFFFF1744),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  status,
                  style: TextStyle(
                    color: status == 'Online'
                        ? Colors.greenAccent
                        : Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              showMessage(context, 'Chat with $name');
            },
            icon: const Icon(Icons.chat_outlined),
          ),
        ],
      ),
    );
  }
}

// ================= PROFILE 