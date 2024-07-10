abstract class SearchEvent {}

class FetchCarsSearchEvent extends SearchEvent {
  FetchCarsSearchEvent();
}

class SearchCarsEvent extends SearchEvent {
  final String searchText;

  SearchCarsEvent(this.searchText);
}
