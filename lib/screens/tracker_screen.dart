import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Behavior {
  String name;
  Color color;
  DateTime soberDate;

  Behavior({required this.name, required this.color, required this.soberDate});
}

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final List<Behavior> _behaviors = [];

  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  Color _selectedColor = Colors.purple;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  void _addBehavior() {
    if (_nameController.text.isEmpty || _selectedDate == null) return;

    setState(() {
      _behaviors.add(
        Behavior(
          name: _nameController.text,
          color: _selectedColor,
          soberDate: _selectedDate!,
        ),
      );
      _nameController.clear();
      _selectedDate = null;
      _selectedColor = Colors.purple;
    });

    Navigator.pop(context); // close the bottom sheet
  }

  void _showAddBehaviorDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            runSpacing: 16,
            children: [
              const Text(
                "Add Target Behavior",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Behavior name",
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                children: [
                  const Text("Color: "),
                  const SizedBox(width: 10),
                  DropdownButton<Color>(
                    value: _selectedColor,
                    items:
                        [
                              Colors.purple,
                              Colors.blue,
                              Colors.green,
                              Colors.orange,
                              Colors.red,
                              Colors.teal,
                            ]
                            .map(
                              (color) => DropdownMenuItem(
                                value: color,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (c) {
                      if (c != null) setState(() => _selectedColor = c);
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "Pick sober date"
                          : "Sober since: ${DateFormat.yMMMd().add_jm().format(_selectedDate!)}",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Colors.purple,
                    ),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _addBehavior,
                child: const Text("Save Behavior"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Behavior Tracker"),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          // Calendar
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (day) => _focusedDay = day,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                // Check if any behavior's soberDate <= day
                for (final behavior in _behaviors) {
                  if (day.isAfter(behavior.soberDate) ||
                      day.isAtSameMomentAs(behavior.soberDate)) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: behavior.color.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text("${day.day}")),
                    );
                  }
                }
                return null;
              },
            ),
          ),

          const Divider(),

          // List of behaviors
          Expanded(
            child: ListView.builder(
              itemCount: _behaviors.length,
              itemBuilder: (context, index) {
                final b = _behaviors[index];
                return ListTile(
                  leading: CircleAvatar(backgroundColor: b.color),
                  title: Text(b.name),
                  subtitle: Text(
                    "Sober since: ${DateFormat.yMMMd().add_jm().format(b.soberDate)}",
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBehaviorDialog,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
