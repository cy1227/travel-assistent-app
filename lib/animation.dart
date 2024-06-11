import 'package:flutter/material.dart';

class AnimationScreen extends StatelessWidget {
  const AnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimationMove(),
        AnimationSwing(),
      ],
    );
  }
}

class AnimationMove extends StatefulWidget {
  @override
  _AnimationMoveState createState() => _AnimationMoveState();
}

class _AnimationMoveState extends State<AnimationMove>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset(1, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Image.asset(
        'assets/airplane.PNG',
        width: 200,
        height: 200,
      ),
    );
  }
}

class AnimationSwing extends StatefulWidget {
  @override
  _AnimationSwingState createState() => _AnimationSwingState();
}

class _AnimationSwingState extends State<AnimationSwing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -0.5, // 左右搖擺的角度（弧度），-0.1 和 0.1 分別表示 -5.7° 和 5.7°
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value,
            child: child,
          );
        },
        child: Image.asset(
          'assets/airplane2.PNG',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
