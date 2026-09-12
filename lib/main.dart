import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jigri Yaar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF11131D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF1744),
                    Color(0xFF7B1FA2),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.mic, size: 50),
                  SizedBox(height: 15),
                  Text(
                    'Jigri Yaar Voice',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Apne dosto ke saath voice room mein baat karo.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VoiceRoomPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.mic),
                label: const Text(
                  'Open Voice Room',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'WebRTC microphone test',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Voice Room open karke microphone test kar sakte ho.',
              style: TextStyle(
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoiceRoomPage extends StatefulWidget {
  const VoiceRoomPage({super.key});

  @override
  State<VoiceRoomPage> createState() => _VoiceRoomPageState();
}

class _VoiceRoomPageState extends State<VoiceRoomPage> {
  MediaStream? localStream;
  bool micOn = false;
  bool loading = false;

  Future<void> startMicrophone() async {
    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      final stream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': false,
      });

      localStream = stream;

      for (final track in stream.getAudioTracks()) {
        track.enabled = true;
      }

      if (!mounted) return;

      setState(() {
        micOn = true;
        loading = false;
      });

      showMessage('Microphone ON 🎙️');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        micOn = false;
      });

      showMessage('Microphone permission/error: $e');
    }
  }

  void toggleMicrophone() {
    if (localStream == null) {
      startMicrophone();
      return;
    }

    final tracks = localStream!.getAudioTracks();

    if (tracks.isEmpty) {
      showMessage('Audio track nahi mila');
      return;
    }

    for (final track in tracks) {
      track.enabled = !track.enabled;
      micOn = track.enabled;
    }

    setState(() {});

    showMessage(
      micOn ? 'Microphone ON 🎙️' : 'Microphone OFF 🔇',
    );
  }

  Future<void> stopMicrophone() async {
    final stream = localStream;

    if (stream != null) {
      for (final track in stream.getTracks()) {
        track.stop();
      }

      await stream.dispose();
    }

    localStream = null;

    if (!mounted) return;

    setState(() {
      micOn = false;
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    final stream = localStream;

    if (stream != null) {
      for (final track in stream.getTracks()) {
        track.stop();
      }
      stream.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A10),
      appBar: AppBar(
        title: const Text('Voice Room'),
        backgroundColor: const Color(0xFF11131D),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: micOn
                            ? const [
                                Color(0xFFFF1744),
                                Color(0xFF7B1FA2),
                              ]
                            : const [
                                Color(0xFF252837),
                                Color(0xFF151722),
                              ],
                      ),
                    ),
                    child: Icon(
                      micOn ? Icons.mic : Icons.mic_off,
                      size: 55,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Jigri Yaar Lounge',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    micOn
                        ? 'Microphone is ON'
                        : 'Microphone is OFF',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                    ),
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: 220,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed:
                          loading ? null : toggleMicrophone,
                      icon: Icon(
                        micOn ? Icons.mic_off : Icons.mic,
                      ),
                      label: Text(
                        loading
                            ? 'Starting...'
                            : micOn
                                ? 'Mute Mic'
                                : 'Turn Mic On',
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (micOn)
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: stopMicrophone,
                        child: const Text('Leave Voice Test'),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(18),
            color: const Color(0xFF11131D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoomButton(
                  icon: micOn ? Icons.mic : Icons.mic_off,
                  label: 'Mic',
                  active: micOn,
                  onTap: toggleMicrophone,
                ),
                RoomButton(
                  icon: Icons.card_giftcard,
                  label: 'Gift',
                  onTap: () {
                    showMessage('Gifts coming soon 🎁');
                  },
                ),
                RoomButton(
                  icon: Icons.chat,
                  label: 'Chat',
                  onTap: () {
                    showMessage('Room chat coming soon 💬');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const RoomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: active
                  ? const Color(0xFFFF1744)
                  : const Color(0xFF252837),
              child: Icon(icon),
            ),
            const SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
},
            