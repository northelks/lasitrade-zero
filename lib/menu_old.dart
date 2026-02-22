// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class PlatformMenuBarExample extends StatefulWidget {
//   const PlatformMenuBarExample({super.key});

//   @override
//   State<PlatformMenuBarExample> createState() => _PlatformMenuBarExampleState();
// }

// class _PlatformMenuBarExampleState extends State<PlatformMenuBarExample> {
//   String _message = 'Hello';
//   bool _showMessage = false;

//   @override
//   Widget build(BuildContext context) {
//     ////////////////////////////////////
//     // THIS SAMPLE ONLY WORKS ON MACOS.
//     ////////////////////////////////////

//     // This builds a menu hierarchy that looks like this:
//     // Flutter API Sample
//     //  ├ About
//     //  ├ ────────  (group divider)
//     //  ├ Hide/Show Message
//     //  ├ Messages
//     //  │  ├ I am not throwing away my shot.
//     //  │  └ There's a million things I haven't done, but just you wait.
//     //  └ Quit
//     return PlatformMenuBar(
//       menus: <PlatformMenu>[
//         PlatformMenu(
//           label: 'lasitrade',
//           menus: <PlatformMenuItem>[
//             PlatformMenuItemGroup(
//               members: <PlatformMenuItem>[
//                 PlatformMenuItem(
//                   label: 'New',
//                   shortcut: const SingleActivator(LogicalKeyboardKey.keyN,
//                       meta: true),
//                   onSelected: () {
//                     // Action for 'New'
//                   },
//                 ),
//                 PlatformMenuItem(
//                   label: 'Open',
//                   shortcut:
//                       SingleActivator(LogicalKeyboardKey.keyO, meta: true),
//                   onSelected: () {
//                     // Action for 'Open'
//                   },
//                 ),
//               ],
//             ),
//             PlatformMenuItemGroup(
//               members: <PlatformMenuItem>[
//                 PlatformMenuItem(
//                   label: 'Quit',
//                   shortcut:
//                       SingleActivator(LogicalKeyboardKey.keyQ, meta: true),
//                   onSelected: () {
//                     // Action to quit the app
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         PlatformMenu(
//           label: 'Edit',
//           menus: <PlatformMenuItem>[
//             PlatformMenuItem(
//               label: 'Cut',
//               shortcut:
//                   const SingleActivator(LogicalKeyboardKey.keyX, meta: true),
//               onSelected: () {},
//             ),
//             PlatformMenuItem(
//               label: 'Copy',
//               shortcut: SingleActivator(LogicalKeyboardKey.keyC, meta: true),
//               onSelected: () {
//                 // Action for 'Copy'
//               },
//             ),
//             PlatformMenuItem(
//               label: 'Paste',
//               shortcut: SingleActivator(LogicalKeyboardKey.keyV, meta: true),
//               onSelected: () {
//                 // Action for 'Paste'
//               },
//             ),
//           ],
//         ),
//         PlatformMenu(
//           label: 'Castopn',
//           menus: <PlatformMenuItem>[
//             PlatformMenuItem(
//               label: 'Cut',
//               shortcut:
//                   const SingleActivator(LogicalKeyboardKey.keyX, meta: true),
//               onSelected: () {},
//             ),
//             PlatformMenuItem(
//               label: 'Copy',
//               shortcut: SingleActivator(LogicalKeyboardKey.keyC, meta: true),
//               onSelected: () {
//                 // Action for 'Copy'
//               },
//             ),
//             PlatformMenuItem(
//               label: 'Paste',
//               shortcut: SingleActivator(LogicalKeyboardKey.keyV, meta: true),
//               onSelected: () {
//                 // Action for 'Paste'
//               },
//             ),
//           ],
//         ),
//       ],
//       // child: const Scaffold(
//       //   child: Center(
//       //     child: Text('Your App Content Here'),
//       //   ),
//       // ),
//     );
//   }
// }
