import 'package:flutter/material.dart';

class Calculator extends StatelessWidget {
  final Function(String) onNumberPressed;
  final Function() onClearPressed;
  final Function() onDeletePressed;
  final Function() onSwitchPressed;

  // final Function() onDividePressed; //除
  // final Function() onMultiplyPressed; //乘
  // final Function() onPlusPressed; //加
  // final Function() onSubstractPressed; //減
  // final Function() onRemainderPressed; //%
  // final Function() onEqualPressed; //=

  const Calculator({
    required this.onNumberPressed,
    required this.onClearPressed,
    required this.onDeletePressed,
    required this.onSwitchPressed,
    // required this.onDividePressed,
    // required this.onMultiplyPressed,
    // required this.onPlusPressed,
    // required this.onSubstractPressed,
    // required this.onRemainderPressed,
    // required this.onEqualPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 170, 137, 220),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.2,
        ),
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          String buttonText;
          Color buttonColor;
          Function() buttonAction;

          switch (index) {
            case 0:
              buttonText = 'C';
              buttonColor = Colors.orange;
              buttonAction = onClearPressed;
              break;
            case 1:
              buttonText = '←';
              buttonColor = Colors.orange;
              buttonAction = onDeletePressed;
              break;
            case 2:
              buttonText = '⇅';
              buttonColor = Colors.orange;
              buttonAction = onSwitchPressed;
              break;
            case 3:
              buttonText = '÷';
              buttonColor = Colors.orange;
              buttonAction = () {};
              break;
            case 4:
              buttonText = '7';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('7');
              break;
            case 5:
              buttonText = '8';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('8');
              break;
            case 6:
              buttonText = '9';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('9');
              break;
            case 7:
              buttonText = '×';
              buttonColor = Colors.orange;
              buttonAction = () {};
              break;
            case 8:
              buttonText = '4';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('4');
              break;
            case 9:
              buttonText = '5';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('5');
              break;
            case 10:
              buttonText = '6';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('6');
              break;
            case 11:
              buttonText = '-';
              buttonColor = Colors.orange;
              buttonAction = () {};
              break;
            case 12:
              buttonText = '1';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('1');
              break;
            case 13:
              buttonText = '2';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('2');
              break;
            case 14:
              buttonText = '3';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('3');
              break;
            case 15:
              buttonText = '+';
              buttonColor = Colors.orange;
              buttonAction = () {};
              break;
            case 16:
              buttonText = '0';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('0');
              break;
            case 17:
              buttonText = '.';
              buttonColor = Colors.grey;
              buttonAction = () => onNumberPressed('.');
              break;
            case 18:
              buttonText = '%';
              buttonColor = Colors.orange;
              buttonAction = () {};
              break;
            case 19:
              buttonText = '=';
              buttonColor = Colors.orange;
              buttonAction = () {};
              break;
            default:
              buttonText = '';
              buttonColor = Colors.grey;
              buttonAction = () {};
          }

          return Container(
            margin: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 224, 208, 234),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: buttonAction,
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
