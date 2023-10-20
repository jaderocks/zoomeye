class SearchFilterAdditive {
  String? txtNameText;
  String? nameContains;
  String? nameStartsWith;
  String? nameEndsWith;
  int? nameRadioValue = 1;
  String? noteContains;
  // double? minPrice;
  // double? maxPrice;
  bool? isActive;
  bool? isNotActive;
  // int? selectedCategoryId;
  static bool showIsDeleted = false;
  static void resetSearchFilter() {
    __instance = SearchFilterAdditive();
  }

  static SearchFilterAdditive? __instance;
  static SearchFilterAdditive get getValues {
    return __instance = __instance ?? SearchFilterAdditive()
      ..nameRadioValue = 1;
  }
}
