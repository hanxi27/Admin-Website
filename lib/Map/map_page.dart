// lib/Map/map_page.dart
import 'package:flutter/material.dart';
import 'region.dart' as myRegion; // Import the region.dart file with a prefix

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String selectedCategory = '';

  void _onRegionTap(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Define the aspect ratio of the floorplan image
                      final aspectRatio = 1.5 / 1.0; // Width / Height

                      // Calculate the dimensions of the floorplan
                      final floorplanWidth = constraints.maxWidth * 1.0;
                      final floorplanHeight = floorplanWidth / aspectRatio;

                      // Calculate the size of the selectable regions
                      final dotSize = 10.0; // Size of the selectable regions

                      // Map the coordinates to the new coordinate system
                      double mapCoordinate(double value, double minValue, double maxValue, double minPixel, double maxPixel) {
                        return (value - minValue) / (maxValue - minValue) * (maxPixel - minPixel) + minPixel;
                      }

                      return InteractiveViewer(
                        constrained: true,
                        minScale: 0.5,
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
                              Container(
                                width: floorplanWidth,
                                height: floorplanHeight,
                                child: Image.asset(
                                  'assets/map/floorplan.jpg',
                                  fit: BoxFit.cover,
                                ),
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
                            ],
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
        ],
      ),
    );
  }
}
