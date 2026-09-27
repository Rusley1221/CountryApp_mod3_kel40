import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onHomeTap;

  const ProfilePage({super.key, this.onHomeTap});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, String>> teamMembers = [
    {
      'nama': 'Syauqi Akifur Rahman',
      'nim': '21120124130097',
      'foto': 'https://raw.githubusercontent.com/Rusley1221/assets/refs/heads/main/syauqi%20foto.jpeg?token=GHSAT0AAAAAAEKLKPKFLVARSRPDLAD2UPEQ2VY7E2A',
    },
    {
      'nama': 'Lionel Jeremi Pinondang Siahaan',
      'nim': '21120124130067',
      'foto': 'https://raw.githubusercontent.com/Rusley1221/assets/refs/heads/main/lionel%20foto.jpeg?token=GHSAT0AAAAAAEKLKPKFMNZB2LOAWZ5ORZ6S2VY7ENA',
    },
    {
      'nama': 'Cornelius Fransinatra Wijaya',
      'nim': '21120124140141',
      'foto': 'https://raw.githubusercontent.com/Rusley1221/assets/refs/heads/main/bahpong%20foto.jpeg?token=GHSAT0AAAAAAEKLKPKEWYOBCOVINYDZVD2Q2VY7DVA',
    },
    {
      'nama': 'Natasya Zahirah Teguh',
      'nim': '21120124140127',
      'foto': 'https://raw.githubusercontent.com/Rusley1221/assets/refs/heads/main/natasya%20foto.jpeg?token=GHSAT0AAAAAAEKLKPKE4Y67AWGWBRASKPYS2VY7FCQ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 13, 105, 225),
        actions: [
          IconButton(icon: const Icon(Icons.home), onPressed: widget.onHomeTap),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      image: NetworkImage(
                        'https://i.pinimg.com/1200x/b1/38/b5/b138b5213ee781543c0f83d704fb7476.jpg',
                      ),
                    ),
                    color: const Color.fromARGB(255, 255, 252, 252)
                        .withValues(alpha: 128),
                  ),
                ),
                const Text(
                  'Kelompok 40',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 6, color: Colors.black45)],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: teamMembers.length,
              itemBuilder: (context, i) {
                final member = teamMembers[i];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(member['foto']!),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          member['nama']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          member['nim']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}