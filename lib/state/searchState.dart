import 'package:therapistapp/helper/enum.dart';
import 'package:therapistapp/helper/utility.dart';
import 'package:therapistapp/model/user.dart';
import 'appState.dart';

class SearchState extends AppState {
  bool isBusy = false;
  SortUser sortBy = SortUser.MaxFollower;
  List<UserModel>? _userFilterList;
  List<UserModel>? _userlist;

  List<UserModel>? get userlist {
    if (_userFilterList == null) {
      return null;
    } else {
      return List.from(_userFilterList!);
    }
  }

  /// get [UserModel list] from static data
  void getDataFromDatabase() {
    try {
      isBusy = true;
      _userlist = <UserModel>[
        UserModel(
          key: '1',
          email: 'user1@example.com',
          userId: 'user1',
          displayName: 'User One',
          userName: 'userone',
          followers: 100,
          following: 50,
          createdAt: '2022-01-01',
          isVerified: true,
        ),
        UserModel(
          key: '2',
          email: 'user2@example.com',
          userId: 'user2',
          displayName: 'User Two',
          userName: 'usertwo',
          followers: 200,
          following: 150,
          createdAt: '2022-02-01',
          isVerified: false,
        ),
      ];
      _userFilterList = List.from(_userlist!);
      _userFilterList!.sort((x, y) => y.followers!.compareTo(x.followers!));
      notifyListeners();
      isBusy = false;
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  /// It will reset filter list
  /// If user has use search filter and change screen and came back to search screen It will reset user list.
  /// This function call when search page open.
  void resetFilterList() {
    if (_userlist != null && _userlist!.length != _userFilterList!.length) {
      _userFilterList = List.from(_userlist!);
      _userFilterList!.sort((x, y) => y.followers!.compareTo(x.followers!));
      // notifyListeners();
    }
  }

  /// This function call when search fiels text change.
  /// UserModel list on  search field get filter by `name` string
  void filterByUsername(String? name) {
    if (name != null &&
        name.isEmpty &&
        _userlist != null &&
        _userlist!.length != _userFilterList!.length) {
      _userFilterList = List.from(_userlist!);
    }
    // return if userList is empty or null
    if (_userlist == null && _userlist!.isEmpty) {
      cprint("User list is empty");
      return;
    }
    // sortBy userlist on the basis of username
    else if (name != null) {
      _userFilterList = _userlist!
          .where((x) =>
              x.userName != null &&
              x.userName!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  /// Sort user list on search user page.
  set updateUserSortPrefrence(SortUser val) {
    sortBy = val;
    notifyListeners();
  }

  String get selectedFilter {
    switch (sortBy) {
      case SortUser.Alphabetically:
        _userFilterList!
            .sort((x, y) => x.displayName!.compareTo(y.displayName!));
        return "Alphabetically";

      case SortUser.MaxFollower:
        _userFilterList!.sort((x, y) => y.followers!.compareTo(x.followers!));
        return "Popular";

      case SortUser.Newest:
        _userFilterList!.sort((x, y) => DateTime.parse(y.createdAt!)
            .compareTo(DateTime.parse(x.createdAt!)));
        return "Newest user";

      case SortUser.Oldest:
        _userFilterList!.sort((x, y) => DateTime.parse(x.createdAt!)
            .compareTo(DateTime.parse(y.createdAt!)));
        return "Oldest user";

      case SortUser.Verified:
        _userFilterList!.sort((x, y) =>
            y.isVerified.toString().compareTo(x.isVerified.toString()));
        return "Verified user";

      default:
        return "Unknown";
    }
  }

  /// Return user list relative to provided `userIds`
  /// Method is used on
  List<UserModel> userList = [];
  List<UserModel> getuserDetail(List<String> userIds) {
    final list = _userlist!.where((x) {
      if (userIds.contains(x.key)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    return list;
  }
}
