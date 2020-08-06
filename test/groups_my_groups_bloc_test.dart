import 'package:giv_flutter/features/groups/my_groups/bloc/my_groups_bloc.dart';
import 'package:giv_flutter/model/app_config/app_config.dart';
import 'package:giv_flutter/model/group_membership/group_membership.dart';
import 'package:giv_flutter/model/user/user.dart';
import 'package:giv_flutter/util/network/http_response.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'test_util/mocks.dart';

main() {
  MyGroupsBloc bloc;
  MockGroupMembershipRepository mockRepository;
  MockGroupMembershipListPublishSubject mockSubject;
  MockGroupMembershipListStreamSink mockStreamSink;
  MockDiskStorageProvider mockDiskStorage;
  MockUtil mockUtil;

  setUp(() {
    mockSubject = MockGroupMembershipListPublishSubject();
    mockStreamSink = MockGroupMembershipListStreamSink();
    mockDiskStorage = MockDiskStorageProvider();
    mockUtil = MockUtil();

    when(mockSubject.sink).thenReturn(mockStreamSink);

    mockRepository = MockGroupMembershipRepository();
    bloc = MyGroupsBloc(
      repository: mockRepository,
      subject: mockSubject,
      diskStorage: mockDiskStorage,
      util: mockUtil,
    );

    when(mockDiskStorage.getAppConfiguration()).thenReturn(AppConfig.fake());
  });

  group('#getMyMemberships', () {
    test('calls repository #getMyMemberships', () {
      // When
      bloc.getMyMemberships();

      // Then
      verify(mockRepository.getMyMemberships(tryCache: false)).called(1);
    });

    test(
        'adds group membership list to sink when repository returns http response with data',
        () async {
      final memberships = GroupMembership.fakeList();

      when(mockRepository.getMyMemberships(tryCache: false)).thenAnswer(
          (_) async => HttpResponse(data: memberships, status: HttpStatus.ok));

      // When
      await bloc.getMyMemberships();

      // Then
      final returnedMemberships =
          verify(mockStreamSink.add(captureAny)).captured.last;

      expect(returnedMemberships[0].id, memberships[0].id);
    });

    test(
        'adds error to sink when repository returns http response without data',
        () async {
      // Given
      when(mockRepository.getMyMemberships(tryCache: false)).thenAnswer(
          (_) async => HttpResponse(data: null, status: HttpStatus.notFound));

      // When
      await bloc.getMyMemberships();

      // Then
      verify(mockStreamSink.addError(any)).called(1);
    });

    test('adds error to sink when repository call throws', () async {
      // Given
      final runTimeError = 'Some runtime error';
      when(mockRepository.getMyMemberships(tryCache: false))
          .thenThrow(runTimeError);

      // When
      await bloc.getMyMemberships();

      // Then
      final error = verify(mockStreamSink.addError(captureAny)).captured.last;

      expect(error, isNot(isA<HttpResponse>()));
      expect(error, equals(runTimeError));
    });
  });

  group('#getUser', () {
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

  tearDown(() {
    mockSubject.close();
  });
}
