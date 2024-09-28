import 'dart:math';

import 'package:flutter/material.dart';

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  //no build method if stateful widget
  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }

}

// "_" means that class is a private class for the file
class _DiceRollerState extends State<DiceRoller> {
  //better for memory when using random (Can be set as a global variable for better)
  final randomizer = Random();

  //variable to change dice image
  var currentDiceRoll = 2;

  void rollDice() {
    //Provided by the state class (Tells flutter to re execute UI for where it is)
    setState(() {
      currentDiceRoll = randomizer.nextInt(6) + 1;
    });
  }

  @override
  Widget build(context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/dice-$currentDiceRoll.png', width: 200),
            TextButton(
              onPressed: rollDice,
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 20),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 28)),
              child: const Text("Roll Dice"),
            )
          ],
        );
  }
}