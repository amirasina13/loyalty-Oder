import 'package:bloc/bloc.dart';

import 'photo.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc() : super(PhotoInitial()) {
    on<PhotoEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  // Function to get photo after select from gallery or take photo
  Future<void> mapEventToState(
      PhotoEvent event, Emitter<PhotoState> emit) async {
    if (event is GetPhoto) {
      emit(PhotoSet(photo: event.photo));
    } else if (event is PhotoFailure) {
      emit(PhotoError());
    } else if (event is PhotoStart) {
      emit(PhotoInitial());
    }
  }
}
