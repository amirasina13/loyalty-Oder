/* Dependencies used by the UseCase must be injected by the Presenter. The UseCase is essentially an Stream managing class. 
When the execute() function is triggered by the UseCase, an Stream is built using the buildUseCaseStream() method, 
subscribed to by the Observer passed, and passed any required params. The StreamSubscription is then added to a CompositeSubscription. 
This is later disposed when dispose() is called. */

abstract class BaseUseCase<TResult, TParams> {
  Future<TResult> execute(TParams params);
}

class UseCaseResult {
  final Exception? exception;
  final bool? result;

  UseCaseResult({this.exception, this.result});

  bool get validResults => exception == null;
}
