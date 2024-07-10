abstract class CategoriesEvent {}

class FetchDataEvent extends CategoriesEvent {
  FetchDataEvent();
}

class BrandSelectionTabEvent extends CategoriesEvent {
  final int selectedTab;
  final String brandName;
  BrandSelectionTabEvent({required this.selectedTab, required this.brandName});
}
