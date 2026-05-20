import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../services/user_profile_service.dart';

class AppUserHeader extends StatefulWidget implements PreferredSizeWidget {
  const AppUserHeader({
    super.key,
    this.includeSafeArea = true,
    this.showBackground = true,
    this.showBorder = true,
    this.showShadow = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.height,
    this.avatarIconColor = const Color(0xFF64748B),
    this.profileRoute = '/profile',
  });

  final bool includeSafeArea;
  final bool showBackground;
  final bool showBorder;
  final bool showShadow;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? height;
  final Color avatarIconColor;
  final String profileRoute;

  @override
  Size get preferredSize => Size.fromHeight(height ?? 72.h);

  @override
  State<AppUserHeader> createState() => _AppUserHeaderState();
}

class _AppUserHeaderState extends State<AppUserHeader> {
  final UserProfileService _profileService = UserProfileService();
  late final Future<String> _displayNameFuture;

  @override
  void initState() {
    super.initState();
    _displayNameFuture = _profileService.currentDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding ?? 20.w,
        vertical: widget.verticalPadding ?? 12.h,
      ),
      decoration: BoxDecoration(
        color:
            widget.showBackground
                ? Colors.white.withValues(alpha: 0.95)
                : Colors.transparent,
        border:
            widget.showBorder
                ? const Border(bottom: BorderSide(color: Color(0xFFE8F8F1)))
                : null,
        boxShadow:
            widget.showShadow
                ? [
                  BoxShadow(
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                    color: Colors.black.withValues(alpha: 0.04),
                  ),
                ]
                : null,
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 26.sp,
            color: const Color(0xFF1C274C),
          ),
          const Spacer(),
          FutureBuilder<String>(
            future: _displayNameFuture,
            builder: (context, snapshot) {
              final displayName = snapshot.data ?? 'User';

              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  ),
                  SizedBox(
                    width: 160.w,
                    child: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF191C1D),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.go(widget.profileRoute),
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: const Color(0xFFEEF2F3),
              child: Icon(
                Icons.person,
                size: 23.sp,
                color: widget.avatarIconColor,
              ),
            ),
          ),
        ],
      ),
    );

    if (!widget.includeSafeArea) {
      return content;
    }

    return SafeArea(bottom: false, child: content);
  }
}

class CurrentUserNameText extends StatefulWidget {
  const CurrentUserNameText({
    super.key,
    required this.builder,
    this.loadingName = 'User',
  });

  final Widget Function(BuildContext context, String displayName) builder;
  final String loadingName;

  @override
  State<CurrentUserNameText> createState() => _CurrentUserNameTextState();
}

class CurrentUserEmailText extends StatelessWidget {
  CurrentUserEmailText({super.key, required this.builder});

  final Widget Function(BuildContext context, String email) builder;
  final UserProfileService _profileService = UserProfileService();

  @override
  Widget build(BuildContext context) {
    return builder(context, _profileService.currentEmail());
  }
}

class AppPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.showBackButton = true,
    this.opensDrawer = false,
    this.fallbackRoute,
    this.actions,
  });

  final String title;
  final bool centerTitle;
  final bool showBackButton;
  final bool opensDrawer;
  final String? fallbackRoute;
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.95),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading:
          showBackButton || opensDrawer
              ? Builder(
                builder: (innerContext) {
                  return IconButton(
                    icon: Icon(
                      opensDrawer
                          ? Icons.menu_rounded
                          : Icons.arrow_back_rounded,
                      color: const Color(0xFF171D17),
                    ),
                    onPressed: () {
                      if (opensDrawer) {
                        Scaffold.maybeOf(innerContext)?.openDrawer();
                        return;
                      }

                      if (context.canPop()) {
                        context.pop();
                      } else if (fallbackRoute != null) {
                        context.go(fallbackRoute!);
                      }
                    },
                  );
                },
              )
              : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF171D17),
        ),
      ),
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFE8F8F1)),
      ),
    );
  }
}

class _CurrentUserNameTextState extends State<CurrentUserNameText> {
  final UserProfileService _profileService = UserProfileService();
  late final Future<String> _displayNameFuture;

  @override
  void initState() {
    super.initState();
    _displayNameFuture = _profileService.currentDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _displayNameFuture,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot.data ?? widget.loadingName);
      },
    );
  }
}
