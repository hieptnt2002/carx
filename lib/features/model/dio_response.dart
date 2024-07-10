class DioReponse {
  final String status;
  final dynamic data;
  const DioReponse({required this.status, required this.data});
  factory DioReponse.fromJson(Map<String, dynamic> json) => DioReponse(
        status: json['status'],
        data: json['data'],
      );
}
