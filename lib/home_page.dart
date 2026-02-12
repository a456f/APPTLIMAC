import 'package:flutter/material.dart';
import 'plantillas_page.dart';

class AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final int delay;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = 0,
  });

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0B0F14),
            Color(0xFF0A0D12),
            Color(0xFF000000),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Dashboard TLI",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none,
                  color: Colors.white70),
              onPressed: () {},
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Color(0xFF1A1F26),
                child: Icon(Icons.person, color: Color(0xFFB6FF00)),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// Saludo
              const AnimatedEntrance(
                delay: 100,
                child: Text(
                  "Hola, Agente",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const AnimatedEntrance(
                delay: 200,
                child: Text(
                  "Resumen del día",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Stats
              AnimatedEntrance(
                delay: 300,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: "Consultas",
                        value: "24",
                        icon: Icons.search,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildStatCard(
                        title: "Plantillas",
                        value: "12",
                        icon: Icons.copy,
                        color: const Color(0xFFB6FF00),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const AnimatedEntrance(
                delay: 400,
                child: Text(
                  "Herramientas",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.2,
                children: [
                  AnimatedEntrance(
                    delay: 500,
                    child: _buildActionCard(
                      context,
                      title: "Buscar Plantillas",
                      icon: Icons.chat_bubble_outline,
                      color: const Color(0xFFB6FF00),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PlantillasPage()),
                        );
                      },
                    ),
                  ),
                  AnimatedEntrance(
                    delay: 600,
                    child: _buildActionCard(
                      context,
                      title: "Historial",
                      icon: Icons.history,
                      color: Colors.cyanAccent,
                      onTap: () {},
                    ),
                  ),
                  AnimatedEntrance(
                    delay: 700,
                    child: _buildActionCard(
                      context,
                      title: "Favoritos",
                      icon: Icons.star_border,
                      color: Colors.amberAccent,
                      onTap: () {},
                    ),
                  ),
                  AnimatedEntrance(
                    delay: 800,
                    child: _buildActionCard(
                      context,
                      title: "Ajustes",
                      icon: Icons.settings_outlined,
                      color: Colors.white70,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFF141A21),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 25,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        splashColor: color.withOpacity(0.2),
        highlightColor: color.withOpacity(0.1),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xFF141A21),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 20,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 34),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
