// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:tutorconnect/data/manager/account.dart';
// import 'package:tutorconnect/domain/models/schedule_model.dart';
// import 'package:tutorconnect/di/di.dart';
// import 'package:tutorconnect/presentation/navigation/route_model.dart';
// import 'package:tutorconnect/presentation/screens/scheduall/schedule_bloc.dart';
// import 'package:tutorconnect/presentation/screens/scheduall/schedule_state.dart';
//
// import '../../../common/utils/format_utils.dart';
// import '../../../theme/color_platte.dart';
// import '../../../theme/text_styles.dart';
//
// class ScheduleScreen extends StatefulWidget {
//   const ScheduleScreen({super.key});
//
//   @override
//   State<ScheduleScreen> createState() => _ScheduleScreenState();
// }
//
// class _ScheduleScreenState extends State<ScheduleScreen> {
//   final _bloc = getIt<ScheduleBloc>();
//   final user = Account.instance.user;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _bloc.listenSchedule(user.uid, role: user.role);
//
//     _bloc.updateScheduleBroadcast.listen((state) {
//       state.when(
//         loading: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Đang lên lịch nhắc nhở'),
//               duration: Duration(seconds: 2),
//             ),
//           );
//         },
//         success: (_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Đã lên lịch nhắc nhở cho ${user.role}'),
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         },
//         failure: (message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(message),
//               duration: const Duration(seconds: 2),
//             ),
//           );
//         },
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ScheduleBloc, ScheduleState>(
//       bloc: _bloc,
//       builder: (context, state) {
//         if (state is ScheduleLoadingState) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is ScheduleSuccessState) {
//           final schedules = state.schedules;
//           return _buiLdContent(schedules);
//         } else if (state is ScheduleFailureState) {
//           return Center(
//             child: Text(state.error),
//           );
//         }
//         return const Center(child: Text('Lịch học trống'));
//       },
//     );
//   }
//
//   Widget _buiLdContent(List<ScheduleModel> schedules) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lịch học'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Text('Lịch học của bạn',
//                 style: AppTextStyles(context).bodyText1.copyWith(
//                       fontSize: 20,
//                     )),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: schedules.length,
//                 itemBuilder: (context, index) {
//                   return _buildScheduleMessage(schedules[index],context);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildScheduleMessage(ScheduleModel schedule, BuildContext context) {
//     return InkWell(
//       child: Container(
//         width: double.infinity - 16,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.purple.shade100,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: const [
//                 Icon(Icons.calendar_month, color: Colors.deepPurple, size: 20),
//                 SizedBox(width: 8),
//                 Text(
//                   "Lịch học đã lên lịch",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const Divider(),
//             _buildInfoRow("Gia sư", schedule.tutorName),
//             _buildInfoRow("Học viên", schedule.studentName),
//             _buildInfoRow("Chủ đề", schedule.topic),
//             _buildInfoRow("Địa điểm", schedule.address),
//             _buildInfoRow("Bắt đầu từ",
//                 DateFormat('dd/MM/yyyy').format(schedule.startDate)),
//             _buildInfoRow("Trạng thái", _formatStatus(schedule.status)),
//             const SizedBox(height: 8),
//             Text("⏰ Lịch học cố định:",
//                 style: AppTextStyles(context).bodyText1.copyWith(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                     )),
//             const SizedBox(height: 4),
//             ...schedule.slots.map((slot) {
//               final day = FormatUtils.weekdayName(slot.weekday);
//               final start =
//                   "${slot.startTime.hour.toString().padLeft(2, '0')}:${slot.startTime.minute.toString().padLeft(2, '0')}";
//               final end =
//                   "${slot.endTime.hour.toString().padLeft(2, '0')}:${slot.endTime.minute.toString().padLeft(2, '0')}";
//               return Padding(
//                 padding: const EdgeInsets.only(top: 2.0),
//                 child: Text("• $day: $start - $end",
//                     style: AppTextStyles(context).bodyText2.copyWith(
//                           color: AppColors.color600,
//                           fontSize: 14,
//                         )),
//               );
//             }),
//             const SizedBox(height: 12),
//             if (user.role == "Học sinh" && schedule.status == "pending")
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _bloc.updateScheduleStatus(schedule.id, 'cancelled');
//                       });
//                     },
//                     child: const Text('Hủy'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       _bloc.approveSchedule(schedule.id);
//                     },
//                     child: const Text('Chấp nhận'),
//                   )
//                 ],
//               )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0),
//       child: Row(
//         children: [
//           Text("$label: ",
//               style: AppTextStyles(context).bodyText1.copyWith(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   )),
//           Expanded(
//             child: Text(
//               value,
//               overflow: TextOverflow.ellipsis,
//               style: AppTextStyles(context)
//                   .bodyText2
//                   .copyWith(color: AppColors.color600),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatStatus(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return 'Chờ xác nhận';
//       case 'approved':
//         return 'Đã hoàn thành';
//       case 'cancelled':
//         return 'Đã hủy';
//       default:
//         return status;
//     }
//   }
// }
