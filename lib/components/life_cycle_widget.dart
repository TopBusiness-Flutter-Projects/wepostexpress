import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:rect_getter/rect_getter.dart';

class LifeCycleWidget extends StatefulWidget {
    LifeCycleWidget(
            {this.onCreated, this.child, this.onDestroyed, this.onMounted});

    final VoidCallback onCreated;
    final Widget child;
    final VoidCallback onDestroyed;
    final void Function(Rect) onMounted;

    @override
    _LifeCycleWidgetState createState() => _LifeCycleWidgetState();
}

class _LifeCycleWidgetState extends State<LifeCycleWidget>
        with AfterLayoutMixin {
    @override
    void afterFirstLayout(BuildContext context) {
        if (widget.onMounted != null)
            widget.onMounted(RectGetter.getRectFromKey(rectKey));
    }

    final rectKey = RectGetter.createGlobalKey();

    @override
    void initState() {
        if (widget.onCreated != null) widget.onCreated();
        super.initState();
    }

    @override
    void dispose() {
        if (widget.onDestroyed != null) widget.onDestroyed();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return RectGetter(
            key: rectKey,
            child: widget.child,
        );
    }
}