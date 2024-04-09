import 'dart:async';
import 'package:flutter/material.dart';

class ImageCycleWidget extends StatefulWidget {
  final List<String> imageUrls;
  final Duration interval;
  final bool autoplay;
  final Function(int)? onImageChanged;
  final double? imageWidth;
  final double? imageHeight;

  ImageCycleWidget({
    required this.imageUrls,
    required this.interval,
    this.autoplay = true,
    this.onImageChanged,
    this.imageWidth,
    this.imageHeight,
  });

  @override
  _ImageCycleWidgetState createState() => _ImageCycleWidgetState();
}

class _ImageCycleWidgetState extends State<ImageCycleWidget> {
  late int _currentImageIndex;
  late Timer _timer;
  late bool _isAutoplaying;

  @override
  void initState() {
    super.initState();
    _currentImageIndex = 0;
    _isAutoplaying = widget.autoplay;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                widget.imageUrls[_currentImageIndex],
                width: widget.imageWidth,
                height: widget.imageHeight,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (index) => GestureDetector(
                    onTap: () {
                      _jumpToImage(index);
                      _pauseAutoplay();
                    },
                    child: Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentImageIndex ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _previousImage();
                _pauseAutoplay();
              },
              icon: Icon(Icons.skip_previous),
            ),
            IconButton(
              onPressed: _toggleAutoplay,
              icon: Icon(_isAutoplaying ? Icons.pause : Icons.play_arrow),
            ),
            IconButton(
              onPressed: () {
                _nextImage();
                _pauseAutoplay();
              },
              icon: Icon(Icons.skip_next),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (widget.autoplay) {
      _timer = Timer.periodic(widget.interval, (timer) {
        if (_isAutoplaying) {
          _nextImage();
        }
      });
    }
  }

  void _pauseAutoplay() {
    setState(() {
      _isAutoplaying = false;
    });
  }

  void _toggleAutoplay() {
    setState(() {
      _isAutoplaying = !_isAutoplaying;
    });
  }

  void _nextImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % widget.imageUrls.length;
    });
    widget.onImageChanged?.call(_currentImageIndex);
  }

  void _previousImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex - 1) % widget.imageUrls.length;
    });
    widget.onImageChanged?.call(_currentImageIndex);
  }

  void _jumpToImage(int index) {
    setState(() {
      _currentImageIndex = index;
    });
    widget.onImageChanged?.call(_currentImageIndex);
  }
}
