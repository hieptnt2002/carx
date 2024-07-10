import 'package:carx/features/presentation/delivery_address/bloc/delivery_address_event.dart';
import 'package:carx/features/presentation/delivery_address/bloc/delivery_address_state.dart';

import 'package:carx/features/reponsitories/auth/auth_reponsitory.dart';
import 'package:carx/service/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryAddressBloc
    extends Bloc<DeliveryAddressEvent, DeliveryAddressState> {
  DeliveryAddressBloc(AuthReponsitory authReponsitory)
      : super(DeliveryAddressState.initial()) {
    on<FetchDeliveryAddressesEvent>(
      (event, emit) async {
        String uId = AuthService.firebase().currentUser!.id;
        emit(state.copyWith(status: DeliveryAddressesStatus.loading));
        try {
          final deliveryAddresses =
              await authReponsitory.fetchDeliveryAddresses(uId);

          emit(state.copyWith(
            status: DeliveryAddressesStatus.success,
            deliveryAddresses: deliveryAddresses,
          ));
        } catch (e) {
          emit(state.copyWith(status: DeliveryAddressesStatus.failure));
        }
      },
    );
    on<DeliveryAddressSelectionEvent>(
      (event, emit) => emit(
        state.copyWith(deliveryAddressSelected: event.deliveryAddress),
      ),
    );
  }
}
