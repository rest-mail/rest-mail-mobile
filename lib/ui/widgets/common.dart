import 'package:flutter/material.dart';
import 'package:restmail_api/restmail_api.dart';

import '../../state/mailbox_state.dart';
import '../../theme/tokens.dart';

/// The bar across the top of an inner screen: a back chevron in the accent,
/// a title, and room for actions.
class RmTopBar extends StatelessWidget {
  const RmTopBar({
    super.key,
    this.title,
    this.onBack,
    this.actions = const [],
    this.trailingText,
    this.onTrailing,
  });

  final String? title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  /// A text action at the right end, such as "Save".
  final String? trailingText;
  final VoidCallback? onTrailing;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final title = this.title, trailingText = this.trailingText;
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: c.bg,
        border: Border(bottom: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          if (onBack != null)
            RmIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              tooltip: 'Back',
              color: c.accent,
              onPressed: onBack,
            )
          else
            const SizedBox(width: 12),
          if (title != null)
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: rmText(
                  16,
                  color: c.ink,
                  weight: FontWeight.w700,
                  tracking: -0.02,
                ),
              ),
            ),
          const Spacer(),
          ...actions,
          if (trailingText != null)
            TextButton(
              onPressed: onTrailing,
              child: Text(
                trailingText,
                style: rmText(
                  15,
                  color: onTrailing == null ? c.ink3 : c.accent,
                  weight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RmIconButton extends StatelessWidget {
  const RmIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    this.size = 20,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    icon: Icon(icon, size: size, color: color ?? context.rm.ink),
  );
}

/// The small capitals above a group of rows or a field.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: rmText(
      12,
      color: context.rm.ink3,
      weight: FontWeight.w700,
      tracking: 0.05,
    ),
  );
}

/// Rows in a rounded card with hairlines between them.
class RmGroup extends StatelessWidget {
  const RmGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) Divider(height: 1, color: c.line),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

/// One row in an [RmGroup]: a label, and a value, a control, or a chevron
/// when it leads somewhere.
class RmRow extends StatelessWidget {
  const RmRow({
    super.key,
    required this.label,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.danger = false,
  });

  final String label;
  final String? subtitle;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final subtitle = this.subtitle,
        value = this.value,
        trailing = this.trailing;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: rmText(
                      14.5,
                      color: danger ? c.danger : c.ink,
                      weight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle,
                        style: rmText(12.5, color: c.ink3, height: 1.35),
                      ),
                    ),
                ],
              ),
            ),
            if (value != null)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 4),
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: rmText(13.5, color: c.ink3),
                  ),
                ),
              ),
            ?trailing,
            if (trailing == null && onTap != null && !danger)
              Icon(Icons.chevron_right_rounded, size: 20, color: c.ink3),
          ],
        ),
      ),
    );
  }
}

/// The design's switch: a 46×28 pill, accent when on.
class RmSwitch extends StatelessWidget {
  const RmSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    const motion = Duration(milliseconds: 160);
    return Semantics(
      toggled: value,
      label: label,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: motion,
          width: 46,
          height: 28,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: value ? c.accent : c.line,
            borderRadius: BorderRadius.circular(99),
          ),
          child: AnimatedAlign(
            duration: motion,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A segmented control in the design's toolbar style: the chosen segment in
/// solid ink.
class RmSegmented<T> extends StatelessWidget {
  const RmSegmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.bg,
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (option, label) in options)
            Semantics(
              selected: option == value,
              button: true,
              child: GestureDetector(
                onTap: () => onChanged(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: option == value ? c.ink : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label,
                    style: rmText(
                      12,
                      color: option == value ? c.bg : c.ink2,
                      weight: FontWeight.w600,
                      tracking: -0.01,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class RmPrimaryButton extends StatelessWidget {
  const RmPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.height = 52,
    this.radius = 13,
    this.fontSize = 16,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;
  final double height;
  final double radius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final enabled = onPressed != null && !busy;
    final shape = BorderRadius.circular(radius);
    return Semantics(
      button: true,
      enabled: enabled,
      child: Opacity(
        opacity: onPressed == null && !busy ? 0.45 : 1,
        child: Material(
          color: c.accent,
          borderRadius: shape,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: shape,
            child: SizedBox(
              height: height,
              child: Center(
                child: busy
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        label,
                        style: rmText(
                          fontSize,
                          color: Colors.white,
                          weight: FontWeight.w700,
                          tracking: -0.01,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RmOutlineButton extends StatelessWidget {
  const RmOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 52,
    this.radius = 13,
    this.fontSize = 15,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: c.line),
    );
    return Material(
      type: MaterialType.transparency,
      shape: shape,
      child: InkWell(
        onTap: onPressed,
        customBorder: shape,
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(
              label,
              style: rmText(
                fontSize,
                color: color ?? c.ink2,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A square outlined button holding an icon, as beside Reply.
class RmOutlineIconButton extends StatelessWidget {
  const RmOutlineIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = 44,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(11),
      side: BorderSide(color: c.line),
    );
    return Tooltip(
      message: tooltip,
      child: Material(
        type: MaterialType.transparency,
        shape: shape,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: SizedBox.square(
            dimension: size,
            child: Icon(icon, size: 18, color: c.ink),
          ),
        ),
      ),
    );
  }
}

class SyncDot extends StatelessWidget {
  const SyncDot(this.status, {super.key});

  final LiveStatus status;

  @override
  Widget build(BuildContext context) => Container(
    width: 7,
    height: 7,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: status == LiveStatus.live ? context.rm.good : context.rm.tintAmber,
    ),
  );
}

String liveLabel(LiveStatus status) => switch (status) {
  LiveStatus.live => 'Live',
  LiveStatus.connecting => 'Connecting…',
  LiveStatus.offline => 'Offline · retrying',
};

/// A text field with no box, for rows that draw their own.
InputDecoration bareInput(
  BuildContext context,
  String hint, {
  double size = 15,
}) => InputDecoration(
  isCollapsed: true,
  filled: false,
  hintText: hint,
  hintStyle: rmText(size, color: context.rm.ink3),
  border: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  contentPadding: EdgeInsets.zero,
);

class ErrorText extends StatelessWidget {
  const ErrorText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.rm;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(Icons.error_outline_rounded, size: 17, color: c.danger),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: rmText(
              13.5,
              color: c.danger,
              weight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

/// What to tell a person about a failed request.
String describeError(Object error, {String? host}) {
  if (error is! ApiException) return 'Something went wrong.';
  final where = host ?? 'the server';
  return switch (error.code) {
    'network_error' => "Can't reach $where.",
    'timeout' => '$where took too long to answer.',
    'tls_error' => "$where's certificate isn't trusted.",
    'http_404' => 'No rest-mail server at $where.',
    'bad_response' => "$where didn't answer like a rest-mail server.",
    _ => error.message,
  };
}

void showToast(BuildContext context, String message, {SnackBarAction? action}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: action,
        duration: Duration(milliseconds: action == null ? 2200 : 4000),
      ),
    );
}

/// Asks before doing something that cannot be taken back.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String action,
}) async {
  final c = context.rm;
  final answer = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: rmText(14.5, color: c.ink2, weight: FontWeight.w600),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            action,
            style: rmText(14.5, color: c.danger, weight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
  return answer ?? false;
}
