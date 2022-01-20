import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String publisherId;
  final int serves;
  final int favorites;
  final RangeValues priceRange;
  final Timestamp timePublished;
  final Duration cookTime;
  final List<String> images;
  final List<String> tags;
  final List<String> steps;
  final List<Map<String, String>> ingredients;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.publisherId,
    required this.priceRange,
    required this.serves,
    required this.favorites,
    required this.timePublished,
    required this.cookTime,
    required this.images,
    required this.tags,
    required this.steps,
    required this.ingredients,
  });
  factory RecipeModel.fromJson(Map<String, dynamic> map) {
    Map<String, dynamic> data = map;
    data['cookTime'] = Duration(seconds: data['cookTime']);
    data['images'] = (data['images'] as List).cast<String>();
    data['tags'] = (data['tags'] as List).cast<String>();
    data['steps'] = (data['steps'] as List).cast<String>();
    data['priceRange'] = RangeValues(
      double.parse((data['priceRange'] as String).split("-")[0]),
      double.parse((data['priceRange'] as String).split("-")[1]),
    );
    data['ingredients'] =
        (data['ingredients'] as List).cast<String>().map((ing) {
      final ingList = ing.split(">");

      return {
        "ingredient": ingList[0],
        "quantity": ingList[1],
      };
    }).toList();
    return RecipeModel(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      category: data["category"],
      publisherId: data["publisherId"],
      priceRange: data["priceRange"],
      serves: data["serves"],
      favorites: data["favorites"],
      timePublished: data["timePublished"],
      cookTime: data["cookTime"],
      images: data["images"],
      tags: data["tags"],
      steps: data["steps"],
      ingredients: data["ingredients"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "category": category,
      "publisherId": publisherId,
      "priceRange": priceRange,
      "serves": serves,
      "favorites": favorites,
      "timePublished": timePublished,
      "cookTime": cookTime,
      "images": images,
      "tags": tags,
      "steps": steps,
      "ingredients": ingredients,
    };
  }

  @override
  String toString() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "category": category,
      "publisherId": publisherId,
      "priceRange": priceRange,
      "serves": serves,
      "favorites": favorites,
      "timePublished": timePublished,
      "cookTime": cookTime,
      "images": images,
      "tags": tags,
      "steps": steps,
      "ingredients": ingredients,
    }.toString();
  }
}
