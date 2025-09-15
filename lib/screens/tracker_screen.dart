import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/animated_button.dart';

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

class _TrackerScreenState extends State<TrackerScreen>
    with TickerProviderStateMixin {
  final List<Behavior> _behaviors = [];

  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  Color _selectedColor = Colors.purple;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  late AnimationController _fabController;
  late AnimationController _cardController;
  late AnimationController _calendarController;

  late Animation<double> _fabScaleAnimation;
  late Animation<double> _calendarFadeAnimation;

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _calendarController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    _calendarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _calendarController, curve: Curves.easeIn),
    );

    // Start animations
    _fabController.forward();
    _calendarController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _cardController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _addBehavior() {
    if (_nameController.text.isEmpty || _selectedDate == null) return;

    // Add haptic feedback
    HapticFeedback.mediumImpact();

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

    // Animate card addition
    _cardController.forward().then((_) {
      _cardController.reset();
    });

    Navigator.pop(context); // close the bottom sheet
  }

  void _showAddBehaviorDialog() {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Add Target Behavior",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 24),

                // Behavior name field
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Behavior name",
                    labelStyle: TextStyle(color: Colors.purple.shade300),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.purple.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.purple.shade50,
                  ),
                ),
                const SizedBox(height: 20),

                // Color selection
                Row(
                  children: [
                    Text(
                      "Color: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        children:
                            [
                              Colors.purple,
                              Colors.blue,
                              Colors.green,
                              Colors.orange,
                              Colors.red,
                              Colors.teal,
                            ].map((color) {
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  setState(() => _selectedColor = color);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _selectedColor == color
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                    boxShadow: _selectedColor == color
                                        ? [
                                            BoxShadow(
                                              color: color.withOpacity(0.5),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: _selectedColor == color
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Date selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "Pick sober date"
                                  : "Sober since:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.purple.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (_selectedDate != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                DateFormat.yMMMd().add_jm().format(
                                  _selectedDate!,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      AnimatedButton(
                        text: "Select",
                        icon: Icons.calendar_today,
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        borderRadius: BorderRadius.circular(8),
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
                ),
                const SizedBox(height: 24),

                // Save button
                AnimatedButton(
                  text: "Save Behavior",
                  icon: Icons.save,
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: BorderRadius.circular(12),
                  onPressed: _addBehavior,
                ),
              ],
            ),
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
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade400, Colors.purple.shade600],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Animated Calendar
          AnimatedBuilder(
            animation: _calendarFadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _calendarFadeAnimation,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, -0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _calendarController,
                          curve: Curves.easeOut,
                        ),
                      ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime(2000),
                      lastDay: DateTime(2100),
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        HapticFeedback.lightImpact();
                        setState(() => _calendarFormat = format);
                      },
                      onPageChanged: (day) => _focusedDay = day,
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          // Check if any behavior's soberDate <= day
                          for (final behavior in _behaviors) {
                            if (day.isAfter(behavior.soberDate) ||
                                day.isAtSameMomentAs(behavior.soberDate)) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      behavior.color.withOpacity(0.3),
                                      behavior.color.withOpacity(0.6),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: behavior.color.withOpacity(0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "${day.day}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: behavior.color,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const Divider(height: 1),

          // Animated List of behaviors
          Expanded(
            child: AnimatedBuilder(
              animation: _cardController,
              builder: (context, child) {
                return SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _cardController,
                          curve: Curves.easeOut,
                        ),
                      ),
                  child: _behaviors.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.track_changes,
                                size: 80,
                                color: Colors.purple.shade200,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No behaviors tracked yet",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.purple.shade400,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Tap the + button to add your first behavior",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.purple.shade300,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _behaviors.length,
                          itemBuilder: (context, index) {
                            final b = _behaviors[index];
                            return AnimatedCard(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.white,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                // Could add edit functionality here
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          b.color,
                                          b.color.withOpacity(0.8),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: b.color.withOpacity(0.3),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.psychology,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          b.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Sober since: ${DateFormat.yMMMd().add_jm().format(b.soberDate)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: AnimatedBuilder(
        animation: _fabScaleAnimation,
        builder: (context, child) {
          return ScaleTransition(
            scale: _fabScaleAnimation,
            child: AnimatedFloatingActionButton(
              icon: Icons.add,
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              tooltip: "Add Behavior",
              onPressed: _showAddBehaviorDialog,
            ),
          );
        },
      ),
    );
  }
}
