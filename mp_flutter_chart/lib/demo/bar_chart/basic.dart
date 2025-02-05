import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/bar_chart.dart';
import 'package:mp_chart/mp/controller/bar_chart_controller.dart';
import 'package:mp_chart/mp/core/color/gradient_color.dart';
import 'package:mp_chart/mp/core/common_interfaces.dart';
import 'package:mp_chart/mp/core/data/bar_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_bar_data_set.dart';
import 'package:mp_chart/mp/core/data_set/bar_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/bar_entry.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/legend_form.dart';
import 'package:mp_chart/mp/core/enums/legend_orientation.dart';
import 'package:mp_chart/mp/core/enums/legend_vertical_alignment.dart';
import 'package:mp_chart/mp/core/enums/x_axis_position.dart';
import 'package:mp_chart/mp/core/enums/y_axis_label_position.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/image_loader.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/value_formatter/day_axis_value_formatter.dart';
import 'package:mp_chart/mp/core/value_formatter/my_value_formatter.dart';
import 'package:mp_flutter_chart/demo/action_state.dart';
import 'package:mp_flutter_chart/demo/util.dart';

class BarChartBasic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BarChartBasicState();
  }
}

class BarChartBasicState extends BarActionState<BarChartBasic>
    implements OnChartValueSelectedListener {
  var random = Random(1);
  int _count = 12;
  double _range = 50.0;

  @override
  void initState() {
    _initController();
    _initBarData(_count, _range);
    super.initState();
  }

  @override
  Widget getBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          left: 0,
          top: 0,
          bottom: 100,
          child: BarChart(controller),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Slider(
                            value: _count.toDouble(),
                            min: 0,
                            max: 1500,
                            onChanged: (value) {
                              _count = value.toInt();
                              _initBarData(_count, _range);
                            })),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        "$_count",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorUtils.BLACK,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Slider(
                            value: _range,
                            min: 0,
                            max: 200,
                            onChanged: (value) {
                              _range = value;
                              _initBarData(_count, _range);
                            })),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        "${_range.toInt()}",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorUtils.BLACK,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  String getTitle() {
    return "Bar Chart Basic";
  }

  void _initController() {
    var desc = Description()..enabled = false;
    controller = BarChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..setLabelCount2(8, false)
            ..typeface = Util.LIGHT
            ..setValueFormatter(MyValueFormatter("\$"))
            ..position = YAxisLabelPosition.OUTSIDE_CHART
            ..spacePercentTop = 15
            ..setAxisMinimum(0);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight
            ..drawGridLines = false
            ..typeface = Util.LIGHT
            ..setLabelCount2(8, false)
            ..setValueFormatter(MyValueFormatter("\$"))
            ..spacePercentTop = 15
            ..setAxisMinimum(0);
        },
        legendSettingFunction: (legend, controller) {
          legend
            ..verticalAlignment = LegendVerticalAlignment.BOTTOM
            ..orientation = LegendOrientation.HORIZONTAL
            ..drawInside = false
            ..shape = LegendForm.SQUARE
            ..formSize = 9
            ..textSize = 11
            ..xEntrySpace = 4;
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis
            ..typeface = Util.LIGHT
            ..position = XAxisPosition.BOTTOM
            ..drawGridLines = false
            ..setGranularity(1.0)
            ..setLabelCount1(7)
            ..setValueFormatter(DayAxisValueFormatter(controller));
        },
        selectionListener: this,
        drawBarShadow: false,
        drawValueAboveBar: true,
        drawGridBackground: false,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        pinchZoomEnabled: false,
        maxVisibleCount: 60,
        description: desc);
  }

  void _initData(int count, double range, ui.Image img) {
    double start = 1;

    List<BarEntry> values = List();

    for (int i = start.toInt(); i < start + count; i++) {
      double val = (random.nextDouble() * (range + 1));

      values.add(BarEntry(x: i.toDouble(), y: val, icon: img));
    }

    BarDataSet set1;

    set1 = BarDataSet(values, "The year 2017");

    set1.setDrawIcons(false);

//            set1.setColors(ColorTemplate.MATERIAL_COLORS);

    /*int startColor = ContextCompat.getColor(this, android.R.color.holo_blue_dark);
            int endColor = ContextCompat.getColor(this, android.R.color.holo_blue_bright);
            set1.setGradientColor(startColor, endColor);*/

    Color startColor1 = ColorUtils.HOLO_ORANGE_LIGHT;
    Color startColor2 = ColorUtils.HOLO_BLUE_LIGHT;
    Color startColor3 = ColorUtils.HOLO_ORANGE_LIGHT;
    Color startColor4 = ColorUtils.HOLO_GREEN_LIGHT;
    Color startColor5 = ColorUtils.HOLO_RED_LIGHT;
    Color endColor1 = ColorUtils.HOLO_BLUE_DARK;
    Color endColor2 = ColorUtils.HOLO_PURPLE;
    Color endColor3 = ColorUtils.HOLO_GREEN_DARK;
    Color endColor4 = ColorUtils.HOLO_RED_DARK;
    Color endColor5 = ColorUtils.HOLO_ORANGE_DARK;

    List<GradientColor> gradientColors = List();
    gradientColors.add(GradientColor(startColor1, endColor1));
    gradientColors.add(GradientColor(startColor2, endColor2));
    gradientColors.add(GradientColor(startColor3, endColor3));
    gradientColors.add(GradientColor(startColor4, endColor4));
    gradientColors.add(GradientColor(startColor5, endColor5));

    set1.setGradientColors(gradientColors);

    List<IBarDataSet> dataSets = List();
    dataSets.add(set1);

    controller.data = BarData(dataSets);
    controller.data
      ..setValueTextSize(10)
      ..setValueTypeface(Util.LIGHT)
      ..barWidth = 0.9;
  }

  void _initBarData(int count, double range) async {
    var img = await ImageLoader.loadImage('assets/img/star.png');
    _initData(count, range, img);
    setState(() {});
  }

  @override
  void onNothingSelected() {}

  @override
  void onValueSelected(Entry e, Highlight h) {
//    if (e == null)
//      return;
//
//    RectF bounds = onValueSelectedRectF;
//    chart.getBarBounds((BarEntry) e, bounds);
//    MPPointF position = chart.getPosition(e, AxisDependency.LEFT);
//
//    Log.i("bounds", bounds.toString());
//    Log.i("position", position.toString());
//
//    Log.i("x-index",
//        "low: " + chart.getLowestVisibleX() + ", high: "
//            + chart.getHighestVisibleX());
//
//    MPPointF.recycleInstance(position);
  }
}
