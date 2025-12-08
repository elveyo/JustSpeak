import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frontend/models/tutor_schedule.dart';
import 'package:frontend/providers/schedule_provider.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:provider/provider.dart';

class ManageScheduleScreen extends StatefulWidget {
  final Schedule? existingSchedule;
  
  const ManageScheduleScreen({super.key, this.existingSchedule});

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

  @override
  void initState() {
    super.initState();
    
    // If editing, pre-populate form with existing data
    if (widget.existingSchedule != null) {
      final schedule = widget.existingSchedule!;
      
      // Set price and duration
      sessionPrice = schedule.price.toDouble();
      sessionDuration = Duration(minutes: schedule.duration);
      
      // Set selected days and times from available days
      if (schedule.availableDays != null && schedule.availableDays!.isNotEmpty) {
        selectedDays.clear();
        
        final dayMap = {
          1: "MON",
          2: "TUE",
          3: "WED",
          4: "THRU",
          5: "FRI",
        };
        
        for (var day in schedule.availableDays!) {
          final dayName = dayMap[day.dayOfWeek];
          if (dayName != null) {
            selectedDays.add(dayName);
          }
        }
        
        // Use first available day's times as default
        final firstDay = schedule.availableDays!.first;
        if (firstDay.startTime != null) {
          final parts = firstDay.startTime!.split(':');
          startTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
        if (firstDay.endTime != null) {
          final parts = firstDay.endTime!.split(':');
          endTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
      }
    }
  }

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
      
      // Check if we're editing or creating
      if (widget.existingSchedule != null && widget.existingSchedule!.id != null) {
        // Update existing schedule
        await scheduleProvider.updateSchedule(widget.existingSchedule!.id!, request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Schedule updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Create new schedule
        await scheduleProvider.insert(request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Schedule created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      // Notify listeners that schedule was updated
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      // Handle error, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save schedule: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
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
                      [1, 45, 60]
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
