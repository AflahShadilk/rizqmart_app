/// Base class identifying whether the dashboard search is active or idle.
abstract class DashboardSearchState {}

class DashboardSearchIdle extends DashboardSearchState {}

class DashboardSearchActive extends DashboardSearchState {
  final String query;
  DashboardSearchActive(this.query);
}