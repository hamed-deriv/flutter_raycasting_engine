import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

import '../data.dart';

Future<Map<String, BitmapTexture>> loadTextures() async {
  final Map<String, BitmapTexture> textures = <String, BitmapTexture>{};

  textures['unknown'] = await getBitmapTexture('assets/unknown.bmp');
  textures['grass'] = await getBitmapTexture('assets/grass.bmp');
  textures['brick'] = await getBitmapTexture('assets/brick.bmp');
  textures['stone'] = await getBitmapTexture('assets/stone.bmp');
  textures['door'] = await getBitmapTexture('assets/door.bmp');
  textures['portal'] = await getBitmapTexture('assets/portal.bmp');
  textures['wall_with_leaves'] =
      await getBitmapTexture('assets/wall_with_leaves.bmp');

  return textures;
}

Future<BitmapTexture> getBitmapTexture(String bitmapAsset) async {
  final ByteData data = await rootBundle.load(bitmapAsset);
  final Uint8List bytes = data.buffer.asUint8List();

  final image.Image result = image.decodeBmp(bytes)!;

  final List<List<Color>> colorArray = <List<Color>>[];

  for (int y = 0; y < result.height; y++) {
    colorArray.add(<Color>[]);
    for (int x = 0; x < result.width; x++) {
      final image.Pixel pixel = result.getPixel(x, y);

      final Color color = Color.fromARGB(
        pixel.a.toInt(),
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
      );

      colorArray[y].add(color);
    }
  }

  return BitmapTexture(colorArray);
}
