import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobmovizz/core/widgets/navigation/rive_model.dart';
import 'package:rive/rive.dart';


class RiveBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItemModel> items;

  const RiveBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<RiveBottomNavBar> createState() => _RiveBottomNavBarState();
}

class _RiveBottomNavBarState extends State<RiveBottomNavBar> {
  List<SMIInput<bool>?> inputs = [];
  List<Artboard> riveArtboards = [];

  @override
  void initState() {
    super.initState();
    loadRiveFiles();
  }

  void loadRiveFiles() async {
    for (var item in widget.items) {
      final bytes = await rootBundle.load('assets/rive/${item.title.toLowerCase()}_icon.riv');
      final file = RiveFile.import(bytes);
      final artboard = file.mainArtboard;
      
      StateMachineController? controller = StateMachineController.fromArtboard(artboard, item.rive.stateMachineName);
      if (controller != null) {
        artboard.addController(controller);
        SMIInput<bool>? input = controller.findInput<bool>('active');
        inputs.add(input);
        riveArtboards.add(artboard);
      }
    }
    setState(() {});
  }

  void updateActiveInput(int index) {
    for (int i = 0; i < inputs.length; i++) {
      inputs[i]?.value = i == index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) {
        updateActiveInput(index);
        widget.onTap(index);
      },
      items: List.generate(widget.items.length, (index) {
        return BottomNavigationBarItem(
          icon: riveArtboards.isNotEmpty
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: Rive(
                    artboard: riveArtboards[index],
                    fit: BoxFit.contain,
                  ),
                )
              : Icon(widget.items[index].icon),
          label: widget.items[index].title,
        );
      }),
    );
  }
}