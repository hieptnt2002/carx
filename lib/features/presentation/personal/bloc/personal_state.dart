import 'package:carx/features/model/distributor.dart';
import 'package:carx/features/model/user.dart';
import 'package:equatable/equatable.dart';

enum FetchUserStatus { initial, loading, success, failure }

class PersonalState extends Equatable {
  final User? user;
  final FetchUserStatus fetchUserStatus;
  final Distributor? distributor;
  const PersonalState({
    required this.user,
    this.distributor,
    required this.fetchUserStatus,
  });
  const PersonalState.initial()
      : user = null,
        distributor = null,
        fetchUserStatus = FetchUserStatus.initial;

  PersonalState copyWith({
    User? user,
    Distributor? distributor,
    FetchUserStatus? fetchUserStatus,
  }) =>
      PersonalState(
        user: user ?? this.user,
        distributor: distributor ?? this.distributor,
        fetchUserStatus: fetchUserStatus ?? this.fetchUserStatus,
      );
  @override
  List<Object?> get props => [user, distributor, fetchUserStatus];
}
