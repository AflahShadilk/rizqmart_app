abstract class DashboardSearchState {}

class DashboardSearchIdle extends DashboardSearchState {}

class DashboardSearchActive extends DashboardSearchState {
  final String query;
  DashboardSearchActive(this.query);
}