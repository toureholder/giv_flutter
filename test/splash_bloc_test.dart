import 'package:giv_flutter/base/custom_error.dart';
import 'package:giv_flutter/features/splash/bloc/splash_bloc.dart';
import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/location/location.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MockUserRepository mockUserRepository;
  MockLocationRepository mockLocationRepository;
  MockAppConfigRepository mockAppConfigRepository;
  MockDiskStorageProvider mockDiskStorageProvider;
  MockSessionProvider mockSessionProvider;
  MockBooleanSubject mockTasksSuccessSubject;
  MockBooleanStreamSink mockBooleanStreamSink;
  SplashBloc bloc;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockLocationRepository = MockLocationRepository();
    mockAppConfigRepository = MockAppConfigRepository();
    mockDiskStorageProvider = MockDiskStorageProvider();
    mockSessionProvider = MockSessionProvider();
    mockTasksSuccessSubject = MockBooleanSubject();
    mockBooleanStreamSink = MockBooleanStreamSink();

    bloc = SplashBloc(
      userRepository: mockUserRepository,
      locationRepository: mockLocationRepository,
      appConfigRepository: mockAppConfigRepository,
      diskStorage: mockDiskStorageProvider,
      session: mockSessionProvider,
      tasksSuccessSubject: mockTasksSuccessSubject,
    );

    when(mockTasksSuccessSubject.sink).thenReturn(mockBooleanStreamSink);

    when(mockTasksSuccessSubject.stream)
        .thenAnswer((_) => PublishSubject<bool>().stream);

    when(mockAppConfigRepository.getConfig())
        .thenAnswer((_) async => HttpResponse<AppConfig>(
              status: HttpStatus.ok,
              data: AppConfig.fake(),
            ));

    when(mockLocationRepository.getMyLocation(any))
        .thenAnswer((_) async => HttpResponse<Location>(
              status: HttpStatus.ok,
              data: Location.fake(),
            ));

    when(mockUserRepository.getMe()).thenAnswer((_) async => HttpResponse<User>(
          status: HttpStatus.ok,
          data: User.fake(),
        ));

    when(mockSessionProvider.isAuthenticated()).thenReturn(true);
  });

  tearDown(() {
    mockTasksSuccessSubject.close();
  });

  group('loads app configuration', () {
    test('gets app configuration from repository', () async {
      await bloc.runTasks();
      verify(mockAppConfigRepository.getConfig()).called(1);
    });

    test(
      'throws CustomError.forceUpdate if response status is preconditionFailed',
      () async {
        when(mockAppConfigRepository.getConfig())
            .thenAnswer((_) async => HttpResponse<AppConfig>(
                  status: HttpStatus.preconditionFailed,
                  data: null,
                ));

        await bloc.runTasks();

        final error =
            verify(mockBooleanStreamSink.addError(captureAny)).captured.last;

        expect(error, CustomError.forceUpdate);
      },
    );

    test('saves app configuration to disk storage', () async {
      await bloc.runTasks();

      verify(mockDiskStorageProvider.setAppConfiguration(any)).called(1);
    });
  });

  group('loads preferred location', () {
    test('doesn\'t get preferred location from repository if location is set',
        () async {
      when(mockDiskStorageProvider.getLocation()).thenReturn(Location.fake());

      await bloc.runTasks();

      verifyNever(mockLocationRepository.getMyLocation(any));
    });

    test('gets preferred location from repository if location is not set',
        () async {
      when(mockDiskStorageProvider.getLocation()).thenReturn(null);

      await bloc.runTasks();

      verify(mockLocationRepository.getMyLocation(any)).called(1);
    });

    test('saves preferred location to disk storage', () async {
      await bloc.runTasks();

      verify(mockDiskStorageProvider.setLocation(any)).called(1);
    });

    test(
      'doesn\'t save preferred location to disk storage if request fails',
      () async {
        when(mockLocationRepository.getMyLocation(any))
            .thenAnswer((_) async => HttpResponse<Location>(
                  status: HttpStatus.notImplemented,
                  data: null,
                ));

        await bloc.runTasks();

        verifyNever(mockDiskStorageProvider.setLocation(any));
      },
    );
  });

  group('loads current user info', () {
    test(
        'doesn\'t get current user from repository if user is not authenticated',
        () async {
      when(mockSessionProvider.isAuthenticated()).thenReturn(false);

      await bloc.runTasks();

      verifyNever(mockUserRepository.getMe());
    });

    test('gets current user from repository if user is authenticate', () async {
      await bloc.runTasks();

      verify(mockUserRepository.getMe()).called(1);
    });

    test('saves user to disk storage', () async {
      await bloc.runTasks();

      verify(mockDiskStorageProvider.setUser(any)).called(1);
    });

    test(
      'doesn\'t save preferred location to disk storage if request fails',
      () async {
        when(mockSessionProvider.isAuthenticated()).thenReturn(true);

        when(mockUserRepository.getMe())
            .thenAnswer((_) async => HttpResponse<User>(
                  status: HttpStatus.unauthorized,
                  data: null,
                ));

        await bloc.runTasks();

        verifyNever(mockDiskStorageProvider.setUser(any));
      },
    );
  });

  test('adds success status to stream once tasks complete', () async {
    await bloc.runTasks();
    verify(mockBooleanStreamSink.add(any)).called(1);
  });

  group('manages streams', () {
    test('exposes streams', () async {
      expect(bloc.tasksStateStream, isA<Stream<bool>>());
    });

    test('closes streams', () async {
      await bloc.dispose();
      verify(mockTasksSuccessSubject.close()).called(1);
    });
  });
}
