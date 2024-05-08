import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication eklenmeli
import 'package:cloud_firestore/cloud_firestore.dart';

class Takvim extends StatefulWidget {
  const Takvim({Key? key});

  @override
  State<Takvim> createState() => _TakvimState();
}

class _TakvimState extends State<Takvim> {
  late User _currentUser; // Aktif kullanıcıyı tutmak için User tipinde bir değişken tanımlıyoruz
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // initState içinde aktif kullanıcıyı alıyoruz
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  void _addEvent(String event) {
    if (event.isNotEmpty) {
      setState(() {
        _events.putIfAbsent(_selectedDay, () => []).add(event);
      });

      // Firebase Firestore'a ekleme
      FirebaseFirestore.instance.collection('Takvim').doc('Kullanicilar').collection(_currentUser.email.toString()).add({
        'baslik': event,
        'tarih': Timestamp.fromDate(_selectedDay),
      });

    }
  }

  void _deleteEvent(String event) {
    setState(() {
      _events[_selectedDay]?.remove(event);
    });
  }

  void _showAddEventDialog() {
    final TextEditingController _eventController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Etkinlik Ekle'),
        content: TextFormField(
          controller: _eventController,
          decoration: const InputDecoration(hintText: 'Etkinlik adını girin'),
        ),
        actions: [
          TextButton(
            child: const Text('İptal'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Ekle'),
            onPressed: () {
              _addEvent(_eventController.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takvim'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            rowHeight: 65,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            focusedDay: _selectedDay,
            firstDay: DateTime.utc(2010, 01, 01),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            eventLoader: (day) => _events[day] ?? [],
            startingDayOfWeek: StartingDayOfWeek.monday, // Haftanın ilk günü Pazartesi olarak ayarlandı
            calendarStyle: CalendarStyle(
              weekendDecoration: BoxDecoration(
                color: Colors.green[200], // Hafta sonu günleri için arka plan rengi
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green[800], // Seçili gün için arka plan rengi
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green[500], // Bugün için arka plan rengi
                shape: BoxShape.circle,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _events[_selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                final event = _events[_selectedDay]![index];
                return Dismissible(
                  key: Key(event),
                  onDismissed: (_) {
                    _deleteEvent(event);
                  },
                  background: Container(color: Colors.red),
                  child: Card(
                    child: ListTile(
                      title: Text(event),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteEvent(event);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

