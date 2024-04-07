import 'package:btl/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:btl/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:btl/utils/consts/colors.dart';
import 'package:flutter/material.dart';

/// A container widget with a primary color background and curved edges.
class TPrimaryHeaderContainer extends StatelessWidget {
  /// Create a container with a primary color background and curved edges.
  ///
  /// Parameters:
  ///   - child: The widget to be placed inside the container.
  const TPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        color: MyColors.primary,
        padding: const EdgeInsets.only(bottom: 0),

        /// -- If [size.isFinite': is not true.in Stack] error occurred -> Read README.md file at [DESIGN ERRORS] # 1
        child: Stack(
          children: [
            /// -- Background Custom Shapes
            Positioned(
                top: -150, right: -250, child: TCircularContainer(backgroundColor: MyColors.textWhite.withOpacity(0.1))),
            Positioned(
                top: 100, right: -300, child: TCircularContainer(backgroundColor: MyColors.textWhite.withOpacity(0.1))),
            child,
          ],
        ),
      ),
    );
  }
}