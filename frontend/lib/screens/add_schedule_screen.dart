import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frontend/providers/schedule_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ManageScheduleScreen extends StatefulWidget {
  const ManageScheduleScreen({super.key});

  @override
  State<ManageScheduleScreen> createState() => _ManageScheduleScreenState();
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final List<String> days = ["MON", "TUE", "WED", "THRU", "FRI"];
  Set<String> selectedDays = {"TUE"};

  TimeOfDay? startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay? endTime = const TimeOfDay(hour: 12, minute: 0);

  Duration sessionDuration = const Duration(hours: 1);
  double sessionPrice = 20.0;

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime! : endTime!,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> _postSchedule() async {
    // INSERT_YOUR_CODE
    final scheduleProvider = Provider.of<ScheduleProvider>(
      context,
      listen: false,
    );

    try {
      final request = {
        "tutorId": AuthService().user?.id,
        "availableDays":
            selectedDays.map((day) {
              final dayMap = {
                "MON": 1,
                "TUE": 2,
                "WED": 3,
                "THRU": 4,
                "FRI": 5,
              };
              return {
                "dayOfWeek": dayMap[day],
                "startTime":
                    startTime != null
                        ? "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}:00"
                        : null,
                "endTime":
                    endTime != null
                        ? "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}:00"
                        : null,
              };
            }).toList(),
        "duration": sessionDuration.inMinutes,
        "price": sessionPrice,
      };
      await scheduleProvider.insert(request);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Schedule saved successfully!')));
      Navigator.pop(context);
    } catch (e) {
      // Handle error, show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save schedule: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MANAGE SCHEDULE',
                      style: TextStyle(
                        color: Color(0xFFB000FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Color(0xFFB000FF)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Working days
                const Text(
                  "Working days",
                  style: TextStyle(
                    color: Color(0xFFB000FF),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      days.map((day) {
                        final isSelected = selectedDays.contains(day);
                        return ChoiceChip(
                          label: Text(day),
                          selected: isSelected,
                          selectedColor: const Color(0xFFB000FF),
                          backgroundColor: Colors.transparent,
                          labelStyle: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFFB000FF),
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),

                const SizedBox(height: 20),

                // Daily work
                const Text(
                  "Daily work",
                  style: TextStyle(
                    color: Color(0xFFB000FF),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickTime(true),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            startTime != null
                                ? startTime!.format(context)
                                : "Start",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFB000FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "—",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFB000FF),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickTime(false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            endTime != null ? endTime!.format(context) : "End",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFB000FF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Session duration
                const Text(
                  "Session duration",
                  style: TextStyle(
                    color: Color(0xFFB000FF),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: sessionDuration.inMinutes,
                  items:
                      [30, 45, 60]
                          .map(
                            (min) => DropdownMenuItem(
                              value: min,
                              child: Text("$min min"),
                            ),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      sessionDuration = Duration(minutes: val!);
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Session price
                const Text(
                  "Session price",
                  style: TextStyle(
                    color: Color(0xFFB000FF),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: sessionPrice.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixText: "\$",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      sessionPrice = double.tryParse(val) ?? sessionPrice;
                    });
                  },
                ),

                const Spacer(),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1B9A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _postSchedule,
                    child: const Text(
                      "SAVE",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
