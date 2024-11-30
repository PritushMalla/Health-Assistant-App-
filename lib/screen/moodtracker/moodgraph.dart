import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/mood_tracking_database/database_helper_sec.dart';

DatabaseHelper_Mood mooddbhelper = DatabaseHelper_Mood();

class MoodGraph extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> graphDataFuture;

  MoodGraph(this.graphDataFuture);

  @override
  Widget build(BuildContext context) {
    
    return Padding(


      padding: const EdgeInsets.all(40.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: graphDataFuture,
        builder: (context, snapshot) {
          print("snap shot is $snapshot");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No mood data available.'));
          } else {

               List<Map<String, dynamic>> sortedData = List.from(snapshot.data!);
            sortedData.sort((a, b) {
              // Assuming 'date' is in the format 'yyyy-MM-dd'
              DateTime dateA = DateTime.parse(a['date']);
              DateTime dateB = DateTime.parse(b['date']);
              return dateA.compareTo(dateB); // Sort in ascending order
            });

            // Prepare data points for the chart
            List<FlSpot> spots = [];
            List<String> dates = [];
            List<int> moodtitlescore=[];
            // for(var moodtitle in snapshot.data!){
            //   moodtitles.add(moodtitle['moodtitle']?? 'Unknown title');
            //
            // }
              Map<String, List<int>> scoresByDate = {};


            for (var moodData in sortedData) {
           // Handle null mood title
              moodtitlescore.add(moodData['score']??'Unknown Score ');


              for (var score in moodtitlescore){
                  String? date = moodData['date'];
                int? score = moodData['score'];
          if (date != null && score != null && score >= 0) {
                if (!scoresByDate.containsKey(date)) {
                  scoresByDate[date] = [];
                }

                // Add the score for the given date
                scoresByDate[date]!.add(score);
              }
            }
            }

            // Prepare data points for the chart
          
            // Calculate the average mood score for each date and create a spot for each day
            scoresByDate.forEach((date, scores) {
              double averageScore = scores.reduce((a, b) => a + b) / scores.length; // Calculate average score
              spots.add(FlSpot(spots.length.toDouble(), averageScore)); // Add a spot for this day
              dates.add(date); // Store the date for tooltip purposes
            });
            // Debugging: Print the spots and dates
            print("Data Points: $spots");
            print("Dates: $dates");

            // Check if there are any spots to display
            if (spots.isEmpty) {
              return Center(child: Text('No valid mood data to display.'));
            }

            return LineChart(
              LineChartData(
                gridData: FlGridData(show: false), // Disable grid lines for a cleaner look
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40, // Space for left titles
                      getTitlesWidget: (value, meta) {
                       // Only display unique values
                        switch (value.toInt()) {
                          case 0:
                            return Text('0', style: TextStyle(color: Colors.black));
                          case 1:
                            return Text('1', style: TextStyle(color: Colors.black));
                          case 2:
                            return Text('2', style: TextStyle(color: Colors.black));
                          case 3:
                            return Text('3', style: TextStyle(color: Colors.black));
                          case 4:
                            return Text('4', style: TextStyle(color: Colors.black));
                          case 5:
                            return Text('5', style: TextStyle(color: Colors.black));
                          default:
                            return Container(); // No label for other values
                        }
                      },
                      interval: 1
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40, // Space for bottom titles
                        getTitlesWidget: (value, meta) {
                          // Display unique Y-axis values at intervals
                          if (value % 1 == 0) { // Adjust the interval (show whole numbers only)
                            return Text(
                              value.toInt().toString(), // Show integer values
                              style: TextStyle(color: Colors.black),
                            );
                          }
                          return Container(); // Hide duplicate or fractional values
                        },
                      interval: 1
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide top titles
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), // Hide right titles
                ),
                borderData: FlBorderData(show: true), // Show borders around the chart
                minX: 0,
                maxX: (spots.length - 1).toDouble(), // Adjust according to number of data points
                minY: 0,
                maxY: 5, // Adjust based on your score range
                lineBarsData: [
                  LineChartBarData(
                    spots: spots, // Your FlSpot data points
                    isCurved: true,
                     // Color of the line
                    belowBarData: BarAreaData(show: false), // Disable area below the line
                 //   dotData: FlDotData(show: true), // Show dots at data points
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true, // Enable touch interaction
                  touchTooltipData: LineTouchTooltipData(
                    //tooltipBgColor: Colors.blueAccent, // Background color of the tooltip
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final index = touchedSpot.spotIndex;
                        final date = dates[index]; // Get the corresponding date from the index
                        return LineTooltipItem(
                          date, // Display the date in the tooltip
                          const TextStyle(color: Colors.white), // Text style for the tooltip
                        );
                      }).toList();
                    },
                  ),
              ),

              ));
          }
        },
      ),
    );
  }

  // Function to convert mood title to a score

}
