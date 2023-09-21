import 'package:advisorapp/config/size_config.dart';
import 'package:advisorapp/style/colors.dart';
import 'package:flutter/material.dart';

class GroupConversation extends StatelessWidget {
  const GroupConversation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: SizeConfig.blockSizeVertical * 5,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.only(left: 40.0, right: 5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.white),
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.iconGray),
                hintText: 'Search a Person or Group to Chat',
                hintStyle:
                    const TextStyle(color: AppColors.secondary, fontSize: 14)),
          ),
        ],
      ),
      SizedBox(
        height: SizeConfig.blockSizeVertical * 2,
      )
    ]);
  }
}
