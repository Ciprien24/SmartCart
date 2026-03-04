import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cart/features/preferences/preferences_screen.dart';

class CartsScreen extends StatelessWidget {
  const CartsScreen({super.key});

  static const Color _background = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF0B1220);
  static const Color _textSecondary = Color(0xFF8B93A1);
  static const Color _divider = Color(0xFFE9EDF3);
  static const Color _card = Color(0xFFF8F9FB);

  static const List<({String name, int count, String asset})> _stores = [
    (name: 'Kaufland', count: 3, asset: 'lib/app/assets/Kaufland_Logo.webp'),
    (name: 'Lidl', count: 4, asset: 'lib/app/assets/Lidl_Logo.webp'),
    (name: 'Carrefour', count: 1, asset: 'lib/app/assets/Carrefour_Logo.jpeg'),
    (name: 'Mega Image', count: 1, asset: 'lib/app/assets/Mega_Logo.png.avif'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(
                            CupertinoIcons.back,
                            size: 30,
                            color: _textPrimary,
                          ),
                        ),
                        const Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.cart,
                                size: 28,
                                color: _textPrimary,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'SmartCart',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.2,
                                  color: _textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Carts',
                      style: TextStyle(
                        fontSize: 52 / 2,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Supermarkets',
                      style: TextStyle(
                        fontSize: 22 / 2 * 2,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6D7380),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: _divider),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < _stores.length; i++) ...[
                            _StoreRow(
                              name: _stores[i].name,
                              count: _stores[i].count,
                              assetPath: _stores[i].asset,
                            ),
                            if (i < _stores.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: _divider,
                              ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Container(
                height: 64,
                margin: const EdgeInsets.only(bottom: 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: _divider),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x120B1220),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PreferencesScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.add, size: 30, color: _textPrimary),
                        SizedBox(width: 8),
                        Text(
                          'New Cart',
                          style: TextStyle(
                            fontSize: 40 / 2,
                            fontWeight: FontWeight.w500,
                            color: _textPrimary,
                          ),
                        ),
                      ],
                    ),
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

class _StoreRow extends StatelessWidget {
  final String name;
  final int count;
  final String assetPath;

  const _StoreRow({
    required this.name,
    required this.count,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Row(
        children: [
          const SizedBox(width: 18),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(
                CupertinoIcons.shopping_cart,
                color: Color(0xFF8B93A1),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 21 / 1,
                fontWeight: FontWeight.w500,
                color: CartsScreen._textPrimary,
              ),
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 38 / 2,
              fontWeight: FontWeight.w500,
              color: CartsScreen._textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            CupertinoIcons.chevron_right,
            size: 22,
            color: CartsScreen._textSecondary,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
