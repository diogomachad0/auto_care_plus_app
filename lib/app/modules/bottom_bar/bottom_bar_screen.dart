import 'package:auto_care_plus_app/app/shared/mixin/theme_mixin.dart';
import 'package:auto_care_plus_app/app/shared/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomBarScreen extends StatefulWidget {
  final bool disableNavigationMenu;

  const BottomBarScreen({super.key, required this.disableNavigationMenu});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> with ThemeMixin {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.disableNavigationMenu) {
        selectedIndex = 2;
        Modular.to.navigate('./$homeRoute');
      } else {
        Modular.to.navigate('./$menuRoute');
      }
    });
  }

  void _onTap(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        Modular.to.navigate('../$menuRoute');
        break;
      case 1:
        Modular.to.navigate('../$homeRoute');
        break;
      case 2:
        Modular.to.navigate('../$atividadeRoute');
        break;
      case 3:
        Modular.to.navigate('../$timeLineRoute');
        break;
      case 4:
        Modular.to.navigate('../$mapaRoute');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: const RouterOutlet(),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Modular.to.navigate('../$atividadeRoute');
          },
          backgroundColor: colorScheme.primary,
          elevation: 8,
          child: Icon(
            Icons.add_rounded,
            color: colorScheme.onPrimary,
            size: 40,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconStyle: IconStyle.Default,
          padding: const EdgeInsets.all(6),
        ),
        hasNotch: true,
        backgroundColor: colorScheme.primary,
        currentIndex: selectedIndex,
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 36,
            ),
            title: Text(
              'Menu',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            selectedIcon: Icon(
              Icons.menu_rounded,
              color: colorScheme.secondary,
              size: 36,
            ),
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 36,
              ),
              title: Text(
                'Início',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              selectedIcon: Icon(
                Icons.home_rounded,
                color: colorScheme.secondary,
                size: 36,
              )),
          BottomBarItem(
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            title: Text(
              '',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.timeline_rounded,
                color: Colors.white,
                size: 36,
              ),
              title: Text(
                'Atividade',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              selectedIcon: Icon(
                Icons.timeline_rounded,
                color: colorScheme.secondary,
                size: 36,
              )),
          BottomBarItem(
            icon: const Icon(
              Icons.location_on_sharp,
              color: Colors.white,
              size: 36,
            ),
            title: Text(
              'Mapa',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            selectedIcon: Icon(
              Icons.location_on_sharp,
              color: colorScheme.secondary,
              size: 32,
            ),
          ),
        ],
        onTap: _onTap,
      ),
    );
  }
}
