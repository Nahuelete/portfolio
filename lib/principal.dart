// ignore_for_file: deprecated_member_use, unused_import, use_key_in_widget_constructors, unused_element, no_leading_underscores_for_local_identifiers, curly_braces_in_flow_control_structures, unused_field, prefer_final_fields, use_super_parameters

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // ================= GLOBAL =================
  bool isHoveredGlobal = false;

  // ================= LENGUAJE =================
  bool _isHoveredLenguaje = false;
  String lenguaje = 'es';

  // ================= ANIMACIÓN DE CARGA =================
  late AnimationController _loadingCodeController;
  late AnimationController _loadingFadeController;
  late AnimationController _loadingScaleController;
  late AnimationController _loadingGlitchController;

  late Animation<double> _loadingCodeAnimation;
  late Animation<double> _loadingFadeAnimation;
  late Animation<double> _loadingScaleAnimation;

  bool _showPortfolio = false;
  bool _loadingComplete = false;

  void _startLoadingAnimation() async {
    await _loadingCodeController.forward();

    await Future.delayed(const Duration(milliseconds: 400));

    for (int i = 0; i < 3; i++) {
      await _loadingGlitchController.forward();
      await _loadingGlitchController.reverse();
    }

    _loadingFadeController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _showPortfolio = true;
      });
    }
    await _loadingScaleController.forward();

    // Marcar como completado
    if (mounted) {
      setState(() {
        _loadingComplete = true;
      });
    }
  }

  // ================= FONDO =================
  late AnimationController _controllerFondo;
  final Random _random = Random();
  final List<_ShootingStar> stars = [];

  // ================= CURSOR =================
  late AnimationController _controllerCursor;
  final List<Particle> particles = [];
  final Random random = Random();
  int lastParticleTime = 0;

  final List<String> codeChars = [
    "{",
    "}",
    "<",
    ">",
    "[",
    "]",
    "(",
    ")",
    ";",
    ":",
    "=",
    "+",
    "-",
    "*",
    "/",
    "=>",
    "!=",
    "==",
    "&&",
    "||",
    "class",
    "void",
    "int",
    "var",
    "const",
    "if",
    "for",
    "return",
    "Nahuel",
    "fullStack",
    "Flutter",
  ];

  // ================= APP BAR =================
  Offset _mousePosition = const Offset(100, 100);
  bool _isMute = false;
  int _hoveredIndex = -1;
  bool _isHoveringContactButton = false;
  bool _isHoveringSoundButton = false;

  final List<String> menuItems = [
    'Inicio',
    'Sobre Mi',
    'Tecnologias',
    'Proyectos',
  ];

  // ================= TEXTO APPBAR =================
  late AnimationController _textAnimationController;
  late Animation<double> _textAnimation;

  // ================= TYPEWRITER =================
  final List<String> _roles = [
    "Desarrollador Full Stack",
    "Especializado en Flutter y Dart",
    "Desarrollador movil multiplataforma",
  ];

  int _currentRole = 0;
  int _visibleChars = 0;

  late Timer _typeTimer;
  late Timer _cursorTimer;

  bool _showCursor = true;
  bool _isDeleting = false;

  // ================= FLOATING STATS =================
  late AnimationController _floatController1;
  late AnimationController _floatController2;
  late AnimationController _floatController3;

  late Animation<double> _floatAnimation1;
  late Animation<double> _floatAnimation2;
  late Animation<double> _floatAnimation3;

  // ========== MOVED FUNCTIONS BEGIN ==========
  void _startTyping() {
    _typeTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;

      final text = _roles[_currentRole];

      setState(() {
        if (!_isDeleting) {
          _visibleChars++;
          if (_visibleChars >= text.length) {
            _visibleChars = text.length;
            timer.cancel();

            // ⏸ pausa larga luego de escribir
            Future.delayed(const Duration(seconds: 5), () {
              if (!mounted) return;
              _isDeleting = true;
              startDeleting();
            });
          }
        }
      });
    });
  }

  void startDeleting() {
    _typeTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) return;

      setState(() {
        _visibleChars--;
        if (_visibleChars <= 0) {
          _visibleChars = 0;
          timer.cancel();

          _isDeleting = false;
          _currentRole = (_currentRole + 1) % _roles.length;

          // pequeña pausa antes de volver a escribir
          Future.delayed(const Duration(milliseconds: 400), () {
            if (!mounted) return;
            _startTyping();
          });
        }
      });
    });
  }
  // ========== MOVED FUNCTIONS END ==========

  // ========== BOTONES PRINCIPALES ==========
  bool _isHoveringPrimaryButton = false;
  bool _isHoveringSecondaryButton = false;

  // ========== ESTADISTICAS ==========
  int _hoveredStatIndex = -1;

  // ================= BLOQUE CODIGO =================
  bool _codeFinished = false;
  bool _isHoveringCode = false;
  late AnimationController _codeScanController;

  // ================= ANIMACIÓN MOUSE SCROLL =================
  late AnimationController _scrollIndicatorController;
  late Animation<double> _scrollBounceAnimation;
  late Animation<double> _scrollFadeAnimation;

  @override
  void initState() {
    super.initState();

    // ================= ANIMACIÓN DE CARGA =================
    _loadingCodeController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _loadingFadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _loadingScaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _loadingGlitchController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _loadingCodeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingCodeController, curve: Curves.easeInOut),
    );

    _loadingFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _loadingFadeController,
        curve: Curves.easeInCubic,
      ),
    );

    _loadingScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingScaleController,
        curve: Curves.easeOutBack,
      ),
    );

    _startLoadingAnimation();

    // ================= TEXTO APPBAR =================
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _textAnimation = CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    );

    _controllerFondo =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(_updateStars)
          ..repeat();

    _controllerCursor =
        AnimationController(vsync: this, duration: const Duration(days: 365))
          ..addListener(_updateCursorParticles)
          ..repeat();

    // ================= FLOATING ANIMATIONS =================
    _floatController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _floatController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnimation1 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController1, curve: Curves.easeInOut),
    );

    _floatAnimation2 = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _floatController2, curve: Curves.easeInOut),
    );

    _floatAnimation3 = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _floatController3, curve: Curves.easeInOut),
    );

    _startTyping();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      setState(() => _showCursor = !_showCursor);
    });

    // ================= BLOQUE CODIGO =================
    _codeScanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // ================= ANIMACIÓN MOUSE SCROLL =================
    _scrollIndicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    _scrollBounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _scrollIndicatorController,
        curve: Curves.easeInOut,
      ),
    );

    _scrollFadeAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _scrollIndicatorController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _typeTimer.cancel();
    _cursorTimer.cancel();
    _loadingCodeController.dispose();
    _loadingFadeController.dispose();
    _loadingScaleController.dispose();
    _loadingGlitchController.dispose();
    _controllerFondo.dispose();
    _controllerCursor.dispose();
    _textAnimationController.dispose();
    _floatController1.dispose();
    _floatController2.dispose();
    _floatController3.dispose();
    _codeScanController.dispose();
    _scrollIndicatorController.dispose();
    super.dispose();
  }

  // ================= FONDO =================
  void _updateStars() {
    if (_random.nextDouble() < 0.02) {
      stars.add(_ShootingStar.random(_random));
    }

    stars.removeWhere((s) => s.isDead);
    for (final s in stars) {
      s.update();
    }

    if (mounted) setState(() {});
  }

  // ================= CURSOR =================
  void _updateCursorParticles() {
    for (int i = particles.length - 1; i >= 0; i--) {
      final p = particles[i];
      p.life += 1;
      p.position += p.velocity;
      p.rotation += p.rotationSpeed;
      p.velocity *= 0.99;

      if (p.life >= p.maxLife) {
        particles.removeAt(i);
      }
    }

    if (mounted) setState(() {});
  }

  void addParticle(Offset position) {
    final now = DateTime.now().millisecondsSinceEpoch;

    if (now - lastParticleTime > 80) {
      particles.add(
        Particle(
          position:
              position +
              Offset(
                (random.nextDouble() - 0.5) * 30,
                (random.nextDouble() - 0.5) * 30,
              ),
          velocity: Offset(
            (random.nextDouble() - 0.5) * 2.5,
            -random.nextDouble() * 2 - 1,
          ),
          maxLife: 100,
          char: codeChars[random.nextInt(codeChars.length)],
          rotation: random.nextDouble() * pi * 2,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.08,
        ),
      );

      lastParticleTime = now;
    }
  }

  // ================= BLOQUE CODIGO =================
  Color _getCodeColor(String line) {
    if (line.contains('import') ||
        line.contains('void') ||
        line.contains('async')) {
      return const Color(0xFFFF79C6); // Rosa para keywords
    } else if (line.contains('print') ||
        line.contains('await') ||
        line.contains('runApp')) {
      return const Color(0xFF8BE9FD); // Cyan para funciones
    } else if (line.contains('\'')) {
      return const Color(0xFFF1FA8C); // Amarillo para strings
    }
    return Colors.white.withOpacity(0.9);
  }

  // ================= LOADING SCREEN =================
  Widget _buildLoadingScreen() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double sp(double size) =>
        size / 430 * (screenWidth < screenHeight ? screenWidth : screenHeight);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _loadingCodeAnimation,
        _loadingFadeAnimation,
      ]),
      builder: (context, child) {
        return Opacity(
          opacity: _loadingFadeAnimation.value,
          child: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B0F1A),
                  Color(0xFF151A33),
                  Color(0xFF0B0F1A),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Fondo con estrellas fugaces
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topLeft,
                        radius: 1.3,
                        colors: [Color(0xFF151A33), Color(0xFF0B0F1A)],
                      ),
                    ),
                    child: CustomPaint(
                      painter: _ShootingStarsPainter(stars),
                      size: Size(screenWidth, screenHeight),
                    ),
                  ),
                ),

                // Grid de líneas decorativas
                ...List.generate(8, (i) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: (screenHeight / 8) * i,
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 800 + i * 100),
                      curve: Curves.easeOut,
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value * 0.03,
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF00D9FF).withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

                // Círculos concéntricos pulsantes
                Center(
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.easeOut,
                    builder: (context, double value, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: List.generate(3, (index) {
                          final delay = index * 0.2;
                          final circleValue = (value - delay).clamp(0.0, 1.0);
                          final size = 100.0 + (index * 50);

                          return Container(
                            width: size * circleValue,
                            height: size * circleValue,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(
                                  0xFF00D9FF,
                                ).withOpacity((1 - circleValue) * 0.2),
                                width: 1.5,
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),

                // Contenido central
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo/Icono con animación de pulso
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.elasticOut,
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: sp(40),
                              height: sp(40),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF00D9FF),
                                    Color(0xFF0099FF),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00D9FF,
                                    ).withOpacity(0.6),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '</>',
                                  style: GoogleFonts.firaCode(
                                    fontSize: sp(12),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: sp(30)),

                      // Nombre con efecto de escritura
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1500),
                        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                        builder: (context, double value, child) {
                          const text = 'Nahuel.dev';
                          final visibleChars = (value * text.length).floor();

                          return Opacity(
                            opacity: value,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  text.substring(0, visibleChars),
                                  style: GoogleFonts.poppins(
                                    fontSize: sp(14),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                                if (visibleChars < text.length)
                                  Container(
                                    width: 3,
                                    height: sp(14),
                                    margin: const EdgeInsets.only(left: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00D9FF),
                                      borderRadius: BorderRadius.circular(2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF00D9FF),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: sp(10)),

                      // Subtítulo
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1500),
                        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Text(
                              'Full Stack Developer',
                              style: GoogleFonts.poppins(
                                fontSize: sp(6),
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF00D9FF).withOpacity(0.8),
                                letterSpacing: 4,
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: sp(50)),

                      // Barra de progreso moderna
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 1800),
                        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Column(
                              children: [
                                // Barra
                                Container(
                                  width: sp(140),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        width:
                                            sp(140) *
                                            _loadingCodeAnimation.value,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF00D9FF),
                                              Color(0xFF00FFF0),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF00D9FF,
                                              ).withOpacity(0.6),
                                              blurRadius: 15,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: sp(12)),

                                // Porcentaje
                                Text(
                                  '${(_loadingCodeAnimation.value * 100).toInt()}%',
                                  style: GoogleFonts.firaCode(
                                    fontSize: sp(6),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withOpacity(0.5),
                                    letterSpacing: 3,
                                  ),
                                ),
                              ],
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
        );
      },
    );
  }

  // ================= APP BAR =================
  Widget _buildAppBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double w(double width) => width / 430 * screenWidth;
    double h(double height) => height / 932 * screenHeight;
    double sp(double size) =>
        size / 430 * (screenWidth < screenHeight ? screenWidth : screenHeight);

    return MouseRegion(
      onEnter: (event) {
        _textAnimationController.forward();
      },
      onExit: (event) {
        _textAnimationController.reverse();
      },
      child: Container(
        height: h(53),
        padding: EdgeInsets.symmetric(horizontal: w(10)),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            // Logo con ancho fijo
            SizedBox(
              width: w(80),
              child: AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  const fullText = ".dev";
                  final progress = _textAnimation.value;
                  final charsToShow = (progress * fullText.length).floor();
                  final partialText = fullText.substring(0, charsToShow);

                  final nextCharOpacity =
                      (progress * fullText.length) - charsToShow;
                  final nextChar = charsToShow < fullText.length
                      ? fullText[charsToShow]
                      : '';

                  return RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '<Nahuel',
                          style: GoogleFonts.firaCode(
                            fontSize: sp(8),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (partialText.isNotEmpty)
                          TextSpan(
                            text: partialText,
                            style: GoogleFonts.firaCode(
                              fontSize: sp(8),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00D9FF),
                            ),
                          ),
                        if (nextChar.isNotEmpty)
                          TextSpan(
                            text: nextChar,
                            style: GoogleFonts.firaCode(
                              fontSize: sp(8),
                              fontWeight: FontWeight.bold,
                              color: const Color(
                                0xFF00D9FF,
                              ).withOpacity(nextCharOpacity),
                            ),
                          ),
                        TextSpan(
                          text: '/>',
                          style: GoogleFonts.firaCode(
                            fontSize: sp(8),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00D9FF),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // Menú de navegación
            ...List.generate(menuItems.length, (index) {
              return MouseRegion(
                onEnter: (event) {
                  if (mounted) {
                    setState(() {
                      _hoveredIndex = index;
                      isHoveredGlobal = true;
                    });
                  }
                },
                onExit: (event) {
                  if (mounted) {
                    setState(() {
                      _hoveredIndex = -1;
                      isHoveredGlobal = false;
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w(10)),
                  child: SizedBox(
                    height: h(53),
                    child: Center(
                      child: UnderlineHoverText(
                        text: menuItems[index],
                        isHovered: _hoveredIndex == index,
                        style: GoogleFonts.poppins(
                          fontSize: sp(5),
                          fontWeight: FontWeight.bold,
                          color: _hoveredIndex == index
                              ? const Color(0xFF00D9FF)
                              : Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            // Selector de idioma (minimal + hint de cambio)
            MouseRegion(
              cursor: SystemMouseCursors.none,
              onEnter: (_) {
                if (mounted) {
                  setState(() {
                    _isHoveredLenguaje = true;
                    isHoveredGlobal = true;
                  });
                }
              },
              onExit: (_) {
                if (mounted) {
                  setState(() {
                    _isHoveredLenguaje = false;
                    isHoveredGlobal = false;
                  });
                }
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    lenguaje = lenguaje == 'es' ? 'en' : 'es';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  height: h(24),
                  padding: EdgeInsets.symmetric(horizontal: w(6)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.035),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.9,
                                end: 1.0,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset(
                          lenguaje == 'es'
                              ? 'assets/spanishIcon.png'
                              : 'assets/englishIcon.png',
                          key: ValueKey(lenguaje),
                          width: w(10),
                          height: w(10),
                        ),
                      ),
                      SizedBox(width: w(5)),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: GoogleFonts.poppins(
                          fontSize: sp(4),
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 1.1,
                        ),
                        child: Text(lenguaje.toUpperCase()),
                      ),
                      SizedBox(width: w(3)),
                      AnimatedRotation(
                        turns: _isHoveredLenguaje ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          Icons.swap_horiz,
                          size: sp(4.5),
                          color: Colors.white.withOpacity(0.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(width: w(10)),

            // Botón Contact Me (animación premium)
            MouseRegion(
              onEnter: (event) {
                if (mounted) {
                  setState(() {
                    _isHoveringContactButton = true;
                    isHoveredGlobal = true;
                  });
                }
              },
              onExit: (event) {
                if (mounted) {
                  setState(() {
                    _isHoveringContactButton = false;
                    isHoveredGlobal = false;
                  });
                }
              },
              child: GestureDetector(
                onTap: () {},
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutExpo,
                  padding: EdgeInsets.symmetric(
                    horizontal: w(10),
                    vertical: h(7),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _isHoveringContactButton
                          ? [const Color(0xFF00FFF0), const Color(0xFF00D9FF)]
                          : [const Color(0xFF00D9FF), Colors.lightBlue],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF00D9FF,
                        ).withOpacity(_isHoveringContactButton ? 0.65 : 0.45),
                        blurRadius: _isHoveringContactButton ? 35 : 20,
                        spreadRadius: _isHoveringContactButton ? 4 : 1,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  transform: Matrix4.identity()
                    ..translate(0.0, _isHoveringContactButton ? -4.0 : 0.0)
                    ..scale(_isHoveringContactButton ? 1.04 : 1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedRotation(
                        turns: _isHoveringContactButton ? -0.05 : 0.0,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white,
                          size: sp(6),
                        ),
                      ),
                      SizedBox(width: w(3)),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        style: GoogleFonts.poppins(
                          fontSize: sp(5),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: _isHoveringContactButton ? 1.1 : 0.6,
                        ),
                        child: const Text('Contactame'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double w(double width) => width / 430 * screenWidth;
    double h(double height) => height / 932 * screenHeight;
    double sp(double size) =>
        size / 430 * (screenWidth < screenHeight ? screenWidth : screenHeight);

    return Scaffold(
      body: Stack(
        children: [
          if (_showPortfolio)
            AnimatedBuilder(
              animation: _loadingScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _loadingScaleAnimation.value,
                  child: Opacity(
                    opacity: _loadingScaleAnimation.value.clamp(0.0, 1.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.none,
                      onHover: (event) {
                        setState(() {
                          _mousePosition = event.localPosition;
                        });
                        addParticle(event.localPosition);
                      },
                      child: Stack(
                        children: [
                          // ============= FONDO =============
                          Container(
                            decoration: const BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.topLeft,
                                radius: 1.3,
                                colors: [Color(0xFF151A33), Color(0xFF0B0F1A)],
                              ),
                            ),
                            child: CustomPaint(
                              painter: _ShootingStarsPainter(stars),
                              size: MediaQuery.of(context).size,
                            ),
                          ),

                          // ============= PARTÍCULAS DEL CURSOR =============
                          IgnorePointer(
                            child: CustomPaint(
                              painter: ParticlePainter(particles),
                            ),
                          ),

                          // ============= CONTENIDO =============
                          IgnorePointer(
                            ignoring: false,
                            child: Center(
                              child: Column(
                                children: [
                                  _buildAppBar(),

                                  SizedBox(height: h(53)),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w(23),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ===== HERO LEFT =====
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: h(6)),

                                              // Saludo pequeño
                                              Text(
                                                "Hola 👋, soy",
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  fontSize: sp(10),
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),

                                              SizedBox(height: h(5)),

                                              // NOMBRE GRANDE con gradiente
                                              ShaderMask(
                                                blendMode: BlendMode.srcIn,
                                                shaderCallback: (bounds) =>
                                                    LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.white,
                                                        Colors.white,
                                                        Color(0xFF00D9FF),
                                                        Colors.lightBlue,
                                                      ],
                                                      stops: [
                                                        0.0,
                                                        0.45,
                                                        0.55,
                                                        1.0,
                                                      ],
                                                    ).createShader(bounds),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 6,
                                                      ),
                                                  child: Text(
                                                    "Nahuel Cappa",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: sp(25),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.1,
                                                      color: Colors
                                                          .white, // importante
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: h(8)),

                                              // Typewriter
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                children: [
                                                  Text(
                                                    _roles[_currentRole]
                                                        .substring(
                                                          0,
                                                          _visibleChars,
                                                        ),
                                                    style: GoogleFonts.firaCode(
                                                      color: Colors.white
                                                          .withOpacity(0.88),
                                                      fontSize: sp(8),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.4,
                                                    ),
                                                  ),
                                                  AnimatedOpacity(
                                                    opacity: _showCursor
                                                        ? 1
                                                        : 0,
                                                    duration: const Duration(
                                                      milliseconds: 150,
                                                    ),
                                                    child: Text(
                                                      "|",
                                                      style:
                                                          GoogleFonts.firaCode(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.88,
                                                                ),
                                                            fontSize: sp(8),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: h(23)),

                                              // Descripción corta
                                              TweenAnimationBuilder<double>(
                                                duration: const Duration(
                                                  milliseconds: 800,
                                                ),
                                                tween: Tween(
                                                  begin: 0.0,
                                                  end: 1.0,
                                                ),
                                                builder: (context, value, child) {
                                                  return Opacity(
                                                    opacity: value,
                                                    child: Transform.translate(
                                                      offset: Offset(
                                                        0,
                                                        20 * (1 - value),
                                                      ),
                                                      child: SizedBox(
                                                        width: w(200),
                                                        child: Text(
                                                          "Construyo experiencias digitales modernas enfocadas en performance, animaciones y detalle visual.",
                                                          style:
                                                              GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                      0.65,
                                                                    ),
                                                                fontSize: sp(
                                                                  5.5,
                                                                ),
                                                                height: 1.6,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),

                                              SizedBox(height: h(33)),

                                              // CTA buttons con iconos
                                              Row(
                                                children: [
                                                  // Primary CTA
                                                  MouseRegion(
                                                    onEnter: (event) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _isHoveringPrimaryButton =
                                                              true;
                                                          isHoveredGlobal =
                                                              true;
                                                        });
                                                      }
                                                    },
                                                    onExit: (event) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _isHoveringPrimaryButton =
                                                              false;
                                                          isHoveredGlobal =
                                                              false;
                                                        });
                                                      }
                                                    },
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 250,
                                                            ),
                                                        curve:
                                                            Curves.easeOutCubic,
                                                        transform: Matrix4.identity()
                                                          ..scale(
                                                            _isHoveringPrimaryButton
                                                                ? 1.05
                                                                : 1.0,
                                                          )
                                                          ..translate(
                                                            0.0,
                                                            _isHoveringPrimaryButton
                                                                ? -3.0
                                                                : 0.0,
                                                          ),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: w(15),
                                                              vertical: h(9),
                                                            ),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors:
                                                                _isHoveringPrimaryButton
                                                                ? [
                                                                    const Color(
                                                                      0xFF00FFF0,
                                                                    ),
                                                                    const Color(
                                                                      0xFF00D9FF,
                                                                    ),
                                                                  ]
                                                                : [
                                                                    const Color(
                                                                      0xFF00D9FF,
                                                                    ),
                                                                    Colors
                                                                        .lightBlue,
                                                                  ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                30,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color:
                                                                  const Color(
                                                                    0xFF00D9FF,
                                                                  ).withOpacity(
                                                                    _isHoveringPrimaryButton
                                                                        ? 0.7
                                                                        : 0.5,
                                                                  ),
                                                              blurRadius:
                                                                  _isHoveringPrimaryButton
                                                                  ? 25
                                                                  : 18,
                                                              spreadRadius:
                                                                  _isHoveringPrimaryButton
                                                                  ? 3
                                                                  : 0,
                                                              offset: Offset(
                                                                0,
                                                                _isHoveringPrimaryButton
                                                                    ? 8
                                                                    : 6,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            AnimatedRotation(
                                                              turns:
                                                                  _isHoveringPrimaryButton
                                                                  ? 0.05
                                                                  : 0,
                                                              duration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        250,
                                                                  ),
                                                              child: Icon(
                                                                Icons
                                                                    .rocket_launch,
                                                                color: Colors
                                                                    .white,
                                                                size: sp(6),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: w(5),
                                                            ),
                                                            AnimatedDefaultTextStyle(
                                                              duration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        250,
                                                                  ),
                                                              style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: sp(
                                                                  5.5,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    _isHoveringPrimaryButton
                                                                    ? 1.0
                                                                    : 0.6,
                                                              ),
                                                              child: const Text(
                                                                "Ver proyectos",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(width: w(8)),

                                                  // Secondary CTA
                                                  MouseRegion(
                                                    onEnter: (event) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _isHoveringSecondaryButton =
                                                              true;
                                                          isHoveredGlobal =
                                                              true;
                                                        });
                                                      }
                                                    },
                                                    onExit: (event) {
                                                      if (mounted) {
                                                        setState(() {
                                                          _isHoveringSecondaryButton =
                                                              false;
                                                          isHoveredGlobal =
                                                              false;
                                                        });
                                                      }
                                                    },
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 250,
                                                            ),
                                                        curve:
                                                            Curves.easeOutCubic,
                                                        transform: Matrix4.identity()
                                                          ..scale(
                                                            _isHoveringSecondaryButton
                                                                ? 1.05
                                                                : 1.0,
                                                          )
                                                          ..translate(
                                                            0.0,
                                                            _isHoveringSecondaryButton
                                                                ? -3.0
                                                                : 0.0,
                                                          ),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: w(15),
                                                              vertical: h(9),
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              _isHoveringSecondaryButton
                                                              ? const Color(
                                                                  0xFF00D9FF,
                                                                ).withOpacity(
                                                                  0.1,
                                                                )
                                                              : Colors
                                                                    .transparent,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                30,
                                                              ),
                                                          border: Border.all(
                                                            color: const Color(
                                                              0xFF00D9FF,
                                                            ),
                                                            width:
                                                                _isHoveringSecondaryButton
                                                                ? 2.5
                                                                : 2,
                                                          ),
                                                          boxShadow:
                                                              _isHoveringSecondaryButton
                                                              ? [
                                                                  BoxShadow(
                                                                    color: const Color(
                                                                      0xFF00D9FF,
                                                                    ).withOpacity(0.3),
                                                                    blurRadius:
                                                                        15,
                                                                    offset:
                                                                        const Offset(
                                                                          0,
                                                                          5,
                                                                        ),
                                                                  ),
                                                                ]
                                                              : [],
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            AnimatedRotation(
                                                              turns:
                                                                  _isHoveringSecondaryButton
                                                                  ? 0.05
                                                                  : 0,
                                                              duration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        250,
                                                                  ),
                                                              child: Icon(
                                                                Icons.download,
                                                                color:
                                                                    const Color(
                                                                      0xFF00D9FF,
                                                                    ),
                                                                size: sp(6),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: w(5),
                                                            ),
                                                            AnimatedDefaultTextStyle(
                                                              duration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        250,
                                                                  ),
                                                              style: GoogleFonts.poppins(
                                                                color:
                                                                    const Color(
                                                                      0xFF00D9FF,
                                                                    ),
                                                                fontSize: sp(
                                                                  5.5,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                letterSpacing:
                                                                    _isHoveringSecondaryButton
                                                                    ? 1.0
                                                                    : 0.4,
                                                              ),
                                                              child: const Text(
                                                                "Descargar CV",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: h(33)),

                                              Row(
                                                children: [
                                                  // Stat 1
                                                  AnimatedBuilder(
                                                    animation: _floatAnimation1,
                                                    builder: (context, child) {
                                                      return Transform.translate(
                                                        offset: Offset(
                                                          0,
                                                          _floatAnimation1
                                                              .value,
                                                        ),
                                                        child: MouseRegion(
                                                          onEnter: (event) {
                                                            if (mounted) {
                                                              setState(() {
                                                                _hoveredStatIndex =
                                                                    0;
                                                              });
                                                            }
                                                          },
                                                          onExit: (event) {
                                                            if (mounted) {
                                                              setState(() {
                                                                _hoveredStatIndex =
                                                                    -1;
                                                              });
                                                            }
                                                          },
                                                          child: AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      300,
                                                                ),
                                                            transform:
                                                                Matrix4.identity()
                                                                  ..scale(
                                                                    _hoveredStatIndex ==
                                                                            0
                                                                        ? 1.1
                                                                        : 1.0,
                                                                  ),
                                                            child: _buildStatWithHover(
                                                              '3+',
                                                              'Años Exp.',
                                                              _hoveredStatIndex ==
                                                                  0,
                                                              w,
                                                              sp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(width: w(25)),

                                                  // Stat 2
                                                  AnimatedBuilder(
                                                    animation: _floatAnimation2,
                                                    builder: (context, child) {
                                                      return Transform.translate(
                                                        offset: Offset(
                                                          0,
                                                          _floatAnimation2
                                                              .value,
                                                        ),
                                                        child: MouseRegion(
                                                          onEnter: (event) {
                                                            if (mounted) {
                                                              setState(() {
                                                                _hoveredStatIndex =
                                                                    1;
                                                              });
                                                            }
                                                          },
                                                          onExit: (event) {
                                                            if (mounted) {
                                                              setState(() {
                                                                _hoveredStatIndex =
                                                                    -1;
                                                              });
                                                            }
                                                          },
                                                          child: AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      300,
                                                                ),
                                                            transform:
                                                                Matrix4.identity()
                                                                  ..scale(
                                                                    _hoveredStatIndex ==
                                                                            1
                                                                        ? 1.1
                                                                        : 1.0,
                                                                  ),
                                                            child: _buildStatWithHover(
                                                              '10+',
                                                              'Proyectos',
                                                              _hoveredStatIndex ==
                                                                  1,
                                                              w,
                                                              sp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(width: w(25)),

                                                  // Stat 3
                                                  AnimatedBuilder(
                                                    animation: _floatAnimation3,
                                                    builder: (context, child) {
                                                      return Transform.translate(
                                                        offset: Offset(
                                                          0,
                                                          _floatAnimation3
                                                              .value,
                                                        ),
                                                        child: MouseRegion(
                                                          onEnter: (event) {
                                                            if (mounted) {
                                                              setState(() {
                                                                _hoveredStatIndex =
                                                                    2;
                                                              });
                                                            }
                                                          },
                                                          onExit: (event) {
                                                            if (mounted) {
                                                              setState(() {
                                                                _hoveredStatIndex =
                                                                    -1;
                                                              });
                                                            }
                                                          },
                                                          child: AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      300,
                                                                ),
                                                            transform:
                                                                Matrix4.identity()
                                                                  ..scale(
                                                                    _hoveredStatIndex ==
                                                                            2
                                                                        ? 1.1
                                                                        : 1.0,
                                                                  ),
                                                            child: _buildStatWithHover(
                                                              '∞',
                                                              'Cafés ☕',
                                                              _hoveredStatIndex ==
                                                                  2,
                                                              w,
                                                              sp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: h(33)),

                                              // Social network buttons (circular)
                                              AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: w(5),
                                                  vertical: h(4.5),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.045),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(0.07),
                                                    width: 0.8,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    _buildSocialButton(
                                                      icon:
                                                          LucideIcons.linkedin,
                                                      tooltip: 'LinkedIn',
                                                      onTap: () {},
                                                      w: w,
                                                      sp: sp,
                                                      index: 0,
                                                    ),
                                                    SizedBox(width: w(3.5)),
                                                    _buildSocialButton(
                                                      icon: LucideIcons.github,
                                                      tooltip: 'GitHub',
                                                      onTap: () {},
                                                      w: w,
                                                      sp: sp,
                                                      index: 1,
                                                    ),
                                                    SizedBox(width: w(3.5)),
                                                    _buildSocialButton(
                                                      icon: LucideIcons.globe,
                                                      tooltip: 'Portfolio',
                                                      onTap: () {},
                                                      w: w,
                                                      sp: sp,
                                                      index: 2,
                                                    ),
                                                    SizedBox(width: w(3.5)),
                                                    _buildSocialButton(
                                                      icon: Icons.work_outline,
                                                      tooltip: 'Fiverr',
                                                      onTap: () {},
                                                      w: w,
                                                      sp: sp,
                                                      index: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(height: h(33)),

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Título sección tecnologías
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: h(8),
                                                    ),
                                                    child: Text(
                                                      "Tecnologías con las que trabajo",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: sp(5),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.75,
                                                                ),
                                                            letterSpacing: 0.8,
                                                          ),
                                                    ),
                                                  ),

                                                  // Subrayado sutil
                                                  Container(
                                                    width: w(40),
                                                    height: 1.5,
                                                    margin: EdgeInsets.only(
                                                      bottom: h(12),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          const Color(
                                                            0xFF00D9FF,
                                                          ),
                                                          Colors.transparent,
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  const InfiniteTechCarousel(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(width: w(20)),

                                        // ===== HERO RIGHT =====
                                        Expanded(
                                          flex: 4,
                                          child: MouseRegion(
                                            onEnter: (_) {
                                              setState(
                                                () => _isHoveringCode = true,
                                              );
                                              _codeScanController.forward(
                                                from: 0,
                                              );
                                            },
                                            onExit: (_) {
                                              setState(
                                                () => _isHoveringCode = false,
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                AnimatedCodeEditor(
                                                  onTypingFinished: () {
                                                    setState(() {
                                                      _codeFinished = true;
                                                    });
                                                  },
                                                  onEditingStarted: () {
                                                    setState(() {
                                                      _codeFinished =
                                                          false; // 👈 CLAVE
                                                    });
                                                  },
                                                ),

                                                if (_isHoveringCode &&
                                                    !_codeFinished)
                                                  Positioned(
                                                    bottom: 14,
                                                    left: 14,
                                                    child: TweenAnimationBuilder<double>(
                                                      duration: const Duration(
                                                        milliseconds: 1300,
                                                      ),
                                                      tween: Tween(
                                                        begin: 0.0,
                                                        end: 1.0,
                                                      ),
                                                      builder: (context, value, _) {
                                                        final isRunning =
                                                            value < 0.55;

                                                        return Opacity(
                                                          opacity: value,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                    0.65,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                              border: Border.all(
                                                                color: isRunning
                                                                    ? const Color(
                                                                        0xFF00D9FF,
                                                                      )
                                                                    : Colors
                                                                          .red,
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color:
                                                                      (isRunning
                                                                              ? const Color(
                                                                                  0xFF00D9FF,
                                                                                )
                                                                              : Colors.red)
                                                                          .withOpacity(
                                                                            0.4,
                                                                          ),
                                                                  blurRadius:
                                                                      14,
                                                                ),
                                                              ],
                                                            ),
                                                            child: Text(
                                                              isRunning
                                                                  ? "Running..."
                                                                  : "Build failed",
                                                              style: GoogleFonts.firaCode(
                                                                fontSize: 11,
                                                                color: isRunning
                                                                    ? const Color(
                                                                        0xFF00D9FF,
                                                                      )
                                                                    : Colors
                                                                          .red,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),

                                                if (_isHoveringCode &&
                                                    _codeFinished)
                                                  Positioned(
                                                    bottom: 14,
                                                    left: 14,
                                                    child: TweenAnimationBuilder<double>(
                                                      duration: const Duration(
                                                        milliseconds: 1300,
                                                      ),
                                                      tween: Tween(
                                                        begin: 0.0,
                                                        end: 1.0,
                                                      ),
                                                      builder: (context, value, _) {
                                                        final isRunning =
                                                            value < 0.55;

                                                        return Opacity(
                                                          opacity: value,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                    0.65,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                              border: Border.all(
                                                                color: isRunning
                                                                    ? const Color(
                                                                        0xFF00D9FF,
                                                                      )
                                                                    : const Color(
                                                                        0xFF00FF9C,
                                                                      ),
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color:
                                                                      (isRunning
                                                                              ? const Color(
                                                                                  0xFF00D9FF,
                                                                                )
                                                                              : const Color(
                                                                                  0xFF00FF9C,
                                                                                ))
                                                                          .withOpacity(
                                                                            0.4,
                                                                          ),
                                                                  blurRadius:
                                                                      14,
                                                                ),
                                                              ],
                                                            ),
                                                            child: Text(
                                                              isRunning
                                                                  ? "Running..."
                                                                  : "Build completed",
                                                              style: GoogleFonts.firaCode(
                                                                fontSize: 11,
                                                                color: isRunning
                                                                    ? const Color(
                                                                        0xFF00D9FF,
                                                                      )
                                                                    : const Color(
                                                                        0xFF00FF9C,
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),

                                                if (_isHoveringCode &&
                                                    _codeFinished)
                                                  Positioned(
                                                    bottom: 54,
                                                    left: 14,
                                                    child: TweenAnimationBuilder<double>(
                                                      duration: const Duration(
                                                        milliseconds: 900,
                                                      ),
                                                      tween: Tween(
                                                        begin: 0.0,
                                                        end: 1.0,
                                                      ),
                                                      builder: (context, value, _) {
                                                        if (value < 0.7)
                                                          return const SizedBox.shrink();

                                                        return Transform.translate(
                                                          offset: Offset(
                                                            0,
                                                            10 * (1 - value),
                                                          ),
                                                          child: Opacity(
                                                            opacity: value,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    10,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    const Color(
                                                                      0xFF0F1117,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                                border: Border.all(
                                                                  color:
                                                                      const Color(
                                                                        0xFF00FF9C,
                                                                      ).withOpacity(
                                                                        0.6,
                                                                      ),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .circle,
                                                                    size: 8,
                                                                    color: Color(
                                                                      0xFF00FF9C,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    "Portfolio app running",
                                                                    style: GoogleFonts.firaCode(
                                                                      fontSize:
                                                                          10,
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                            0.85,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Spacer(),

                                  //Animacion Scroll
                                  Center(
                                    child: AnimatedBuilder(
                                      animation: _scrollIndicatorController,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                            0,
                                            _scrollBounceAnimation.value,
                                          ),
                                          child: Opacity(
                                            opacity: _scrollFadeAnimation.value,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ShaderMask(
                                                  blendMode: BlendMode.srcIn,
                                                  shaderCallback: (bounds) =>
                                                      LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.white,
                                                          Colors.white,
                                                          Color(0xFF00D9FF),
                                                          Colors.lightBlue,
                                                        ],
                                                        stops: [
                                                          0.0,
                                                          0.45,
                                                          0.55,
                                                          1.0,
                                                        ],
                                                      ).createShader(bounds),
                                                  child: Text(
                                                    "Deslizar",
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                        0xFF00D9FF,
                                                      ).withOpacity(0.7),
                                                      fontSize: sp(5),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 1.2,
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(height: h(4)),

                                                // Flecha hacia abajo
                                                Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: const Color(
                                                    0xFF00D9FF,
                                                  ).withOpacity(0.6),
                                                  size: sp(8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  SizedBox(height: h(23)),
                                ],
                              ),
                            ),
                          ),

                          // ============= CURSOR CUSTOM =============
                          Positioned(
                            left: _mousePosition.dx - 20,
                            top: _mousePosition.dy - 20,
                            child: IgnorePointer(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: AnimatedRotation(
                                  turns: isHoveredGlobal ? 0.025 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    isHoveredGlobal ? "</>" : "{}",
                                    key: ValueKey(isHoveredGlobal),
                                    style: GoogleFonts.firaCode(
                                      fontSize: isHoveredGlobal ? sp(5) : sp(6),
                                      color: isHoveredGlobal
                                          ? Colors.white
                                          : Color(0xFF00D9FF),
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: isHoveredGlobal ? 15 : 10,
                                          color:
                                              (isHoveredGlobal
                                                      ? Colors.white
                                                      : const Color(0xFF00D9FF))
                                                  .withOpacity(0.6),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          // ============= PANTALLA DE CARGA (ENCIMA) =============
          if (!_loadingComplete) _buildLoadingScreen(),
        ],
      ),
    );
  }

  // Minimalist language selector item
  Widget _buildMinimalLanguageItem({
    required String label,
    required String asset,
    required bool isActive,
    required VoidCallback onTap,
    required double Function(double) w,
    required double Function(double) sp,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: w(6), vertical: w(3)),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Opacity(
              opacity: isActive ? 1.0 : 0.45,
              child: SvgPicture.asset(asset, width: sp(6)),
            ),
            SizedBox(width: w(3)),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                fontSize: sp(4.5),
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                letterSpacing: 0.6,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  // Helper para botones animados CTA
  Widget _buildAnimatedButton({
    required String text,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
    required Function w,
    required Function h,
    required Function sp,
  }) {
    final ValueNotifier<bool> isHovered = ValueNotifier(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ValueListenableBuilder<bool>(
          valueListenable: isHovered,
          builder: (context, hovered, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..scale(hovered ? 1.05 : 1.0)
                ..translate(0.0, hovered ? -3.0 : 0.0),
              padding: EdgeInsets.symmetric(horizontal: w(15), vertical: h(9)),
              decoration: BoxDecoration(
                gradient: isPrimary
                    ? LinearGradient(
                        colors: hovered
                            ? const [Color(0xFF00FFF0), Color(0xFF00D9FF)]
                            : const [Color(0xFF00D9FF), Colors.lightBlue],
                      )
                    : null,
                color: isPrimary ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: isPrimary
                    ? null
                    : Border.all(
                        color: const Color(0xFF00D9FF),
                        width: hovered ? 2.5 : 2,
                      ),
                boxShadow: [
                  if (isPrimary)
                    BoxShadow(
                      color: const Color(
                        0xFF00D9FF,
                      ).withOpacity(hovered ? 0.7 : 0.5),
                      blurRadius: hovered ? 25 : 18,
                      offset: Offset(0, hovered ? 8 : 6),
                    ),
                  if (!isPrimary && hovered)
                    BoxShadow(
                      color: const Color(0xFF00D9FF).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedRotation(
                    turns: hovered ? 0.05 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      icon,
                      size: sp(6),
                      color: isPrimary ? Colors.white : const Color(0xFF00D9FF),
                    ),
                  ),
                  SizedBox(width: w(5)),
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      color: isPrimary ? Colors.white : const Color(0xFF00D9FF),
                      fontSize: sp(5.5),
                      fontWeight: isPrimary ? FontWeight.bold : FontWeight.w600,
                      letterSpacing: hovered ? 1.0 : 0.6,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatWithHover(
    String number,
    String label,
    bool isHovered,
    Function w,
    Function sp,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: isHovered
                ? [const Color(0xFF00FFF0), const Color(0xFF00D9FF)]
                : [const Color(0xFF00D9FF), const Color(0xFF00D9FF)],
          ).createShader(bounds),
          child: Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: sp(12),
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: isHovered
                  ? [
                      Shadow(
                        color: const Color(0xFF00D9FF).withOpacity(0.6),
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: sp(4),
            color: Colors.white.withOpacity(isHovered ? 0.8 : 0.6),
          ),
        ),
      ],
    );
  }

  // Helper para botones redes
  int _hoveredSocialIndex = -1;

  Widget _buildSocialButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required double Function(double) w,
    required double Function(double) sp,
    required int index,
  }) {
    final bool isHovered = _hoveredSocialIndex == index;

    return MouseRegion(
      onEnter: (event) {
        if (mounted) {
          setState(() {
            _hoveredSocialIndex = index;
            isHoveredGlobal = true;
          });
        }
      },
      onExit: (event) {
        if (mounted) {
          setState(() {
            _hoveredSocialIndex = -1;
            isHoveredGlobal = false;
          });
        }
      },
      child: Tooltip(
        message: tooltip,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF00D9FF).withOpacity(0.3),
            width: 1,
          ),
        ),
        textStyle: GoogleFonts.poppins(
          color: Colors.white.withOpacity(0.9),
          fontSize: sp(5),
          fontWeight: FontWeight.w500,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: w(18),
            height: w(18),
            transform: Matrix4.identity()
              ..scale(isHovered ? 1.2 : 1.0)
              ..translate(0.0, isHovered ? -1.5 : 0.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isHovered
                  ? const Color(0xFF00D9FF).withOpacity(0.15)
                  : Colors.transparent,
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00D9FF).withOpacity(0.25),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: AnimatedRotation(
                turns: isHovered ? 0.05 : 0,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  icon,
                  color: isHovered
                      ? const Color(0xFF00D9FF)
                      : Colors.white.withOpacity(0.5),
                  size: sp(6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= ESTRELLAS FUGACES =================
class _ShootingStar {
  Offset position;
  Offset velocity;
  double life;

  _ShootingStar(this.position, this.velocity, this.life);

  factory _ShootingStar.random(Random random) {
    return _ShootingStar(
      Offset(random.nextDouble(), random.nextDouble() * 0.3),
      const Offset(0.015, 0.009),
      1.0,
    );
  }

  void update() {
    position += velocity;
    life -= 0.03;
  }

  bool get isDead => life <= 0 || position.dx > 1.2 || position.dy > 1.2;
}

class _ShootingStarsPainter extends CustomPainter {
  final List<_ShootingStar> stars;

  _ShootingStarsPainter(this.stars);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    for (final star in stars) {
      final start = Offset(
        star.position.dx * size.width,
        star.position.dy * size.height,
      );

      final end = Offset(
        (star.position.dx - star.velocity.dx * 25) * size.width,
        (star.position.dy - star.velocity.dy * 25) * size.height,
      );

      final opacity = (0.25 * star.life).clamp(0.0, 1.0);

      final paint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(opacity),
          ],
        ).createShader(Rect.fromPoints(start, end))
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(end, start, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ================= PARTICULAS CURSOR =================
class Particle {
  Offset position;
  Offset velocity;
  double life;
  final double maxLife;
  final String char;
  double rotation;
  double rotationSpeed;

  Particle({
    required this.position,
    required this.velocity,
    required this.maxLife,
    required this.char,
    required this.rotation,
    required this.rotationSpeed,
    this.life = 0,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final alpha = ((1 - p.life / p.maxLife) * 0.7).clamp(0.0, 1.0);

      final textPainter = TextPainter(
        text: TextSpan(
          text: p.char,
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'Fira Code',
            color: const Color(0xFF00D9FF).withOpacity(alpha),
            shadows: [
              Shadow(
                blurRadius: 5,
                color: const Color(0xFF00D9FF).withOpacity(alpha),
              ),
              Shadow(
                blurRadius: 13,
                color: const Color(0xFF00D9FF).withOpacity(alpha * 0.4),
              ),
            ],
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      canvas.rotate(p.rotation);
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ================= EFECTO HOVER BOTON =================
class ShimmerHoverEffect extends StatefulWidget {
  final Widget child;
  final bool isHovered;
  final Color primaryColor;
  final Color secondaryColor;

  const ShimmerHoverEffect({
    required this.child,
    required this.isHovered,
    this.primaryColor = const Color(0xFF00D9FF),
    this.secondaryColor = const Color(0xFF00FFF0),
  });

  @override
  State<ShimmerHoverEffect> createState() => _ShimmerHoverEffectState();
}

class _ShimmerHoverEffectState extends State<ShimmerHoverEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(ShimmerHoverEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHovered && !oldWidget.isHovered) {
      _shimmerController.repeat();
    } else if (!widget.isHovered && oldWidget.isHovered) {
      _shimmerController.stop();
      _shimmerController.reset();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                _shimmerAnimation.value - 0.3,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 0.3,
                1.0,
              ],
              colors: widget.isHovered
                  ? [
                      Colors.transparent,
                      widget.primaryColor.withOpacity(0.3),
                      widget.secondaryColor.withOpacity(0.8),
                      widget.primaryColor.withOpacity(0.3),
                      Colors.transparent,
                    ]
                  : [
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                    ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// ================= EFECTO SUBRAYADO =================
class UnderlineHoverText extends StatelessWidget {
  final String text;
  final bool isHovered;
  final TextStyle style;

  const UnderlineHoverText({
    required this.text,
    required this.isHovered,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Texto principal
        Text(text, style: style),

        // Línea de subrayado posicionada debajo
        Positioned(
          left: 0,
          right: 0,
          bottom: -6,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 2,
              width: isHovered ? style.fontSize! * text.length * 0.6 : 0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.lightBlue, Color(0xFF00D9FF)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ================= BLOQUE CODIGO =================
class AnimatedCodeEditor extends StatefulWidget {
  final VoidCallback onTypingFinished;
  final VoidCallback onEditingStarted; // 👈 NUEVO

  const AnimatedCodeEditor({
    super.key,
    required this.onTypingFinished,
    required this.onEditingStarted,
  });

  @override
  State<AnimatedCodeEditor> createState() => _AnimatedCodeEditorState();
}

class _AnimatedCodeEditorState extends State<AnimatedCodeEditor> {
  late List<String> _fullLines;
  late List<String> _visibleLines;

  bool _isHovered = false;

  int _line = 0;
  int _char = 0;
  bool _typingFinished = false;

  int _cursorLine = 0;
  bool _showCursor = true;

  late Timer _typingTimer;
  late Timer _blinkTimer;
  Timer? _editTimer;

  final Random _random = Random();
  int _editCount = 0;

  final List<String> stackVariants = [
    '["Flutter", "Firebase", "Riverpod"]',
    '["Flutter", "Supabase", "REST API"]',
    '["Flutter", "Bloc", "Clean Architecture"]',
    '["Flutter", "GraphQL", "Animations"]',
  ];

  final List<String> focusVariants = [
    '"UI/UX & Animations"',
    '"Performance & Scalability"',
    '"Clean Architecture"',
    '"Pixel Perfect Interfaces"',
  ];

  @override
  void initState() {
    super.initState();

    _fullLines = [
      '// portfolio.dart',
      '',
      'import \'package:flutter/material.dart\';',
      'import \'package:flutter_animate/flutter_animate.dart\';',
      '',
      'class Profile {',
      '  final String name;',
      '  final String role;',
      '  final List<String> stack;',
      '  final String focus;',
      '',
      '  const Profile({',
      '    required this.name,',
      '    required this.role,',
      '    required this.stack,',
      '    required this.focus,',
      '  });',
      '}',
      '',
      'final Profile profile = Profile(',
      '  name: "Nahuel Cappa",',
      '  role: "Flutter & FullStack Developer",',
      '  stack: ["Flutter", "Firebase", "Riverpod"],',
      '  focus: "UI/UX & Animations",',
      ');',
      '',
      'class Portfolio {',
      '  late final AnimationController controller;',
      '',
      '  PortfolioController(TickerProvider vsync) {',
      '    controller = AnimationController(',
      '      vsync: vsync,',
      '      duration: const Duration(milliseconds: 900),',
      '    );',
      '  }',
      '',
      '  Future<void> loadProfile() async {',
      '    await Future.delayed(const Duration(milliseconds: 600));',
      '  }',
      '',
      '  Widget buildHero(BuildContext context) {',
      '    return Text(',
      '      profile.name,',
      '      style: Theme.of(context).textTheme.headlineLarge,',
      '    ).animate().fadeIn().slideY();',
      '  }',
      '}',
    ];

    _visibleLines = List.generate(_fullLines.length, (_) => '');

    _typingTimer = Timer.periodic(const Duration(milliseconds: 42), _typeStep);

    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _showCursor = !_showCursor);
    });
  }

  void _typeStep(Timer timer) {
    if (_line >= _fullLines.length) {
      timer.cancel();
      _typingFinished = true;

      widget.onTypingFinished();

      _startEdits();
      return;
    }

    final current = _fullLines[_line];

    setState(() {
      _cursorLine = _line;
      _char++;
      _visibleLines[_line] = current.substring(
        0,
        _char.clamp(0, current.length),
      );
    });

    if (_char >= current.length) {
      timer.cancel();
      Future.delayed(const Duration(milliseconds: 320), () {
        if (!mounted) return;
        setState(() {
          _line++;
          _char = 0;
        });
        _typingTimer = Timer.periodic(
          const Duration(milliseconds: 42),
          _typeStep,
        );
      });
    }
  }

  void _startEdits() {
    _editTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (_editCount >= 5) {
        _resetAndRewrite();
        return;
      }

      // ⏸ pausa visible tipo IDE (código estable)
      await Future.delayed(const Duration(milliseconds: 300));

      await _animateEdit();

      _editCount++;
    });
  }

  Future<void> _animateEdit() async {
    widget.onEditingStarted(); // 🔴 running

    await Future.delayed(const Duration(milliseconds: 600));

    final editable = _fullLines.asMap().entries.where((e) {
      return e.value.contains('"') && !e.value.contains('Nahuel Cappa');
    }).toList();

    // 🟡 NO hubo nada para editar → build OK igual
    if (editable.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 400));
      widget.onTypingFinished(); // ✅ build completed
      return;
    }

    final entry = editable[_random.nextInt(editable.length)];
    final lineIndex = entry.key;
    final oldLine = entry.value;

    final variants = oldLine.contains('stack') ? stackVariants : focusVariants;

    final replacement = variants[_random.nextInt(variants.length)];

    final start = oldLine.indexOf('"');
    final end = oldLine.lastIndexOf('"') + 1;

    _cursorLine = lineIndex;

    // borrar
    for (int i = end; i >= start; i--) {
      await Future.delayed(const Duration(milliseconds: 32));
      setState(() {
        _visibleLines[lineIndex] = oldLine.substring(0, i);
      });
    }

    await Future.delayed(const Duration(milliseconds: 420));

    // escribir
    for (int i = 0; i < replacement.length; i++) {
      await Future.delayed(const Duration(milliseconds: 36));
      setState(() {
        _visibleLines[lineIndex] += replacement[i];
      });
    }

    _fullLines[lineIndex] = oldLine.replaceRange(start, end, replacement);

    // ⏸ pausa tipo IDE
    await Future.delayed(const Duration(milliseconds: 500));

    widget.onTypingFinished(); // 🟢 build completed
  }

  void _resetAndRewrite() async {
    widget.onEditingStarted();
    _editTimer?.cancel();
    _editCount = 0;

    await _eraseAllProgressively();

    setState(() {
      _line = 0;
      _char = 0;
      _typingFinished = false;
    });

    _typingTimer = Timer.periodic(const Duration(milliseconds: 42), _typeStep);
  }

  Future<void> _eraseAllProgressively() async {
    for (int line = _visibleLines.length - 1; line >= 0; line--) {
      while (_visibleLines[line].isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 26));
        setState(() {
          _visibleLines[line] = _visibleLines[line].substring(
            0,
            _visibleLines[line].length - 1,
          );
          _cursorLine = line;
        });
      }
    }
  }

  void _markBuildCompleted() {
    if (!_typingFinished) {
      setState(() {
        _typingFinished = true;
      });

      // 🔥 avisa al padre que el código está estable
      widget.onTypingFinished();
    }
  }

  @override
  void dispose() {
    _typingTimer.cancel();
    _blinkTimer.cancel();
    _editTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fontSize = size.width * 0.011;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.015 : 1.0)
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF00D9FF,
              ).withOpacity(_isHovered ? 0.45 : 0.25),
              blurRadius: _isHovered ? 35 : 20,
              spreadRadius: _isHovered ? 2 : 0,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Container(
          width: size.width * 0.52,
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.2),
                blurRadius: 45,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(_visibleLines.length, (i) {
                      final showCursor = i == _cursorLine && _showCursor;

                      return RichText(
                        text: TextSpan(
                          children: [
                            ...highlightDart(_visibleLines[i], fontSize),
                            if (showCursor)
                              TextSpan(
                                text: '|',
                                style: GoogleFonts.firaCode(
                                  fontSize: fontSize,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const _Dot(color: Color(0xFFFF5F56)),
        const SizedBox(width: 6),
        const _Dot(color: Color(0xFFFFBD2E)),
        const SizedBox(width: 6),
        const _Dot(color: Color(0xFF27C93F)),
        const SizedBox(width: 12),
        Text(
          'portfolio.dart',
          style: GoogleFonts.firaCode(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}

List<TextSpan> highlightDart(String text, double fontSize) {
  final base = GoogleFonts.firaCode(fontSize: fontSize, height: 1.55);

  final rules = <RegExp, Color>{
    RegExp(r'//.*'): Colors.white38,
    RegExp(r'\b(class|final|const|return|import|late)\b'): const Color(
      0xFF569CD6,
    ),
    RegExp(r'\b(String|int|double|Widget|BuildContext|Profile)\b'): const Color(
      0xFF4EC9B0,
    ),
    RegExp(r'"[^"]*"'): const Color(0xFF9CDCFE),
    RegExp(r'\b\d+\b'): const Color(0xFFDCDCAA),
    RegExp(r'\b[A-Z][a-zA-Z]+\b'): const Color(0xFF4EC9B0),
    RegExp(r'\b[a-zA-Z_]+(?=\()'): const Color(0xFFDCDCAA),
    RegExp(r'\b[a-zA-Z_]+(?=\:)'): const Color(0xFFD16D9E),
  };

  final spans = <TextSpan>[];
  int index = 0;

  while (index < text.length) {
    Match? match;
    Color? color;

    for (final rule in rules.entries) {
      final m = rule.key.matchAsPrefix(text.substring(index));
      if (m != null) {
        match = m;
        color = rule.value;
        break;
      }
    }

    if (match != null) {
      spans.add(
        TextSpan(
          text: match.group(0),
          style: base.copyWith(color: color),
        ),
      );
      index += match.group(0)!.length;
    } else {
      spans.add(
        TextSpan(
          text: text[index],
          style: base.copyWith(color: Colors.white70),
        ),
      );
      index++;
    }
  }

  return spans;
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _CodeScanPainter extends CustomPainter {
  final double progress;

  _CodeScanPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // ===== Glow ambiental (muy sutil) =====
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topRight,
        radius: 1.4,
        colors: [const Color(0xFF00D9FF).withOpacity(0.10), Colors.transparent],
      ).createShader(Offset.zero & size)
      ..blendMode = BlendMode.plus;

    canvas.drawRect(Offset.zero & size, bgPaint);

    // ===== Parámetros de código =====
    const lineHeight = 18.0;
    final totalLines = (size.height / lineHeight).floor();
    final activeLine = (progress * totalLines).clamp(0, totalLines - 1).toInt();

    // ===== Líneas pasivas =====
    final passivePaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;

    // ===== Línea activa =====
    final activePaint = Paint()
      ..color = const Color(0xFF00FFF0).withOpacity(0.7)
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    for (int i = 0; i < totalLines; i++) {
      final y = i * lineHeight + 14;

      canvas.drawLine(Offset(16, y), Offset(size.width - 16, y), passivePaint);

      if (i == activeLine) {
        canvas.drawLine(Offset(16, y), Offset(size.width - 16, y), activePaint);
      }
    }

    // ===== Cursor tipo IDE =====
    final cursorX = lerpDouble(40, size.width - 60, progress)!;
    final cursorY = activeLine * lineHeight + 8;

    final cursorPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(cursorX, cursorY),
      Offset(cursorX + 10, cursorY),
      cursorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CodeScanPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

//Carrusel Lenguajes
class InfiniteTechCarousel extends StatefulWidget {
  const InfiniteTechCarousel({Key? key}) : super(key: key);

  @override
  State<InfiniteTechCarousel> createState() => _InfiniteTechCarouselState();
}

class _InfiniteTechCarouselState extends State<InfiniteTechCarousel> {
  late ScrollController _scrollController;
  late Timer _timer;
  double _scrollPosition = 0;
  bool _isHoveringCarousel = false;

  // Lista de tecnologías con imágenes
  final List<String> _technologies = [
    'assets/arduinoIcon.svg',
    'assets/dartIcon.svg',
    'assets/firebaseIcon.svg',
    'assets/flutterIcon.svg',
    'assets/mysqlIcon.svg',
    'assets/pythonIcon.svg',
  ];

  late List<String> _visibleTechs;

  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _visibleTechs = [..._technologies, ..._technologies, ..._technologies];

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isHoveringCarousel) return;

      if (_scrollController.hasClients) {
        _scrollPosition += 1.5;

        final max = _scrollController.position.maxScrollExtent;

        if (_scrollPosition > max - 300) {
          setState(() {
            _visibleTechs.addAll(_technologies);
          });
        }

        _scrollController.jumpTo(_scrollPosition);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double w(double width) => width / 430 * screenWidth;

    return SizedBox(
      height: w(40),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: const [0.0, 0.1, 0.9, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.modulate,
        child: MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHoveringCarousel = true;
            });
          },
          onExit: (_) {
            setState(() {
              _isHoveringCarousel = false;
            });
          },
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _visibleTechs.length,
            itemBuilder: (context, index) {
              final isHovered = _hoveredIndex == index;

              return MouseRegion(
                cursor: SystemMouseCursors.none,
                onEnter: (_) {
                  setState(() => _hoveredIndex = index);
                },
                onExit: (_) {
                  setState(() => _hoveredIndex = null);
                },
                child: AnimatedScale(
                  scale: isHovered ? 1.5 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(15)), //20
                    child: SvgPicture.asset(
                      _visibleTechs[index],
                      width: w(15),
                      height: w(15),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Helper para selector de idioma con banderas
Widget _buildLanguageFlag({
  required String label,
  required String asset,
  required bool isActive,
  required VoidCallback onTap,
  required double Function(double) w,
  required double Function(double) h,
  required double Function(double) sp,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: w(4), vertical: h(2)),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF00D9FF).withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(asset, width: w(8), height: h(8), fit: BoxFit.cover),
          SizedBox(width: w(2)),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.poppins(
              fontSize: sp(4),
              fontWeight: FontWeight.bold,
              color: isActive
                  ? const Color(0xFF00D9FF)
                  : Colors.white.withOpacity(0.7),
            ),
            child: Text(label),
          ),
        ],
      ),
    ),
  );
}
