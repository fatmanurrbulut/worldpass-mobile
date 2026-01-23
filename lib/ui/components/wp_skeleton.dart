import 'package:flutter/material.dart';


/// Tüm Skeleton parçalarının ortak animasyonunu yöneten widget
class WpSkeletonScope extends StatefulWidget {
  final Widget child;
  const WpSkeletonScope({super.key, required this.child});

  @override
  State<WpSkeletonScope> createState() => _WpSkeletonScopeState();
}

class _WpSkeletonScopeState extends State<WpSkeletonScope> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // "Nefes alma" efekti için ileri-geri (reverse) animasyon
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Altındaki tüm skeleton parçalarına bu controller'ı dağıtıyoruz
    return _SkeletonControllerProvider(
      controller: _controller,
      child: widget.child,
    );
  }
}

// Controller'ı aşağı taşımak için InheritedWidget (Performans için)
class _SkeletonControllerProvider extends InheritedWidget {
  final AnimationController controller;
  const _SkeletonControllerProvider({required this.controller, required super.child});

  static AnimationController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_SkeletonControllerProvider>()!.controller;
  }

  @override
  bool updateShouldNotify(_SkeletonControllerProvider oldWidget) => false;
}

// -----------------------------------------------------------------------------

/// Tekil İskelet Kutusu (Kendi kendine anime olur)
class WpSkeletonBox extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;
  final BoxShape shape;

  const WpSkeletonBox({
    super.key,
    required this.height,
    this.width,
    this.borderRadius = 12, // AppRadii.md
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    // Eğer bir Scope içindeyse oradan al, yoksa statik durmasın diye fallback yapabilirdik
    // ama genelde Scope içinde kullanılır.
    AnimationController controller;
    try {
      controller = _SkeletonControllerProvider.of(context);
    } catch (e) {
      // Eğer kullanıcı Scope koymayı unuttuysa hata vermesin, kendi controller'ını üretsin
      // (Basitlik adına burayı şimdilik scope zorunlu gibi düşünelim veya statik render edelim)
      return _buildContainer(context, 0.5); 
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Opaklık 0.3 ile 1.0 arasında gidip gelir
        final opacity = 0.3 + (controller.value * 0.7);
        return _buildContainer(context, opacity);
      },
    );
  }

  Widget _buildContainer(BuildContext context, double opacity) {
    final theme = Theme.of(context);
    // Base renk: Container rengi
    // Highlight için opacity kullanıyoruz
    final baseColor = theme.colorScheme.surfaceContainerHighest;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: baseColor.withOpacity(opacity * 0.6), // Renk yoğunluğunu ayarla
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// -----------------------------------------------------------------------------

/// Akıllı Liste İskeleti
class WpSkeletonList extends StatelessWidget {
  final int count;
  
  // "Simple" mod: Sadece kutu gösterir
  // "Tile" modu (Varsayılan): Avatar + 2 satır yazı gösterir (Daha gerçekçi)
  final bool simple; 

  const WpSkeletonList({
    super.key,
    this.count = 6,
    this.simple = false,
  });

  @override
  Widget build(BuildContext context) {
    // Animasyonu başlatan Scope
    return WpSkeletonScope(
      child: ListView.separated(
        padding: const EdgeInsets.all(16), // AppSpacing.lg
        itemCount: count,
        physics: const NeverScrollableScrollPhysics(), // Loading sırasında kaydırma olmasın
        shrinkWrap: true,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, __) => simple ? _buildSimpleItem() : _buildTileItem(),
      ),
    );
  }

  // Basit Kutu Modu (Kartlar için)
  Widget _buildSimpleItem() {
    return const WpSkeletonBox(height: 120, width: double.infinity);
  }

  // Detaylı Liste Modu (WhatsApp/Rehber tarzı satırlar için)
  Widget _buildTileItem() {
    return Row(
      children: [
        // Avatar Yuvarlağı
        const WpSkeletonBox(height: 48, width: 48, shape: BoxShape.circle),
        const SizedBox(width: 16),
        // Yazı Satırları
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık Satırı (Uzun)
              const WpSkeletonBox(height: 14, width: 140),
              const SizedBox(height: 8),
              // Alt Başlık Satırı (Kısa)
              const WpSkeletonBox(height: 12, width: 80),
            ],
          ),
        ),
      ],
    );
  }
}