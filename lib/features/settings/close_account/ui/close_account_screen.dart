import 'package:flutter/material.dart';
import 'package:giv_flutter/base/base_state.dart';
import 'package:giv_flutter/features/base/base.dart';
import 'package:giv_flutter/features/settings/close_account/bloc/close_account_bloc.dart';
import 'package:giv_flutter/features/settings/close_account/ui/create_cancellation_intent_screen.dart';
import 'package:giv_flutter/features/settings/close_account/ui/delete_me_screen.dart';
import 'package:giv_flutter/util/presentation/custom_app_bar.dart';
import 'package:giv_flutter/util/presentation/custom_scaffold.dart';

class CloseAccountScreen extends StatefulWidget {
  final CloseAccountBloc bloc;

  const CloseAccountScreen({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  @override
  _CloseAccountScreenState createState() => _CloseAccountScreenState();
}

class _CloseAccountScreenState extends BaseState<CloseAccountScreen> {
  CloseAccountBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _bloc.statusStream.listen(_handleStatusEvent);
    _bloc.errorMessageStream.listen(_handleErrorMessageEvent);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final deleteMeConfirmationText =
        string('close_account_confirmation_string');

    final defaultCreateCancellationScreen = CreateCancellationIntentScreen(
      onCancelPressed: _close,
      onContinuePressed: _createInent,
    );

    final defaultDeleteMeScreen = DeleteMeScreen(
      onCancelPressed: _close,
      onContinuePressed: _sendDeleteMeRequest,
      confirmationText: deleteMeConfirmationText,
    );

    return CustomScaffold(
      appBar: CustomAppBar(
        title: string('settings_section_account_close_account'),
      ),
      body: StreamBuilder<AccountCancellationStatus>(
          stream: _bloc.statusStream,
          builder: (
            BuildContext context,
            AsyncSnapshot<AccountCancellationStatus> snapshot,
          ) {
            switch (snapshot.data) {
              case AccountCancellationStatus.sendingIntent:
                return CreateCancellationIntentScreen(
                  isLoading: true,
                );
                break;
              case AccountCancellationStatus.errorSendingIntent:
                return defaultCreateCancellationScreen;
                break;
              case AccountCancellationStatus.intentSent:
                return defaultDeleteMeScreen;
                break;
              case AccountCancellationStatus.deletingAccount:
                return DeleteMeScreen(
                  isLoading: true,
                  confirmationText: deleteMeConfirmationText,
                );
                break;
              case AccountCancellationStatus.errorDeletingAccount:
                return defaultDeleteMeScreen;
                break;
              default:
                return defaultCreateCancellationScreen;
            }
          }),
    );
  }

  void _createInent() {
    _bloc.createIntent();
  }

  void _sendDeleteMeRequest() {
    _bloc.deleteMe();
  }

  void _close() {
    navigation.pop();
  }

  void _handleStatusEvent(AccountCancellationStatus event) {
    if (event == AccountCancellationStatus.accountDeleted) {
      print('accountDeleted');
      navigation.push(Base(), clearStack: true);
    }
  }

  void _handleErrorMessageEvent(String event) {
    showGenericErrorDialog(
      message:
          'Olá, eu estou tentando encerrar minha conta, mas ocorreu este erro: $event.',
    );
  }
}
