import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutorconnect/presentation/screens/scheduall/schedule_bloc.dart';
import 'package:tutorconnect/presentation/screens/scheduall/schedule_state.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/format_utils.dart';
import '../../../domain/model/schedule.dart';
import '../../../theme/color_platte.dart';
import '../../../theme/text_styles.dart';

class CalendarScreen extends StatefulWidget {
  final List<Schedule> schedules;

  const CalendarScreen({super.key, required this.schedules});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final Map<DateTime, List<Schedule>> _events;
  late DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _events = _groupSchedulesByDay(widget.schedules);
  }

  Map<DateTime, List<Schedule>> _groupSchedulesByDay(List<Schedule> schedules) {
    final Map<DateTime, List<Schedule>> data = {};
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 90)); // 3 tháng tới

    for (final schedule in schedules) {
      if (schedule.status == 'cancelled') continue;
      for (final slot in schedule.slots) {
        // Tìm ngày đầu tiên đúng weekday >= start_date
        DateTime firstDay = schedule.startDate!;
        while (firstDay.weekday % 7 != slot.weekday! % 7) {
          firstDay = firstDay.add(const Duration(days: 1));
        }
        // Lặp lại từng tuần cho đến endDate
        for (DateTime d = firstDay;
        !d.isAfter(endDate);
        d = d.add(const Duration(days: 7))) {
          final key = DateTime(d.year, d.month, d.day);
          data.putIfAbsent(key, () => []).add(schedule);
        }
      }
    }
    return data;
  }

  List<Schedule> _getSchedulesForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch học'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Material(
            child: TableCalendar<Schedule>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getSchedulesForDay,
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(events.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.5),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                          );
                        }),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('Chọn ngày để xem lịch học'))
                : _getSchedulesForDay(_selectedDay!).isEmpty
                ? const Center(child: Text('Không có lịch học'))
                : ListView(
              children: _getSchedulesForDay(_selectedDay!).map((schedule) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(schedule.topic!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Địa chỉ: ${schedule.address}',
                            style: AppTextStyles(context).bodyText2.copyWith(
                              color: AppColors.color600,
                              fontSize: 14,
                            )),
                        Text('Trạng thái: ${_formatStatus(schedule.status!)}',
                            style: AppTextStyles(context).bodyText2.copyWith(
                              color: AppColors.color600,
                              fontSize: 14,
                            )),
                        ...schedule.slots.map((slot) {
                          final start =
                              "${slot.startTime?.hour.toString().padLeft(2, '0')}:${slot.startTime?.minute.toString().padLeft(2, '0')}";
                          final end =
                              "${slot.endTime?.hour.toString().padLeft(2, '0')}:${slot.endTime?.minute.toString().padLeft(2, '0')}";
                          return Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text("Giờ học: $start - $end",
                                style: AppTextStyles(context).bodyText2.copyWith(
                                  color: AppColors.color600,
                                  fontSize: 14,
                                )),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'approved':
        return 'Đã xác nhận';
      case 'cancelled':
        return 'Đã hủy';
      case 'complete':
        return 'Đã hoàn thành';
      default:
        return status;
    }
  }
}
