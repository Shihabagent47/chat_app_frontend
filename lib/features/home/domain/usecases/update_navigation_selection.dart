import '../../data/repositories/navigation_repository.dart';

class UpdateNavigationSelection {
  final NavigationRepository repository;

  UpdateNavigationSelection(this.repository);

  Future<void> call(int index) async {
    await repository.updateSelectedItem(index);
  }
}
