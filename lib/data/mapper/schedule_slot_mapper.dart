import '../../domain/model/schedule_slot.dart';
import '../network/dto/schedule_slot_dto.dart';

extension ScheduleSlotDtoExtension on ScheduleSlotDto {
  ScheduleSlot toModel() {
    return ScheduleSlot(
      weekday,
      startTime,
      endTime,
    );
  }
}
