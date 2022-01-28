import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final String checkBoxText;
  final String text;
  final Widget? child;
  final void Function(bool?) onChanged;
  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.checkBoxText,
    required this.text,
    this.child,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Flexible(
          flex: 0,
          child: InkWell(
            onTap: () => onChanged(!value),
            child: Container(
              // margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(4),
              height: 30,
              width: 30,
              child: Center(
                child: Text(
                  checkBoxText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                // color: Get.theme.primaryColor,
                color: value ? Get.theme.primaryColor : Colors.grey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: value ? Get.theme.primaryColor : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
        Flexible(flex: 0, child: SizedBox(width: 15)),
        Flexible(child: child ?? Text(text)),
      ],
    );
  }
}
