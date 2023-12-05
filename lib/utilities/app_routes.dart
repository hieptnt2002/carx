// ignore_for_file: equal_keys_in_map

import 'package:carx/data/presentation/add_delivery_address/add_delivery_address_screen.dart';
import 'package:carx/data/presentation/car_by_brand/car_by_brand_screen.dart';
import 'package:carx/data/presentation/car_detail/ui/detail_screen.dart';
import 'package:carx/data/presentation/distributor_manage_orders/distributor_manage_orders.dart';
import 'package:carx/data/presentation/delivery_address/delivery_address_screen.dart';
import 'package:carx/data/presentation/add_delivery_address/edit_delivery_address_screen.dart';
import 'package:carx/data/presentation/distributor_manage_orders/distributor_manage_orders_detail.dart';
import 'package:carx/data/presentation/edit_profile/ui/edit_profile_screen.dart';
import 'package:carx/data/presentation/order/order_screen.dart';
import 'package:carx/data/presentation/order_management/ui/car_rental_booking.dart';
import 'package:carx/data/presentation/order_management_detail/ui/car_rental_booking_detail.dart';
import 'package:carx/data/presentation/order_success/order_success_view.dart';
import 'package:carx/data/presentation/payment/ui/payment_screen.dart';
import 'package:carx/data/presentation/search/ui/search_view.dart';
import 'package:carx/data/presentation/dashboard_distributor/distributor_dashboard_view.dart';

import 'package:carx/view/favorite_screen.dart';
import 'package:carx/view/login/login_view.dart';
import 'package:carx/view/login/register_view.dart';

import 'package:carx/view/main_view.dart';
import 'package:path/path.dart';



class Routes {
  static final pages = {
    routeLogin: (context) => const LoginView(),
    routeRegister: (context) => const RegisterView(),
    routeCarDetail: (context) => const CarDetailView(),
    routeMain: (context) => const MainView(),
    routeEditProfile: (context) => const EditProfileScreen(),
    routeOrder: (context) => const OrderView(),
    routeOrderSuccess: (context) => const OrderSucess(),
    routePayment: (context) => const PaymentSreen(),
    routeSearch: (context) => const SearchView(),
    routeOrderDetail: (context) => const CarRentalBookingDetail(),
    routeAllOrder: (context) => const CarRentalBooking(),
    routeCarByBrand: (context) => const CarByBrandScreen(),
    routeDeliveryAddresses: (context) => const DeliveryAddressScreen(),
    routeAddDeliveryAddresses: (context) => const AddDeliveryAddressScreen(),
    routeEditDeliveryAddresses: (context) => const EditDeliveryAddressScreen(),
    routeFavorite: (context) => const FavoriteScreen(),
    routeManageDistributor: (context) => const DistributorDashboard(),
     routeManageOrders: (context) => const DistributorManageOrders(),
     routeManageOrderDetails : (context) => const ManageOrdersDetail()
  };
  static const routeRegister = '/register';
  static const routeLogin = '/login';
  static const routeCarDetail = '/car_detail';
  static const routeMain = '/main';
  static const routeEditProfile = '/edit_profile';
  static const routeOrder = '/order';
  static const routeOrderSuccess = '/order_success';
  static const routePayment = '/payment';
  static const routeSearch = '/search';
  static const routeAllOrder = '/all_order';
  static const routeOrderDetail = '/order_detail';
  static const routeCarByBrand = '/car_by_brand';
  static const routeDeliveryAddresses = '/delivery_addresses';
  static const routeAddDeliveryAddresses = '/add_delivery_addresses';
  static const routeEditDeliveryAddresses = '/edit_delivery_addresses';
  static const routeFavorite = '/favorite';
  static const routeManageDistributor = '/manage_distributors';
  static const routeManageOrders = '/manage_orders';
  static const routeManageOrderDetails = '/manage_order_details';
}
