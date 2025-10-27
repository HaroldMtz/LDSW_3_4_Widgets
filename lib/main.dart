import 'package:flutter/material.dart';

void main() => runApp(const WidgetsDemoApp());

class WidgetsDemoApp extends StatelessWidget {
  const WidgetsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LDSW 3.4 - Widgets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C2BD9)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int counter = 0;

  
  final Set<String> selected = {};

  
  bool showBadge = true;
  final _dur = const Duration(milliseconds: 350);

  
  double radius = 16;

  void _toast(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(milliseconds: 900)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LDSW 3.4 - Widgets')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => counter++),
        icon: const Icon(Icons.add),
        label: Text('Contador: $counter'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SectionTitle('1) Text'),
              const CardBox(
                child: Text(
                  'Hola, Flutter 👋\nEste Text convive con interacciones abajo.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3),
                ),
              ),

              
              const SectionTitle('2) Row (acciones rápidas)'),
              CardBox(
                child: Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Toques rápidos'),
                    Row(children: [
                      IconButton(
                        onPressed: () => _toast(context, '❤️ Me gusta'),
                        icon: const Icon(Icons.favorite),
                        tooltip: 'Me gusta',
                      ),
                      IconButton(
                        onPressed: () => _toast(context, '🔗 Compartir'),
                        icon: const Icon(Icons.share),
                        tooltip: 'Compartir',
                      ),
                      IconButton(
                        onPressed: () => setState(() => showBadge = !showBadge),
                        icon: const Icon(Icons.visibility),
                        tooltip: 'Mostrar/ocultar badge en Stack',
                      ),
                    ]),
                  ],
                ),
              ),

              
              const SectionTitle('3) Column (selección de elementos)'),
              CardBox(
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final item in const ['Elemento 1', 'Elemento 2', 'Elemento 3'])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            selected.contains(item) ? selected.remove(item) : selected.add(item);
                          }),
                          child: Pill(
                            text: item,
                            selected: selected.contains(item),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              
              const SectionTitle('4) Stack (tócalo para animar)'),
              CardBox(
                child: SizedBox(
                  height: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => showBadge = !showBadge),
                        child: Stack( 
                          children: [
                            
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple.shade200,
                                    Colors.deepPurple.shade400,
                                  ],
                                ),
                              ),
                            ),

                            
                            const Center(
                              child: Text(
                                'Toca aquí: aparece/desaparece el badge ↑',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            
                            AnimatedOpacity(
                              opacity: showBadge ? 1 : 0,
                              duration: _dur,
                              child: const _Bubbles(),
                            ),

                            
                            AnimatedPositioned(
                              duration: _dur,
                              curve: Curves.easeOut,
                              right: showBadge ? 16 : -80,
                              top: 16,
                              child: AnimatedOpacity(
                                opacity: showBadge ? 1 : 0,
                                duration: _dur,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(999),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.18),
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Nuevo',
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              
              const SectionTitle('5) Container (estilo dinámico)'),
              CardBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container( 
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(radius),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 6),
                            color: Colors.black.withOpacity(0.05),
                          ),
                        ],
                      ),
                      child: Text(
                        'Desliza para cambiar el radio: ${radius.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Slider(
                      value: radius,
                      min: 8,
                      max: 40,
                      onChanged: (v) => setState(() => radius = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  final Widget child;
  const CardBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300.withOpacity(0.6)),
      ),
      child: child,
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final bool selected;
  const Pill({super.key, required this.text, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: selected ? cs.primary : cs.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: selected ? cs.onPrimary : cs.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Bubbles extends StatelessWidget {
  const _Bubbles();

  @override
  Widget build(BuildContext context) {
    Widget bubble(double size, Alignment align) => Align(
          alignment: align,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.22),
              shape: BoxShape.circle,
            ),
          ),
        );

    return Stack(children: [
      bubble(28, const Alignment(-0.9, 0.8)),  
      bubble(18, const Alignment(0.85, -0.7)), 
      bubble(14, const Alignment(0.4, 0.6)),   
    ]);
  }
}
