% --- Initial and Goal States ---
initial_state([on(a,table), on(b,table), on(c,a)]).
goal_state([on(a,b), on(b,table), on(c,table)]).

% --- Check if a block is clear ---
clear(Block, State) :-
    \+ member(on(_, Block), State).

% --- Possible moves ---
move(State, pickup(X,Y), NewState) :-
    member(on(X,Y), State),
    clear(X, State),
    delete(State, on(X,Y), Temp),
    append([holding(X)], Temp, NewState).

move(State, putdown(X,Y), NewState) :-
    member(holding(X), State),
    clear(Y, State),
    delete(State, holding(X), Temp),
    append([on(X,Y)], Temp, NewState).

% --- Depth-First Search ---
dfs(State, Goal, _, []) :- subset(Goal, State), !.
dfs(State, Goal, Visited, [Action|Plan]) :-
    move(State, Action, NewState),
    \+ member(NewState, Visited),
    dfs(NewState, Goal, [NewState|Visited], Plan).

% --- Main Planner ---
plan(Plan) :-
    initial_state(Init),
    goal_state(Goal),
    dfs(Init, Goal, [Init], Plan).
