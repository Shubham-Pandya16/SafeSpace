import 'package:flutter/material.dart';

class AppColors {
  // ===== Dark Neutral Base (Primary backgrounds - calm, dark, easy on eyes) =====
  static const Color brown = Color(
    0xFF010b2f,
  ); // dark charcoal-blue (darkest background)
  static const Color mediumBrown = Color(
    0xFF152C5E,
  ); // slightly lighter surface
  static const Color lightBrown = Color(0xFF242A38); // card/container level
  static const Color lightestBrowm = Color(
    0xFF2E3444,
  ); // subtle elevation level

  // ===== Neutral Text & Utility =====
  static const Color darkGrey = Color(
    0xFF0A0D12,
  ); // near-black for deepest surfaces
  static const Color lightGrey =
      Colors.white70; // muted off-white for secondary text
  static const Color textPrimary = Color(0xFFE8EAED); // off-white primary text
  static const Color textSecondary = Color(
    0xFF88909A,
  ); // muted grey-blue secondary

  // ===== Subtle Accent Colors (Ocean Palette - use sparingly in small UI elements only)
  static const Color accentTeal = Color(
    0xFF47c8e5,
  ); // soft teal for icons, highlights
  static const Color accentBlue = Color(0xFF44A5C2); // subtle blue for emphasis
  static const Color accentCyan = Color(
    0xFF5FD3E8,
  ); // light cyan for hover/focus states

  // ===== Semantic Colors =====
  static const Color success = Color(0xFF6DD3B3);
  static const Color warning = Color(0xFFF2C94C);
  static const Color error = Color(0xFFEF6C6C);

  // ===== Borders & Dividers (low-opacity neutral) =====
  static const Color borderLight = Color(0xFF3A4150);
  static const Color dividerColor = Color(0xFF2D3340);

  // Legacy name compatibility (maps to accentTeal for old "green" usage)
  static const Color green = accentTeal;
}
