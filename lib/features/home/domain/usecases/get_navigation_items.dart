import 'package:chat_app_user/features/home/data/models/navigation_item.dart';

import '../../data/repositories/navigation_repository.dart';

class GetNavigationItems {
  final NavigationRepository repository;

  GetNavigationItems(this.repository);

  List<NavigationItem> call() {
    return repository.getNavigationItems();
  }
}
