initial_state([
    on(a, table),
    on(b, table),
    on(c, a)
]).

goal_state([
    on(a, b),
    on(b, table),
    on(c, table)
]).

% --- Pickup Action ---
pickup(Block, From, State, NewState) :-
    % Preconditions
    member(on(Block, From), State),
    clear(Block, State),
    % Effects
    remove(on(Block, From), State, TempState),
    append([holding(Block)], TempState, NewState).

% --- Putdown Action ---
putdown(Block, To, State, NewState) :-
    % Preconditions
    member(holding(Block), State),
    % Effects
    remove(holding(Block), State, TempState),
    append([on(Block, To), clear(Block)], TempState, NewState).

remove(Fact, State, NewState) :-
    select(Fact, State, NewState).

clear(Block, State) :-
    \+ member(on(_, Block), State).

move(State, pickup(Block, From), NewState) :-
    pickup(Block, From, State, NewState).
move(State, putdown(Block, To), NewState) :-
    putdown(Block, To, State, NewState).

dfs(State, Goal, _, []) :-
    subset(Goal, State).  % Goal satisfied

dfs(State, Goal, Visited, [Action | Plan]) :-
    move(State, Action, NewState),
    \+ member(NewState, Visited),   
    dfs(NewState, Goal, [NewState | Visited], Plan).


plan(Plan) :-
    initial_state(InitialState),
    goal_state(GoalState),
    dfs(InitialState, GoalState, [InitialState], Plan).
