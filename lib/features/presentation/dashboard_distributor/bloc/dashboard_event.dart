abstract class DashboardEvent {}

class FetchDataDashboardEvent extends DashboardEvent {
  final int id;
  FetchDataDashboardEvent({required this.id});
}
