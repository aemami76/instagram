import 'package:flutter/material.dart';

class LikeAnim extends StatefulWidget {
  const LikeAnim(
      {required this.child,
      this.duration = const Duration(milliseconds: 150),
      this.onEnd,
      required this.isAnimating,
      this.smallLike = false,
      super.key});

  final Widget child;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool isAnimating;
  final bool smallLike;

  @override
  State<LikeAnim> createState() => _LikeAnimState();
}

class _LikeAnimState extends State<LikeAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  void startAnim() async {
    if (widget.isAnimating || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnim oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != widget.isAnimating) {
      startAnim();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
