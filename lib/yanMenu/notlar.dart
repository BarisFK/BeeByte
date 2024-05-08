import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notlar extends StatefulWidget {
  final String araziAdi;

  const Notlar({Key? key, required this.araziAdi}) : super(key: key);

  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  final List<Map<String, String>> notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _getNotes();
  }

  void _getNotes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Notlar')
        .doc(_user.email)
        .collection('notlar')
        .get();

    setState(() {
      notes.addAll(snapshot.docs.map((doc) => _convertToMap(doc.data())).toList());
    });
  }

  Map<String, String> _convertToMap(Map<String, dynamic> data) {
    return data.map((key, value) => MapEntry(key, value.toString()));
  }



  @override
  Widget build(BuildContext context) {
    if (widget.araziAdi == null) {
      _titleController.text = "Başlık";
    } else {
      _titleController.text = widget.araziAdi;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notlar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.green[100],
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(notes[index]['baslik'] ?? ''),
                    subtitle: Text(notes[index]['metin'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _silNot(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Başlık',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Metin',
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Buton rengi
                      ),
                      onPressed: () {
                        _ekleNot();
                      },
                      child: Text(
                        'Not Ekle',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Not ekleme fonksiyonu
  void _ekleNot() async {
    final title = _titleController.text;
    final text = _textController.text;
    if (title.isNotEmpty && text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('Notlar')
          .doc(_user.email)
          .collection('notlar')
          .add({'baslik': title, 'metin': text});
      setState(() {
        notes.add({'baslik': title, 'metin': text});
        _titleController.clear();
        _textController.clear();
      });
    }
  }


  void _silNot(int index) async {
    await FirebaseFirestore.instance
        .collection('Notlar')
        .doc(_user.email)
        .collection('notlar')
        .where('baslik', isEqualTo: notes[index]['baslik'])
        .where('metin', isEqualTo: notes[index]['metin'])
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    setState(() {
      notes.removeAt(index);
    });
  }
}
