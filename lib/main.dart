import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ============================================================================
// CONSTANTES GLOBALES
// ============================================================================

const Color _bgGradient1 = Color(0xFF160027);
const Color _bgGradient2 = Color(0xFF090014);

const Color _primaryPurple = Color(0xFFB45BFF);
const Color _lightBlue = Color(0xFF6570C8);
const Color _statsBlue = Color(0xFF6178FF);
const Color _statsPink = Color(0xFFFF2D89);
const Color _statsGold = Color(0xFFFFB21B);
const Color _textPurple = Color(0xFF32134B);
const Color _glowPurple = Color(0xFF6D28D9);
const Color _glowPink = Color(0xFFFF2D95);
const Color _glowOrange = Color(0xFFFF6B1A);
const Color _counterOrange = Color(0xFFFF781A);
const Color _buttonDarkPurple = Color(0xFF54206E);
const Color _buttonDarkMagenta = Color(0xFF762643);
const Color _buttonGradientTop = Color(0xFF626CE8);
const Color _buttonGradientMid = Color(0xFFD5329D);
const Color _buttonGradientBot = Color(0xFFFF8C1B);
const Color _secondaryButtonText = Color(0xFFAD8D9F);
const Color _borderDark = Color(0xFF29114B);
const Color _borderDarker = Color(0xFF38175A);

const Map<int, Color> _historyColors = {
  0: Color(0xFF332D68),
  1: Color(0xFF403577),
  2: Color(0xFF57408A),
  3: Color(0xFFE83D83),
  4: Color(0xFFFFA817),
};

void main() => runApp(const CounterClicksApp());

class CounterClicksApp extends StatelessWidget {
  const CounterClicksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter Clicks',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080014),
        useMaterial3: true,
      ),
      home: const CounterPage(),
    );
  }
}

class ImageViewerPage extends StatelessWidget {
  const ImageViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transformationController = TransformationController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Volver a la aplicación',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out_map_rounded),
            tooltip: 'Restablecer zoom',
            onPressed: () => transformationController.value = Matrix4.identity(),
          ),
        ],
      ),
      body: InteractiveViewer(
        transformationController: transformationController,
        minScale: 0.5,
        maxScale: 4,
        child: Center(child: Image.asset('assets/gta.png.webp')),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage>
    with SingleTickerProviderStateMixin {
  int counter = 0, session = 0, best = 0;
  final List<int> history = [];
  late AnimationController _animationController;
  late Animation<double> _counterAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _counterAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.15), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.15, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateCounter(int delta) {
    HapticFeedback.lightImpact();
    setState(() {
      counter = (counter + delta).clamp(0, double.infinity).toInt();
      session++;
      if (counter > best) best = counter;
      history.add(counter);
      if (history.length > 5) history.removeAt(0);
    });
    _animationController.forward(from: 0);
  }

  void increase() => _updateCounter(1);
  void decrease() => _updateCounter(-1);

  void restart() {
    HapticFeedback.mediumImpact();
    setState(() {
      counter = 0;
      session = 0;
      history.clear();
    });
    _animationController.forward(from: 0);
  }

  Map<String, double> _getResponsiveSizes(BoxConstraints constraints) {
    final w = constraints.maxWidth, h = constraints.maxHeight;
    final vSmall = h < 600, small = h < 720, smallW = w < 360;
    return {
      'buttonHeight': (vSmall ? 115.0 : small ? 140.0 : h * 0.22).clamp(110.0, 205.0),
      'hPadding': smallW ? 14.0 : w < 420 ? 20.0 : w * 0.10,
      'buttonGap': smallW ? 10.0 : 14.0,
      'counterSize': smallW ? 78.0 : w < 420 ? 88.0 : 100.0,
      'counterFont': smallW ? 42.0 : w < 420 ? 50.0 : 58.0,
      'titleSpace': vSmall ? 10.0 : small ? 15.0 : 20.0,
      'preCounterSpace': vSmall ? 25.0 : small ? 40.0 : h * 0.07,
      'historySpace': vSmall ? 22.0 : small ? 30.0 : 48.0,
      'buttonSpace': vSmall ? 20.0 : small ? 28.0 : 45.0,
      'statsSpace': vSmall ? 25.0 : small ? 35.0 : 45.0,
      'msgSpace': vSmall ? 10.0 : 16.0,
      'restartSpace': vSmall ? 16.0 : small ? 22.0 : 30.0,
      'restartWidth': smallW ? w * 0.65 : w < 500 ? 215.0 : 240.0,
      'glow1Size': w < 400 ? 190.0 : 220.0,
      'glow2Size': w < 400 ? 210.0 : 240.0,
      'glow3Size': w < 400 ? 160.0 : 180.0,
      'imgWidth': w < 360 ? 85.0 : 110.0,
      'imgHeight': w < 360 ? 70.0 : 90.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final s = _getResponsiveSizes(constraints);
            final w = constraints.maxWidth, h = constraints.maxHeight;

            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_bgGradient1, _bgGradient2],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(top: h * 0.15, left: -80, child: _Glow(size: s['glow1Size']!, color: _glowPurple)),
                  Positioned(top: h * 0.40, right: -100, child: _Glow(size: s['glow2Size']!, color: _glowPink)),
                  Positioned(bottom: h * 0.10, left: w * 0.25, child: _Glow(size: s['glow3Size']!, color: _glowOrange)),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: SizedBox(
                      width: s['imgWidth'],
                      height: s['imgHeight'],
                      child: Image.asset('assets/gta.png.webp', fit: BoxFit.cover, alignment: Alignment.topRight),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: s['hPadding']!),
                        child: Column(
                          children: [
                            SizedBox(height: s['titleSpace']),
                            const Text('CLICK COUNTER', textAlign: TextAlign.center,
                              style: TextStyle(color: _primaryPurple, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 3)),
                            SizedBox(height: s['preCounterSpace']),
                            ScaleTransition(
                              scale: _counterAnimation,
                              child: Container(
                                width: s['counterSize'],
                                height: s['counterSize']! + 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFF7459F2), Color(0xFFE73591), Color(0xFFFF713A)],
                                  ),
                                  boxShadow: [BoxShadow(color: const Color(0xFFFF3F8F).withValues(alpha: 0.35), blurRadius: 35, spreadRadius: 5)],
                                ),
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text('$counter', style: TextStyle(color: _textPurple, fontSize: s['counterFont'], fontWeight: FontWeight.w900)),
                                ),
                              ),
                            ),
                            SizedBox(height: s['msgSpace']),
                            const Text('PRESS + TO START', textAlign: TextAlign.center,
                              style: TextStyle(color: _lightBlue, fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.7)),
                            SizedBox(height: s['historySpace']),
                            SizedBox(width: double.infinity, child: _History(history: history)),
                            SizedBox(height: s['buttonSpace']),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: _CounterButton(text: 'DECREASE', icon: Icons.remove_rounded, primary: false, enabled: counter > 0, height: s['buttonHeight']!, onPressed: decrease)),
                                SizedBox(width: s['buttonGap']),
                                Expanded(child: _CounterButton(text: 'INCREASE', icon: Icons.add_rounded, primary: true, enabled: true, height: s['buttonHeight']!, onPressed: increase)),
                              ],
                            ),
                            SizedBox(height: s['restartSpace']),
                            _RestartButton(onPressed: restart, width: s['restartWidth']!),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const ImageViewerPage(),
                                ),
                              ),
                              icon: const Icon(Icons.image_rounded),
                              label: const Text('ABRIR IMAGEN'),
                            ),
                            SizedBox(height: s['statsSpace']),
                            _Stats(session: session, best: best, counter: counter),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
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
}

// ============================================================================
// GLOW
// ============================================================================

class _Glow extends StatelessWidget {
  final double size;
  final Color color;

  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.05),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.18), blurRadius: 100, spreadRadius: 20)],
      ),
    ),
  );
}

// ============================================================================
// HISTORIAL
// ============================================================================

class _History extends StatelessWidget {
  final List<int> history;

  const _History({required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox(height: 20);
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = constraints.maxWidth < 330 ? 5.0 : 9.0;
        final fontSize = constraints.maxWidth < 330 ? 14.0 : 16.0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(history.length, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: Text('${history[index]}',
                  key: ValueKey('${history[index]}-$index'),
                  style: TextStyle(
                    color: _historyColors[index.clamp(0, _historyColors.length - 1)],
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ============================================================================
// BOTON INCREASE / DECREASE
// ============================================================================

class _CounterButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool primary;
  final bool enabled;
  final VoidCallback onPressed;
  final double height;

  const _CounterButton({required this.text, required this.icon, required this.primary, required this.enabled, required this.onPressed, required this.height});

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: enabled ? 1.0 : 0.35,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: primary
                ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [_buttonGradientTop, _buttonGradientMid, _buttonGradientBot])
                : const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [_buttonDarkPurple, _buttonDarkMagenta]),
            boxShadow: primary ? [BoxShadow(color: const Color(0xFFFF4190).withValues(alpha: 0.25), blurRadius: 30, spreadRadius: 2)] : null,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 130;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: compact ? (primary ? 38 : 30) : (primary ? 55 : 38)),
                  SizedBox(height: compact ? 8 : 18),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(text,
                      style: TextStyle(
                        color: primary ? Colors.white : _secondaryButtonText,
                        fontSize: compact ? 14 : 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

// ============================================================================
// RESTART
// ============================================================================

class _RestartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;

  const _RestartButton({required this.onPressed, required this.width});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: width,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: _counterOrange, width: 2),
          gradient: const LinearGradient(colors: [Color(0xFF2B1055), Color(0xFF18092F)]),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded, color: _counterOrange, size: 25),
            SizedBox(width: 10),
            Text('RESTART',
              style: TextStyle(color: _counterOrange, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
          ],
        ),
      ),
    ),
  );
}

// ============================================================================
// ESTADISTICAS
// ============================================================================

class _Stats extends StatelessWidget {
  final int session, best, counter;

  const _Stats({required this.session, required this.best, required this.counter});

  @override
  Widget build(BuildContext context) {
    final nextMilestone = ((counter ~/ 10) + 1) * 10;
    return Container(
      width: double.infinity,
      height: 112,
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: _borderDark, width: 1))),
      child: Row(
        children: [
          Expanded(child: _StatItem(title: 'SESSION', value: '$session', color: _statsBlue)),
          Container(width: 1, height: 62, color: _borderDarker),
          Expanded(child: _StatItem(title: 'BEST', value: '$best', color: _statsPink)),
          Container(width: 1, height: 62, color: _borderDarker),
          Expanded(child: _StatItem(title: 'MILESTONE', value: '$nextMilestone', suffix: 'to go', color: _statsGold)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title, value;
  final String? suffix;
  final Color color;

  const _StatItem({required this.title, required this.value, required this.color, this.suffix});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final narrow = constraints.maxWidth < 105;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(title,
              style: TextStyle(color: color.withValues(alpha: 0.75), fontSize: narrow ? 11 : 14, fontWeight: FontWeight.w500, letterSpacing: narrow ? 0.8 : 1.4)),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: value, style: TextStyle(color: color, fontSize: narrow ? 21 : 25, fontWeight: FontWeight.w500)),
                if (suffix != null) TextSpan(text: ' $suffix', style: TextStyle(color: color, fontSize: narrow ? 10 : 13)),
              ]),
            ),
          ),
        ],
      );
    },
  );
}
