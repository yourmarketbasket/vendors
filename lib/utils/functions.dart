
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nisoko_vendors/screens/login.dart';
import 'package:nisoko_vendors/utils/colors.dart';
import 'package:nisoko_vendors/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'dart:io';

import 'package:webview_windows/webview_windows.dart';

Future<List<String>> uploadFilesAndUpdateUrls(List<File> files, Function(double) onProgress) async {
  final storage = FirebaseStorage.instance;
  final storageRef = storage.ref();
  final directory = storageRef.child("products/");

  // List to store download URLs
  List<String> urls = [];

  try {
    // Upload files concurrently
    await Future.forEach(files, (File file) async {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageToUpload = directory.child("product_${fileName}.jpg");

      // Upload file to Firebase Storage
      UploadTask task = imageToUpload.putFile(File(file.path));

      // Wait for the upload to complete
      await task;

      // Get the download URL of the uploaded file
      String downloadUrl = await imageToUpload.getDownloadURL();

      // Add the download URL to the list of URLs
      urls.add(downloadUrl);

      // Report progress
      double progress = (urls.length / files.length) * 100;
      onProgress(progress);
    });

    return urls;
  } catch (error) {
    // Handle any errors that occur during the upload process
    print('Error uploading files: $error');
    return [];
  }
}

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

void showOrderDeliveryMapDialog(BuildContext context, String mapUrl) async {
  final webviewController = WebviewController();
  await webviewController.initialize();
  await webviewController.setBackgroundColor(Colors.transparent);
  webviewController.loadUrl(mapUrl);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Comprehensive Delivery Route")
          ],
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Webview(
            webviewController,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

String generateGoogleMapsUrl(List<dynamic> origins, List<dynamic> destinations) {
  // Convert origins to a string
  String originString = origins
      .map((origin) => '${origin['latitude']},${origin['longitude']}')
      .join('|');

  // Convert destinations to a string
  String destinationString = destinations
      .map((destination) => '${destination['latitude']},${destination['longitude']}')
      .join('|');

  // Construct the URL
  String url = 'https://www.google.com/maps/dir/?api=1&origin=${origins.first['latitude']},${origins.first['longitude']}&destination=${destinations.last['latitude']},${destinations.last['longitude']}&waypoints=$originString|$destinationString&travelmode=driving&maptype=satellite&t=k&hl=en';

  return url;
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
  double totalSellingPrice = 0;
  List<Map<String, dynamic>> bestPerformingProducts = [];

  // Calculate total profit and cost price
  for (var productData in productsData) {
    if (productData is Map<String, dynamic>) {
      double costPrice = productData['bp'].toDouble()*productData['quantity'].toDouble();
      double sellingPrice = productData['sp'].toDouble()*productData['quantity'].toDouble();
      double profit = sellingPrice - costPrice;
      totalProfit += profit;
      totalCostPrice += costPrice;
      totalSellingPrice+=sellingPrice;
      bestPerformingProducts.add({
        'name': productData['name'],
        'profitPercentage': double.parse(((profit / costPrice) * 100).toStringAsFixed(1)),
      });
    }
  }

  // Calculate profit percentage
  double profitPercentage = double.parse((((totalSellingPrice-totalCostPrice) / totalCostPrice) * 100).toStringAsFixed(1));

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
String calculateTimeDifference(String postDateString) {
  final postDate = DateTime.parse(postDateString);
  final now = DateTime.now();
  final difference = now.difference(postDate);
  
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'second' : 'seconds'} ago';
  } else if (difference.inMinutes < 60) {
    final seconds = difference.inSeconds % 60;
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ${seconds} ${seconds == 1 ? 'second' : 'seconds'} ago';
  } else if (difference.inHours < 24) {
    final minutes = difference.inMinutes % 60;
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ${minutes} ${minutes == 1 ? 'minute' : 'minutes'} ago';
  } else if (difference.inDays < 7) {
    final hours = difference.inHours % 24;
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ${hours} ${hours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inDays < 30) {
    final days = difference.inDays % 7;
    return '${difference.inDays ~/ 7} ${difference.inDays ~/ 7 == 1 ? 'week' : 'weeks'} ${days} ${days == 1 ? 'day' : 'days'} ago';
  } else if (difference.inDays < 365) {
    final months = difference.inDays % 30;
    return '${difference.inDays ~/ 30} ${difference.inDays ~/ 30 == 1 ? 'month' : 'months'} ${months} ${months == 1 ? 'day' : 'days'} ago';
  } else {
    final years = difference.inDays % 365;
    return '${difference.inDays ~/ 365} ${difference.inDays ~/ 365 == 1 ? 'year' : 'years'} ${years} ${years == 1 ? 'day' : 'days'} ago';
  }
}

Map<String, double> calculateTotalSalesAndInvestment(List<dynamic> orders) {
  double totalSales = 0;
  double totalInvestment = 0;
  double totalProfit = 0;

  // Iterate through each order
  for (var order in orders) {
    // Check if the paymentStatus is "Completed"
    if (order['paymentStatus'] == "Completed") {
      // Access the 'products' object within the order
      var product = order['products'];

      // Access the 'bp' (buying price) and 'quantity' fields within the product
      double buyingPrice = product['bp'].toDouble();
      double quantity = product['quantity'].toDouble();

      // Calculate the total investment for this product (bp * quantity) and add it to the total investment
      totalInvestment += buyingPrice * quantity;
      totalSales += product['price'] * quantity;

    }
  }

      totalProfit += totalSales - totalInvestment;
  // Calculate profit percentage
  double profitPercentage = (totalProfit / totalInvestment) * 100;
  final data = {
    'totalSales': totalSales,
    'totalInvestment': totalInvestment,
    'profit': totalProfit,
    'profitPercentage': profitPercentage,
  };
  // Return the total sales, total investment, profit, and profit percentage as a map
  return data;
}

void showFeedback(BuildContext context, String message, bool success) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Message'),
        content: Row(
          children: <Widget>[
            success
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.error, color: Colors.red),
            SizedBox(width: 10),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
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

