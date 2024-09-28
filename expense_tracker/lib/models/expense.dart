//package to get unique id parameters like a GUID value
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

//utility object to generate a unique id
const uuid = Uuid();

//enumerate types of epenses categories
enum Category {
  food,
  travel,
  leisure,
  work
}

const categoryIcon = {
  Category.food : Icons.fastfood_outlined,
  Category.travel : Icons.airplane_ticket_outlined,
  Category.leisure : Icons.shopping_bag_outlined,
  Category.work : Icons.workspaces_outlined,
};

class Expense {

  Expense({
    required this.title, 
    required this.amount, 
    required this.date,
    required this.category,
  }) : id = uuid.v4();  //sets an id for id with unique string id

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}