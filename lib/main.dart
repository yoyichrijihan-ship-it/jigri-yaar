import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

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
      home: const PhoneLoginPage(),
    );
  }
}



class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String? verificationId;
  bool codeSent = false;
  bool loading = false;

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) return;

    setState(() => loading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'Verification failed')),
          );
        }
      },
      codeSent: (String id, int? resendToken) {
        if (mounted) {
          setState(() {
            verificationId = id;
            codeSent = true;
            loading = false;
          });
        }
      },
      codeAutoRetrievalTimeout: (String id) {
        verificationId = id;
      },
    );

    if (mounted && !codeSent) {
      setState(() => loading = false);
    }
  }

  Future<void> verifyOtp() async {
    if (verificationId == null || otpController.text.trim().isEmpty) return;

    setState(() => loading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Invalid OTP')),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090A10),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Jigri Yaar',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Login with your phone number',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 35),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '+91 9876543210',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.phone, color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF171923),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              if (codeSent) ...[
                const SizedBox(height: 15),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter OTP',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF171923),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading
                      ? null
                      : (codeSent ? verifyOtp : sendOtp),
                  child: Text(
                    loading
                        ? 'Please wait...'
                        : (codeSent ? 'Verify OTP' : 'Send OTP'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            }
