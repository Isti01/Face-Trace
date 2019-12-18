import 'package:bloc/bloc.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:face_app/bloc/register_bloc_states.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final String name;

  RegisterBloc({this.name});

  @override
  RegisterState get initialState => RegisterState.init(name: name);

  @override
  Stream<RegisterState> mapEventToState(event) async* {
    RegisterState newState;

    if (event is NameChangedEvent) {
      newState = state.update(name: event.name);
    } else if (event is DateChangedEvent) {
      newState = state.update(birthDate: event.date);
    } else if (event is InterestAddedEvent) {
      newState = state.update(interests: {
        if (state.interests != null) ...state.interests,
        event.interest,
      });
    } else if (event is InterestRemovedEvent) {
      newState = state.update(interests: {
        for (final interest in state.interests ?? {})
          if (interest != event.interest) interest
      });
    } else if (event is DescriptionChangedEvent) {
      newState = state.update(description: event.description);
    } else if (event is ColorChangedEvent) {
      newState = state.update(color: event.newColor);
    } else if (event is GenderChangedEvent) {
      newState = state.update(gender: event.gender);
    } else if (event is PhotoChangedEvent) {
      newState = state.update(
        facePhoto: event.photo,
        removeSelectedFace: true,
      );
    } else if (event is FaceChosenEvent) {
      newState = state.update(userFace: event.face);
    } else if (event is FacesDetectedEvent) {
      newState = state.update(detectedFaces: event.faces);
    }

    if (newState == null) {
      throw Exception("${event.runtimeType} was not mapped to state");
    }
    yield newState;
  }

  nameChanged(String name) => add(NameChangedEvent(name));

  onDateChanged(DateTime date) => add(DateChangedEvent(date));

  onInterestAdded(Interest interest) => add(InterestAddedEvent(interest));

  onInterestRemoved(Interest interest) => add(InterestRemovedEvent(interest));

  onDescriptionChanged(String desc) => add(DescriptionChangedEvent(desc));

  onColorChanged(AppColor newColor) => add(ColorChangedEvent(newColor));

  onGenderChanged(Gender gender) => add(GenderChangedEvent(gender));

  onPhotoChanged(String photoPath) => add(PhotoChangedEvent(photoPath));

  onFacesDetected(List<Face> faces) => add(FacesDetectedEvent(faces));

  onFaceChosen(Face face) => add(FaceChosenEvent(face));

  @override
  void onError(Object error, StackTrace stacktrace) {
    print([error, stacktrace]);
    super.onError(error, stacktrace);
  }
}
