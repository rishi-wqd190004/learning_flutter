// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'I am your loved ones!',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 11, 229, 214),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyDropDown(
              label: 'Dropdown 1',
              items: ['Option 1.1', 'Option 1.2', 'Option 1.3'],
            ),
            const SizedBox(height: 20),
            const MyDropDown(
              label: 'Dropdown 3',
              items: ['Option 3.1', 'Option 3.2', 'Option 3.3'],
            ),
            const SizedBox(height: 20),
            MyDropDownNumberInput(
              label: 'Dropdown 2',
              selectedValue: MyDropDown.selectedValues['Dropdown 1'] ?? '',
            ),
            const SizedBox(height: 20),
            
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showSuccessNotification(context);
                },
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessNotification(BuildContext context) {
    if (MyDropDown.selectedValues.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Values Confirmed: ${MyDropDown.selectedValues}'),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select values before confirming.'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class MyDropDown extends StatefulWidget {
  final String label;
  final List<String> items;

  const MyDropDown({super.key, required this.label, required this.items});

  static Map<String, String> selectedValues = {};

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String selectedValue = '';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose an option for ${widget.label}:',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedValue.isNotEmpty ? selectedValue : null,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
                MyDropDown.selectedValues[widget.label] = selectedValue;
              });
            },
            items: widget.items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class MyDropDownNumberInput extends StatelessWidget {
  final String label;
  final String selectedValue;

  const MyDropDownNumberInput({super.key, required this.label, required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter age for $label:',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          TextField(
            readOnly: true,
            controller: TextEditingController(text: selectedValue),
            decoration: const InputDecoration(
              hintText: 'Enter age (18-80)',
            ),
            onTap: () {
              _showNumericKeyboard(context);// Open a dialog or navigate to a new screen for age selection
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
              // Limit input to numeric characters
            ],
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  void _showNumericKeyboard(BuildContext context) {
    // Use the FocusScope to request focus on the text field
    FocusScope.of(context).requestFocus(FocusNode());

    // Show numeric keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }
}
