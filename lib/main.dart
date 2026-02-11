import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  late AnimationController _rotationController;
  late AnimationController _typingPulseController;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _passwordFocusNode.addListener(_onFocusChange);
    _rotationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
    _typingPulseController = AnimationController(
      duration: const Duration(milliseconds: 150), // Pulso rápido al teclear
      vsync: this,
    );
    _emailController.addListener(_onTyping);
    _passwordController.addListener(_onTyping);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus;
    });
  }

  void _onTyping() {
    _typingPulseController.forward(from: 0); // Reinicia el pulso con cada tecla
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.removeListener(_onFocusChange);
    _passwordFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _rotationController.dispose();
    _typingPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0D0D0D),
              Color(0xFF000000),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: _isFocused ? 20 : 40,
                  ),

                  /// 🔥 LOGO CON GLOW
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /// ⚡ EFECTO GRIETAS / SOL VERDE
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _isFocused ? 1.0 : 0.0,
                        child: SizedBox(
                          width: 400, // Área grande para que las grietas se extiendan
                          height: 400,
                          child: CustomPaint(
                            painter: TechRingsPainter(
                              animation: _rotationController,
                              pulseAnimation: _typingPulseController,
                              color: const Color(0xFFB6FF00),
                            ),
                          ),
                        ),
                      ),
                      /// Borde Punteado
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _isFocused ? 100 : 140,
                        height: _isFocused ? 100 : 140,
                        child: CustomPaint(
                          painter: DashedCirclePainter(
                            color: const Color(0xFFB6FF00).withOpacity(0.5),
                          ),
                        ),
                      ),
                      /// Logo 3D Giratorio
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.all(_isFocused ? 15 : 25),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB6FF00).withOpacity(0.6),
                              blurRadius: 60,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(_isFocused ? 0 : _rotationController.value * 2 * math.pi),
                              child: child,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/logoapp.png',
                              height: _isFocused ? 50 : 70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: _isFocused ? 20 : 50,
                  ),

                  if (!_isFocused)
                    const Text(
                      "¡Bienvenido!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  if (!_isFocused) const SizedBox(height: 8),

                  if (!_isFocused)
                    Text(
                      "Inicia sesión para continuar",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: _isFocused ? 0 : 50,
                  ),

                  /// 🔥 FORM
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// EMAIL
                        TextFormField(
                          focusNode: _emailFocusNode,
                          controller: _emailController,
                          cursorColor: const Color(0xFFB6FF00),
                          style: const TextStyle(
                            color: Color(0xFFB6FF00),
                            fontFamily: 'monospace', // Fuente tipo código
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu correo';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Correo electrónico",
                            hintStyle:
                                TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: const Color(0xFF111111),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFB6FF00), width: 2),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// PASSWORD
                        TextFormField(
                          focusNode: _passwordFocusNode,
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: const Color(0xFFB6FF00),
                          style: const TextStyle(
                            color: Color(0xFFB6FF00),
                            fontFamily: 'monospace', // Fuente tipo código
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingresa tu contraseña';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Contraseña",
                            hintStyle:
                                TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: const Color(0xFF111111),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            suffixIcon: const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: Color(0xFFB6FF00), width: 2),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// 🔥 BOTÓN NEÓN
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePage(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFB6FF00),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Iniciar Sesión",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final Color color;
  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    const dashWidth = 8.0;
    const dashSpace = 8.0;
    double startAngle = 0;
    
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final anglePerDash = (dashWidth / circumference) * 2 * math.pi;
    final anglePerSpace = (dashSpace / circumference) * 2 * math.pi;

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        anglePerDash,
        false,
        paint,
      );
      startAngle += anglePerDash + anglePerSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TechRingsPainter extends CustomPainter {
  final Animation<double> animation;
  final Animation<double> pulseAnimation;
  final Color color;

  TechRingsPainter({required this.animation, required this.pulseAnimation, required this.color}) : super(repaint: Listenable.merge([animation, pulseAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pulse = pulseAnimation.value; // Valor de 0.0 a 1.0 al escribir
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round // Puntas redondeadas para suavidad
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 6 + (pulse * 8)); // El brillo aumenta al escribir

    final t = animation.value * 2 * math.pi;

    // --- Anillo 1: Interno, rápido ---
    paint.strokeWidth = 3 + (pulse * 2); // Se engrosa al escribir
    // Dibujamos dos arcos opuestos
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width * 0.28), t, 1.5, false, paint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width * 0.28), t + math.pi, 1.5, false, paint);

    // --- Anillo 2: Medio, lento, dirección contraria ---
    paint.strokeWidth = 2 + pulse;
    // Un arco largo casi completo
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width * 0.34), -t * 0.7, 4, false, paint);

    // --- Anillo 3: Externo, detalles finos ---
    paint.strokeWidth = 1.5 + pulse;
    // Tres pequeños segmentos decorativos
    double offset = t * 0.5;
    for (int i = 0; i < 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width * 0.40),
        offset + (i * (math.pi * 2 / 3)),
        0.5,
        false,
        paint
      );
    }
  }

  @override
  bool shouldRepaint(covariant TechRingsPainter oldDelegate) => true;
}
