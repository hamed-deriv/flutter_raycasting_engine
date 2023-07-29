import 'package:flutter/material.dart';

import 'data.dart';
import 'calculation_helpers.dart';
import 'drawing_helpers.dart';

class RayCastingPainter extends CustomPainter {
  RayCastingPainter({
    required this.playerPosition,
    required this.playerRotation,
  }) {
    Player.position = playerPosition;
    Player.angle = playerRotation;
  }

  final Offset playerPosition;
  final double playerRotation;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(Screen.scale, Screen.scale);

    final List<Offset> rays = calculateRaycasts(
      playerPosition: Player.position,
      playerAngle: Player.angle,
      fov: Player.fov,
      precision: RayCasting.precision,
      width: Projection.width,
      map: MapInfo.data,
    );

    for (int rayCount = 0; rayCount < rays.length; rayCount++) {
      const double halfFov = Player.fov / 2;
      const double increment = Player.fov / Projection.width;

      final double distance = getDistance(playerPosition, rays[rayCount]);
      final double rayAngle = Player.angle - halfFov + (rayCount * increment);
      final double correctedDistance =
          distance * cosDegrees(rayAngle - Player.angle);
      final double wallHeight =
          (Projection.halfHeight / correctedDistance).floorToDouble();

      drawSky(canvas, rayCount, wallHeight);
      drawWalls(canvas, rayCount, wallHeight, correctedDistance);
      drawGround(canvas, rayCount, wallHeight);
    }

    drawMiniMap(canvas);
    drawRays(canvas, rays);
    drawPlayer(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
