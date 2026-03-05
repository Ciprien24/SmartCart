import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cart/features/preferences/preferences_screen.dart';

class CartsScreen extends StatelessWidget {
  const CartsScreen({super.key});

  static const Color _pageBackground = Color(0xFFF4F5F9);
  static const Color _headerBlue = Color(0xFF1800AD);
  static const Color _accentOrange = Color(0xFFFF751F);
  static const Color _textDark = Color(0xFF141414);

  static const List<({String name, String asset})> _stores = [
    (name: 'Kaufland', asset: 'lib/app/assets/kaufland.png'),
    (name: 'Lidl', asset: 'lib/app/assets/lidl.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: _pageBackground,
      body: DefaultTextStyle.merge(
        style: const TextStyle(fontWeight: FontWeight.w900),
        child: Stack(
          children: [
            Container(color: _pageBackground),
            _buildHeader(context, topInset),
            Positioned(
              top: 110 + topInset,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Supermarkets',
                        style: TextStyle(
                          color: _textDark,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _SupermarketCard(
                        name: _stores[0].name,
                        assetPath: _stores[0].asset,
                      ),
                      const SizedBox(height: 18),
                      _SupermarketCard(
                        name: _stores[1].name,
                        assetPath: _stores[1].asset,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20 + MediaQuery.of(context).padding.bottom,
              child: Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: _accentOrange,
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PreferencesScreen(),
                        ),
                      );
                    },
                    child: Center(
                      child: Image.asset(
                        'lib/app/assets/Button_logo.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
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

  Widget _buildHeader(BuildContext context, double topInset) {
    return Container(
      height: 150 + topInset,
      padding: EdgeInsets.fromLTRB(24, topInset + 2, 24, 0),
      decoration: const BoxDecoration(color: _headerBlue),
      child: Align(
        alignment: const Alignment(0, -0.45),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                'lib/app/assets/logo_smart_cart.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'SmartCart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupermarketCard extends StatelessWidget {
  final String name;
  final String assetPath;

  const _SupermarketCard({required this.name, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                CupertinoIcons.shopping_cart,
                size: 18,
                color: CartsScreen._textDark,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: CartsScreen._textDark,
              ),
            ),
          ),
          const Icon(
            CupertinoIcons.chevron_right,
            color: CartsScreen._accentOrange,
            size: 22,
          ),
        ],
      ),
    );
  }
}
