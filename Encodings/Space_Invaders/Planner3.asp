player(X,Y,0):-playerSensor(ID,objectIndex(Index),intPair(x(X))),playerSensor(ID,objectIndex(Index),intPair(y(Y))).
player_move_speed(X):-playerSensor(_,_,player(increaseFactor(X))).
laser(X,Y,S,0):-laserSensor(ID,objectIndex(Index),intPair(x(X))),laserSensor(ID,objectIndex(Index),intPair(y(Y))),laserSensor(ID,objectIndex(Index),projectile(increaseFactor(S))).

invaders(X,Y,0):-invader01Sensor(ID,objectIndex(Index),intPair(x(X))),invader01Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader02Sensor(ID,objectIndex(Index),intPair(x(X))),invader02Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders(X,Y,0):-invader03Sensor(ID,objectIndex(Index),intPair(x(X))),invader03Sensor(ID,objectIndex(Index),intPair(y(Y))).
invaders_direction("right"):-invadersSensor(_,_,invaders(direction(x("1")))).
invaders_direction("left"):-invadersSensor(_,_,invaders(direction(x("-1")))).
invaders_move_speed(X,0):-invadersSensor(_,_,invaders(increaseFactor(X))).
invaders_move_speed(S_Next,T_Next) :- invaders_direction("right"), invaders_move_speed(S,T), S_Next=S+25, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
invaders_move_speed(S_Next,T_Next) :- invaders_direction("left"), invaders_move_speed(S,T), S_Next=S-25, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

% MAX PLAN LENGTH
maxTime(10).
min_x_matrix(-15500).
max_x_matrix(15500).
action("MoveAction").
move("left").
move("right").
action("FireAction").

% START PLANNING
1<={applyAction(0,A) : action(A)}<=1.
1<={actionArgument(0,"move",M) : move(M)}<=1 :- applyAction(0,"MoveAction").

%% PLANNED TIME STEP FOR T>0  
1<={applyAction(T_Next,A) : action(A)}<=1 :- applyAction(T,_), T_Next=T+1, T_Next<=TM, maxTime(TM).
1<={actionArgument(T,"move",M) : move(M)}<=1 :- applyAction(T,"MoveAction").

%% GET PLAYER PREVIOUS DIRECTION
previous_direction(D):-playerSensor(ID,objectIndex(Index),player(previousDirection(D))).

% ESTIMATE INVADERS' FUTURE POSITION 
invaders(X_Next,Y,T_Next) :- invaders(X,Y,T), T_Next=T+1, X>X_Min, X<X_Max, invaders_move_speed(S,T), X_Next=X+S, T_Next<=T_Max, maxTime(T_Max), min_x_matrix(X_Min), max_x_matrix(X_Max).

% ESTIMATE PLAYER'S FUTURE POSITION 
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","right"), player_move_speed(S), X_Next=X+S, X_Next<=X_Max, max_x_matrix(X_Max), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X_Next,Y,T_Next) :- player(X,Y,T), applyAction(T,"MoveAction"), actionArgument(T,"move","left"), player_move_speed(S), X_Next=X-S, X_Next>=X_Min, min_x_matrix(X_Min), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
player(X,Y,T_Next) :- player(X,Y,T), applyAction(T,"FireAction"), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).

% ESTIMATE LASER'S FUTURE POSITION 
laser(X,Y_Next,S,T_Next) :- laser(X,Y,S,T), Y_Next=Y+S, T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
laser(X,Y,200,T):-player(X,Y,T), applyAction(T,"FireAction").

% FIND ALL ENEMIES ON THE MOST LEFT/RIGHT COLUMN 
most_left_invader(X,T) :- #min{C: invaders(C,_,T)}=X, invaders(_,_,T).
most_right_invader(X,T) :- #max{C: invaders(C,_,T)}=X, invaders(_,_,T).

% FIND THE NEAREST W.R.T. TO THE PLAYER (ON X AND Y COORD)
min_y_invader(Y,T) :- #min{C: invaders(_,C,T)}=Y, invaders(_,_,T).
nearest_y_invader(X,Y,T) :- #min{C: invaders(C,Y,T)}=X, min_y_invader(Y,T).
invaders_near_player(T) :- invaders(_,Y1,T), player(_,Y2,T), Y1>=Y2, Y1-Y2<=12000.

% DO NOT FIRE IF THERE IS ALREADY AN ACTIVE LASER 
:-applyAction(T_Next,"FireAction"), laser(_,_,_,T), T_Next=T+1, T_Next<=T_Max, maxTime(T_Max).
:-applyAction(T1,"FireAction"), applyAction(T2,"FireAction"), T2>T1+1.

% STRATEGIA DI MOVIMENTO
% NON ANDARE IN PUNTI ESTREMI (DESTRA/SINISTRA) DOVE NON CI SONO INVADERS
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","left"), player(X1,Y1,T), most_left_invader(X2,T), X1<=X2+100, T_Next=T+1.
:-applyAction(T_Next,"MoveAction"), actionArgument(T_Next,"move","right"), player(X1,_,T), most_right_invader(X2,T), X1>=X2-100, T_Next=T+1.


%%%%%%%%%%% WEAK CONSTRAINTS %%%%%%%%%%%

%%%%%%%%%%% UPDATE STRATEGY DEPENDING ON INVADERS HEIGHT %%%%%%%%%%%
% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù A SINISTRA SE GLI INVADERS VANNO VERSO DESTRA
distance_left_column(X,T) :- invaders_direction("right"), not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,T), X=X1-X2, X1>=X2.
distance_left_column(X,T) :- invaders_direction("right"), not invaders_near_player(T), player(X1,_,T), most_left_invader(X2,T), X=X2-X1, X1<X2.
:~distance_left_column(X,T). [X@2,T]

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù A DESTRA  SE GLI INVADERS VANNO VERSO DESTRA
distance_right_column(X,T) :- invaders_direction("left"), not invaders_near_player(T), player(X1,_,T), most_right_invader(X2,T), X=X1-X2, X1>=X2.
distance_right_column(X,T) :- invaders_direction("left"), not invaders_near_player(T), player(X1,_,T), most_right_invader(X2,T), X=X2-X1, X1<X2.
:~distance_right_column(X,T). [X@2,T]

% SE POSSIBILE SPOSTATI VERSO UN INVADERS DELLE FILE PIù BASSE QUANDO GLI INVADERS SONO VICINISSIMI AL PLAYER (IN ALTEZZA)
distance_player_invader(X,T) :- invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X1-X2, X1>=X2.
distance_player_invader(X,T) :- invaders_near_player(T), player(X1,_,T), nearest_y_invader(X2,_,T), X=X2-X1, X1<X2.
:~distance_player_invader(X,T). [X@2,X,T]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% WHEN MOVE, PREFER THE SAME DIRECTION OF PREVIOUS ACTIONS (AVOID LEFT AND RIGHT CONTINUOUS MOVE) 
:~actionArgument(T1,"move",M1), actionArgument(T2,"move",M2), T2=T1+1, M1!=M2. [1@3,T1,M1,T2,M2]
:~actionArgument(T1,"move",M1), actionArgument(T2,"move",M2), T1=T2+1, M1!=M2. [1@3,T1,M1,T2,M2]
:~actionArgument(T1,"move",M1), previous_direction(M2), M1!=M2. [1@2,M1,M2,T1]

% WHEN MOVE, GO TOWARDS INVADERS
:~actionArgument(_,"move",M), invaders_direction(M). [1@1,M]

% ATTACK
% FIRE WHEN THERE IS AN INVADER UP TO THE PLAYER
:~applyAction(T_Next,"MoveAction"), nearest_y_invader(X,_,T_Next), player(X,_,T), T_Next=T+1. [1@6,X,T]
:~applyAction(T_Next,"MoveAction"), invaders_near_player(T_Next), nearest_y_invader(X1,_,T_Next), player(X2,_,T), T_Next=T+1. [1@6,T,X1,X2]
% AUMENTA LA FREQUENZA DI FUOCO QUANDO GLI INVADERS SONO VICINI AL PLAYER
player_under_invader(T) :- player(X,_,T), invaders(X,_,T).
%:~applyAction(T, "MoveAction"), invaders_near_player(T), player_under_invader(T). [1@6,T]

a.
:~a. [1@1]
:~a. [1@2]
:~a. [1@3]
:~a. [1@4]
:~a. [1@5]
:~a. [1@6]
:~a. [1@7]
:~a. [1@8]

#show applyAction/2. 
#show actionArgument/3.
%#show player/3.