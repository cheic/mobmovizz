import 'package:bloc/bloc.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_bar_items.dart';
import 'package:mobmovizz/core/widgets/navigation/nav_bar_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavbarItem.home, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(const NavigationState(NavbarItem.home, 0));
        break;
      case NavbarItem.genre:
        emit(const NavigationState(NavbarItem.genre, 1));
        break;
      case NavbarItem.search:
        emit(const NavigationState(NavbarItem.search, 2));
        break;
      case NavbarItem.favorites:
        emit(const NavigationState(NavbarItem.favorites, 3));
        break;
    }
  }
}
