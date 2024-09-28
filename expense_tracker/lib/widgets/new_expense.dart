import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  //object that handles user input
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context, 
      initialDate: now, 
      firstDate: firstDate, 
      lastDate: now
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    //make sure to delete texteditingcontroller when not in use,
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          //for Title Value
          TextField(
            //registers value changed in text field
            controller: _titleController,
            maxLength: 50,
            //keyboardType: ,   Specifies what keyboard textfield should use
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              //For amount value
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null ? 'No date selected' : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: _presentDatePicker, 
                      icon: const Icon(Icons.calendar_month_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase()),
                  ),
                ).toList(), 
                onChanged: (value) {
                  //Return if value not chosen as to not set new state when there is a null value
                  if(value == null) return;
                  //set new state inside widget (NEED THIS IMPORTANT)
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () {
                        //print(_enteredTitle);
                      }, 
                      child: const Text('Save Expense'),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}