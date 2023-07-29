import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';
import 'helpers/calculation_helpers.dart';
import 'helpers/texture_helpers.dart';
import 'ray_casting_painter.dart';

Map<String, BitmapTexture> textures = <String, BitmapTexture>{};

void main() => runApp(const MainApp());

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: FutureBuilder<void>(
            future: _loadTextures(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: _handleKeyPress,
                child: ClipRect(
                  child: SizedBox(
                    width: Screen.width,
                    height: Screen.height,
                    child: Stack(
                      children: <Widget>[
                        CustomPaint(
                          size: const Size(Screen.width, Screen.height),
                          painter: RayCastingPainter(
                            playerPosition: Player.position,
                            playerRotation: Player.angle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        rotateLeft();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        rotateRight();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        moveUp();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        moveDown();
      }
    }
  }

  void moveUp() {
    Player.position += Offset(
      cosDegrees(Player.angle) * Player.speed,
      sinDegrees(Player.angle) * Player.speed,
    );

    if (_isInsideWall()) {
      Player.position -= Offset(
        cosDegrees(Player.angle) * Player.speed,
        sinDegrees(Player.angle) * Player.speed,
      );
    }

    setState(() {});
  }

  void moveDown() {
    Player.position -= Offset(
      cosDegrees(Player.angle) * Player.speed,
      sinDegrees(Player.angle) * Player.speed,
    );

    if (_isInsideWall()) {
      Player.position += Offset(
        cosDegrees(Player.angle) * Player.speed,
        sinDegrees(Player.angle) * Player.speed,
      );
    }

    setState(() {});
  }

  void rotateLeft() {
    Player.angle -= Player.rotationSpeed;

    setState(() {});
  }

  void rotateRight() {
    Player.angle += Player.rotationSpeed;

    setState(() {});
  }

  bool _isInsideWall() =>
      MapInfo.data[Player.position.dy.floor()][Player.position.dx.floor()] > 0;

  Future<void> _loadTextures() async {
    if (textures.isNotEmpty) {
      return;
    }

    textures['brick'] = await getBitmapTexture('assets/brick.bmp');
    textures['stone'] = await getBitmapTexture('assets/stone.bmp');
  }
}
