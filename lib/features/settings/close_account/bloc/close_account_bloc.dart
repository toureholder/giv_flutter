import 'package:flutter/foundation.dart';
import 'package:giv_flutter/base/base_bloc.dart';
import 'package:giv_flutter/model/user/repository/user_repository.dart';
import 'package:giv_flutter/service/preferences/disk_storage_provider.dart';
import 'package:giv_flutter/service/session/session_provider.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class CloseAccountBloc extends BaseBloc {
  final DiskStorageProvider diskStorage;
  final UserRepository userRepository;
  final SessionProvider session;
  final PublishSubject<AccountCancellationStatus> statusPublishSubject;
  final PublishSubject<String> errorMessageSubject;

  Observable<AccountCancellationStatus> get statusStream =>
      statusPublishSubject.stream;

  Observable<String> get errorMessageStream => errorMessageSubject.stream;

  CloseAccountBloc({
    @required this.diskStorage,
    @required this.userRepository,
    @required this.statusPublishSubject,
    @required this.errorMessageSubject,
    @required this.session,
  }) : super(diskStorage: diskStorage);

  Future<void> createIntent() async {
    statusPublishSubject.add(AccountCancellationStatus.sendingIntent);

    try {
      final result = await userRepository.createAccountCancellationIntent();

      if (result != null && result.status == HttpStatus.created) {
        statusPublishSubject.add(AccountCancellationStatus.intentSent);
        return;
      } else {
        statusPublishSubject.add(AccountCancellationStatus.errorSendingIntent);
        errorMessageSubject.add(
          '${result.status.toString()}: ${result.message}',
        );
      }
    } catch (e) {
      statusPublishSubject.add(AccountCancellationStatus.errorSendingIntent);
      errorMessageSubject.add(e.toString());
      return;
    }
  }

  Future<void> deleteMe() async {
    statusPublishSubject.add(AccountCancellationStatus.deletingAccount);

    try {
      final result = await userRepository.deleteMe();

      if (result != null && result.status == HttpStatus.ok) {
        await session.logUserOut();
        statusPublishSubject.add(AccountCancellationStatus.accountDeleted);
        return;
      } else {
        statusPublishSubject.add(
          AccountCancellationStatus.errorDeletingAccount,
        );

        errorMessageSubject.add(
          '${result.status.toString()}: ${result.message}',
        );
      }
    } catch (e) {
      statusPublishSubject.add(AccountCancellationStatus.errorDeletingAccount);
      errorMessageSubject.add(e.toString());
      return;
    }
  }
}

enum AccountCancellationStatus {
  sendingIntent,
  errorSendingIntent,
  intentSent,
  deletingAccount,
  errorDeletingAccount,
  accountDeleted,
}
