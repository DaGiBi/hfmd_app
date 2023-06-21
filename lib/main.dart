import 'package:flutter/material.dart';
import 'package:hfmd_app/screens/landing_screen.dart';
import 'package:hfmd_app/screens/login_screen.dart';
import 'package:hfmd_app/screens/register_screen.dart';
import 'package:hfmd_app/screens/bottom_bar.dart';
import 'package:hfmd_app/screens/home_screen.dart';
import 'package:hfmd_app/screens/upload_screen.dart';
import 'package:hfmd_app/screens/list_screen.dart';
import 'package:hfmd_app/screens/profile_screen.dart';
import 'package:hfmd_app/screens/analytic_screen.dart';
import 'package:hfmd_app/screens/map_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Recognition App',
      theme: FlexThemeData.light(
        scheme: FlexScheme.materialBaseline,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 1,
        subThemesData: const FlexSubThemesData(
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          defaultRadius: 12.0,
          elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
          elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          toggleButtonsBorderSchemeColor: SchemeColor.primary,
          segmentedButtonSchemeColor: SchemeColor.primary,
          segmentedButtonBorderSchemeColor: SchemeColor.primary,
          unselectedToggleIsColored: true,
          sliderValueTinted: true,
          inputDecoratorSchemeColor: SchemeColor.primary,
          inputDecoratorBackgroundAlpha: 31,
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorFocusedBorderWidth: 1.0,
          inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
          fabUseShape: true,
          fabAlwaysCircular: true,
          fabSchemeColor: SchemeColor.tertiary,
          popupMenuRadius: 8.0,
          popupMenuElevation: 3.0,
          drawerIndicatorRadius: 12.0,
          drawerIndicatorSchemeColor: SchemeColor.primary,
          bottomNavigationBarMutedUnselectedLabel: false,
          bottomNavigationBarMutedUnselectedIcon: false,
          menuRadius: 8.0,
          menuElevation: 3.0,
          menuBarRadius: 0.0,
          menuBarElevation: 2.0,
          menuBarShadowColor: Color(0x00000000),
          navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
          navigationBarMutedUnselectedLabel: false,
          navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationBarMutedUnselectedIcon: false,
          navigationBarIndicatorSchemeColor: SchemeColor.primary,
          navigationBarIndicatorOpacity: 1.00,
          navigationBarIndicatorRadius: 12.0,
          navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
          navigationRailMutedUnselectedLabel: false,
          navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
          navigationRailMutedUnselectedIcon: false,
          navigationRailIndicatorSchemeColor: SchemeColor.primary,
          navigationRailIndicatorOpacity: 1.00,
          navigationRailIndicatorRadius: 12.0,
          navigationRailBackgroundSchemeColor: SchemeColor.surface,
        ),
      // Use dark or light theme based on system setting.
        
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
          keepPrimary: true,
        ),
        tones: FlexTones.jolly(Brightness.light),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      themeMode: ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/bottomBar': (context) => BottomBar(),
        '/home': (context) => HomeScreen(),
        '/upload': (context) => UploadScreen(),
        '/list': (context) => ListScreen(),
        '/profile': (context) => ProfileScreen(),
        '/analytic': (context) => AnalyticScreen(),
        '/map': (context) => MapScreen(),
      },
    );
  }
}
