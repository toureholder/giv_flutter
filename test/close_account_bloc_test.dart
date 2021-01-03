import 'package:giv_flutter/features/settings/close_account/bloc/close_account_bloc.dart';
import 'package:giv_flutter/model/api_response/api_response.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  CloseAccountBloc bloc;
  MockDiskStorageProvider mockDiskStorage;
  MockSessionProvider mockSession;
  MockUserRepository mockUserRepository;
  MockAccountCancellationStatusPublishSubject mockStatusSubject;
  MockStringPublishSubject mockErrorMessageSubject;

  setUp(() {
    mockDiskStorage = MockDiskStorageProvider();
    mockSession = MockSessionProvider();
    mockUserRepository = MockUserRepository();
    mockStatusSubject = MockAccountCancellationStatusPublishSubject();
    mockErrorMessageSubject = MockStringPublishSubject();

    bloc = CloseAccountBloc(
      diskStorage: mockDiskStorage,
      session: mockSession,
      userRepository: mockUserRepository,
      statusPublishSubject: mockStatusSubject,
      errorMessageSubject: mockErrorMessageSubject,
    );
  });

  tearDown(() {
    mockStatusSubject.close();
    mockErrorMessageSubject.close();
  });

  test('exposes subject streams', () {
    expect(bloc.statusStream, mockStatusSubject.stream);
    expect(bloc.errorMessageStream, mockErrorMessageSubject.stream);
  });

  group('#deleteMe', () {
    test('calls repository #deleteMe', () async {
      // When
      await bloc.deleteMe();

      // Then
      verify(mockUserRepository.deleteMe()).called(1);
    });

    test('adds deletingAccount state to sink', () async {
      // When
      await bloc.deleteMe();

      // Then
      verify(
        mockStatusSubject.add(AccountCancellationStatus.deletingAccount),
      ).called(1);
    });

    group('when repository deleteMe succeeds', () {
      setUp(() async {
        // Given
        when(mockUserRepository.deleteMe()).thenAnswer(
          (_) async => HttpResponse(
            data: User.fake(),
            status: HttpStatus.ok,
          ),
        );

        // When
        await bloc.deleteMe();
      });

      test('calls session logout', () async {
        // Then
        verify(mockSession.logUserOut()).called(1);
      });

      test('adds accountDeleted state to sink', () async {
        // Then
        verify(
          mockStatusSubject.add(AccountCancellationStatus.accountDeleted),
        ).called(1);
      });
    });

    test(
        'adds errorDeletingAccount state to sink when repository deleteMe fails',
        () async {
      // Given
      when(mockUserRepository.deleteMe()).thenAnswer(
        (_) async => HttpResponse(
          data: null,
          status: HttpStatus.notFound,
        ),
      );

      // When
      await bloc.deleteMe();

      // Then
      verify(
        mockStatusSubject.add(AccountCancellationStatus.errorDeletingAccount),
      ).called(1);
    });

    test(
        'adds errorDeletingAccount state to sink when repository deleteMe throws',
        () async {
      // Given
      when(mockUserRepository.deleteMe()).thenThrow('');

      // When
      await bloc.deleteMe();

      // Then
      verify(
        mockStatusSubject.add(AccountCancellationStatus.errorDeletingAccount),
      ).called(1);
    });
  });

  group('#createIntent', () {
    test('calls repository #createAccountCancellationIntent', () async {
      // When
      await bloc.createIntent();

      // Then
      verify(mockUserRepository.createAccountCancellationIntent()).called(1);
    });

    test('adds sendingIntent state to sink', () async {
      // When
      await bloc.createIntent();

      // Then
      verify(mockStatusSubject.add(AccountCancellationStatus.sendingIntent))
          .called(1);
    });

    test(
        'adds intentSent state to sink when repository createAccountCancellationIntent succeeds',
        () async {
      // Given
      when(mockUserRepository.createAccountCancellationIntent()).thenAnswer(
        (_) async => HttpResponse(
          data: ApiResponse.fake(),
          status: HttpStatus.created,
        ),
      );

      // When
      await bloc.createIntent();

      // Then
      verify(mockStatusSubject.add(AccountCancellationStatus.intentSent))
          .called(1);
    });

    group('when repository createAccountCancellationIntent throws', () {
      final errorMessage = 'any error message';

      setUp(() async {
        // Given
        when(
          mockUserRepository.createAccountCancellationIntent(),
        ).thenThrow(
          errorMessage,
        );

        // When
        await bloc.createIntent();
      });

      test('adds error message to error message sink', () async {
        // Then
        verify(mockErrorMessageSubject.add(errorMessage)).called(1);
      });
    });

    group('when repository createAccountCancellationIntent fails', () {
      final errorMessage = 'any error message';

      setUp(() async {
        // Given
        when(mockUserRepository.createAccountCancellationIntent()).thenAnswer(
          (_) async => HttpResponse(
            data: null,
            status: HttpStatus.notFound,
            message: errorMessage,
          ),
        );

        // When
        await bloc.createIntent();
      });

      test('adds errorSendingIntent state to sink', () async {
        // Then
        verify(mockStatusSubject
                .add(AccountCancellationStatus.errorSendingIntent))
            .called(1);
      });

      test('adds error message to error message sink', () async {
        // Then
        verify(mockErrorMessageSubject
                .add('HttpStatus.notFound: $errorMessage'))
            .called(1);
      });
    });

    test(
        'adds errorSendingIntent state to sink when repository createAccountCancellationIntent throws',
        () async {
      // Given
      when(mockUserRepository.createAccountCancellationIntent()).thenThrow('');

      // When
      await bloc.createIntent();

      // Then
      verify(mockStatusSubject
              .add(AccountCancellationStatus.errorSendingIntent))
          .called(1);
    });
  });

  group('handles user authentication', () {
    test('gets user from disk storage', () {
      // Given
      final fakeUser = User.fake();
      when(mockDiskStorage.getUser()).thenReturn(fakeUser);

      // When
      final authenticatedUser = bloc.getUser();

      // Then
      expect(authenticatedUser.id, fakeUser.id);
    });
  });
}
