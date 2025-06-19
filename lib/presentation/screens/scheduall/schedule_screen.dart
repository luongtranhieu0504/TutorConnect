import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/domain/model/other_user.dart';
import 'package:tutorconnect/domain/model/student.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/screens/scheduall/schedule_bloc.dart';
import 'package:tutorconnect/presentation/screens/scheduall/schedule_state.dart';

import '../../../common/utils/format_utils.dart';
import '../../../domain/model/schedule.dart';
import '../../../theme/color_platte.dart';
import '../../../theme/text_styles.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  final _bloc = getIt<ScheduleBloc>();
  final user = Account.instance.user;
  final student = Account.instance.student;
  final tutor = Account.instance.tutor;

  late TabController _tabController;
  late List<Schedule> schedules = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (user.typeRole == "Student") {
      _bloc.getSchedules(studentId: student?.id);
    } else {
      _bloc.getSchedules(tutorId: tutor?.id);
    }
    _bloc.studentsStream.listen((state) {
      state.when(
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
        success: (students) {
          // Message sent successfully
          _showStudentSelectionPopup(students);
        },
        failure: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send message: $error")),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch học'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
              onPressed: () {
                context.push(Routes.calendarPage, extra: {'schedules': schedules});
              },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đã duyệt'),
            Tab(text: 'Chờ duyệt'),
            Tab(text: 'Đã hủy/Hoàn thành'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (user.typeRole == "Student") {
            _bloc.getSchedules(studentId: student?.id);
          } else {
            _bloc.getSchedules(tutorId: tutor?.id);
          }
        },
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is ScheduleLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ScheduleSuccessState) {
              schedules = state.schedules;
              final approvedSchedules =
                  state.schedules.where((s) => s.status == 'approved').toList();
              final pendingSchedules =
                  state.schedules.where((s) => s.status == 'pending').toList();
              final cancelledOrCompleteSchedules = state.schedules
                  .where((s) => s.status == 'cancelled' || s.status == 'complete')
                  .toList();
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildApprovedTab(approvedSchedules),
                  _buildPendingTab(pendingSchedules),
                  _buildCancelledOrCompleteTab(cancelledOrCompleteSchedules),
                ],
              );
            } else if (state is ScheduleFailureState) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text('Hiện tại chưa có lịch học nào.'));
          },
        ),
      ),
    );
  }

  Widget _buildApprovedTab(List<Schedule> schedules) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return _buildScheduleMessage(schedule, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTab(List<Schedule> schedules) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          if (user.typeRole == 'Tutor')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  _bloc.fetchStudentsWithConversations();
                },
                child: const Text('Tạo lịch học mới'),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return _buildScheduleMessage(schedule, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledOrCompleteTab(List<Schedule> schedules) {
    if (schedules.isEmpty) {
      return const Center(
          child: Text('Không có lịch học đã hủy hoặc hoàn thành.'));
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return ListTile(
            title: Text(schedule.topic!),
            subtitle: Text(
                'Bắt đầu: ${DateFormat('dd/MM/yyyy').format(schedule.startDate!)}'),
            trailing: schedule.status == 'complete'
                ? TextButton(
                    onPressed: () {
                      context.push(
                        Routes.tutorProfilePage,
                        extra: {
                          'tutor': schedule.tutor,
                          'isCurrentUser': false,
                        },
                      );
                    },
                    child: const Text('Viết đánh giá'),
                  )
                : null,
          );
        },
      ),
    );
  }

  void _showStudentSelectionPopup(List<Student?> students) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn học sinh'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(student!.user.photoUrl!),
                    ),
                    title: Text(student.user.name!),
                    subtitle: Text(student.user.email!),
                    onTap: () {
                      Navigator.pop(context); // Close the popup
                      context.push(
                        Routes.scheduleFormPage,
                        extra: {'student': student},
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleMessage(Schedule schedule, BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity - 16,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.calendar_month, color: Colors.deepPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  "Lịch học đã lên lịch",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow("Gia sư", schedule.tutor.user.name!),
            _buildInfoRow("Học viên", schedule.student.user.name!),
            _buildInfoRow("Chủ đề", schedule.topic!),
            _buildInfoRow("Địa điểm", schedule.address!),
            _buildInfoRow("Bắt đầu từ",
                DateFormat('dd/MM/yyyy').format(schedule.startDate!)),
            _buildInfoRow("Trạng thái", _formatStatus(schedule.status!)),
            const SizedBox(height: 8),
            Text("⏰ Lịch học cố định:",
                style: AppTextStyles(context).bodyText1.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 4),
            ...schedule.slots.map((slot) {
              final day = FormatUtils.weekdayName(slot.weekday!);
              final start =
                  "${slot.startTime?.hour.toString().padLeft(2, '0')}:${slot.startTime?.minute.toString().padLeft(2, '0')}";
              final end =
                  "${slot.endTime?.hour.toString().padLeft(2, '0')}:${slot.endTime?.minute.toString().padLeft(2, '0')}";
              return Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text("• $day: $start - $end",
                    style: AppTextStyles(context).bodyText2.copyWith(
                          color: AppColors.color600,
                          fontSize: 14,
                        )),
              );
            }),
            const SizedBox(height: 12),
            if (user.typeRole == "Student" && schedule.status == "pending")
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _bloc.updateSchedule(
                            schedule.id,
                            schedule.copyWith(
                              status: 'cancelled',
                            ));
                      });
                    },
                    child: const Text('Hủy'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _bloc.updateSchedule(
                          schedule.id,
                          schedule.copyWith(
                            status: 'approved',
                          ));
                    },
                    child: const Text('Chấp nhận'),
                  )
                ],
              )
            else if (user.typeRole == "Tutor" && schedule.status == "approved")
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _bloc.updateSchedule(
                            schedule.id,
                            schedule.copyWith(
                              status: 'complete',
                            ));
                      });
                    },
                    child: const Text('Hoàn thành'),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label: ",
              style: AppTextStyles(context).bodyText1.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles(context)
                  .bodyText2
                  .copyWith(color: AppColors.color600),
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

  void _showCalendarPopup(BuildContext context, List<Schedule> schedules) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lịch học'),
          content: SizedBox(
            height: 400, // Set a fixed height for the calendar
            child: Column(
              children: [
                Expanded(
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime(2100),
                    focusedDay: DateTime.now(),
                    eventLoader: (day) {
                      return schedules
                          .where((s) =>
                      isSameDay(s.startDate, day) &&
                          s.status != 'cancelled' &&
                          s.status != 'complete')
                          .toList();
                    },
                    onDaySelected: (selectedDay, _) {
                      final selectedSchedules = schedules
                          .where((s) =>
                      isSameDay(s.startDate, selectedDay) &&
                          s.status != 'cancelled' &&
                          s.status != 'complete')
                          .toList();
                      if (selectedSchedules.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  'Lịch học ngày ${DateFormat('dd/MM/yyyy').format(selectedDay)}'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: selectedSchedules.map((schedule) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Chủ đề: ${schedule.topic!}"),
                                      Text("Địa điểm: ${schedule.address!}"),
                                      const SizedBox(height: 8),
                                      Text("⏰ Lịch học cố định:"),
                                      ...schedule.slots.map((slot) {
                                        final day =
                                        FormatUtils.weekdayName(slot.weekday!);
                                        final start =
                                            "${slot.startTime?.hour.toString().padLeft(2, '0')}:${slot.startTime?.minute.toString().padLeft(2, '0')}";
                                        final end =
                                            "${slot.endTime?.hour.toString().padLeft(2, '0')}:${slot.endTime?.minute.toString().padLeft(2, '0')}";
                                        return Text("• $day: $start - $end");
                                      }),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      }
                    },
                    calendarStyle: const CalendarStyle(
                      markerDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
