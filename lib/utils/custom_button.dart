import 'package:flutter/material.dart';
import '../utils/styles.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData icon;
  final String? description;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
    this.description,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Transform.scale(
        scale: 1 - _controller.value,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.arsenalblack,
                AppColors.arsenalblack.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _isPressed
                    ? AppColors.arsenalblack.withOpacity(0.2)
                    : AppColors.arsenalblack.withOpacity(0.3),
                offset: _isPressed ? const Offset(0, 2) : const Offset(0, 5),
                blurRadius: _isPressed ? 4 : 8,
                spreadRadius: _isPressed ? 1 : 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 26.0,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyles.titlewhite.copyWith(fontSize: 18.0),
                        ),
                        if (widget.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.description!,
                            style: TextStyles.bodywhite.copyWith(
                              fontSize: 12.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}