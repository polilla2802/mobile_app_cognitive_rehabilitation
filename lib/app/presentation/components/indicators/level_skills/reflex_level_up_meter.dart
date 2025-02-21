import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

import 'package:mobile_app_cognitive_rehabilitation/app/providers/providers.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/presentation/components/common/common_widgets.dart';
import 'package:mobile_app_cognitive_rehabilitation/app/providers/skills/skill_manager.dart'
    as Skill;

class ReflexLevelUpMeter extends StatefulWidget {
  final int raise;
  const ReflexLevelUpMeter({super.key, this.raise = 1});

  @override
  State<ReflexLevelUpMeter> createState() => _ReflexLevelUpMeterState(raise);
}

class _ReflexLevelUpMeterState extends State<ReflexLevelUpMeter>
    with TickerProviderStateMixin {
  static const String _key = "reflex_level_up_meter";

  late AnimationController _controller;
  late int _raise;

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  );

  double _opacity = 0;

  late User? _user;

  late int? _userReflex;
  late Skill.SkillManager? _skillManager;

  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  _ReflexLevelUpMeterState(int raise) {
    _raise = raise;
    _userReflex = null;
    _skillManager = Skill.SkillManager();
    _user = FirebaseAuth.instance.currentUser!;
  }

  @override
  void initState() {
    print('$_key invoked');
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _afterBuild());
  }

  Future<void> _afterBuild() async {
    await _fetchReflex();
    await Future.delayed(const Duration(milliseconds: 100), () async {
      _animate();
    });
    await Future.delayed(const Duration(milliseconds: 300), () async {
      tooltipkey.currentState?.ensureTooltipVisible();
    });
    await Future.delayed(const Duration(seconds: 1), () async {
      tooltipkey.currentState?.deactivate();
    });
  }

  Future<void> _fetchReflex() async {
    print("fetchReflex [USER ID]: ${_user!.uid}");
    _userReflex = await _skillManager!.getReflex(_user!.uid);
    print("userReflex $_userReflex");
    if (_userReflex != null) {
      Provider.of<GameProvider>(context, listen: false).setMyReflex =
          _userReflex!;
    }
  }

  void _animate() {
    if (mounted) {
      _controller.forward();
      setState(() {
        _opacity = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [toolTip(animation: _animation), reflexLevelUpMeter()],
    ));
  }

  Widget reflexLevelUpMeter() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 16),
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Reflex: ",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                                child: AnimatedFlipCounter(
                              textStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: Duration(milliseconds: 1500),
                              value: Provider.of<GameProvider>(context).reflex,
                            )),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "1000",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Container(
                child: SfLinearGauge(
                    minimum: 0,
                    maximum: 1000,
                    animationDuration: 3000,
                    animateAxis: true,
                    animateRange: true,
                    minorTicksPerInterval: 0,
                    useRangeColorForAxis: true,
                    maximumLabels: 4,
                    showLabels: false,
                    tickPosition: LinearElementPosition.cross,
                    labelPosition: LinearLabelPosition.outside,
                    axisTrackStyle: LinearAxisTrackStyle(thickness: 10),
                    markerPointers: null,
                    ranges: [
                      LinearGaugeRange(
                          rangeShapeType: LinearRangeShapeType.curve,
                          edgeStyle: LinearEdgeStyle.bothCurve,
                          endValue: Provider.of<GameProvider>(context)
                              .reflex
                              .toDouble(),
                          color: ConstValues.myGreenColor,
                          position: LinearElementPosition.cross)
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget toolTip({Animation<double>? animation}) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      curve: Curves.fastLinearToSlowEaseIn,
      opacity: _opacity,
      child: Tooltip(
        key: tooltipkey,
        textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 2),
        verticalOffset: -65,
        showDuration: Duration(seconds: 1),
        decoration: BoxDecoration(
            color: ConstValues.myGreenColor,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        triggerMode: TooltipTriggerMode.tap,
        message: "+ $_raise",
        child: RotationTransition(
          turns: animation!,
          child: ScaleTransition(
            scale: animation,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Image.asset(
                "assets/images/icons/skills/reflex.png",
                width: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() async {
    print('$_key Dispose invoked');
    _controller.dispose();
    super.dispose();
  }
}
