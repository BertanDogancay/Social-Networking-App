import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/utils/colors.dart';

class InputBox extends ConsumerStatefulWidget {
  const InputBox({Key? key}) : super(key: key);

  @override
  ConsumerState<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends ConsumerState<InputBox> {
  TextEditingController controller = TextEditingController();
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  void setEnabled() {
      setState(() {
        isEnabled = !isEnabled;
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: TextField(
            controller: controller,
            readOnly: !isEnabled,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.white60,
                  width: 1
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
                borderSide: BorderSide(
                  color: isEnabled ? Colors.yellow
                  : Colors.white60,
                  width: 1
                )
              ),
            ),
          ),
        ),
        SizedBox(
          child: Container(
            width: 400,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              border: Border.all(color: Colors.white60)
            ),
            child: isEnabled ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                child: Text('Cancel',
                style: TextStyle(color: mainColor),
                ),
                onPressed: () => setEnabled(),
              ),
              TextButton(
                child: const Text('Submit',
                style: TextStyle(color: Colors.green),
                ),
                onPressed: () {},
              ),
              ],
            ) : Center(
              child: TextButton(
                child: const Text('Change username',
                style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => setEnabled(),
              ),
            ) 
          ),
        )
      ],
    );
  }
}