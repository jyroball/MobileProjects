//package to get unique id parameters like a GUID value
import 'package:uuid/uuid.dart';

//utility object to generate a unique id
const uuid = Uuid();

//enumerate types of epenses categories
enum Category {
  food,
  travel,
  leisure,
  work
}

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

}