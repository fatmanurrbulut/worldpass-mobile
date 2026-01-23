import 'package:flutter/material.dart';

class WpFormInput extends StatefulWidget {
  final String label;
  final String? hint; // Placeholder metni (örn: "adınız@site.com")
  final TextEditingController controller;
  final bool obscure; // Şifre mi?
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final IconData? prefixIcon; // Sol tarafa ikon (örn: email, kilit)
  final bool enabled;

  const WpFormInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  State<WpFormInput> createState() => _WpFormInputState();
}

class _WpFormInputState extends State<WpFormInput> {
  // Şifre görünürlüğünü içeride yönetelim
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Arka plan rengi: Light modda hafif gri, Dark modda hafif beyazımsı
    final fillColor = theme.brightness == Brightness.dark
        ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
        : colorScheme.surfaceContainerHighest.withOpacity(0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label'ı inputun içinde değil de üstünde sevenler için (Opsiyonel,
        // ama ben inputun içine gömmeyi tercih ettim aşağıda)
        
        TextFormField(
          controller: widget.controller,
          obscureText: _isObscured,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500, // Yazı biraz daha tok dursun
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            filled: true,
            fillColor: widget.enabled ? fillColor : fillColor.withOpacity(0.1),
            
            // Sol İkon (Prefix)
            prefixIcon: widget.prefixIcon != null 
                ? Icon(widget.prefixIcon, color: colorScheme.onSurfaceVariant) 
                : null,

            // Sağ İkon (Suffix) - Sadece şifre ise göster
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null, // Şifre değilse boş kalsın (veya çarpı butonu eklenebilir)

            // Kenarlık Ayarları
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), // WpButton ile uyumlu yuvarlaklık
              borderSide: BorderSide.none, // Normalde kenarlık yok, sadece dolgu
            ),
            
            // Odaklanınca çıkan kenarlık (Turkuaz parlar)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            
            // Hata durumunda çıkan kenarlık
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error.withOpacity(0.5), width: 1),
            ),

            focusedErrorBorder: OutlineInputBorder(
               borderRadius: BorderRadius.circular(16),
               borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            
            // İç boşlukları ferahlat
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            
            // Label stili
            labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            floatingLabelStyle: TextStyle(color: colorScheme.primary), // Odaklanınca label rengi
          ),
        ),
      ],
    );
  }
}