import 'package:flutter/material.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/domain/model/other_user.dart';
import 'package:tutorconnect/domain/model/student.dart';
import 'package:tutorconnect/domain/model/tutor.dart';
import 'package:tutorconnect/presentation/screens/scheduall/schedule_bloc.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';

import '../../../domain/model/schedule.dart';
import '../../../domain/model/schedule_slot.dart';
import '../../../domain/model/user.dart';

class ScheduleFormScreen extends StatefulWidget {
  final Student student;
  const ScheduleFormScreen({super.key, required this.student});

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _bloc = getIt<ScheduleBloc>();
  final user = Account.instance.user;
  final tutor = Account.instance.tutor;

  // Text editing controllers
  final _titleController = TextEditingController(text: "Tutor Name");
  final _topicController = TextEditingController();

  // Schedule slots
  final List<ScheduleSlot> _slots = [];

  // Date and time controllers
  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _startTime =
      const TimeOfDay(hour: 8, minute: 0); // Default 8 AM
  late TimeOfDay _endTime =
      const TimeOfDay(hour: 10, minute: 0); // Default 10 AM
  late int _selectedWeekday = DateTime.now().weekday;
  String? address;

  final List<String> _weekdays = [
    'Thứ 2',
    'Thứ 3',
    'Thứ 4',
    'Thứ 5',
    'Thứ 6',
    'Thứ 7',
    'Chủ nhật'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Thêm lịch học'),
          centerTitle: true,
        ),
        body: Form(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: user.name,
                  readOnly: true,
                  style: AppTextStyles(context).bodyText2.copyWith(
                        fontSize: 16,
                      ),
                  decoration: const InputDecoration(
                    labelText: 'Tên gia sư',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: widget.student.user.name,
                  readOnly: true,
                  style: AppTextStyles(context).bodyText2.copyWith(
                        fontSize: 16,
                      ),
                  decoration: const InputDecoration(
                    labelText: 'Tên học viên',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Địa điểm học:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  value: address,
                  // Default value
                  items: [
                    DropdownMenuItem(
                      value: user.address,
                      child: Text(
                        "${user.address}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    DropdownMenuItem(
                      value: widget.student.user.address,
                      child: Text(
                        '${widget.student.user.address}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // topic
                TextFormField(
                  controller: _topicController,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Làm ơn nhập nội dung';
                    }
                    return null;
                  },
                ),

                // Date selection
                const Text(
                  'Ngày học bắt đầu:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Schedule slots
                const Text(
                  'Thời gian học:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _slots.length,
                  itemBuilder: (context, index) {
                    final slot = _slots[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                            '${getWeekdayLabel(slot.weekday ?? 1)}: ${slot.startTime?.format(context)} - ${slot.endTime?.format(context)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _slots.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  onPressed: _openAddSlotDialog,
                  icon: Icon(Icons.add),
                  label: Text("Thêm buổi học"),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => {
                          _submitForm(),
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Gửi lịch học'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _submitForm() {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung'),
        ),
      );
      return;
    }
    if (_slots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng thêm ít nhất một buổi học'),
        ),
      );
      return;
    }


    // Handle form submission logic here
    final schedule = Schedule(
      0, // Assuming 0 is a placeholder for new schedule ID
      _topicController.text,
      address,
      _selectedDate,
      'pending',
      DateTime.now(),
      _slots,
      tutor!,
      widget.student,
    );
    _bloc.createSchedule(schedule);
    Navigator.pop(context);
  }

  Future _openAddSlotDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm buổi học'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: _selectedWeekday,
                items: List.generate(7, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(_weekdays[index]),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _selectedWeekday = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Thời gian bắt đầu',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _startTime,
                            );
                            if (picked != null && picked != _startTime) {
                              setState(() {
                                _startTime = picked;
                              });
                            }
                          },
                        ),
                      ),
                      controller: TextEditingController(
                          text: _startTime.format(context)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Thời gian kết thúc',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _endTime,
                            );
                            if (picked != null && picked != _endTime) {
                              setState(() {
                                _endTime = picked;
                              });
                            }
                          },
                        ),
                      ),
                      controller:
                          TextEditingController(text: _endTime.format(context)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () => _createSchedule(),
              child: const Text('Tạo'),
            )
          ],
        );
      },
    );
  }

  void _createSchedule() {
    // Handle the creation of the schedule slot here
    if (_startTime.hour >= _endTime.hour) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thời gian kết thúc phải lớn hơn thời gian bắt đầu'),
        ),
      );
      Navigator.of(context).pop();
      return;
    }
    if (_slots.any((slot) =>
        slot.weekday == _selectedWeekday &&
        slot.startTime?.hour == _startTime.hour &&
        slot.startTime?.minute == _startTime.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Buổi học đã tồn tại'),
        ),
      );
      return;
    }
    setState(() {
      _slots.add(ScheduleSlot(
        _selectedWeekday,
        TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
        TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
      ));
    });
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedWeekday = picked.weekday;
      });
    }
  }

  String getWeekdayLabel(int weekday) {
    if (weekday >= 1 && weekday <= 7) {
      return _weekdays[weekday - 1]; // vì weekday 1 = Thứ 2, index 0 = Thứ 2
    }
    return 'Không xác định';
  }
}
