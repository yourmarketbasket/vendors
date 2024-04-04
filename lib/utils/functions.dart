
import 'package:flutter/material.dart';
import 'package:nisoko_vendors/screens/login.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';

import 'dart:math';

logout(BuildContext context) async {
            // Delete user ID from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("userid");
  

  // Navigate to login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
 
}

String formatNumber(num number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}b';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}m';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}k';
  } else {
    return number.toString();
  }
}

Map<String, dynamic> calculateProductStatistics(List<dynamic> productsData) {
  double totalProfit = 0;
  double totalCostPrice = 0;
  List<Map<String, dynamic>> bestPerformingProducts = [];

  // Calculate total profit and cost price
  for (var productData in productsData) {
    if (productData is Map<String, dynamic>) {
      double costPrice = productData['bp'].toDouble();
      double sellingPrice = productData['sp'].toDouble();
      double profit = sellingPrice - costPrice;
      totalProfit += profit;
      totalCostPrice += costPrice;
      bestPerformingProducts.add({
        'name': productData['name'],
        'profitPercentage': double.parse(((profit / costPrice) * 100).toStringAsFixed(1)),
      });
    }
  }

  // Calculate profit percentage
  double profitPercentage = double.parse(((totalProfit / totalCostPrice) * 100).toStringAsFixed(1));

  // Calculate total investment
  double totalInvestment = totalCostPrice;

  // Sort products by profit percentage
  bestPerformingProducts.sort((a, b) => b['profitPercentage'].compareTo(a['profitPercentage']));

  return {
    'totalProfit': totalProfit,
    'profitPercentage': profitPercentage,
    'totalInvestment': totalInvestment,
    'bestPerformingProducts': bestPerformingProducts,
  };
}


Widget buildBestPerformingProductsChart(List<Map<String, dynamic>> bestPerformingProducts, double height, double width) {
  int touchedIndex = -1;

  List<BarChartGroupData> showingGroups() => List.generate(bestPerformingProducts.length, (i) {
    double profitPercentage = bestPerformingProducts[i]['profitPercentage'] as double;
    return BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
          borderRadius: BorderRadius.circular(20),
          fromY: 0,
          toY: profitPercentage,
          color: AppTheme.mainColor,
          width: 25,
        ),
      ],
    );
  });
  return AspectRatio(
    aspectRatio: 1,
    child: Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[            
              Expanded(
                child: BarChart(                  
                  BarChartData(
                    groupsSpace: 5,
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta){
                            return Text(value.toStringAsFixed(0), style: TextStyle(color: Colors.white, fontSize: 9), );

                          }
                        )
                      ),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            return Text(
                                bestPerformingProducts[index]['name'].toString(),
                                style: TextStyle(
                                  color: Colors.white, // Change color as needed
                                  fontSize: 9, // Adjust font size as needed
                                ),
                              );// Return an empty SizedBox if no title is available
                          },
                        ),
                      ),
                    ),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String productName = bestPerformingProducts[group.x]['name'] as String;
                          return BarTooltipItem(
                            '${rod.toY.toStringAsFixed(1)}%',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                      touchCallback: (FlTouchEvent event, barTouchResponse) {
                        if (!event.isInterestedForInteractions ||
                            barTouchResponse == null ||
                            barTouchResponse.spot == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                      },
                    ),
                    
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: const Color(0xff37434d)),
                    ),
                    barGroups: showingGroups(),
                  ),
                  swapAnimationDuration: Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
 
  
}



