abstract class PostStateDoctor {}

class PostInitialDoctor extends PostStateDoctor {}

class PostLoadingDoctor extends PostStateDoctor {
  final List<dynamic> oldAppointments;
  final bool isFirstFetch;

  PostLoadingDoctor(this.oldAppointments, {this.isFirstFetch = false});
}

class PostLoadedDoctor extends PostStateDoctor {
  final List<dynamic> appointments;
  final bool hasReachedMax;

  PostLoadedDoctor(this.appointments, {this.hasReachedMax = false});
}

class PostErrorDoctor extends PostStateDoctor {
  final String message;

  PostErrorDoctor(this.message);
}
