import 'package:flutter/material.dart';

import 'genColor.dart';

class MenuNavbar {
  const MenuNavbar(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<MenuNavbar> allDestinations = <MenuNavbar>[
  MenuNavbar('Jadwal', Icons.home_outlined),
  MenuNavbar('Fasilitas', Icons.assignment),
  MenuNavbar('History', Icons.history),
  MenuNavbar('Reservasi', Icons.shopping_cart_outlined),
];