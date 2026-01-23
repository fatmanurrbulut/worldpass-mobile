import 'package:flutter/material.dart';

class WpInput extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscure;
  final IconData? icon; // Sol tarafa ikon desteği
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged; // Anlık değişimleri yakalamak için

  const WpInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.icon,
    this.keyboardType,
    this.onChanged,
  });

  @override
  State<WpInput> createState() => _WpInputState();
}

class _WpInputState extends State<WpInput> {
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
    
    // Light/Dark mod uyumlu dolgu rengi
    final fillColor = theme.brightness == Brightness.dark
        ? colorScheme.surfaceContainerHighest.withOpacity(0.5)
        : colorScheme.surfaceContainerHighest.withOpacity(0.3);

    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: colorScheme.primary, // İmleç rengi tema rengi olsun
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        filled: true,
        fillColor: fillColor,
        
        // Sol İkon (Opsiyonel)
        prefixIcon: widget.icon != null 
            ? Icon(widget.icon, color: colorScheme.onSurfaceVariant) 
            : null,

        // Sağ İkon (Sadece şifre ise görünür)
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
            : null,

        // Kenarlıklar (FormInput ile aynı stilde)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
      ),
    );
  }
}