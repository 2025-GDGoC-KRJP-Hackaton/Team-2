import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/app/screens/home/logic/home_provider.dart';
import 'package:remember_me/app/screens/home/logic/home_state.dart';

class HomeBottomBar extends ConsumerWidget {
  const HomeBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(homeProvider).selectedTab;
    return SafeArea(
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, left: 17),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    ref.read(homeProvider.notifier).setTab(HomeTabs.record);
                  },
                  child: Container(
                    height: 50 + kToolbarHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),

                      color:
                          selectedTab == HomeTabs.record
                              ? Colors.grey.shade300
                              : null,
                    ),
                    child: Tab(icon: Icon(Icons.mic)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 17, left: 10),
                child: InkWell(
                  onTap: () {
                    ref.read(homeProvider.notifier).setTab(HomeTabs.answer);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 50 + kToolbarHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),

                      color:
                          selectedTab == HomeTabs.answer
                              ? Colors.grey.shade300
                              : null,
                    ),
                    child: Tab(icon: Icon(Icons.chat)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
