
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ma Calculatrice',
      theme: ThemeData.dark(),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String display = '0';
  double firstNumber = 0;
  String operator = '';
  bool startNewNumber = true;

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        display = '0';
        firstNumber = 0;
        operator = '';
        startNewNumber = true;
      } else if (value == 'DEL') {
        if (display.length > 1 && display != 'Erreur') {
          display = display.substring(0, display.length - 1);
        } else {
          display = '0';
        }
      } else if (value == '.') {
        if (startNewNumber) {
          display = '0.';
          startNewNumber = false;
        } else if (!display.contains('.')) {
          display += '.';
        }
      } else if (['+', '-', '×', '÷'].contains(value)) {
        firstNumber = double.tryParse(display) ?? 0;
        operator = value;
        startNewNumber = true;
      } else if (value == '=') {
        final secondNumber = double.tryParse(display) ?? 0;
        double result;

        switch (operator) {
          case '+':
            result = firstNumber + secondNumber;
            break;
          case '-':
            result = firstNumber - secondNumber;
            break;
          case '×':
            result = firstNumber * secondNumber;
            break;
          case '÷':
            if (secondNumber == 0) {
              display = 'Erreur';
              operator = '';
              startNewNumber = true;
              return;
            }
            result = firstNumber / secondNumber;
            break;
          default:
            return;
        }

        display = result % 1 == 0
            ? result.toInt().toString()
            : result.toString();

        operator = '';
        startNewNumber = true;
      } else {
        if (startNewNumber || display == '0' || display == 'Erreur') {
          display = value;
          startNewNumber = false;
        } else {
          display += value;
        }
      }
    });
  }

  Widget buildButton(
    String text, {
    Color color = const Color(0xFF333333),
    Color textColor = Colors.white,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 72,
          child: ElevatedButton(
            onPressed: () => onButtonPressed(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 0,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF9500);
    const lightGrey = Color(0xFFA5A5A5);

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: const Text('Ma Calculatrice'),
        centerTitle: true,
        backgroundColor: const Color(0xFF171717),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                buildButton('AC', color: lightGrey, textColor: Colors.black),
                buildButton('DEL', color: lightGrey, textColor: Colors.black),
                buildButton('÷', color: orange),
              ],
            ),
            Row(
              children: [
                buildButton('7'),
                buildButton('8'),
                buildButton('9'),
                buildButton('×', color: orange),
              ],
            ),
            Row(
              children: [
                buildButton('4'),
                buildButton('5'),
                buildButton('6'),
                buildButton('-', color: orange),
              ],
            ),
            Row(
              children: [
                buildButton('1'),
                buildButton('2'),
                buildButton('3'),
                buildButton('+', color: orange),
              ],
            ),
            Row(
              children: [
                buildButton('0', flex: 2),
                buildButton('.'),
                buildButton('=', color: orange),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
