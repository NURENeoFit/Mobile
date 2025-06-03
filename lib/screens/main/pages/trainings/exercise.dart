// import 'package:flutter/material.dart';
// import 'package:neofit_mobile/models/trainer.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:neofit_mobile/providers/workout_provider.dart';
//
// class TrainingDetailPage extends StatefulWidget {
//   final Trainer trainer;
//
//   const TrainingDetailPage({super.key, required this.trainer});
//
//   @override
//   State<TrainingDetailPage> createState() => _TrainingDetailPageState();
// }
//
// class _TrainingDetailPageState extends State<TrainingDetailPage> {
//   bool isFavorite = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadFavoriteStatus();
//   }
//
//   Future<void> _loadFavoriteStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final favoritesJson = prefs.getStringList('favorite_workouts') ?? [];
//     setState(() {
//       isFavorite = favoritesJson.contains(widget.trainer.id.toString());
//     });
//   }
//
//   Future<void> _toggleFavorite() async {
//     final prefs = await SharedPreferences.getInstance();
//     final favoritesJson = prefs.getStringList('favorite_workouts') ?? [];
//
//     setState(() {
//       if (isFavorite) {
//         favoritesJson.remove(widget.workoutProgram.id.toString());
//         isFavorite = false;
//       } else {
//         favoritesJson.add(widget.workoutProgram.id.toString());
//         isFavorite = true;
//       }
//     });
//
//     await prefs.setStringList('favorite_workouts', favoritesJson);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final iconData = iconMap[widget.workoutProgram.icon] ?? Icons.fitness_center;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.workoutProgram.name, style: Theme.of(context).textTheme.headlineMedium),
//         actions: [
//           IconButton(
//             icon: isFavorite ? Icon(Icons.star, color: Colors.amber) : Icon(Icons.star_border),
//             onPressed: _toggleFavorite,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(iconData, size: 80, color: Theme.of(context).colorScheme.primary),
//             const SizedBox(height: 24),
//             Text(widget.workoutProgram.name, style: Theme.of(context).textTheme.titleMedium),
//             const SizedBox(height: 8),
//             Text(widget.workoutProgram.coach, style: Theme.of(context).textTheme.bodyLarge),
//             const SizedBox(height: 24),
//             Text(
//               'This is a detailed view of the workout program "${widget.workoutProgram.name}". '
//                   'Here will be displayed duration, sets, reps, instructions or video.',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
