import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget {
  final List<dynamic> recommendations;

  // Constructor to accept the recommendations data
  DisplayPage({required this.recommendations});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  late final List<Map<String, dynamic>> recipeDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    recipeDetails = widget.recommendations.map((recipe) {
      return {
        'name': recipe['Name'] ?? 'Unknown Name',
        'recipeid': recipe['RecipeId'] ?? 'No ingredients available',
        'instructions':
            recipe['RecipeInstructions'] ?? 'No instructions available',
      };
    }).toList();

    // Force UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendations'),
      ),
      body: ListView.builder(
        itemCount: widget.recommendations.length,
        itemBuilder: (context, index) {
          final recipe = recipeDetails[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RecipeDetailsPage(recipe: recipe['instructions']),
                ),
              );
            },
            title:
                Text(recipe['name']), // assuming the data has a 'title' field
            // assuming a 'description' field
          );
        },
      ),
    );
  }
}

// class Recipe {
//   final String name;
//   final int recipeId;
//   final String ingredients;

//   Recipe(
//       {required this.name, required this.recipeId, required this.ingredients});
// }

class RecipeDetailsPage extends StatelessWidget {
  final recipe;

  RecipeDetailsPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recipe :', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(recipe), // Display the ingredients
          ],
        ),
      ),
    );
  }
}
