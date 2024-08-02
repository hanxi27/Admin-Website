import 'package:flutter/material.dart';
import 'region.dart' as myRegion; // Import the region.dart file with a prefix

class MapPage extends StatefulWidget {
  final String coordinates;
  MapPage({required this.coordinates});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String selectedCategory = '';
  double redDotX = 2.0; // Default x-coordinate
  double redDotY = 2.0; // Default y-coordinate

  @override
  void initState() {
    super.initState();
    _parseCoordinates();
  }

  void _parseCoordinates() {
    if (widget.coordinates.isNotEmpty) {
      List<String> coords = widget.coordinates.replaceAll('(', '').replaceAll(')', '').split(', ');
      if (coords.length == 2) {
        setState(() {
          redDotX = double.parse(coords[0]);
          redDotY = 1 - (double.parse(coords[1]));
        });
      }
    }
  }

  void _onRegionTap(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Define the aspect ratio of the floorplan image
                    final aspectRatio = 1.5; // Width / Height (1.5 / 1.0)

                    // Calculate the dimensions of the floorplan
                    final floorplanWidth = constraints.maxWidth * 0.8; // Adjusted for web layout
                    final floorplanHeight = floorplanWidth / aspectRatio;

                    // Calculate the size of the selectable regions
                    final dotSize = 10.0; // Size of the selectable regions

                    // Map the coordinates to the new coordinate system
                    double mapCoordinate(double value, double minValue, double maxValue, double minPixel, double maxPixel) {
                      return (value - minValue) / (maxValue - minValue) * (maxPixel - minPixel) + minPixel;
                    }

                    return FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: floorplanWidth,
                        height: floorplanHeight,
                        child: InteractiveViewer(
                          constrained: true,
                          minScale: 0.3,
                          maxScale: 1.0,
                          child: GestureDetector(
                            onTapDown: (details) {
                              // Get the tap position relative to the widget
                              final RenderBox box = context.findRenderObject() as RenderBox;
                              final localOffset = box.globalToLocal(details.globalPosition);
                              final tapX = localOffset.dx;
                              final tapY = localOffset.dy;

                              // Map the tap coordinates to the original coordinate system
                              final mappedX = (tapX / floorplanWidth) * 1.7 - 0.1;
                              final mappedY = (tapY / floorplanHeight) * 1.2;

                              print('Tap position: $mappedX, $mappedY');

                              // Determine which region was tapped
                              for (myRegion.SelectableRegion region in myRegion.getSelectableRegions(floorplanWidth, floorplanHeight, mapCoordinate, dotSize, _onRegionTap)) {
                                final regionLeft = region.left;
                                final regionTop = region.top;
                                final regionRight = regionLeft + region.width;
                                final regionBottom = regionTop + region.height;

                                if (tapX >= regionLeft && tapX <= regionRight &&
                                    tapY >= regionTop && tapY <= regionBottom) {
                                  region.onTap();
                                  break;
                                }
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/map/floorplan.jpg',
                                  fit: BoxFit.cover,
                                  width: floorplanWidth,
                                  height: floorplanHeight,
                                ),
                                ...myRegion.getSelectableRegions(floorplanWidth, floorplanHeight, mapCoordinate, dotSize, _onRegionTap).map((region) {
                                  return Positioned(
                                    left: region.left,
                                    top: region.top,
                                    child: GestureDetector(
                                      onTap: region.onTap,
                                      child: Container(
                                        width: region.width,
                                        height: region.height,
                                        color: region.color,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                // Add the red dot
                                Positioned(
                                  left: mapCoordinate(redDotX, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                                  top: mapCoordinate(redDotY, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                                  child: Container(
                                    width: dotSize,
                                    height: dotSize,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Selected Category: $selectedCategory', // Display the selected category
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
