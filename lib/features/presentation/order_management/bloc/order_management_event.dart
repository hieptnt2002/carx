class OrderManagementEvent {}

class FetchOrderManagementEvent extends OrderManagementEvent {
  FetchOrderManagementEvent();
}

class FetchOrderManagementByStatusEvent extends OrderManagementEvent {
  final String status;

  FetchOrderManagementByStatusEvent({required this.status});
}
