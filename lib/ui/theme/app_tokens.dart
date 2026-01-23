class AppSpacing {
  // 4px - Çok sıkışık öğeler arası (örn: metin ile minik ikon)
  static const xs = 4.0; 
  
  // 8px - Standart küçük boşluk (örn: buton içi ikon-yazı arası)
  static const sm = 8.0; 
  
  // 12px - Orta boşluk (örn: liste elemanları arası)
  static const md = 12.0; 
  
  // 16px - Standart Kenar Boşluğu (Padding) - EN ÇOK KULLANILAN
  static const lg = 16.0; 
  
  // 24px - Bölümler arası boşluk (Rahatlatıcı boşluk)
  static const xl = 24.0; 
  
  // 32px - Büyük bloklar arası veya sayfa başı boşluğu
  static const xxl = 32.0; 
  
  // 48px - Devasa boşluk (Bölüm sonları)
  static const xxxl = 48.0;
}

class AppRadii {
  // 8px - Küçük iç elemanlar, checkboxlar
  static const sm = 8.0; 
  
  // 12px - Standart kartlar, inputlar
  static const md = 12.0; 
  
  // 16px - Modern, yumuşak kartlar ve butonlar (WpButton ve WpCard standardı)
  static const lg = 16.0; 
  
  // 24px - BottomSheet'ler veya büyük diyaloglar
  static const xl = 24.0; 
  
  // 999px - Tam yuvarlak (Pill shape) butonlar için
  static const full = 999.0;
}

// Yeni Ek: Animasyon Süreleri (Tutarlılık için çok önemli)
class AppDurations {
  static const fast = Duration(milliseconds: 200);   // Tıklama efektleri
  static const medium = Duration(milliseconds: 350); // Sayfa geçişleri, açılır menüler
  static const slow = Duration(milliseconds: 500);   // Büyük yükleme geçişleri
}