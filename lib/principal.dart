// ignore_for_file: deprecated_member_use, unused_import, use_key_in_widget_constructors, unused_element, no_leading_underscores_for_local_identifiers, curly_braces_in_flow_control_structures, unused_field

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //Hovered Global
  bool isHoveredGlobal = false;

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
    // Paso 1: Escribir código (2.5s)
    await _loadingCodeController.forward();

    // Paso 2: Pequeño delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Paso 3: Efecto glitch rápido
    for (int i = 0; i < 3; i++) {
      await _loadingGlitchController.forward();
      await _loadingGlitchController.reverse();
    }

    // Paso 4: Fade out del código
    _loadingFadeController.forward();

    // Paso 5: Mostrar portfolio con escala
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
    "Full Stack Developer",
    "Flutter Developer",
    "UI Lover",
    "App Builder",
  ];

  int _currentRole = 0;
  int _visibleChars = 0;

  late Timer _typeTimer;
  late Timer _cursorTimer;

  bool _showCursor = true;
  bool _isDeleting = false;

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

    _startTyping();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      setState(() => _showCursor = !_showCursor);
    });
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
    super.dispose();
  }

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

            // Icono de sonido
            MouseRegion(
              onEnter: (event) {
                if (mounted) {
                  setState(() {
                    _isHoveringSoundButton = true;
                    isHoveredGlobal = true;
                  });
                }
              },
              onExit: (event) {
                if (mounted) {
                  setState(() {
                    _isHoveringSoundButton = false;
                    isHoveredGlobal = false;
                  });
                }
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMute = !_isMute;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: w(18),
                  height: h(23),
                  decoration: BoxDecoration(
                    color: _isHoveringSoundButton
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isHoveringSoundButton
                          ? const Color(0xFF00D9FF).withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                      width: _isHoveringSoundButton ? 1.5 : 1,
                    ),
                    boxShadow: _isHoveringSoundButton
                        ? [
                            BoxShadow(
                              color: const Color(0xFF00D9FF).withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    _isMute ? Icons.volume_off : Icons.volume_up,
                    color: const Color(0xFF00D9FF),
                    size: sp(7),
                  ),
                ),
              ),
            ),

            SizedBox(width: w(10)),

            // Botón Contact Me
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
                child: AnimatedScale(
                  scale: _isHoveringContactButton ? 1.03 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: w(10),
                      vertical: h(7),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isHoveringContactButton
                            ? [
                                const Color(0xFF00D9FF),
                                Colors.lightBlue,
                                const Color(0xFF00D9FF),
                              ]
                            : [Colors.lightBlue, const Color(0xFF00D9FF)],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.lightBlue.withOpacity(
                            _isHoveringContactButton ? 0.8 : 0.5,
                          ),
                          blurRadius: _isHoveringContactButton ? 25 : 15,
                          spreadRadius: _isHoveringContactButton ? 3 : 0,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ShimmerHoverEffect(
                      isHovered: _isHoveringContactButton,
                      primaryColor: Colors.white,
                      secondaryColor: const Color(0xFF00FFF0),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: GoogleFonts.poppins(
                          fontSize: sp(5),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: _isHoveringContactButton ? 1.2 : 0,
                        ),
                        child: const Text('Contactame'),
                      ),
                    ),
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hola 👋, yo soy",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: sp(10),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            "Nahuel Cappa",
                                            style: GoogleFonts.poppins(
                                              color: Color(0xFF00D9FF),
                                              fontSize: sp(17),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          SizedBox(height: h(3)),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            children: [
                                              Text(
                                                _roles[_currentRole].substring(
                                                  0,
                                                  _visibleChars,
                                                ),
                                                style: GoogleFonts.firaCode(
                                                  color: Colors.white
                                                      .withOpacity(0.88),
                                                  fontSize: sp(8),
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              AnimatedOpacity(
                                                opacity: _showCursor ? 1 : 0,
                                                duration: const Duration(
                                                  milliseconds: 150,
                                                ),
                                                child: Text(
                                                  "|",
                                                  style: GoogleFonts.firaCode(
                                                    color: Colors.white
                                                        .withOpacity(0.88),
                                                    fontSize: sp(8),
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      Spacer(),

                                      //Bloque Codigo
                                      const AnimatedCodeEditor(),
                                    ],
                                  ),
                                ),
                              ],
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
                                          : const Color(0xFF00D9FF),
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
  const AnimatedCodeEditor({super.key});

  @override
  State<AnimatedCodeEditor> createState() => _AnimatedCodeEditorState();
}

class _AnimatedCodeEditorState extends State<AnimatedCodeEditor> {
  late List<String> _fullLines;
  late List<String> _visibleLines;

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

    _typingTimer = Timer.periodic(const Duration(milliseconds: 26), _typeStep);

    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _showCursor = !_showCursor);
    });
  }

  void _typeStep(Timer timer) {
    if (_line >= _fullLines.length) {
      timer.cancel();
      _typingFinished = true;
      _startEdits();
      return;
    }

    final current = _fullLines[_line];

    setState(() {
      _char++;
      _visibleLines[_line] = current.substring(
        0,
        _char.clamp(0, current.length),
      );

      if (_char >= current.length) {
        _line++;
        _char = 0;
      }
    });
  }

  void _startEdits() {
    _editTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_editCount >= 4) {
        _resetAndRewrite();
        return;
      }
      _animateEdit();
      _editCount++;
    });
  }

  void _animateEdit() async {
    final editable = _fullLines.asMap().entries.where((e) {
      return e.value.contains('"') && !e.value.contains('Nahuel Cappa');
    }).toList();

    if (editable.isEmpty) return;

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
      await Future.delayed(const Duration(milliseconds: 18));
      setState(() {
        _visibleLines[lineIndex] = oldLine.substring(0, i);
      });
    }

    // escribir
    for (int i = 0; i < replacement.length; i++) {
      await Future.delayed(const Duration(milliseconds: 22));
      setState(() {
        _visibleLines[lineIndex] += replacement[i];
      });
    }

    _fullLines[lineIndex] = oldLine.replaceRange(start, end, replacement);
  }

  void _resetAndRewrite() async {
    _editTimer?.cancel();
    _editCount = 0;

    await _eraseAllProgressively();

    setState(() {
      _line = 0;
      _char = 0;
      _typingFinished = false;
    });

    _typingTimer = Timer.periodic(const Duration(milliseconds: 26), _typeStep);
  }

  Future<void> _eraseAllProgressively() async {
    for (int line = _visibleLines.length - 1; line >= 0; line--) {
      while (_visibleLines[line].isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 14));
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

    return Container(
      width: size.width * 0.52,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.cyanAccent.withOpacity(0.2), blurRadius: 45),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_visibleLines.length, (i) {
                  final showCursor =
                      _typingFinished && i == _cursorLine && _showCursor;

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

// ================= DOT =================
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
