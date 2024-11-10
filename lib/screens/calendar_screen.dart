import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Perbaiki import
import 'dart:convert';

class Task {
  String title;
  String description;
  DateTime date;
  TimeOfDay time;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isCompleted = false,
  });

  // Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'time': {'hour': time.hour, 'minute': time.minute},
      'isCompleted': isCompleted,
    };
  }

  // Create Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: json['time']['hour'],
        minute: json['time']['minute'],
      ),
      isCompleted: json['isCompleted'],
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Task> tasks = [];
  final String _storageKey = 'tasks';
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _updateDateController();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final String? tasksJson = _prefs.getString(_storageKey);
    if (tasksJson != null) {
      final List<dynamic> decodedTasks = jsonDecode(tasksJson);
      setState(() {
        tasks = decodedTasks.map((task) => Task.fromJson(task)).toList();
        tasks.sort((a, b) {
          int dateComparison = a.date.compareTo(b.date);
          if (dateComparison != 0) return dateComparison;
          return a.time.hour * 60 + a.time.minute - (b.time.hour * 60 + b.time.minute);
        });
      });
    }
  }

  Future<void> _saveTasks() async {
    final List<Map<String, dynamic>> encodedTasks = tasks.map((task) => task.toJson()).toList();
    await _prefs.setString(_storageKey, jsonEncode(encodedTasks));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTimeController();
  }

  void _updateDateController() {
    _dateController.text = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
  }

  void _updateTimeController() {
    _timeController.text = _selectedTime.format(context);
  }

  void _addTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    setState(() {
      tasks.add(Task(
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        time: _selectedTime,
      ));

      tasks.sort((a, b) {
        int dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;
        return a.time.hour * 60 + a.time.minute - (b.time.hour * 60 + b.time.minute);
      });

      _titleController.clear();
      _descriptionController.clear();
    });

    _saveTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added successfully')),
    );
  }

  void _toggleTaskComplete(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted')),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.arsenalblack,
              onPrimary: Colors.white,
              onSurface: AppColors.arsenalblack,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateController();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.arsenalblack,
              onPrimary: Colors.white,
              onSurface: AppColors.arsenalblack,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _updateTimeController();
      });
    }
  }

  String _getDayName(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[day - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime date) {
    return '${_getDayName(date.weekday)}, ${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar & Tasks', style: TextStyles.titlewhite),
        backgroundColor: AppColors.arsenalblack,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add New Task', style: TextStyles.title),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Task Title',
                          labelStyle: TextStyles.body,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Description',
                          labelStyle: TextStyles.body,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                          labelText: 'Date',
                          labelStyle: TextStyles.body,
                        ),
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _timeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () => _selectTime(context),
                          ),
                          labelText: 'Time',
                          labelStyle: TextStyles.body,
                        ),
                        onTap: () => _selectTime(context),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.arsenalblack,
                          padding: const EdgeInsets.all(16),
                        ),
                        child: Text('Add Task', style: TextStyles.button),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Tasks', style: TextStyles.title),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: Key(task.title),
                    onDismissed: (_) => _deleteTask(index),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: task.isCompleted
                              ? TextStyles.bodygrey
                              : TextStyles.bodyblack,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(_formatDate(task.date), style: TextStyles.bodygrey),
                            Text('${task.time.format(context)}', style: TextStyles.bodygrey), // Menampilkan waktu
                            Text(task.description, style: TextStyles.bodygrey),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            task.isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: AppColors.arsenalblack,
                          ),
                          onPressed: () => _toggleTaskComplete(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
