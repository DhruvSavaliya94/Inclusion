import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ignore: use_key_in_widget_constructors
class BasicInformationForm extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BasicInformationFormState createState() => _BasicInformationFormState();
}

class _BasicInformationFormState extends State<BasicInformationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late int _selectedRadio;
  final List<bool> _selectedCheckbox = [false, false, false, false, false];
  late DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Basic Information'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _textController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'John Doe',
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Which of the following applies to you?'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      CheckboxListTile(
                        title: const Text('Visual Impairments'),
                        value: _selectedCheckbox[0],
                        onChanged: (value) {
                          setState(() {
                            _selectedCheckbox[0] = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Deaf / Hard of Hearing'),
                        value: _selectedCheckbox[1],
                        onChanged: (value) {
                          setState(() {
                            _selectedCheckbox[1] = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Handicapped'),
                        value: _selectedCheckbox[2],
                        onChanged: (value) {
                          setState(() {
                            _selectedCheckbox[2] = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title:
                            const Text('Intellectual / Cognitive Disabilities'),
                        value: _selectedCheckbox[3],
                        onChanged: (value) {
                          setState(() {
                            _selectedCheckbox[3] = value!;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('None of the above'),
                        value: _selectedCheckbox[4],
                        onChanged: (value) {
                          setState(() {
                            _selectedCheckbox[4] = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        initialDatePickerMode: DatePickerMode.year,
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                          _dateController.text = picked.year
                              .toString(); // Update the text controller
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          hintText: 'Select your birth year',
                          border: OutlineInputBorder(),
                          labelText: 'Birth year',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _contentTextController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter text';
                      }
                      return null;
                    },
                    maxLines: null, // to enable multiple lines
                    decoration: const InputDecoration(
                      hintText: 'Content',
                      border: OutlineInputBorder(),
                      labelText: 'Content',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save the form data to the database
                        // Navigate to the next page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NextPage(
                              key: _formKey,
                              data: _contentTextController.text,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class NextPage extends StatefulWidget {
  String? data;

  NextPage({Key? key, required this.data}) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  void initializeTts() {
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future _speak() async {
    await flutterTts.speak(widget.data!);
  }

  Future _stop() async {
    await flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Output'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              isSpeaking ? _stop() : _speak();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              Text(
                widget.data!,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 32,
                  color: Colors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class NextPage extends StatelessWidget {
//   String? data;
//
//   NextPage({Key? key, required this.data}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Output'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.all(16.0),
//           color: Colors.white,
//           child: Column(
//             children: [
//               const SizedBox(height: 16.0),
//               Text(
//                 data!,
//                 style: const TextStyle(
//                   fontFamily: 'Arial',
//                   fontSize: 32,
//                   color: Colors.red,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
