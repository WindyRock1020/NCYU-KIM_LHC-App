import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionSlider extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onSelected;
  final double sliderWidth;
  final double sliderHeight;
  final double valueWidth;
  final double valueHeight;
  final double valueFontSize;
  final IconData preIcon;
  final IconData nextIcon;

  const OptionSlider({
    Key? key,
    required this.options,
    required this.onSelected,
    this.sliderWidth = 240,
    this.sliderHeight = 90,
    this.valueWidth = 350,
    this.valueHeight = 90,
    this.valueFontSize = 25,
    this.preIcon = CupertinoIcons.chevron_left_circle,
    this.nextIcon = CupertinoIcons.chevron_right_circle,
  }) : super(key: key);

  @override
  _OptionSliderState createState() => _OptionSliderState();
}

class _OptionSliderState extends State<OptionSlider> {
  double _selectedIndex = 0;
  double value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xff7392ff),
            inactiveTrackColor: const Color(0xffd9d9d9),
            trackHeight: 20.0,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbColor: const Color(0xff7392ff),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
            overlayColor: Colors.black,
            tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 5.0),
            activeTickMarkColor: Colors.transparent,
            inactiveTickMarkColor: Colors.transparent,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: const Color(0xff7392ff),
            valueIndicatorTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: widget.valueFontSize,
            ),
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: widget.valueWidth,
                height: widget.valueHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff7392ff),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  widget.options[_selectedIndex.toInt()],
                  style: TextStyle(
                      fontSize: widget.valueFontSize, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      if(_selectedIndex != 0){
                        _selectedIndex -= 1;
                      }else{
                        _selectedIndex = 0;
                      }
                      widget.onSelected(widget.options[_selectedIndex.toInt()]);
                      },
                    icon: Icon(widget.preIcon),
                    iconSize: widget.sliderHeight/3,
                  ),
                  Container(
                    width: widget.sliderWidth,
                    height: widget.sliderHeight,
                    child: Slider(
                      value: _selectedIndex,
                      min: 0,
                      max: widget.options.length - 1,
                      divisions: widget.options.length - 1,
                      onChanged: (value) {
                        setState(() {
                          _selectedIndex = value;
                          widget.onSelected(widget.options[_selectedIndex.toInt()]);
                        });
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        if(_selectedIndex != widget.options.length - 1){
                          _selectedIndex += 1;
                        }else{
                          _selectedIndex = widget.options.length - 1;
                        }
                        widget.onSelected(widget.options[_selectedIndex.toInt()]);
                      },
                      icon: Icon(widget.nextIcon),
                      iconSize: widget.sliderHeight/3
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}