import { Effect } from "effect";

export function tryPromise<A>(
  thunk: () => Promise<A>,
): Effect.Effect<A, Error> {
  return Effect.tryPromise({
    try: thunk,
    catch: (error) =>
      error instanceof Error ? error : new Error(String(error)),
  });
}

export function runEffect<A>(effect: Effect.Effect<A, Error>): Promise<A> {
  return Effect.runPromise(effect);
}
