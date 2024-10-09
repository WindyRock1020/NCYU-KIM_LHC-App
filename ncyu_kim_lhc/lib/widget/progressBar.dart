import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final num current;
  final num max;
  final double barSize;
  final double textSize;
  final String? labelText;

  const ProgressBar({super.key, 
    required this.current,
    this.max = 20.0,
    this.barSize = 30,
    this.textSize = 25,
    this.labelText,
  });

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.current / widget.max;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.current / widget.max,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current != widget.current) {
      _previousValue = _animation.value;
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.current / widget.max,
      ).animate(_controller)
        ..addListener(() {
          setState(() {});
        });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LinearProgressIndicator(
                  backgroundColor: const Color(0xffd9d9d9),
                  valueColor: const AlwaysStoppedAnimation(Color(0xff7392ff)),
                  value: _animation.value,
                  minHeight: widget.barSize,
                ),
              ),
              if (widget.labelText != null)
                Center(
                  child: Text(
                    widget.labelText!,
                    style: TextStyle(
                      fontSize: widget.textSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}