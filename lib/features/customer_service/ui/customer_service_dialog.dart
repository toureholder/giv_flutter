import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/customer_service/bloc/customer_service_dialog_bloc.dart';
import 'package:giv_flutter/util/navigation/navigation.dart';
import 'package:giv_flutter/util/presentation/alert_dialog_widgets.dart';

class CustomerServiceDialog extends StatefulWidget {
  final String message;
  final CustomerServiceDialogBloc bloc;
  final bool showNoMore;

  const CustomerServiceDialog({
    Key key,
    @required this.bloc,
    this.message,
    this.showNoMore,
  }) : super(key: key);

  @override
  _CustomerServiceDialogState createState() => _CustomerServiceDialogState();
}

class _CustomerServiceDialogState extends BaseState<CustomerServiceDialog> {
  bool _showNoMore;
  CustomerServiceDialogBloc _bloc;

  @override
  void initState() {
    super.initState();
    _showNoMore = widget.showNoMore ?? false;
    _bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      title: AlertDialogTitle(
        text: string('customer_service_dialog_title'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AlertDialogContent(
            text: string('customer_service_dialog_content'),
          ),
          Row(
            children: <Widget>[
              AlertDialogCheckBox(
                value: _showNoMore,
                onChanged: (bool newValue) {
                  setState(() {
                    _showNoMore = newValue;
                  });
                },
              ),
              AlertDialogCheckBoxText(
                text: string('shared_dont_show_this_again'),
              ),
            ],
          )
        ],
      ),
      actions: <Widget>[
        AlertDialogCancelButton(
          onPressed: () {
            Navigation(context).pop();
          },
        ),
        AlertDialogConfirmButton(onPressed: () async {
          if (_showNoMore) await _bloc.setHasAgreedToCustomerService();
          _bloc.launchCustomerService(widget.message);
          Navigation(context).pop();
        })
      ],
    );
  }
}
