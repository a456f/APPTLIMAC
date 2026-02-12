import 'dart:ui';
import 'package:flutter/material.dart';
import 'plantillas_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1026),
      body: Stack(
        children: [
          /// 🔥 Background Glow
          Positioned(
            top: -120,
            left: -80,
            child: _glowCircle(300, Colors.blueAccent),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: _glowCircle(350, Colors.blueAccent),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 👋 Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Hola, Agente", style: TextStyle(color: Colors.white70, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("Panel de Control", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.person, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ⚡ Stats Card
                  _glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rendimiento",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "98% Eficiencia",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _miniStat("45", "Consultas"),
                            const SizedBox(width: 12),
                            _miniStat("1.2m", "Tiempo Prom."),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// 🔘 Tabs
                  Row(
                    children: [
                      _tabButton("Principal", true),
                      const SizedBox(width: 10),
                      _tabButton("Herramientas", false),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 📦 Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.1,
                      children: [
                        _ActionCard(
                          title: "Plantillas",
                          icon: Icons.copy_all,
                          color: Colors.blueAccent,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlantillasPage())),
                        ),
                        _ActionCard(
                          title: "Historial",
                          icon: Icons.history,
                          color: Colors.blueAccent,
                          onTap: () {},
                        ),
                        _ActionCard(
                          title: "Reportes",
                          icon: Icons.bar_chart,
                          color: Colors.blueAccent,
                          onTap: () {},
                        ),
                        _ActionCard(
                          title: "Ajustes",
                          icon: Icons.settings,
                          color: Colors.blueAccent,
                          onTap: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),

      /// 🚀 Bottom Nav
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white.withOpacity(0.08),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.chat_bubble_outline, color: Colors.white38),
            Icon(Icons.bar_chart, color: Colors.white38),
            Icon(Icons.person_outline, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  /// 🔥 Glow
  static Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// 💎 Glass Card
  static Widget _glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  static Widget _miniStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _tabButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: active
            ? const LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Colors.lightBlueAccent,
                ],
              )
            : null,
        color: active ? null : Colors.white.withOpacity(0.05),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.white54,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String subtitle;
  final bool highlighted;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle = "Disponible",
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: highlighted
                    ? color.withOpacity(0.6)
                    : Colors.white.withOpacity(0.1),
              ),
              boxShadow: highlighted
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.02),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// 🔵 Icono en burbuja glow
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(0.7),
                        color.withOpacity(0.15),
                      ],
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),

                Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                /// 👉 Indicador inferior elegante
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ver más",
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios,
                        size: 12, color: color),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
